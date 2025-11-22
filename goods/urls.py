# goods/urls.py
from django.urls import path
from . import views

app_name = 'goods'

urlpatterns = [
    path('', views.catalog, name='catalog'),
    path('product/<int:product_id>/', views.product_detail, name='product_detail'),
    path('category/<int:category_id>/', views.category_products, name='category_products'),
]