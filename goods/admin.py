# goods/admin.py
from django.contrib import admin
from .models import Categories, Products


@admin.register(Categories)
class CategoriesAdmin(admin.ModelAdmin):
    """Админ-панель для категорий"""
    list_display = ['id', 'name']
    list_display_links = ['id', 'name']
    search_fields = ['name']
    prepopulated_fields = {}  # Убираем prepopulated_fields для избежания ошибки


@admin.register(Products)
class ProductsAdmin(admin.ModelAdmin):
    """Админ-панель для товаров"""
    list_display = ['id', 'name', 'category', 'created_at']
    list_display_links = ['id', 'name']
    list_filter = ['category', 'created_at']
    search_fields = ['name', 'description']
    readonly_fields = ['created_at', 'updated_at']
    
    fieldsets = (
        ('Основная информация', {
            'fields': ('name', 'description', 'category')
        }),
        ('Изображение', {
            'fields': ('image',)
        }),
        ('Системная информация', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )