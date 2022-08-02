#!/bin/bash
## This is a multiplication shell script, Calculate decimals using command 'expr'.
## Writen by callcz 20220801
if [[ $1 == '--help' || $1 == '-h' || ! $1 ]]
then
	head -n3 $0
	echo  "  Usage : $0 [FACTOR 0] [FACTOR 1] [FACTOR 2] ..."
	exit
fi
yin=($*)
for ((i=0;i<${#yin[@]};i++))
do
#	echo $i
	for j in ${yin[$i]}
	do
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
			done
			if [[ $check == 0 ]]
			then
				echo \"$j\" is no a figure.
				exit $(expr $i + 1)
			fi
		done
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
#如果因数是0
for i in ${yin_b[@]}
do
	if [[ $i -eq 0 ]]
	then
		deshu=0
		echo $deshu
		exit
	fi
done
#去掉前面的0
for i in ${yin_b[@]}
do
	if [[ ${i:0:1} -eq 0 ]]
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
#echo yin_c=${yin_c[@]}
#用expr计算
for i in ${yin_c[@]}
do
	deshu_c=${deshu_c:-1}
	deshu_c=`expr $deshu_c \* $i`
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
	deshu=$zhengshu.$xiaoshu
	if [[ $xiaoshu -eq 0 ]]
	then
	deshu=$zhengshu
	fi
fi
echo $deshu
exit
