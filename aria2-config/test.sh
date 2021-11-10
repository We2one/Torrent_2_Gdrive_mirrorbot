#!/bin/bash
category=""

lc(){ #usage: lc "SOME STRING" -> "some string"
    i=0
    while ([ $i -lt ${#1} ]) do
        CUR=${1:$i:1}
        case $uppers in
            *$CUR*)CUR=${uppers%$CUR*};OUTPUT="${OUTPUT}${lowers:${#CUR}:1}";;
            *)OUTPUT="${OUTPUT}$CUR";;
        esac
        i=$((i+1))
    done
    echo "${OUTPUT}"
}


lowercase() {
    word="$1"
    for((i=0;i<${#word};i++)); do
        ch="${word:$i:1}"
        lowercaseChar "$ch"
    done
}


DoWork(){
       category=$1
       # uploadpath=${path}
       # remotepath="${name}:${folder}/$category/${rdp%%/*}"
       # Task_INFO
       # Upload
        echo $category
}


#contains function
Contains(){
lowercase="$(tr [A-Z] [a-z] <<< $1)"
echo $lowercase
case "$lowercase" in
        *jayspov*) DoWork "Jayspov" ;;
        *tiny4k*) DoWork "Tiny4k" ;;
        *cum4k*) DoWork "Cum4k" ;;
        *myfamilypies*) DoWork "MyFamilyPies" ;;
        *brattysis*) DoWork "Brattysis" ;;
        *sislovesme*) DoWork "Sislovesme" ;;
        *) DoWork "Others";;
esac
}

Contains $1
