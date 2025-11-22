#!/bin/bash
# scripts/docker-status.sh

echo "📊 Статус Docker контейнеров:"

# Показываем работающие контейнеры
echo "🟢 Работающие контейнеры:"
docker-compose ps

echo ""
echo "📋 Логи веб-приложения:"
docker-compose logs web --tail=10

echo ""
echo "📋 Логи базы данных:"
docker-compose logs db --tail=10