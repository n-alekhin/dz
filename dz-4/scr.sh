#!/bin/bash

# Убедимся, что все входные файлы существуют
if [[ ! -f "GCF_000005845.2_ASM584v2_genomic.fna" ]]; then
    echo "Файл GCF_000005845.2_ASM584v2_genomic.fna не найден. Проверьте наличие референсного генома."
    exit 1
fi

if [[ ! -f "SRR31782600_1.fastq" || ! -f "SRR31782600_2.fastq" ]]; then
    echo "Файлы SRR31782600_1.fastq и SRR31782600_2.fastq не найдены. Проверьте входные данные."
    exit 1
fi

# Шаг 1: Индексирование референсного генома
echo "Индексирование референсного генома..."
bwa index GCF_000005845.2_ASM584v2_genomic.fna
if [[ $? -ne 0 ]]; then
    echo "Ошибка на этапе индексирования."
    exit 1
fi

# Шаг 2: Картирование ридов на референсный геном
echo "Картирование ридов на референсный геном..."
bwa mem GCF_000005845.2_ASM584v2_genomic.fna SRR31782600_1.fastq SRR31782600_2.fastq > aligned_reads.sam
if [[ $? -ne 0 ]]; then
    echo "Ошибка на этапе картирования."
    exit 1
fi

# Шаг 3: Конвертация SAM в BAM
echo "Конвертация SAM в BAM..."
samtools view -bS aligned_reads.sam > aligned_reads.bam
if [[ $? -ne 0 ]]; then
    echo "Ошибка на этапе конвертации SAM в BAM."
    exit 1
fi

# Шаг 4: Оценка качества картирования
echo "Оценка качества картирования..."
samtools flagstat aligned_reads.bam > flagstat_output.txt
if [[ $? -ne 0 ]]; then
    echo "Ошибка на этапе оценки качества."
    exit 1
fi

# Шаг 5: Проверка процента картированных ридов через awk
echo "Проверка процента картированных ридов..."
MAPPED_PERCENT=$(grep "mapped (" flagstat_output.txt | awk -F'[(%]' '{print $2}')
if [[ -z "$MAPPED_PERCENT" ]]; then
    echo "Не удалось извлечь процент картированных ридов из файла flagstat_output.txt."
    exit 1
fi

if [[ $(awk 'BEGIN {print ("'$MAPPED_PERCENT'" > 90.0)}') -eq 1 ]]; then
    echo "OK: $MAPPED_PERCENT% ридов успешно картировано." > result.txt
    # Сортировка BAM только если картирование прошло успешно
    echo "Сортировка BAM..."
    samtools sort aligned_reads.bam -o aligned_reads_sorted.bam
    if [[ $? -ne 0 ]]; then
        echo "Ошибка на этапе сортировки BAM."
        exit 1
    fi
else
    echo "NOT OK: Только $MAPPED_PERCENT% ридов картировано." > result.txt
fi

echo "Анализ завершен. Результаты сохранены в result.txt."

