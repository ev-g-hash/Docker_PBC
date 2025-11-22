#!/bin/bash
# scripts/check-db.sh

echo "🔍 Проверка соединения с базой данных..."

# Проверяем статус контейнера базы данных
echo "📊 Статус контейнера PostgreSQL:"
docker-compose ps db

# Проверяем логи базы данных
echo "📋 Последние 10 строк лога PostgreSQL:"
docker-compose logs db --tail=10

# Проверяем соединение
echo "🔄 Проверка соединения Django с PostgreSQL:"
docker-compose exec web python -c "
import os
import sys
sys.path.append('/app')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'shop.settings')

try:
    import django
    django.setup()
    from django.db import connection
    with connection.cursor() as cursor:
        cursor.execute('SELECT version();')
        version = cursor.fetchone()
        print('✅ Соединение с PostgreSQL успешно!')
        print(f'📋 Версия PostgreSQL: {version[0]}')
        
except Exception as e:
    print(f'❌ Ошибка соединения: {e}')
    print('💡 Попробуйте перезапустить контейнеры: docker-compose restart')
"