import datetime
from django.db import models

# Create your models here.
from django.db.models import CharField, BooleanField, SmallIntegerField, DateTimeField, IntegerField, AutoField


class TaskManage(models.Model):
    """
        任务记录表
    """
    step_action_model = BooleanField(default=False)
    step_music_analysis = BooleanField(default=False)
    step_planning_generation = BooleanField(default=False)
    step_script_generation = BooleanField(default=False)
    music_path = CharField(max_length=255)
    pkl_path = CharField(max_length=255)
    result_path = CharField(max_length=255, null=True)
    score = SmallIntegerField(null=True)
    status = SmallIntegerField(null=True)
    start_time = DateTimeField(auto_created=datetime.datetime.now, auto_now=datetime.datetime.now)
    execute_time = IntegerField(default=None, null=True)
