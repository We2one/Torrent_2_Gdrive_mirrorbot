#!/bin/bash
#=================================================
# Description: Aria2 download completes calling Rclone upload
# Lisence: MIT
# Version: 1.8
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

downloadpath='/root/Download' #Aria2下载目录
name='Loopin' #配置Rclone时填写的name
folder='/OhYeah' #网盘里的文件夹，留空为整个网盘。
retry_num=3 #上传失败重试次数

#=================下面不需要修改===================
filepath=$3 #Aria2传递给脚本的文件路径。BT下载有多个文件时该值为文件夹内第一个文件，如/root/Download/a/b/1.mp4
rdp=${filepath#${downloadpath}/} #路径转换，去掉开头的下载路径。
path=${downloadpath}/${rdp%%/*} #路径转换。下载文件夹时为顶层文件夹路径，普通单文件下载时与文件路径相同。
filename=${filepath##*/} #文件名称
extension=${filename##*.} #文件后缀
category=""

Task_INFO(){
    echo
    echo -e "[\033[1;32mUPLOAD\033[0m] Task information:"
    echo -e "-------------------------- [\033[1;33mINFO\033[0m] --------------------------"
    echo -e "\033[1;35mDownload path：\033[0m${downloadpath}"
    echo -e "\033[1;35mFile path: \033[0m${filepath}"
    echo -e "\033[1;35mUpload path: \033[0m${uploadpath}"
    echo -e "\033[1;35mRemote path：\033[0m${remotepath}"
    echo -e "-------------------------- [\033[1;33mINFO\033[0m] --------------------------"
    echo
}

Upload(){
    retry=0
    while [ $retry -le $retry_num -a -e "${uploadpath}" ]; do
        [ $retry != 0 ] && echo && echo -e "Upload failed! Retry ${retry}/${retry_num} ..." && echo
        rclone move -v "${uploadpath}" "${remotepath}"
        rclone rmdirs -v "${downloadpath}" --leave-root
        retry=$(($retry+1))
    done
    [ -e "${uploadpath}" ] && echo && echo -e "Upload failed: ${uploadpath}" && echo
    [ -e "${path}".aria2 ] && rm -vf "${path}".aria2
    [ -e "${filepath}".aria2 ] && rm -vf "${filepath}".aria2
}


DoWork(){
        category=$1
        uploadpath=${path}
        remotepath="${name}:${folder}/$category/${rdp%%/*}"
        Task_INFO
        Upload
        exit 0
}


#contains function
Contains(){
lowercase="$(tr [A-Z] [a-z] <<<$1)"
case "$lowercase" in
        *jayspov*) DoWork "Jayspov" ;;
        *tiny4k*) DoWork "Tiny4k" ;;
        *cum4k*) DoWork "Cum4k" ;;
        *myfamilypies*) DoWork "MyFamilyPies" ;;
        *brattysis*) DoWork "Brattysis" ;;
        *sislovesme*) DoWork "Sislovesme" ;;
        *creampie-angels*) DoWork "Creampie-Angels" ;;
        *teencurves*) DoWork "TeenCurves" ;;
        *teenpies*) DoWork "TeenPies" ;;
        *codex*) DoWork "Games" ;;
        *stepSiblingscaught*) DoWork "StepSiblingsCaught" ;;
        *) DoWork "Others";;
esac
}


if [[ $2 -eq 0 ]]
    then
        exit 0
fi

echo && echo -e "      \033[1;33mU P L O A D ! ! !\033[0m" && echo
echo && echo -e "      \033[1;32mU P L O A D ! ! !\033[0m" && echo
echo && echo -e "      \033[1;35mU P L O A D ! ! !\033[0m" && echo

if [ "$path" = "$filepath" ] && [ $2 -eq 1 ] #普通单文件下载，移动文件到设定的网盘文件夹。
    then
   # if [ "$extension" = "jpg" ]
    #	then 
    	#${folder} = '/testDectet'
     #   uploadpath=${filepath}
      #  remotepath="${name}:/testDectet"
        #touch yes.txt
#        Task_INFO
 #       Upload
  #      exit 0
    if ["$extension" = "pdf"]
        then
        uploadpath=${filepath}
        remotepath="${name}:/study/Books/programming"
        Task_INFO
        Upload
        exit 0
    elif ["$extension" = "exe"]
        then
        uploadpath=${filepath}
        remotepath="${name}:/general/winprogram"
        Task_INFO
        Upload
        exit 0
    elif [["$extension" = "zip"] || ["$extension"="tar.gz"]||["$extension"="7z"]]
        then 
        uploadpath="${name}:/general/zips"
        Task_INFO
        Upload
        exit 0 
    else  
        uploadpath=${filepath}
        remotepath="${name}:/others"
        #touch no.txt
        Task_INFO
        Upload
        exit 0
    fi
elif [ "$path" != "$filepath" ] && [ $2 -gt 1 ] #BT下载（文件夹内文件数大于1），移动整个文件夹到设定的网盘文件夹。
    then
         Contains $path
       # uploadpath=${path}
       # remotepath="${name}:${folder}/${rdp%%/*}"
       # Task_INFO
       # Upload
       # exit 0
elif [ "$path" != "$filepath" ] && [ $2 -eq 1 ] #第三方度盘工具下载（子文件夹或多级目录等情况下的单文件下载）、BT下载（文件夹内文件数等于1），移动文件到设定的网盘文件夹下的相同路径文件夹。
    then
        uploadpath=${filepath}
        remotepath="${name}:${folder}/${rdp%/*}"
        Task_INFO
        Upload
        exit 0
fi
Task_INFO
