from django.contrib import admin
from api.models.account import Account
from api.models.category import Category
from api.models.menu import Menu
from api.models.product import Product
from api.models.store import Store
from api.models.orders import Order

# Register your models here.
admin.site.register(Account)
admin.site.register(Store)
admin.site.register(Menu)
admin.site.register(Category)
admin.site.register(Product)
admin.site.register(Order)