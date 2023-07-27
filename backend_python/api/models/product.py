from django.db import models

from api.models.menu import Menu

from .category import Category

class Product(models.Model):
    name = models.CharField(max_length=60)
    price = models.IntegerField(default=0)
    menu_id = models.ForeignKey(Menu, on_delete=models.CASCADE, default=1)
    category_id = models.ForeignKey(Category, on_delete=models.CASCADE, default=1)
    description = models.CharField(
        max_length=500, default='', blank=True, null=True)
    image = models.TextField()
    qty = models.IntegerField(default=0)
    volume = models.IntegerField(default=0)
    discount = models.IntegerField(default=0)
    

    class Meta:
        verbose_name_plural = "Products"

    def __str__(self):
        volume = ''
        if (self.volume > 1000):
            volume = '{}L'.format(self.volume / 1000)
        else:
            volume = '{}ml'.format(self.volume)
        
        return  '{} {}'.format(self.name,volume)