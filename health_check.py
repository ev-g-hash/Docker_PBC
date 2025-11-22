#!/bin/bash
# health_check.py
import requests
import time
import sys

def check_health():
    """Проверка здоровья приложения"""
    max_attempts = 30
    attempt = 0
    
    while attempt < max_attempts:
        try:
            response = requests.get('http://localhost:8000/health/', timeout=5)
            if response.status_code == 200:
                print("✅ Приложение работает нормально")
                return True
        except requests.exceptions.RequestException:
            pass
        
        attempt += 1
        print(f"⏳ Попытка {attempt}/{max_attempts} - ожидание запуска приложения...")
        time.sleep(10)
    
    print("❌ Приложение не запустилось после всех попыток")
    return False

if __name__ == "__main__":
    check_health()