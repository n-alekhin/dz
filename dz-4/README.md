1) https://www.ncbi.nlm.nih.gov/sra/SRX27143984[accn]
2) в scr.sh
3) в flagstat_output.txt
4) в scr2.sh
6)
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

conda create -n snakemake-env -c conda-forge -c bioconda snakemake
conda activate snakemake-env
sudo apt install graphviz
7)
rule test:
    shell:
        'echo Hello world'
8)
Assuming unrestricted shared filesystem usage.
host: LAPTOP-DRG6QRID
Building DAG of jobs...
Using shell: /usr/bin/bash
Provided cores: 8
Rules claiming more threads will be scaled down.
Job stats:
job      count
-----  -------
test         1
total        1

Select jobs to execute...
Execute 1 jobs...

[Sun Dec 22 12:34:29 2024]
localrule test:
    jobid: 0
    reason: Rules with neither input nor output files are always executed.
    resources: tmpdir=/tmp

Hello world
[Sun Dec 22 12:34:29 2024]
Finished job 0.
1 of 1 steps (100%) done
Complete log: .snakemake/log/2024-12-22T123429.328497.snakemake.log



лог в Hello.log
10) Snakefile
11) mapping_quality_report.txt
12) 2024-12-22T125957.696038.snakemake.log
13) pipeline.png
14) использовал команду snakemake --dag | dot -Tpng > pipeline.png
формируется граф на основе правил. узел правило, стрлка это зависимость 