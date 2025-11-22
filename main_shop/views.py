# main_shop/views.py
import requests
from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.http import require_http_methods
from .forms import ContactForm
from goods.models import Products
from goods.forms import ProductOrderForm


def index(request):
    return render(request, 'main_shop/index.html')


def aboutas(request):
    return render(request, 'main_shop/aboutas.html')


def readmore(request):
    return render(request, 'main_shop/readmore.html')

# main_shop/views.py (обновленный def forms)
@require_http_methods(["GET", "POST"])
def forms(request):
    """Обработка формы заявки"""
    if request.method == 'GET':
        form = ContactForm()
        return render(request, 'main_shop/forms.html', {'form': form})
    
    elif request.method == 'POST':
        form = ContactForm(request.POST)
        
        if form.is_valid():
            # Получаем очищенные данные
            name = form.cleaned_data['name'].strip()
            email = form.cleaned_data['email'].strip()
            phone = form.cleaned_data['phone'].strip()
            message = form.cleaned_data['message'].strip()
            
            # Логируем попытку отправки
            print(f"Получена форма от {name} ({email})")
            
            # Отправляем в Telegram
            BOT_TOKEN = '8581138752:AAEyEJWYZrjo0GjdKowbIk23tA9k7qDr0oY'
            CHAT_ID = '443467930'
            TELEGRAM_API = f'https://api.telegram.org/bot{BOT_TOKEN}/sendMessage'
            
            telegram_message = f"""Вам новая заявка:
Имя: {name}
Email: {email}
Телефон: {phone}
Сообщение: {message}"""

            try:
                requests.post(TELEGRAM_API, data={
                    'chat_id': CHAT_ID,
                    'text': telegram_message
                })
                print(f"Заявка от {name} успешно отправлена в Telegram")
            except Exception as e:
                print(f"Ошибка отправки в Telegram: {e}")

            # Возвращаем красивую страницу с сообщением и кнопками
            context = {
                'success_message': 'Ожидайте в ближайшее время мы с вами свяжемся!',
                'user_name': name
            }
            return render(request, 'main_shop/success.html', context)
        else:
            return render(request, 'main_shop/forms.html', {'form': form})


@require_http_methods(["GET", "POST"])
def order_product(request):
    """Обработка заказа товара"""
    if request.method == 'POST':
        form = ProductOrderForm(request.POST)
        
        if form.is_valid():
            product_id = form.cleaned_data['product_id']
            quantity = form.cleaned_data['quantity']
            
            try:
                product = Products.objects.get(id=product_id)
                
                # Отправляем в Telegram
                BOT_TOKEN = '8581138752:AAEyEJWYZrjo0GjdKowbIk23tA9k7qDr0oY'
                CHAT_ID = '443467930'
                TELEGRAM_API = f'https://api.telegram.org/bot{BOT_TOKEN}/sendMessage'
                
                telegram_message = f"""Заказ товара:
Товар: {product.name}
Количество: {quantity}
Ссылка на товар: http://127.0.0.1:8000/goods/product/{product_id}/"""

                requests.post(TELEGRAM_API, data={
                    'chat_id': CHAT_ID,
                    'text': telegram_message
                })
                
                return HttpResponse("Заказ принят! Мы свяжемся с вами в ближайшее время!")
            except Products.DoesNotExist:
                return HttpResponse("Товар не найден.", status=404)
        else:
            return HttpResponse("Ошибка в форме заказа.", status=400)
    
    return HttpResponse("Метод не разрешен.", status=405)