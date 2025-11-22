#!/bin/bash
# scripts/docker-start.sh

echo "🚀 Запуск Docker проекта..."

# Останавливаем предыдущие контейнеры
echo "🛑 Остановка предыдущих контейнеров..."
docker-compose down

# Собираем проект заново
echo "🔨 Сборка Docker образа..."
docker-compose build --no-cache

# Запускаем контейнеры
echo "▶️ Запуск контейнеров..."
docker-compose up -d

# Ждем запуска базы данных
echo "⏳ Ожидание запуска базы данных..."
sleep 15

# Применяем миграции с проверкой
echo "🔄 Проверка соединения с базой данных..."
docker-compose exec web python -c "
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'shop.settings')
django.setup()
from django.db import connection
from django.core.management import execute_from_command_line
print('✅ Соединение с базой данных установлено!')
"

echo "🔄 Применение миграций..."
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate

# Собираем статические файлы
echo "📦 Сборка статических файлов..."
docker-compose exec web python manage.py collectstatic --noinput

# Создаем суперпользователя (опционально)
echo "👤 Проверка суперпользователя..."
docker-compose exec web python -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    print('Создание суперпользователя...')
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
    print('✅ Суперпользователь создан')
else:
    print('✅ Суперпользователь уже существует')
"

echo "✅ Проект успешно запущен!"
echo "🌐 Откройте в браузере: http://localhost:8000"
echo "👤 Логин администратора: admin / admin"
echo "📊 Для просмотра логов: docker-compose logs -f"