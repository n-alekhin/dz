#!/bin/bash

# Проверяем, передан ли файл с результатами
if [[ $# -ne 1 ]]; then
    echo "Использование: $0 <файл_flagstat>"
    exit 1
fi

# Проверяем существование файла
FLAGSTAT_FILE=$1
if [[ ! -f "$FLAGSTAT_FILE" ]]; then
    echo "Файл $FLAGSTAT_FILE не найден."
    exit 1
fi

# Извлекаем процент картированных ридов
MAPPED_PERCENT=$(grep "mapped (" "$FLAGSTAT_FILE" | awk -F'[(%]' '{print $2}')

# Проверяем, удалось ли извлечь данные
if [[ -z "$MAPPED_PERCENT" ]]; then
    echo "Не удалось извлечь процент картированных ридов из файла $FLAGSTAT_FILE."
    exit 1
fi

# Вывод процента
echo "Процент картированных ридов: $MAPPED_PERCENT%"

# Проверка процента с помощью awk
if [[ $(awk 'BEGIN {print ("'$percents'" > 90.0)}') -eq 1 ]]; then
    echo "OK: $percents% ридов успешно картировано."
else
    echo "NOT OK: Только $percents% ридов картировано."
fi
