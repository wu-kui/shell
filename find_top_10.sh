#!/bin/bash
# author: wukui
#
#
echo `date`
echo -e "进程ID\t占用内存\t程序"
for i in `ps aux |awk '{print $2}'`
do
    grep -q VmRSS /proc/$i/status 2>/dev/null || continue
    [ $i == 1 ] && continue
    if ps aux |grep $i > /dev/null 2>&1
    then
        use_mem=`grep VmRSS /proc/${i}/status |grep -v grep |awk '{print $2}'` 
        process_dir=`ls -l /proc/$i/ |grep exe |grep -v grep |awk '{print $11}'`
    else
        continue
    fi
    ps aux |grep -q $i &&echo -e "${i}\t${use_mem}\t${process_dir}"
    #echo $i
done | sort -nrk2 | awk -F'\t' '{
    pid[NR]=$1;
    mem[NR]=$2;
    proce[NR]=$3;
}END{
    for(i=1;i<length(pid);i++){
        if(mem[i]<1024)
        {
            printf "%-7s%-10s %s\n",pid[i],mem[i]"-KB",proce[i]; continue
        }
        if(mem[i]<1048576){
            printf "%-7s%-10s %s\n",pid[i],mem[i]/1024"-MB",proce[i]
        }else{
            printf "%-7s%-10s %s\n",pid[i],mem[i]/1024/1024"-GB",proce[i]
        }

    }
}'  |head -n 10
