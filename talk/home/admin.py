from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from home.models import User, Object, Avatar

admin.site.register(User, UserAdmin)
admin.site.register(Object)
admin.site.register(Avatar)
