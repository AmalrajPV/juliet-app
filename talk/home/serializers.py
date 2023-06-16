from rest_framework import serializers
from .models import User, Avatar, Object


class AvatarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Avatar
        fields = ('id', 'image')


class UserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    username = serializers.CharField(required=True)
    avatar = serializers.PrimaryKeyRelatedField(queryset=Avatar.objects.all(), required=False)

    class Meta:
        model = User
        fields = ('id', 'email', 'username', 'password', 'avatar')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        email = validated_data.get('email')
        username = validated_data.get('username')
        password = validated_data.get('password')
        avatar_id = validated_data.get('avatar')

        user = User(email=email, username=username, avatar=avatar_id)
        user.set_password(password)
        user.save()

        return user


class UserViewSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    username = serializers.CharField(required=True)
    avatar = AvatarSerializer(read_only=True)

    class Meta:
        model = User
        fields = ('id', 'email', 'username', 'password', 'avatar')
        extra_kwargs = {'password': {'write_only': True}}
        depth = 1


class ObjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Object
        fields = ('id', 'name', 'image')


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True)
