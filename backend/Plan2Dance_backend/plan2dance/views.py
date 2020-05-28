import json
import os
from time import time

from rest_framework.parsers import MultiPartParser
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from plan2dance.Plan2Dance.run import run_action_model, run_music_analysis, run_planning_generation, run_generate_script
from plan2dance.models import TaskManage

ALLOWED_EXTENSIONS = set(['mp3'])


def allowed_file(filename):  # 验证上传的文件名是否符合要求，文件名必须带点并且符合允许上传的文件类型要求，两者都满足则返回 true
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


temp_dir = '/home/plan2dance/music'


class ActionModel(APIView):
    parser_classes = [MultiPartParser, ]

    def post(self, request, *args, **kwargs):
        """
            Step 1: Action Model
        """

        try:
            file_obj = request.data['file']
            if not (file_obj and allowed_file(file_obj.name)):
                raise ValueError
            music_path = os.path.join(temp_dir, f"{int(time())}_{file_obj.name}")
            with open(music_path, 'wb') as f:
                for chunk in file_obj.chunks():
                    f.write(chunk)
            data = run_action_model(music_path)
            pkl_path = data['pkl_path']
            task = {
                'music_path': music_path,
                'pkl_path': pkl_path,
                'step_action_model': True
            }
            tm = TaskManage(**task)
            tm.save()
            result = {
                'data': {
                    "id": tm.id,
                    'basic_action': data['basic_action'],
                    'dummy_action': data['dummy_action']
                },
                'status': 1
            }
            return Response(result, status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return Response({}, status=status.HTTP_408_REQUEST_TIMEOUT)


class MusicAnalysis(APIView):
    def post(self, request, *args, **kwargs):
        """
                Step 2: Music Analysis
            """
        try:
            request_id = int(request.data['request_id'])
            origin_config = request.data['config']
            config = get_config(origin_config)
            task = TaskManage.objects.get(id=request_id)
            if not task:
                return False
            pkl_path = task.pkl_path
            data = run_music_analysis(pkl_path, config)
            task.step_music_analysis = True
            task.save()
            result = {
                'data': {
                    'segment_result': data['segment_result']
                },
                'status': 1
            }
            return Response(result, status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return Response({}, status=status.HTTP_408_REQUEST_TIMEOUT)


class PlanningGeneration(APIView):
    def post(self, request, *args, **kwargs):
        try:
            request_id = int(request.data['request_id'])
            origin_config = request.data['config']
            config = get_config(origin_config)
            task = TaskManage.objects.get(id=request_id)
            if not task:
                raise
            pkl_path = task.pkl_path
            data = run_planning_generation(pkl_path, config)
            task.step_planning_generation = True
            task.save()
            # 这里plan_list要转为字典
            result = {
                'data': {
                    'plan_list': plan_objects_to_json(data['plan_list'])
                },
                'status': 1
            }
            return Response(result, status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return Response({}, status=status.HTTP_408_REQUEST_TIMEOUT)


class ScriptGeneration(APIView):
    def post(self, request, *args, **kwargs):
        try:
            request_id = request.data['request_id']
            task = TaskManage.objects.get(id=request_id)
            if not task:
                return False
            pkl_path = task.pkl_path
            data = run_generate_script(pkl_path)
            task.step_script_generation = True
            # task.result_path = data['ts']
            result = {
                'data': {
                    'script': data['ts']
                },
                'status': 1
            }
            return Response(result, status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return Response({}, status=status.HTTP_408_REQUEST_TIMEOUT)


def get_config(origin_config):
    if isinstance(origin_config, str):
        return json.loads(origin_config)
    else:
        return dict(origin_config)


def plan_objects_to_json(plan_results):
    """
        转换objects为json
    """
    datas = {}
    for plan in plan_results:
        datas[str(plan.seq)] = {
            'seq': plan.seq,
            'domain': plan.domain,
            'problem': plan.problem,
            'plan': plan.plan,
        }
    return datas
