#!/bin/bash
# migrate.sh - Скрипт для миграций

echo "🔄 Применение миграций базы данных..."

python manage.py makemigrations
python manage.py migrate

echo "✅ Миграции успешно применены!"