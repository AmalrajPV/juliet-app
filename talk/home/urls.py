from django.urls import path
from . import views


urlpatterns = [
    path('register', views.RegisterView.as_view(), name='register'),
    path('login', views.LoginView.as_view(), name='login'),
    path('myprofile', views.UserDataView.as_view(), name='myprofile'),
    path('change-password', views.ChangePasswordView.as_view(), name='change-password'),
    path('object', views.RandomObjectView.as_view(), name='object'),
    path('avatar', views.AvatarListView.as_view(), name='avatar'),
    path('speech-recognition', views.SpeechRecognitionView.as_view(), name='speech_recognition')
]
