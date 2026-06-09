Данный проект парсит данные из openvpn сервера для ситематизации данных

Использует Docker для запуска, PostgresSQL как база данных, nginx

# Для запуска необходимо: 

## Установить Docker engine:

sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

(для проверки можно использовать: sudo docker run hello-world)

## Клонировать репозиторий: 

git clone -b main git@github.com@ShadyOboroten/Pract "Директория"

## Запустить docker:
cd "Директория куда установлен репозиторий"
docker compose up -d