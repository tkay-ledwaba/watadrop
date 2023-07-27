import datetime

from .store import Store
from .account import Account

from django.db import models

class Order(models.Model):
    customer = models.ForeignKey(Account, on_delete=models.CASCADE)
    store = models.ForeignKey(Store, on_delete=models.CASCADE)
    price = models.IntegerField()
    address = models.CharField(max_length=250, default='', blank=True)
    cart = models.TextField(default='', blank=True)
    date = models.DateField(default=datetime.datetime.today)
    status = models.IntegerField(default=1)
    driver = models.TextField(default='', blank=True)
    reference = models.TextField(default='', blank=True)