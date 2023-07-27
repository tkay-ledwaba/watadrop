from django.db import models

class Menu(models.Model):
    title = models.CharField(max_length=30)
    
    def __str__(self):
        return self.title
    