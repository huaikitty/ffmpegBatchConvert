#!/bin/bash
#202206231827

#默认值
FFmpegPath="/Applications/ffmpeg"

#默认为覆盖已有文件,空值为提示是否复写
#isOverWrite="" 
isOverWrite="-y"

#搜寻目录深度,默认为当前文件夹,不含子文件夹.置空为文件夹及所有子文件夹.
# DirDepth=""	
DirDepth="-maxdepth 1"

#是否移除元数据(metadata),置空为保留元数据
# rm_Metadata=""
rm_Metadata="-map_metadata -1"


# echo ${isOverWrite}
# echo ${DirDepth}
# echo ${StrMetadata}

echo "输入音频目录路径:"
read FileDirPath

if [ -z "$FileDirPath" ];
	then
# 	FileDirPath="/Users/Xiaoke/Desktop/莫文蔚-TheVoyage"
# 	FileDirPath="/Users/Xiaoke/Desktop/徐佳莹 - 给"
	echo "路径不能为空"
	exit
fi

echo "输入音频源后缀(默认为flac):"
read InFileType
if [ -z "$InFileType" ];
	then
	InFileType="flac"
fi

echo "输入转换后格式后缀(默认为wav):"
read OutFileType
# 
# if test "$OutFileType" == "";
if [ -z "$OutFileType" ];
then 
OutFileType="wav"
fi
# echo "$FileDirPath$InFileType$OutFileType"

#以指定后缀为搜索条件查找要处理的文件
FindedFileList=$(find "${FileDirPath}"  ${DirDepth}  -type f -name "*.${InFileType}")

#将找到的文件后缀更换为特殊符号(便于确保分割唯一性).
FindedFilePrefix=${FindedFileList//".${InFileType}"/".★"} 

OLD_IFS=${IFS}#保存原有分隔符
IFS=$'\n★' #以"换行符+特殊符号"为分割创建数组

#将字符串转为数组
FilePrefixArray=(${FindedFilePrefix})


for ExecuteConvert in ${FilePrefixArray[@]};#遍历执行转换(也将遵循换行符)
do

#恢复原有分隔符
IFS=${OLD_IFS}
# echo "${ExecuteConvert}"
$(${FFmpegPath} -i "${ExecuteConvert}${InFileType}"  ${rm_Metadata}  "${ExecuteConvert}${OutFileType}" ${isOverWrite})
done
