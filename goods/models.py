# goods/models.py
from django.db import models


class Categories(models.Model):
    """Модель категорий товаров"""
    name = models.CharField(
        max_length=100,
        verbose_name='Название категории',
        help_text='Введите название категории'
    )
    
    class Meta:
        verbose_name = 'Категория'
        verbose_name_plural = 'Категории'
        ordering = ['name']
    
    def __str__(self):
        return self.name


class Products(models.Model):
    """Модель товаров"""
    name = models.CharField(
        max_length=200,
        verbose_name='Название товара',
        help_text='Введите название товара'
    )
    description = models.TextField(
        verbose_name='Описание товара',
        help_text='Введите подробное описание товара'
    )
    image = models.ImageField(
        upload_to='products/',
        verbose_name='Изображение товара',
        help_text='Загрузите изображение товара',
        blank=True,
        null=True
    )
    category = models.ForeignKey(
        Categories,
        on_delete=models.CASCADE,
        related_name='products',
        verbose_name='Категория'
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='Дата создания'
    )
    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name='Дата обновления'
    )
    
    class Meta:
        verbose_name = 'Товар'
        verbose_name_plural = 'Товары'
        ordering = ['-created_at']
    
    def __str__(self):
        return self.name
