from django.db import models

# Create your models here.
class Store(models.Model):
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    phone = models.CharField(max_length=12)
    email = models.EmailField()
    
    def __str__(self):
        return self.name

    class Meta:
        db_table = "stores"
