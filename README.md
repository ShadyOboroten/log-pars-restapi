Данный проект парсит данные из openvpn сервера для ситематизации данных

Использует Docker для запуска, PostgresSQL как база данных, nginx

# Для запуска необходимо: 

## Установить Docker engine:

sudo bash install-docker-debian.sh

## Клонировать репозиторий: 

git clone -b main git@github.com@ShadyOboroten/Pract

## Запустить docker:

cd "Директория куда установлен репозиторий"
docker compose up -d