#! /bin/bash
#Created by Ravinder Singh

#Define variables
musage=$( free | awk '/Mem/{printf("%.0f"), $3/$2*100}' )
datex=$( date '+%Y%m%d %H:%M' )
echo $datex > top10.txt
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -11 >> top10.txt

#Define arguments
while getopts c:w:e: options; do
               case $options in
               c) critical=$OPTARG;;
	       w) warning=$OPTARG;;
               e) email=$OPTARG;;
esac
done

#Check if arguments are null or empty
if [[ -z $critical || -z $warning || -z $email ]]; then
   echo =============================================================
   echo 'One or more variables are undefined(critical, warning,email)'
   echo 'Example: ./memory_check.sh -c 90 -w 60 -e email@mine.com'
   echo ============================================================= 
   exit 1
fi

#Check if arguments are valid
if [[ $critical -le $warning || $warning -ge $critical ]];then
    echo =============================================================
    echo "Incorect usage, Warning value must not exceed critical value"
    echo 'Your input for critical:' $critical 
    echo 'Your input for warning:' $warning
    echo 'Error: Warning value' $warning '>= Critical value'  $critical
    echo =============================================================
    exit 1
fi

#Check if arguments meet the criterias
if [ $musage -ge $critical ]
  then
   echo =============================================================
   echo 'Alert: Memory usage has reached/exceeded crtical threshhold'
   echo 'Memory usage is:' $musage%
   echo 'Critical threshold is:' $critical%
   echo 'Now sending an email to:' $email
   mail -s "$datex memory check -critical" -a top10.txt  $email <<< "Hi $email, memory usage is critical, please see attached files"
   echo =============================================================
   exit 2

elif [[ $musage -ge $warning && $musage -lt $critical ]];then
    echo =============================================================
    echo 'Alert: Memory usage has reached/exceeded warning threshold' 
    echo 'Memory usage is:' $musage%
    echo 'Warning threshold is:' $warning%
    echo =============================================================
    exit 1
else
    echo =============================================================
    echo 'Info: Memory usage is less than the warning threshold' $warning%
    echo 'Everything is normal'
    echo =============================================================
    exit 0
fi














