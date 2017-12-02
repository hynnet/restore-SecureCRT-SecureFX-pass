#!/bin/bash
# by HuangYingNing at g mail dot com

listoffiles=$(find ~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions/ -type f -name '*.ini' ! -path '*/__FolderData__.ini' ! -path '*/Default.ini')
nfiles=$(echo "${listoffiles}" | wc -l)
unset files
split="//"
for i in $(seq 1 ${nfiles}) ; do
#	files[$((i-1))]=${i}-`find ~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions/ -type f -name '*.ini' ! -path '*/__FolderData__.ini' ! -path '*/Default.ini' | sed -n "${i}p;${i}q"`
	file=`echo "${listoffiles}" | sed -n "${i}p;${i}q"`
	echo file${i}=${file} path:${file%//*}  name: ${file##*//}
	if grep 'D:"Session Password Saved"=00000001-' "${file}" -q ; then
		echo ${file} 已经保存密码
	else
		password=`grep 'S:"Password V2"=02:' "${file%/Sessions//*}.personal/Sessions/${file##*//}"`
		if [ "${password}" != "" ] ; then
			echo 找到备份中的密码: ${password}
			if grep 'S:"Password V2"=' "${file}" -q ; then
#				sed -i "s/S:\"Password V2\"=.*/${password}/g" "${file}"
				# for Mac OS
				sed "s/S:\"Password V2\"=.*/${password}/g" "${file}" > /tmp/tmp.ini
				mv -f /tmp/tmp.ini "${file}"
			else
				echo "${password}" >> "${file}"
				:;
			fi
			username=`grep 'S:"Username"=' "${file%/Sessions//*}.personal/Sessions/${file##*//}"`
			if [ "${username}" != "" ] ; then
				echo "找到备份中的用户名：${username}"
				if grep 'S:"Username"=' "${file}" -q ; then
#					sed -i "s/S:\"Username\"=.*/${username}/g" "${file}"
					# for Mac OS
					sed "s/S:\"Username\"=.*/${username}/g" "${file}" > /tmp/tmp.ini
					mv -f /tmp/tmp.ini "${file}"
				else
					echo "${username}" >> "${file}"
					:;
				fi
				:;
			fi
			if grep 'D:"Session Password Saved"=' "${file}" -q ; then
#				sed -i "s/D:\"Session Password Saved\"=.*/D:\"Session Password Saved\"=00000001/g" "${file}"
				# for Mac OS
				sed "s/D:\"Session Password Saved\"=.*/D:\"Session Password Saved\"=00000001/g" "${file}" > /tmp/tmp.ini
				mv -f /tmp/tmp.ini "${file}"
				:;
			else
				echo 'D:"Session Password Saved"=00000001' >> "${file}"
				:;
			fi
			:;
		fi
	fi
done


