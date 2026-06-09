#!/usr/bin/env bash
# Установка Docker на Debian (11/12/13) из официального репозитория
# Использование: sudo bash install-docker-debian.sh

set -e  # прерывать скрипт при любой ошибке

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Установка Docker на Debian ===${NC}"

# Проверка, что скрипт запущен с sudo
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Ошибка: этот скрипт должен быть запущен с правами root (используйте sudo).${NC}"
   exit 1
fi

# Определяем версию Debian
if [ -f /etc/debian_version ]; then
    DEBIAN_VERSION=$(cat /etc/debian_version)
    echo -e "${GREEN}Обнаружена Debian версия: $DEBIAN_VERSION${NC}"
else
    echo -e "${RED}Этот скрипт предназначен только для Debian.${NC}"
    exit 1
fi

# 1. Обновление системы и установка зависимостей
echo -e "${YELLOW}1. Обновление списка пакетов и установка зависимостей...${NC}"
apt update && apt upgrade -y
apt install -y ca-certificates curl

# 2. Добавление официального репозитория Docker
echo -e "${YELLOW}2. Добавление официального GPG-ключа и репозитория Docker...${NC}"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Определяем кодовое имя версии Debian (bookworm, bullseye и т.д.)
VERSION_CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2)
if [ -z "$VERSION_CODENAME" ]; then
    # fallback для старых версий
    VERSION_CODENAME=$(lsb_release -cs 2>/dev/null || echo "bookworm")
fi

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $VERSION_CODENAME stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Установка Docker Engine и плагинов
echo -e "${YELLOW}3. Установка Docker Engine, CLI, containerd и плагинов...${NC}"
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Запуск Docker и добавление в автозагрузку
echo -e "${YELLOW}4. Запуск Docker и настройка автозапуска...${NC}"
systemctl enable docker
systemctl start docker

# 5. Добавление текущего пользователя (кто запустил sudo) в группу docker
if [ -n "$SUDO_USER" ]; then
    echo -e "${YELLOW}5. Добавление пользователя $SUDO_USER в группу docker...${NC}"
    usermod -aG docker "$SUDO_USER"
    echo -e "${GREEN}Пользователь $SUDO_USER добавлен в группу docker.${NC}"
    echo -e "${YELLOW}⚠️ После выхода из скрипта перезайдите в систему или выполните 'newgrp docker', чтобы применить изменения.${NC}"
else
    echo -e "${YELLOW}Не удалось определить обычного пользователя. Добавьте себя в группу docker вручную: usermod -aG docker <ваш_пользователь>${NC}"
fi

# 6. Проверка установки
echo -e "${YELLOW}6. Проверка установки (запуск hello-world)...${NC}"
if docker run --rm hello-world > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker успешно установлен и работает!${NC}"
else
    echo -e "${RED}❌ Что-то пошло не так. Проверьте вывод команд вручную.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Установка завершена ===${NC}"
echo -e "Теперь вы можете управлять Docker от имени пользователя ${GREEN}$SUDO_USER${NC} (после перезахода)."
echo -e "Попробуйте: ${YELLOW}docker run hello-world${NC}"