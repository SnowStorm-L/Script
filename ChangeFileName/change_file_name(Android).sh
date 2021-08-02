#! /bin/bash

new_name="$2.png"

function read_dir() {
    for file in `ls $1` #注意此处这是两个反引号，表示运行系统命令
    do
     if [ -d $1"/"$file ] #注意此处之间一定要加上空格，否则会报错
     then
        read_dir $1"/"$file
     else
        mv $1"/"$file $1"/"$new_name
        echo $1"/"$new_name
     fi
    done
}
#读取第一个参数
read_dir $1

# sh /Users/L/Desktop/change_file_name.sh /Users/L/Desktop/蓝湖资源存放/logo_slices XXX(要修改的名字)
