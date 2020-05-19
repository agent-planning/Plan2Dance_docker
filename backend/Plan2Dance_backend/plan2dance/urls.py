from django.conf.urls import url
from plan2dance.views import ActionModel, MusicAnalysis, PlanningGeneration, ScriptGeneration

urlpatterns = [
    url(r'^action_model$', ActionModel.as_view()),
    url(r'^music_analysis$', MusicAnalysis.as_view()),
    url(r'^planning_generation$', PlanningGeneration.as_view()),
    url(r'^script_generation$', ScriptGeneration.as_view()),
]
