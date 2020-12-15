#!/usr/bin/env bash

docker run --name mariadb -d -e MYSQL_ROOT_PASSWORD=root -p 13306:3306 -v maria_db:/var/lib/mysql mariadb:10.4 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
docker run --name phpMyAdmin -d -e UPLOAD_LIMIT=256mb --link mariadb:db -p 8081:80 phpmyadmin/phpmyadmin:5
docker run --name postgres -d -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -p 15432:5432 -v postgres:/var/lib/postgresql/data postgres:12
docker run --name pgadmin4 -d --link postgres:db -e PGADMIN_DEFAULT_EMAIL=root -e PGADMIN_DEFAULT_PASSWORD=root -p 8082:80 -v pgadmin:/var/lib/pgadmin dpage/pgadmin4
docker run --name adminer -d --link mariadb:db -p 8080:8080 adminer
docker run --name mongodb -d mongo:latest -p 27017:27017
