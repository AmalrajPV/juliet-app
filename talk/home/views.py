from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate
from .models import User, Avatar, Object
from .serializers import UserSerializer, AvatarSerializer, ObjectSerializer, UserViewSerializer, \
    ChangePasswordSerializer
from rest_framework_simplejwt.tokens import AccessToken
from random import choice
import speech_recognition as sr
from django.contrib.auth.hashers import check_password


class AvatarListView(APIView):
    def get(self, request):
        avatars = Avatar.objects.all()
        serializer = AvatarSerializer(avatars, many=True)
        return Response(serializer.data)


class SpeechRecognitionView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        audio_file = request.FILES['audio']
        print(audio_file)
        phrase = request.data.get('phrase')

        recognizer = sr.Recognizer()
        with sr.AudioFile(audio_file) as source:
            audio_data = recognizer.record(source)

        try:
            text = recognizer.recognize_google(audio_data)
            if text.lower() == phrase.lower():
                return Response({'text': text, 'result': "Correct pronunciation"})
            return Response({'text': text, 'result': "Wrong pronunciation"})
        except sr.UnknownValueError:
            return Response({'error': 'Could not understand audio'}, status=400)


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = []

    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        print(request.data)

        # Check if a user with the given email already exists
        if User.objects.filter(email=email).exists():
            return Response(
                {'error': 'User with this email already exists.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        access_token = AccessToken.for_user(user)
        access_token.set_exp(None)  # Set the token to never expire
        return Response(
            {
                "access_token": str(access_token),
            },
            status=status.HTTP_201_CREATED,
        )


class LoginView(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')

        # Authenticate using both email and username
        user = authenticate(request, email=email, password=password) or authenticate(request, username=email,
                                                                                     password=password)

        if user:
            access_token = AccessToken.for_user(user)
            access_token.set_exp(None)  # Set the token to never expire
            return Response({'access_token': str(access_token)})
        else:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


class UserDataView(generics.RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserViewSerializer

    def get_object(self):
        return self.request.user


class RandomObjectView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        objects = Object.objects.all()
        if(objects is None):
            return Response({'message':'no objects found'}, status=status.HTTP_204_NO_CONTENT)

        random_object = choice(objects)
        serializer = ObjectSerializer(random_object)
        return Response(serializer.data)

class ChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):

        serializer = ChangePasswordSerializer(data=request.data)
        if serializer.is_valid():
            user = request.user
            old_password = serializer.validated_data['old_password']
            new_password = serializer.validated_data['new_password']

            if not check_password(old_password, user.password):
                return Response({'error': 'Invalid old password'}, status=status.HTTP_400_BAD_REQUEST)

            user.set_password(new_password)
            user.save()

            return Response({'success': 'Password changed successfully'}, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
