#!/bin/bash
# scripts/check-production.sh

echo "🔍 Проверка настроек для продакшна..."

# Проверяем переменные окружения
echo "🔧 Проверка переменных окружения..."
if [ -z "$SECRET_KEY" ]; then
    echo "❌ SECRET_KEY не установлен!"
    exit 1
fi

# Проверяем настройки Django
echo "📋 Проверка настроек Django..."
docker-compose exec web python manage.py check --deploy

# Проверяем доступность на 0.0.0.0:8000
echo "🌐 Проверка доступности на 0.0.0.0:8000..."
if curl -f http://0.0.0.0:8000/ > /dev/null 2>&1; then
    echo "✅ Приложение доступно на 0.0.0.0:8000"
else
    echo "❌ Приложение недоступно на 0.0.0.0:8000"
fi

# Проверяем ALLOWED_HOSTS
echo "🔐 Проверка ALLOWED_HOSTS..."
docker-compose exec web python -c "
import os
from django.conf import settings
print(f'ALLOWED_HOSTS: {settings.ALLOWED_HOSTS}')
print(f'DEBUG: {settings.DEBUG}')
print(f'HOST: 0.0.0.0 включен: {\"0.0.0.0\" in settings.ALLOWED_HOSTS}')
"

echo "✅ Проверка завершена!"