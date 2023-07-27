from django.urls import path
from api.views.view_account import AccountViews, getAccounts
from api.views.view_catagories import getCategories

from api.views.view_login import LoginAPI
from api.views.view_menu import getMenu
from api.views.view_products import getProducts
from api.views.view_register import RegisterAPI
from api.views.view_store import getStores
from api.views.view_orders import OrderViews, getOrders

urlpatterns = [
    path('login/', LoginAPI.as_view(), name='login'),
    path('register/', RegisterAPI.as_view(), name='register'),
    path('user/', AccountViews.as_view()),
    path('getuser/', getAccounts),
    path('getstores/', getStores),
    path('getmenu/', getMenu),
    path('getcategories/', getCategories, name="categories"),
    path('getproducts/', getProducts, name="products"),
    path('order/', OrderViews.as_view(), name="order"),
    path('getorders/', getOrders, name="orders"),
]