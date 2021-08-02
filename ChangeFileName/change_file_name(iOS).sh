#! /bin/bash

new_name="$2"
file_name_array=(".png" "@2x.png" "@3x.png")
i=0

function read_dir() {
    for file in `ls $1` #注意此处这是两个反引号，表示运行系统命令
    do
      mv $1"/"$file $1"/"$new_name${file_name_array[$i]}
      echo $1"/"$new_name${file_name_array[$i]}
      ((i++))
    done
}
#读取第一个参数
read_dir $1

# sh /Users/L/Desktop/change_file_name.sh /Users/L/Desktop/蓝湖资源存放/logo_slices XXX(要修改的名字)



