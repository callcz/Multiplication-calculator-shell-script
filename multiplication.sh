#!/bin/bash
## This is a multiplication shell script, Calculate decimals using command 'expr'.
## Writen by callcz 20220801
if [[ $1 == '--help' || $1 == '-h' || ! $1 ]]
then
	head -n3 $0
	echo "
Usage : $0 [OPTIONS] [FACTOR 0] [FACTOR 1] [FACTOR 2] ...
	example: \`$0 1 0.2 -3\` as '1*0.2*(-3)'.
options:
  -	Using shell pipes as input sources.
	example: \`echo 1 0.2| $0 - -3\` as '1 * 0.2 * (-3)'.
  --help,-h	List this help.
"
	exit
fi
#处理管道
yin_proto=($*)
if [[ $1 == '-' ]]
then
	while read f
	do
		yin_proto[0]=
		yin_proto=($f ${yin_proto[@]})
	done
fi
#处理负数
yin=(${yin_proto[@]})
for ((i=0;i<${#yin[@]};i++))
do
	for j in ${yin[$i]}
	do
		if [[ ${j:0:1} == '-' && ${#j} -ne 1 ]]
		then
			yin[$i]=${j#-}
			minus_n=$(expr $minus_n + 1)
		fi
	done
done
#echo ${yin[@]}
if [[ $(expr ${minus_n:-0} % 2) -ne 0 ]]
then
	minus=1
else
	minus=0
fi
##检查参数格式是否数字
for ((i=0;i<${#yin[@]};i++))
do
#	echo $i
	for j in ${yin[$i]}
	do
		unset check_1
#		echo $j
#		echo ${#j}
		for ((k=0;k<${#j};k++))
		do
			l=${j:$k:1}
			check=0
			for m in {0..9} '.'
			do
#				echo $m
#				echo $l
				if [[ $l == '.' && ${#j} == '1' ]]
				then
					check=0
				elif [[ $m == $l ]]
				then
					check=1
				fi
				if [[ $l == '.' && $l == $m ]]
				then
					check_1=$(expr $check_1 + 1)
				fi
			done
			if [[ $check == 0 ]]
			then
				echo \"${yin_proto[$i]}\" is no a figure.
				exit $(expr $i + 1)
			fi
		done
		if [[ $check_1 -gt 1 ]]
		then
			echo "There are more then one '.' in '${yin_proto[$i]}'"
			exit $(expr $i + 1)
		fi
	done
done

#去除小数点
#yin=($*)
for i in ${yin[@]}
do
	if [[ ${i#*.} != $i ]]
	then
		j=${i#*.}
		xiaoshu=$j
		j=${#j}
		k=${i%.*}
		zhengshu=$k
		xiaoshuwei=`expr $xiaoshuwei + $j`
	else
		zhengshu=$i
	fi
	yin_b=(${yin_b[@]} $zhengshu$xiaoshu)
	unset zhengshu
	unset xiaoshu
done
#echo yin_b=${yin_b[@]}
#echo xiaoshuwei=$xiaoshuwei

#去掉前面的0
for i in ${yin_b[@]}
do
	if [[ ${i:0:1} -eq 0 && ${#i} -ne 1 ]]
	then
		while [[ ${i:0:1} -eq 0 ]]
		do
			i=${i:1}
		done
		yin_c=(${yin_c[@]} $i)
	else
		yin_c=(${yin_c[@]} $i)
	fi
done
#如果因数是0，结果为0
for i in ${yin_c[@]}
do
	if [[ $i -eq 0 ]]
	then
		deshu=0
		echo $deshu
		exit
	fi
done
#echo yin_c=${yin_c[@]}
#用expr计算
for i in ${yin_c[@]}
do
	deshu_c=${deshu_c:-1}
	deshu_c=`expr $deshu_c \* $i`
	error=$?
	if [[ $error -ne 0 && $error -ne 1 ]]
	then
	echo 'expr error'
	exit $error
	fi
done
#echo d=$deshu_c
if [[ ${#deshu_c} -lt $xiaoshuwei ]]
then
	xiaoshuwei_cha=`expr $xiaoshuwei - ${#deshu_c}`
	for ((i=0;i<=$xiaoshuwei_cha;i++))
	do
		deshu_c=0${deshu_c}
#		echo $deshu_c
#		echo $i
	done
fi
#echo $deshu_c
#添加小数点
if [[ ! $xiaoshuwei || $xiaoshuwei -eq 0 ]]
then
	deshu=$deshu_c
else
	zhengshu=${deshu_c:0:$(expr ${#deshu_c} - $xiaoshuwei)}
	if [[ ! $zhengshu ]];then zhengshu=0;fi
	xiaoshu=${deshu_c:0-$xiaoshuwei}
	while [[ ${xiaoshu:0-1} -eq 0 && ${#xiaoshu} -ne 1 ]]
	do
		xiaoshu=${xiaoshu:0:$(expr ${#xiaoshu} - 1)}
	done
	deshu=$zhengshu.$xiaoshu
	xiaoshu_kz=$xiaoshu
	while [[ ${xiaoshu_kz:0:1} -eq 0 && ${#xiaoshu_kz} -ne 1 ]]
	do
		xiaoshu_kz=${xiaoshu_kz:1}
	done
#	echo xiaoshu_kz=$xiaoshu_kz
	if [[ $xiaoshu_kz -eq 0 ]]
	then
	deshu=$zhengshu
	fi
fi
if [[ $minus -eq 1 ]]
then
	deshu='-'$deshu
fi

echo $deshu
exit 0
