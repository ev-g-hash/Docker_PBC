#!/bin/bash
# scripts/diagnose.sh

echo "🔍 ДИАГНОСТИКА ПРОБЛЕМ DOCKER"

echo ""
echo "📋 Информация о Docker:"
docker --version
docker-compose --version

echo ""
echo "📊 Статус всех контейнеров:"
docker ps -a

echo ""
echo "📋 Последние ошибки веб-контейнера:"
docker-compose logs web --tail=30 | grep -i error || echo "Ошибки не найдены"

echo ""
echo "📋 Последние ошибки базы данных:"
docker-compose logs db --tail=30 | grep -i error || echo "Ошибки не найдены"

echo ""
echo "💾 Использование ресурсов:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

echo ""
echo "🌐 Проверка портов:"
netstat -tuln | grep :8000 || echo "Порт 8000 не занят"
netstat -tuln | grep :5432 || echo "Порт 5432 не занят"

echo ""
echo "🔧 Рекомендации:"
echo "1. Если контейнеры не запускаются: ./scripts/emergency-clean.sh"
echo "2. Если проблемы с базой данных: docker-compose restart db"
echo "3. Если проблемы с веб-приложением: docker-compose restart web"
echo "4. Для полного перезапуска: ./scripts/full-start.sh"