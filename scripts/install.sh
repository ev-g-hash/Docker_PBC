#!/bin/bash
# scripts/install.sh

echo "🚀 Установка проекта..."

# Создание виртуального окружения
echo "📦 Создание виртуального окружения..."
python -m venv venv

# Активация виртуального окружения
echo "🔄 Активация виртуального окружения..."
source venv/bin/activate

# Обновление pip
echo "🔄 Обновление pip..."
pip install --upgrade pip

# Установка зависимостей
echo "📋 Установка зависимостей..."
pip install -r requirements.txt

# Создание .env файла
echo "⚙️ Создание .env файла..."
cp .env.example .env

# Применение миграций
echo "🔄 Применение миграций..."
python manage.py makemigrations
python manage.py migrate

# Создание суперпользователя (опционально)
echo "👤 Создание суперпользователя..."
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@example.com', 'admin') if not User.objects.filter(username='admin').exists() else None" | python manage.py shell

echo "✅ Установка завершена!"
echo "🚀 Для запуска используйте: python manage.py runserver"