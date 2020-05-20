# -*- coding: utf-8 -*-
import json
import sys

sys.path.append("../")
import os
from configparser import ConfigParser
from functools import partial
import requests
import win32api
from PySide2 import QtCore, QtWidgets, QtGui
from PySide2.QtCore import Qt
from PySide2.QtGui import QCursor
from PySide2.QtWidgets import (
    QApplication,
    QFileDialog,
    QListWidgetItem,
    QFormLayout,
    QVBoxLayout,
    QTextEdit,
    QAbstractItemView
)
import pandas as pd
from urllib3 import encode_multipart_formdata
from Plan2Dance.win_base_ui import Ui_Robot as ui

ProjectPath = os.path.dirname(os.path.realpath(__file__))
# Config file path
path = os.path.join(ProjectPath, 'cache/Plan2Dance.cfg')
PAST_MUSIC_PATH = os.path.join(ProjectPath, "cache/past_music.txt")
MTNX_FILE_PATH = os.path.join(ProjectPath, "cache/output")
ERROR_LOG_PATH = os.path.join(ProjectPath, "cache/error.log")
# Result store
PLAN2DANCE_REQUEST_ID = None
SEGMENT_LIST = None
PLAN_LIST = None
SCRIPT_DATA = None
ACTION_MODEL = None
REQUEST_PREFFIX_URL = "http://localhost:8081"  # Change the request ip and port
# Web service URL: plan2dance.dongbox.top:8081

class IOConfig:
    """
        Class: Read configuration file
    """

    def __init__(self):
        self.config = {}
        self._get_config()

    def _get_config(self):
        cf = ConfigParser()
        cf.read(path, encoding='UTF-8')
        boolean = cf.has_section("config")
        config_list = dict()
        if boolean:
            try:
                for key in cf['config']:
                    config_list[key] = cf['config'][key]
                self.config = config_list
            except KeyError as ke:
                assert ke

    def get_config(self):
        return self.config

    @staticmethod
    def set_config(data: dict):
        cf = ConfigParser()
        cf.read(path, encoding='UTF-8')
        for name, value in data.items():
            if name in cf['config'].keys():
                cf.set("config", name, value)
            else:
                raise KeyError("{} not exist in the config.".format(name))
        with open(path, "w+", encoding='UTF-8') as f:
            cf.write(f)
        return True


class MainWindow(QtWidgets.QWidget, ui):
    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent)
        self.setWindowFlags(QtCore.Qt.WindowCloseButtonHint)
        self.setWindowIcon(QtGui.QIcon('logo.ico'))
        self.setupUi(self)
        self._update_size_by_desktop_rect()

        # Step button Enabled
        self.__set_btn_enabled(self.btn_action_model, False)
        self.__set_btn_enabled(self.btn_music_analysis, False)
        self.__set_btn_enabled(self.btn_run_planner, False)
        self.__set_btn_enabled(self.btn_generate_mtnx, False)
        self.__set_btn_enabled(self.btn_execute, False)

        # Step button click event
        self.btn_action_model.clicked.connect(self.__func_btn_step_action_model)
        self.btn_music_analysis.clicked.connect(self.__func_btn_step_analysis)
        self.btn_run_planner.clicked.connect(self.__func_btn_step_planner)
        self.btn_generate_mtnx.clicked.connect(self.__func_btn_step_mtnx)

        # set Cursor
        self.btn_action_model.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_music_analysis.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_run_planner.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_generate_mtnx.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_base_action.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_dummy_action.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_segment_data.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_mtnx_data.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_choose.setCursor(QtCore.Qt.PointingHandCursor)
        self.btn_execute.setCursor(QtCore.Qt.PointingHandCursor)
        # init
        self.__set_btn_enabled(self.btn_dummy_action, False)
        self.__set_btn_enabled(self.btn_base_action, False)
        self.__set_btn_enabled(self.btn_segment_data, False)
        self.__set_btn_enabled(self.btn_mtnx_data, False)

        # File display box
        self.te_model.setReadOnly(True)
        self.te_planner.setWordWrapMode(QtGui.QTextOption.NoWrap)
        self.te_planner.setReadOnly(True)
        self.te_mtnx.setReadOnly(True)
        self.tv_analysis.setEditTriggers(QAbstractItemView.NoEditTriggers)
        # Display box title
        self.label_planner_output.setVisible(False)
        self.label_analysis_output.setVisible(False)
        self.label_mtnx_output.setVisible(False)

        # Set common button click event
        self.btn_base_action.clicked.connect(self.__func_print_basic_actions)
        self.btn_dummy_action.clicked.connect(self.__func_print_dummy_action)
        self.btn_segment_data.clicked.connect(self.__func_print_cluster_data)
        self.btn_mtnx_data.clicked.connect(self.__func_print_robot_script)
        self.btn_execute.clicked.connect(self.__func_btn_execute)
        self.btn_choose.clicked.connect(self.__func_btn_open_file)

        self.le_input_music.setReadOnly(True)
        self.step = 0
        self.mtnx_file_path = None
        # process bar timer
        self.model_timer = QtCore.QTimer(self)
        self.music_timer = QtCore.QTimer(self)
        self.planner_timer = QtCore.QTimer(self)
        self.mtnx_timer = QtCore.QTimer(self)
        # process label cannot visible
        self.pb_model.setVisible(False)
        self.pb_analysis.setVisible(False)
        self.pb_planner.setVisible(False)
        self.pb_mtnx.setVisible(False)
        self.label_model_running.setVisible(False)
        self.label_music_running.setVisible(False)
        self.label_planner_running.setVisible(False)
        self.label_mtnx_running.setVisible(False)
        # Time restrict Slider
        self.hs_time_restrict.setMinimum(20)
        self.hs_time_restrict.setMaximum(500)
        self.hs_time_restrict.setTickPosition(QtWidgets.QSlider.TicksBelow)
        self.hs_time_restrict.setTickInterval(20)
        self.hs_time_restrict.valueChanged.connect(self.__func_hs_number)
        # About the time restrict
        self.sb_time_restrict.valueChanged.connect(self.__func_sb_number)
        self.sb_time_restrict.setMinimum(20)
        self.sb_time_restrict.setMaximum(500)
        self.music_path = None
        self.music_list = []
        self.__past_music()
        self.cb_past_music.currentIndexChanged.connect(self.__func_cb_past_music)
        self.config = self.__set_cur_config()
        self.plan_number = None
        self.finished_plan_number = None
        self.mark_planner_times = None

    def _update_size_by_desktop_rect(self):
        """
            update the size by screen geometry
        :return:
        """
        self.desktop = QApplication.desktop()

        screenRect = self.desktop.screenGeometry()
        height = screenRect.height()
        self.scrollAreaWidgetContents.setMinimumHeight(1400)
        if height == 1080:
            self.setFixedSize(650, 772)
        if height <= 900:
            self.scrollArea.setGeometry(QtCore.QRect(10, 10, 650, 690))
            self.setFixedSize(660, 710)
        if height <= 768:
            self.scrollArea.setGeometry(QtCore.QRect(10, 10, 650, 580))
            self.setFixedSize(660, 600)

    def __func_sb_number(self):
        """
            Planner time limit: number change
        """
        cur_value = self.sb_time_restrict.value()
        self.hs_time_restrict.setValue(cur_value)

    def __func_hs_number(self):
        """
            Planner time limit: slider changes
        """
        cur_value = self.hs_time_restrict.value()
        self.sb_time_restrict.setValue(cur_value)

    def __func_cb_past_music(self):
        """
            Slot function: displays the current music
        """
        index = self.cb_past_music.currentIndex()
        cur_path = self.music_list[index]
        self.le_input_music.setText(cur_path)
        self.music_path = cur_path

    def __func_btn_open_file(self):
        """
            Slot function: select music
        """
        file_name, file_type = QFileDialog.getOpenFileName(self, "Choose your input music.", "../",
                                                           "Wave or mp3 (*.wav *.mp3)")
        if file_name:
            self.le_input_music.setText(file_name)
            self.music_path = file_name
            self.__set_btn_enabled(self.btn_action_model, True)

            with open(PAST_MUSIC_PATH, 'r+', encoding='UTF-8') as f:
                cur_list = f.readlines()
                if len(cur_list) == 0:
                    f.write("{}\n".format(file_name))
                else:
                    cur_path = "{}\n".format(file_name)
                    if cur_path not in cur_list:
                        f.write(cur_path)
        else:
            print("Have not choose music.")

    def __func_btn_execute(self):
        """
                Slot function: Open directory
        """
        try:
            win32api.ShellExecute(0, 'open', MTNX_FILE_PATH, '', '', 1)
        except FileNotFoundError or FileExistsError:
            self.show_error("Directory not Found. {}".format(MTNX_FILE_PATH))

    def __func_print_cluster_data(self):
        """
            Slot function: displays cluster data
        """
        col = ["Start", "End", "Type"]
        segment_result = SEGMENT_LIST['segment_result']
        df = pd.DataFrame(data=segment_result, columns=col)
        model = self.load_data(df)
        self.tv_analysis.setModel(model)
        self.label_analysis_output.setText("Segment Data")
        self.label_analysis_output.setVisible(True)

    def __func_print_basic_actions(self):
        """
            Slot function: print basic actions
        """
        content = ACTION_MODEL['basic_action']
        self.te_model.setPlainText(content)
        self.label_model_output.setText("Basic Actions")
        self.label_model_output.setVisible(True)

    def __func_print_dummy_action(self):
        """
            Slot function: print dummy action
        """
        content = ACTION_MODEL['dummy_action']
        self.te_model.setPlainText(content)
        self.label_model_output.setText("Dummy Action")
        self.label_model_output.setVisible(True)

    def __func_print_problem_btn(self, seq):
        """
            Slot function: displays the Problem file
        """
        plan_list = PLAN_LIST['plan_list']
        problem_file = plan_list[str(seq)]['problem']
        self.te_planner.setPlainText(problem_file)
        self.label_planner_output.setText("Problem")
        self.label_planner_output.setVisible(True)

    def __func_print_domain_btn(self, seq):
        """
            Slot function: displays Domain files
        """
        plan_list = PLAN_LIST['plan_list']
        domain_file = plan_list[str(seq)]['domain']
        self.te_planner.setPlainText(domain_file)
        self.label_planner_output.setText("Domain")
        self.label_planner_output.setVisible(True)

    def __func_print_plan_btn(self, seq):
        """
            Slot function: displays the Plan file
        """
        plan_list = PLAN_LIST['plan_list']
        plan_file = plan_list[str(seq)]['plan']
        self.te_planner.setPlainText("".join(plan_file))
        self.label_planner_output.setText("Plan")
        self.label_planner_output.setVisible(True)

    def __func_print_robot_script(self):
        """
            Slot function: Print Robot script
        """
        mtnx_file = SCRIPT_DATA['script']
        self.te_mtnx.setPlainText(mtnx_file)
        self.label_mtnx_output.setText("Robot File")
        self.label_mtnx_output.setVisible(True)

    def __delete_problem_list(self):
        """
            Clear the Problem file button in the list before
        """
        count = self.lw_problem.count()
        for i in range(count - 1, -1, -1):
            self.lw_problem.takeItem(i)

    def __delete_domain_list(self):
        """
            Clear the Domain file button in the list before
        """
        count = self.lw_domain.count()
        for i in range(count - 1, -1, -1):
            self.lw_domain.takeItem(i)

    def __delete_plan_list(self):
        """
            Clear the Plan file button in the list before
        """
        count = self.lw_plan.count()
        for i in range(count - 1, -1, -1):
            self.lw_plan.takeItem(i)

    def __update_init_config_segment_type(self):
        """
            Update the user's configuration about segment
        """
        index = self.cb_segment.currentIndex()
        func_name = "cluster"
        if index == 0:
            func_name = "cluster"
        elif index == 1:
            func_name = "silence"

        self.config["segment_type"] = func_name
        IOConfig().set_config(self.config)

    def __update_init_config_preference(self):
        """
            Update the user's configuration about preferences
        """
        if self.cb_dumpy_action.isChecked():
            self.config["dummy_action"] = "yes"
        else:
            self.config["dummy_action"] = "no"

        if self.cb_best_rate.isChecked():
            self.config["best_rate"] = "yes"
        else:
            self.config["best_rate"] = "no"

        if self.cb_beat_tracker.isChecked():
            self.config["beat_tracker"] = "yes"
        else:
            self.config["beat_tracker"] = "no"

        if self.cb_action_coherent.isChecked():
            self.config["action_coherent"] = "yes"
        else:
            self.config["action_coherent"] = "no"

        # planer time
        cur_value = self.hs_time_restrict.value()
        self.config["time_restrict"] = str(cur_value)

        index = self.cb_planning_function.currentIndex()
        func_name = "parallel"
        if index == 0:
            func_name = "parallel"
        elif index == 1:
            func_name = "serial"
        self.config["plan_function"] = func_name
        IOConfig().set_config(self.config)

    def __func_btn_step_action_model(self):
        """
            Step1: Action Model Generation
        """
        self.step = 0
        self.__set_btn_enabled(self.btn_choose, False)
        self.__set_btn_enabled(self.btn_dummy_action, False)
        self.__set_btn_enabled(self.btn_base_action, False)
        self.__set_btn_enabled(self.btn_segment_data, False)
        self.__set_btn_enabled(self.btn_mtnx_data, False)

        self.te_model.setPlainText("")
        self.tv_analysis.setModel(QtGui.QStandardItemModel())
        self.te_planner.setPlainText("")
        self.te_mtnx.setPlainText("")

        self.__delete_domain_list()
        self.__delete_problem_list()
        self.__delete_plan_list()

        self.label_model_running.setVisible(False)
        self.label_music_running.setVisible(False)
        self.label_planner_running.setVisible(False)
        self.label_mtnx_running.setVisible(False)

        self.pb_model.setVisible(False)
        self.pb_analysis.setVisible(False)
        self.pb_planner.setVisible(False)
        self.pb_mtnx.setVisible(False)

        self.label_model_running.setVisible(True)
        self.label_model_running.setText("Running...")

        self.__set_btn_enabled(self.btn_action_model, False)
        self.__set_btn_enabled(self.btn_music_analysis, False)
        self.__set_btn_enabled(self.btn_run_planner, False)
        self.__set_btn_enabled(self.btn_generate_mtnx, False)
        self.__set_btn_enabled(self.btn_execute, False)

        music_name = os.path.basename(self.music_path)
        self.thread = ModelThread(music_name, self.music_path)
        self.thread._signal.connect(self.__update_step_action_model)
        self.thread.start()
        self.pb_model.setVisible(True)
        self.model_timer.timeout.connect(self._update_model_process)
        self.model_timer.start(100)

    def __func_btn_step_analysis(self):
        """
            槽函数：开始音乐分析（music analysis）
        """
        # 音乐处理好
        if not self.music_path:
            data = {
                "title": "ERROR",
                "content": "Music not exist",
            }
            TextShow(self, data).show()
        self.step = 0
        # 选择音乐按钮
        self.__set_btn_enabled(self.btn_choose, False)
        # step1中的res按钮不可见
        self.__set_btn_enabled(self.btn_segment_data, False)
        # generate data
        self.__set_btn_enabled(self.btn_mtnx_data, False)
        # 如果已存在结果，需要清空
        self.__delete_domain_list()
        self.__delete_problem_list()
        self.__delete_plan_list()

        self.label_analysis_output.setVisible(False)
        self.label_planner_output.setVisible(False)
        self.label_mtnx_output.setVisible(False)

        # 标签显示
        self.label_domain.setVisible(True)
        self.label_problem_list.setVisible(True)
        self.label_plan_list.setVisible(True)

        # 清空显示器
        self.tv_analysis.setModel(QtGui.QStandardItemModel())
        self.te_planner.setPlainText("")
        self.te_mtnx.setPlainText("")
        # 进度条
        # planner的进度条和标签消失

        self.label_music_running.setVisible(False)
        self.label_planner_running.setVisible(False)
        self.label_mtnx_running.setVisible(False)

        self.pb_planner.setVisible(False)
        self.pb_mtnx.setVisible(False)
        # analysis的标签可见，显示为running
        self.label_music_running.setVisible(True)
        self.label_music_running.setText("Running...")

        self.__set_btn_enabled(self.btn_action_model, False)
        self.__set_btn_enabled(self.btn_music_analysis, False)
        self.__set_btn_enabled(self.btn_run_planner, False)
        self.__set_btn_enabled(self.btn_generate_mtnx, False)
        self.__set_btn_enabled(self.btn_execute, False)

        self.__update_init_config_segment_type()

        self.thread = AnalysisThread(self.config)
        self.thread._signal.connect(self.__update_step_analysis_text)
        self.thread.start()
        self.pb_analysis.setVisible(True)
        self.music_timer.timeout.connect(self._update_analysis_process)
        self.music_timer.start(100)

    def __func_btn_step_planner(self):
        """
            Slot function: start to run planner
        """
        self.plan_number = 0
        self.finished_plan_number = 0
        self.step = 0
        self.mark_planner_times = 0
        # 选择音乐按钮
        self.__set_btn_enabled(self.btn_choose, False)
        self.__set_btn_enabled(self.btn_mtnx_data, False)
        # 清空显示器
        self.te_planner.setPlainText("")
        self.te_mtnx.setPlainText("")
        # 如果已存在结果，需要清空
        self.__delete_domain_list()
        self.__delete_problem_list()
        self.__delete_plan_list()

        self.label_planner_output.setVisible(False)
        self.label_mtnx_output.setVisible(False)
        self.label_mtnx_running.setVisible(False)
        # 设置进度条
        self.label_planner_running.setVisible(True)
        self.label_planner_running.setText("Running...")
        # 标签显示
        self.label_domain.setVisible(True)
        self.label_problem_list.setVisible(True)
        self.label_plan_list.setVisible(True)
        # analysis和planner 的开始不可点击
        self.__set_btn_enabled(self.btn_action_model, False)
        self.__set_btn_enabled(self.btn_music_analysis, False)
        self.__set_btn_enabled(self.btn_run_planner, False)
        self.__set_btn_enabled(self.btn_generate_mtnx, False)
        self.__set_btn_enabled(self.btn_execute, False)
        self.pb_mtnx.setVisible(False)
        # 更新配置
        self.__update_init_config_preference()
        # 运行规划器
        self.thread = PlannerThread(self.config)
        self.thread._signal.connect(self.__update_step_planner_text)
        self.thread.start()
        # 进度条
        self.pb_planner.setVisible(True)
        # 进度条时间
        self.planner_timer.timeout.connect(self._update_planner_process)
        self.planner_timer.start(100)

    def __func_btn_step_mtnx(self):
        """
            Slot function: starts generating the robot script file
        """
        # 选择音乐按钮
        self.step = 0
        self.__set_btn_enabled(self.btn_choose, False)
        self.te_mtnx.setPlainText("")
        self.label_mtnx_output.setVisible(False)
        # 设置进度条
        self.label_mtnx_running.setVisible(True)
        self.label_mtnx_running.setText("Running...")
        # analysis和planner 的开始不可点击
        self.__set_btn_enabled(self.btn_action_model, False)
        self.__set_btn_enabled(self.btn_music_analysis, False)
        self.__set_btn_enabled(self.btn_run_planner, False)
        self.__set_btn_enabled(self.btn_generate_mtnx, False)
        self.__set_btn_enabled(self.btn_execute, False)

        self.__set_btn_enabled(self.btn_mtnx_data, False)

        self.thread = RobotScriptThread()
        self.thread._signal.connect(self.__update_step_generate_robot_script)
        self.thread.start()
        # 进度条
        self.pb_mtnx.setVisible(True)
        # 进度条时间
        self.mtnx_timer.timeout.connect(self._update_robot_script_process)
        self.mtnx_timer.start(100)

    def _update_model_process(self):
        """
            Update action model program running progress bar for Step1
        """
        if self.step < 80:
            self.step += 20
            self.pb_model.setValue(self.step)
        if self.step == 80:
            self.model_timer.stop()

    def _update_analysis_process(self):
        """
            Update the music analyzer progress bar for step2
        """
        if self.step < 99:
            self.step += 1
            self.pb_analysis.setValue(self.step)
        if self.step == 99:
            self.music_timer.stop()

    def _update_planner_process(self):
        """
            Update planner run program progress bar for step3
        """
        if self.step < 45:
            if self.step < 30:
                if self.config['plan_function'] == "serial":
                    self.step += 0.2
                else:
                    self.step += 0.5
            else:
                self.step += 0.3
            self.pb_planner.setValue(self.step)
        elif self.step >= 45 and self.step < 85:
            self.step += 0.1
            self.pb_planner.setValue(self.step)

    def _update_robot_script_process(self):
        """
          Update script run program progress bar for step4
        """
        if self.step < 80:
            self.step += 5
            self.pb_mtnx.setValue(self.step)
        if self.step == 80:
            self.mtnx_timer.stop()

    def __update_step_action_model(self, line):
        """
            Update the interface after execution for step1
        """
        if line == "success":
            self.model_timer.stop()
            self.pb_model.setValue(100)
            self.label_model_running.setText("Finished!!!")
            # button state update
            self.__set_btn_enabled(self.btn_choose, True)
            self.__set_btn_enabled(self.btn_action_model, True)
            self.__set_btn_enabled(self.btn_music_analysis, True)
            self.__set_btn_enabled(self.btn_base_action, True)
            self.__set_btn_enabled(self.btn_dummy_action, True)
        if line == "-1" or line == "-2":
            print("Error")
            # 进度条重置
            self.model_timer.stop()
            self.pb_model.setValue(0)
            self.pb_model.setVisible(False)
            self.label_model_running.setVisible(False)
            # 按钮打开
            self.__set_btn_enabled(self.btn_choose, True)
            self.__set_btn_enabled(self.btn_action_model, True)
            # 弹窗
            if line == "-1":
                self.__add_log("Network Error!!!")
            else:
                self.__add_log("Request Error!!! Please feedback your error to issue in github.")
        else:
            print(line)

    def __update_step_analysis_text(self, line):
        """
            Update the interface after execution for step2
        """
        if line == "success":
            self.music_timer.stop()
            self.pb_analysis.setValue(100)
            self.label_music_running.setText("Finished!!!")
            # button state update
            self.__set_btn_enabled(self.btn_choose, True)

            self.__set_btn_enabled(self.btn_action_model, True)
            self.__set_btn_enabled(self.btn_music_analysis, True)
            self.__set_btn_enabled(self.btn_run_planner, True)

            self.__set_btn_enabled(self.btn_segment_data, True)
        if line == "-1" or line == "-2":
            print("Error")
            # 进度条重置
            self.music_timer.stop()
            self.pb_analysis.setValue(0)
            self.pb_analysis.setVisible(False)
            self.label_music_running.setVisible(False)
            # 按钮打开
            self.__set_btn_enabled(self.btn_choose, True)
            self.__set_btn_enabled(self.btn_action_model, True)
            self.__set_btn_enabled(self.btn_music_analysis, True)
            # 弹窗
            if line == "-1":
                self.__add_log("Network Error!!!")
            else:
                self.__add_log("Request Error!!! Please feedback your error to issue in github.")
        else:
            print(line)

    def __update_step_planner_text(self, line):
        """
           Update the interface after execution for step3
        """

        if line == "success":
            self.planner_timer.stop()
            self.pb_planner.setValue(100)
            self.label_planner_running.setText("Finished!!!")

            # analysis和planner 可点击
            self.__set_btn_enabled(self.btn_choose, True)
            self.__set_btn_enabled(self.btn_action_model, True)
            self.__set_btn_enabled(self.btn_music_analysis, True)
            self.__set_btn_enabled(self.btn_run_planner, True)
            self.__set_btn_enabled(self.btn_generate_mtnx, True)

            self.__add_domain_item_to_scroll()
            self.__add_problem_item_to_scroll()
            self.__add_plan_item_to_scroll()
            self.label_domain.setVisible(False)
            self.label_problem_list.setVisible(False)
            self.label_plan_list.setVisible(False)
        # 错误处理
        if line == "-1" or line == "-2":
            # 进度条
            print("Error")
            self.planner_timer.stop()
            self.label_planner_running.setVisible(False)
            self.__set_btn_enabled(self.btn_choose, True)
            self.__set_btn_enabled(self.btn_action_model, True)
            self.__set_btn_enabled(self.btn_music_analysis, True)
            self.__set_btn_enabled(self.btn_run_planner, True)
            self.pb_planner.setValue(0)
            self.pb_planner.setVisible(False)
            # 弹窗
            if line == "-1":
                self.__add_log("Network Error!!!")
            else:
                self.__add_log("Request Error!!! Please feedback your error to issue in github.")
        else:
            # 正常打印
            print(line)

    def __update_step_generate_robot_script(self, line):
        """
            Update the interface after execution for step4
        """
        if line == "success":
            self.mtnx_timer.stop()
            self.pb_mtnx.setValue(100)
            self.label_mtnx_running.setText("Finished!!!")
            # button state update
            self.__set_btn_enabled(self.btn_choose, True)

            self.__set_btn_enabled(self.btn_action_model, True)
            self.__set_btn_enabled(self.btn_music_analysis, True)
            self.__set_btn_enabled(self.btn_run_planner, True)
            self.__set_btn_enabled(self.btn_generate_mtnx, True)
            self.__set_btn_enabled(self.btn_execute, True)

            self.__set_btn_enabled(self.btn_mtnx_data, True)
            self.__save_mtnx()
        if line == "-1" or line == "-2":
            print("Error")
            # 进度条重置
            self.mtnx_timer.stop()
            self.pb_mtnx.setValue(0)
            self.pb_mtnx.setVisible(False)
            self.label_mtnx_running.setVisible(False)
            # 按钮打开
            self.__set_btn_enabled(self.btn_choose, True)
            self.__set_btn_enabled(self.btn_action_model, True)
            self.__set_btn_enabled(self.btn_music_analysis, True)
            self.__set_btn_enabled(self.btn_run_planner, True)
            self.__set_btn_enabled(self.btn_generate_mtnx, True)
            # 弹窗
            if line == "-1":
                self.__add_log("Network Error!!!")
            else:
                self.__add_log("Request Error!!! Please feedback your error to issue in github.")
        else:
            print(line)

    def __add_domain_item_to_scroll(self):
        """
            Add each domain result display button to the corresponding list
        """
        plan_list = PLAN_LIST['plan_list']
        for seq in range(len(plan_list)):
            # 新建一个按钮v
            item = QListWidgetItem("domain_{}".format(seq))
            item.setSizeHint(QtCore.QSize(45, 20))
            btn = QtWidgets.QPushButton()
            btn.setGeometry(QtCore.QRect(0, 40 * seq, 45, 20))
            btn.setCursor(QtCore.Qt.PointingHandCursor)
            btn.setText(QtWidgets.QApplication.translate("Robot", "Domain {}".format(seq), None, -1))
            btn.clicked.connect(partial(self.__func_print_domain_btn, seq))
            self.lw_domain.insertItem(seq, item)
            self.lw_domain.setItemWidget(item, btn)

    def __add_problem_item_to_scroll(self):
        """
            Add each problem result display button to the corresponding list
        """
        plan_list = PLAN_LIST['plan_list']
        for seq in range(len(plan_list)):
            # 新建一个按钮v
            item = QListWidgetItem("problem_{}".format(seq))
            item.setSizeHint(QtCore.QSize(45, 20))
            btn = QtWidgets.QPushButton()
            btn.setGeometry(QtCore.QRect(0, 40 * seq, 45, 20))
            btn.setCursor(QtCore.Qt.PointingHandCursor)
            btn.setText(QtWidgets.QApplication.translate("Robot", "Problem {}".format(seq), None, -1))
            btn.clicked.connect(partial(self.__func_print_problem_btn, seq))
            self.lw_problem.insertItem(seq, item)
            self.lw_problem.setItemWidget(item, btn)

    def __add_plan_item_to_scroll(self):
        """
            Add each plan result display button to the corresponding list
        """
        plan_list = PLAN_LIST['plan_list']
        for seq in range(len(plan_list)):
            # 新建一个按钮v
            item = QListWidgetItem("plan_{}".format(seq))
            item.setSizeHint(QtCore.QSize(45, 20))
            btn = QtWidgets.QPushButton()
            btn.setGeometry(QtCore.QRect(0, 40 * seq, 45, 20))
            btn.setCursor(QtCore.Qt.PointingHandCursor)
            btn.setText(QtWidgets.QApplication.translate("Robot", "Plan {}".format(seq), None, -1))
            btn.clicked.connect(partial(self.__func_print_plan_btn, seq))
            self.lw_plan.insertItem(seq, item)
            self.lw_plan.setItemWidget(item, btn)

    def __add_log(self, content):
        """
            Add error log
        """
        try:
            with open(ERROR_LOG_PATH, 'a+', encoding='utf8') as f:
                f.write(content + "\n")
            self.show_error(content)
        except FileExistsError or FileNotFoundError:
            self.show_error("Cannot found file {}, check for your directory.".format(ERROR_LOG_PATH))

    def __past_music(self):
        """
            Used music
        """
        with open(PAST_MUSIC_PATH, 'r', encoding="UTF-8") as f:
            music_list = f.readlines()
        if len(music_list) != 0:
            real_path_list = []
            item_name_list = []
            for path in music_list:
                # Exist past Music
                path = path.rstrip("\n")
                if os.path.exists(path):
                    real_path_list.append(path)
                    name = os.path.basename(path)
                    item_name_list.append(name)
                else:
                    print(path.encode("utf8"), ":Invalid.")

            # 处理音乐排序
            self.music_list = real_path_list
            for item_name in item_name_list:
                self.cb_past_music.addItem(item_name)
            self.__set_btn_enabled(self.btn_action_model, True)  # 存在则可以开始与运行
            self.cb_past_music.setCurrentIndex(len(item_name_list) - 1)
            if len(real_path_list) != 0:
                self.le_input_music.setText(real_path_list[-1])
                self.music_path = real_path_list[-1]

    def __save_mtnx(self):
        """
            Save mtnx to a local file
        """
        mtnx_file_content = SCRIPT_DATA['script']
        if not os.path.exists(MTNX_FILE_PATH):
            try:
                os.mkdir(MTNX_FILE_PATH)
            except FileExistsError:
                self.__add_log("Something is unusual while saving robot script, check your directory again.")
            except FileNotFoundError:
                self.__add_log("Something is unusual while saving robot script, check your directory again.")
        music_name = os.path.basename(self.music_path).split('.')[0]
        save_path = os.path.join(MTNX_FILE_PATH, "{}.mtnx".format(music_name))
        with open(save_path, 'w', encoding='utf8') as f:
            f.write(mtnx_file_content)
        print("Save Robot script at:", save_path)

    def show_error(self, content):
        """
            Popup displays error message
        """
        data = {
            "title": "ERROR",
            "content": content,
        }
        TextShow(self, data).show()

    def __set_cur_config(self):
        """
            Get the config
        """
        config = IOConfig().get_config()
        if config["dummy_action"] == "yes":
            self.cb_dumpy_action.setChecked(True)
        if config["best_rate"] == "yes":
            self.cb_best_rate.setChecked(True)
        if config["beat_tracker"] == 'yes':
            self.cb_beat_tracker.setChecked(True)
        if config["action_coherent"] == "yes":
            self.cb_action_coherent.setChecked(True)
        time_restrict = int(config["time_restrict"])
        self.hs_time_restrict.setValue(time_restrict)
        self.sb_time_restrict.setValue(time_restrict)

        if config["segment_type"] == "cluster":
            self.cb_segment.setCurrentIndex(0)
        else:
            self.cb_segment.setCurrentIndex(1)

        if config["plan_function"] == "parallel":
            self.cb_planning_function.setCurrentIndex(0)
        else:
            self.cb_planning_function.setCurrentIndex(1)
        return config

    @staticmethod
    def load_data(df):
        """
            Generate a model
            return: model=>QtGui.QStandardItemModel()
        """
        model = QtGui.QStandardItemModel()
        head_data = df.columns.values.tolist()
        for i in range(len(head_data)):
            item = QtGui.QStandardItem(head_data[i])
            model.setHorizontalHeaderItem(i, item)
        for index, row in df.iterrows():
            for coln in range(len(row)):
                cur_data = row[coln]
                if isinstance(cur_data, float):
                    cur_data = round(cur_data, 6)
                item = QtGui.QStandardItem(str(cur_data))
                model.setItem(index, coln, item)
        return model

    @staticmethod
    def __set_btn_enabled(btn, enabled=True):
        """
            Set button unavailable or available styles
        """
        if enabled:
            btn.setEnabled(enabled)
            btn.setStyleSheet(
                "QPushButton{background-color:#09A3DC} QPushButton:hover{background-color:rgb(60,195,245);}")
        else:
            btn.setEnabled(enabled)
            btn.setStyleSheet(
                "QPushButton{background-color:#BEBEBE}")


class ModelThread(QtCore.QThread):
    """
       Process the request in step 1
    """
    _signal = QtCore.Signal(str)

    def __init__(self, file_name, file_path, parent=None):
        super(ModelThread, self).__init__()
        self.file_name = file_name
        self.file_path = file_path

    def __del__(self):
        self.wait()

    def run(self):
        global PLAN2DANCE_REQUEST_ID
        global ACTION_MODEL
        print("Start One Process...")
        data = step_model_send_file(self.file_name, self.file_path)
        if not data:
            self._signal.emit("-2")
        else:
            status = data['status']
            if status == 1:
                action_model_dict = {}
                PLAN2DANCE_REQUEST_ID = int(data['data']['id'])
                action_model_dict['basic_action'] = data['data']['basic_action']
                action_model_dict['dummy_action'] = data['data']['dummy_action']
                print("Request ID:", PLAN2DANCE_REQUEST_ID)
                ACTION_MODEL = action_model_dict
                self._signal.emit("success")
            else:
                self._signal.emit("-2")


class AnalysisThread(QtCore.QThread):
    """
        Process the request in step 2
    """
    _signal = QtCore.Signal(str)

    def __init__(self, config, parent=None):
        super(AnalysisThread, self).__init__()
        self.config = config

    def __del__(self):
        self.wait()

    def run(self):
        global SEGMENT_LIST
        print("Start One Process...")
        print(PLAN2DANCE_REQUEST_ID)
        data = step_analysis_send_param(PLAN2DANCE_REQUEST_ID, self.config)
        if not data:
            self._signal.emit("-1")
        else:
            status = data['status']
            if status == 1:
                SEGMENT_LIST = data['data']  # 正确有数据
                self._signal.emit("success")
            elif status == 2:
                self._signal.emit("-1")
            elif status == 3:
                self._signal.emit("success")  # 直接读取文件
            else:
                self._signal.emit("-1")


class PlannerThread(QtCore.QThread):
    """
        Process the request in step 3
    """
    _signal = QtCore.Signal(str)

    def __init__(self, config, parent=None):
        super(PlannerThread, self).__init__()
        self.config = config

    def __del__(self):
        self.wait()

    def run(self):
        global PLAN_LIST
        print("Start One Process...")
        data = step_planner_send_config(PLAN2DANCE_REQUEST_ID, self.config)
        if not data:
            self._signal.emit("-2")
        else:
            status = data['status']
            if status == 1:
                PLAN_LIST = data['data']  # 正确有数据
                self._signal.emit("success")
            elif status == 2:
                self._signal.emit("-2")
            elif status == 3:
                self._signal.emit("success")  # 直接读取文件
            else:
                self._signal.emit("-2")
        # 保存数据


class RobotScriptThread(QtCore.QThread):
    """
        Process the request in step 4
    """
    _signal = QtCore.Signal(str)

    def __init__(self, parent=None):
        super(RobotScriptThread, self).__init__()

    def __del__(self):
        self.wait()

    def run(self):
        global SCRIPT_DATA
        print("Start One Process...")
        data = step_robot_script_send_id(PLAN2DANCE_REQUEST_ID)
        if not data:
            self._signal.emit("-2")
        else:

            status = data['status']
            if status == 1:
                SCRIPT_DATA = data['data']  # 正确有数据
                self._signal.emit("success")
            elif status == 2:
                self._signal.emit("-2")
            elif status == 3:
                self._signal.emit("success")  # 直接读取文件
            else:
                self._signal.emit("-2")
        # 保存数据


def step_model_send_file(filename, file_path):
    """
        Network request for Step 1
    :param filename：music name
    :param file_path：music path
    """
    url = REQUEST_PREFFIX_URL + "/api/action_model"

    with open(file_path, mode="rb")as f:  # 打开文件
        file = {
            "file": (filename, f.read()),  # 引号的file是接口的字段，后面的是文件的名称、文件的内容
        }

    encode_data = encode_multipart_formdata(file)

    file_data = encode_data[0]
    headers_from_data = {
        "Content-Type": encode_data[1],
    }
    try:
        response = requests.post(url=url, headers=headers_from_data, data=file_data)
    except OSError:
        error_data = {
            'status': 2
        }
        return error_data
    data = response.content.decode('utf-8')
    data = json.loads(data)
    return data


def step_analysis_send_param(request_id, config):
    """
        Network request for Step 2
    :param request_id: request id
    :param config: local config
    :return: 
    """
    url = REQUEST_PREFFIX_URL + "/api/music_analysis"
    file_data = {
        'request_id': request_id,
        'config': json.dumps(config)
    }
    try:
        response = requests.post(url=url, data=file_data)  # json
    except OSError:
        error_data = {
            'status': 2
        }
        return error_data
    data = response.content.decode('utf-8')
    data = json.loads(data)
    return data


def step_planner_send_config(request_id, config):
    """
        Network request for Step 3
    """
    url = REQUEST_PREFFIX_URL + "/api/planning_generation"
    file_data = {
        'request_id': request_id,
        'config': json.dumps(config)
    }
    try:
        response = requests.post(url=url, data=file_data)  # json
    except OSError:
        error_data = {
            'status': 2
        }
        return error_data
    data = response.content.decode('utf-8')
    real_data = json.loads(data)
    return real_data


def step_robot_script_send_id(request_id):
    """
        Network request for Step 4
    """
    url = REQUEST_PREFFIX_URL + "/api/script_generation"
    file_data = {
        'request_id': request_id,
    }
    try:
        response = requests.post(url=url, data=file_data)  # json
    except OSError:
        error_data = {
            'status': 2
        }
        return error_data
    data = response.content.decode('utf-8')
    real_data = json.loads(data)
    return real_data


class TextShow(QtWidgets.QDialog):
    """
        Popover information display
    """

    def __init__(self, parent=None, data=None):
        QtWidgets.QDialog.__init__(self, parent)
        self.resize(500, 250)
        self.content = data["content"]
        self.setWindowTitle(data["title"])
        self.initUi()

    def initUi(self):
        document = QtGui.QTextDocument(str(self.content))
        self.text_edit = QTextEdit()
        self.text_edit.setDocument(document)
        self.text_edit.setReadOnly(False)
        self.setStyleSheet("QPushButton{border-radius:5px;background-color: rgb(230,25,25);color:#fff;}"
                           "QPushButton:hover{background-color:rgb(250,0,0);}")
        btn_save = QtWidgets.QPushButton(self)
        btn_save.setText("Close")
        btn_save.setFixedSize(70, 30)
        btn_save.setCursor(QCursor(Qt.PointingHandCursor))
        btn_save.clicked.connect(self.close)

        vbox = QVBoxLayout()
        form_layout = QFormLayout()
        form_layout.addRow(self.text_edit)
        form_layout.addRow(btn_save)
        vbox.addLayout(form_layout)

        self.setLayout(vbox)
        self.show()


def main():
    QApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
    app = QApplication(sys.argv)
    win = MainWindow()
    win.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
