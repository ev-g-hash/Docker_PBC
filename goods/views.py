# goods/views.py
from django.shortcuts import render, get_object_or_404
from django.core.paginator import Paginator
from django.db.models import Q
from .models import Products, Categories
from .forms import ProductOrderForm


def catalog(request):
    """Каталог товаров"""
    # Получаем все товары с изображениями
    products_list = Products.objects.filter(image__isnull=False).select_related('category')
    
    # Поиск по товарам
    search_query = request.GET.get('search', '')
    if search_query:
        products_list = products_list.filter(
            Q(name__icontains=search_query) | 
            Q(description__icontains=search_query)
        )
    
    # Фильтрация по категории
    category_id = request.GET.get('category', '')
    if category_id:
        products_list = products_list.filter(category_id=category_id)
    
    # Пагинация (не более 6 товаров на странице)
    paginator = Paginator(products_list, 6)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    # Получаем все категории для фильтра
    categories = Categories.objects.all()
    
    context = {
        'page_obj': page_obj,
        'categories': categories,
        'search_query': search_query,
        'selected_category': category_id,
    }
    
    return render(request, 'goods/catalog.html', context)


def product_detail(request, product_id):
    """Детальная страница товара"""
    product = get_object_or_404(Products.objects.select_related('category'), id=product_id)
    
    # Форма заказа товара
    form = ProductOrderForm(product_id=product_id)
    
    # Похожие товары (из той же категории, исключая текущий)
    related_products = Products.objects.filter(
        category=product.category
    ).exclude(id=product_id).filter(image__isnull=False)[:4]
    
    context = {
        'product': product,
        'form': form,
        'related_products': related_products,
    }
    
    return render(request, 'goods/product.html', context)


def category_products(request, category_id):
    """Товары определенной категории"""
    category = get_object_or_404(Categories, id=category_id)
    products_list = Products.objects.filter(
        category=category, 
        image__isnull=False
    ).select_related('category')
    
    # Пагинация
    paginator = Paginator(products_list, 6)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    context = {
        'page_obj': page_obj,
        'category': category,
        'categories': Categories.objects.all(),
    }
    
    return render(request, 'goods/catalog.html', context)
