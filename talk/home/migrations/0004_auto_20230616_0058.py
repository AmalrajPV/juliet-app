# Generated by Django 3.1.7 on 2023-06-15 19:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('home', '0003_auto_20230615_2008'),
    ]

    operations = [
        migrations.AlterField(
            model_name='object',
            name='image',
            field=models.ImageField(upload_to='object_images/'),
        ),
    ]