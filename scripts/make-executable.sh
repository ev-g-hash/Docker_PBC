#!/bin/bash
# scripts/make-executable.sh

echo "🔧 Создание исполняемых скриптов..."

chmod +x scripts/*.sh

echo "✅ Все скрипты теперь исполняемые!"
echo ""
echo "📋 Доступные команды:"
echo "  ./scripts/menu.sh              - Интерактивное меню"
echo "  ./scripts/full-start.sh        - Полный запуск"
echo "  ./scripts/quick-restart.sh     - Быстрый перезапуск"
echo "  ./scripts/stop-and-clean.sh    - Остановка и очистка"
echo "  ./scripts/emergency-clean.sh   - Экстренная очистка"
echo "  ./scripts/status.sh            - Проверка статуса"
echo "  ./scripts/diagnose.sh          - Диагностика"