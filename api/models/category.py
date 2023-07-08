from django.db import models

from api.models.menu import Menu



class Category(models.Model):
	title = models.CharField(max_length=50)
	menu_id = models.ForeignKey(Menu, on_delete=models.CASCADE)
	
	class Meta:
		verbose_name_plural = "Categories"

	def __str__(self):
		return self.title
