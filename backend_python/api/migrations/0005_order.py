# Generated by Django 4.2.3 on 2023-07-13 12:05

import datetime
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_account'),
    ]

    operations = [
        migrations.CreateModel(
            name='Order',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('quantity', models.IntegerField(default=1)),
                ('price', models.IntegerField()),
                ('address', models.CharField(blank=True, default='', max_length=100)),
                ('date', models.DateField(default=datetime.datetime.today)),
                ('status', models.IntegerField(default=1)),
                ('cRT', models.TextField(blank=True, default='')),
                ('customer', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.account')),
            ],
        ),
    ]
