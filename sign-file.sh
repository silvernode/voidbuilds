#!/bin/bash

case ${1} in
    -f)
        
        if [ ! -f "${2}" ];then
            echo "File '${2}' does not exist!"
        else
	    if [ ! -f /usr/bin/gpg ];then
                gpg2 --output "${2}.sig" --detach-sig ${2}
	    else
		gpg --output "${2}.sig" --detach-sig ${2}
	    fi

            if [ ! -f "${2}.sig" ];then
                echo "Error creating file: ${2}.sig"
            else
                echo "File ${2}.sig created!"
            fi
        fi
    ;;
esac

