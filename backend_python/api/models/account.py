from django.db import models

class Account(models.Model):
    first_name = models.CharField(max_length=200)
    last_name = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    
    def __str__(self):
        return '{} {}'.format(self.first_name,self.last_name)