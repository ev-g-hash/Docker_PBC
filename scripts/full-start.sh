#!/bin/bash
# scripts/full-start.sh

echo "🚀 ПОЛНЫЙ ЗАПУСК ПРОЕКТА..."

# Проверяем наличие необходимых файлов
echo "🔍 Проверка файлов проекта..."
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Файл docker-compose.yml не найден!"
    exit 1
fi

if [ ! -f "requirements.txt" ]; then
    echo "❌ Файл requirements.txt не найден!"
    exit 1
fi

# Останавливаем предыдущие контейнеры
echo "⏹️ Остановка предыдущих контейнеров..."
docker-compose down -v

# Очищаем кэш
echo "💾 Очистка кэша сборки..."
docker builder prune -f

# Собираем образы
echo "🔨 Сборка Docker образов..."
docker-compose build --no-cache

# Запускаем контейнеры
echo "▶️ Запуск контейнеров..."
docker-compose up -d

# Ждем запуска базы данных
echo "⏳ Ожидание запуска базы данных..."
sleep 20

# Проверяем статус контейнеров
echo "📊 Проверка статуса контейнеров..."
docker-compose ps

# Применяем миграции
echo "🔄 Применение миграций..."
docker-compose exec -T web python manage.py makemigrations
docker-compose exec -T web python manage.py migrate

# Собираем статические файлы
echo "📦 Сборка статических файлов..."
docker-compose exec -T web python manage.py collectstatic --noinput

# Создаем суперпользователя
echo "👤 Создание суперпользователя..."
docker-compose exec -T web python -c "
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'shop.settings')
django.setup()
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
    print('✅ Суперпользователь создан: admin / admin')
else:
    print('✅ Суперпользователь уже существует')
"

echo "🎉 ПРОЕКТ УСПЕШНО ЗАПУЩЕН!"
echo "🌐 Откройте в браузере: http://localhost:8000"
echo "👤 Админ-панель: http://localhost:8000/admin"
echo "👤 Логин: admin | Пароль: admin"
echo "📊 Для просмотра логов: docker-compose logs -f"