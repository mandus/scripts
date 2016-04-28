#!/bin/bash
#
# (C) ExpertAnalytics 2016
# Åsmund Ødegård <asmund@xal.no>
#
# This is a script in the public domain - use however you like.
#

cleanup=no
set -- `getopt c $*`
for i ; do
    case "$i"
    in
        -c) cleanup=yes; shift;;
        --) shift;;
    esac
done

if [[ $# -lt 1 ]] ; then 
    echo "Please, specify the master tex-document as argument"
    exit 1
fi

# set master-file, normalized
master=$1
[[ $master =~ ^\./.* ]] || master="./$master"

if [[ ! -f $master ]] ; then 
    echo "Unable to find master tex-document $master"
    exit 2
fi

if [[ ${master: -4} != ".tex" ]] ; then
    echo "Specified master $master doesn't look like a TeX source"
    exit 3
fi

rootline="%!TEX root=$master"
texdocs=$(find . -name '*.tex')

for file in $texdocs ; do 
    if [[ $file != $master ]] ; then 
        echo "Edit $file"
        firstline=$(head -1 $file)
        # Trim leading/trailing whitespace
        firstline="${firstline##*( )}"
        firstline="${firstline%%*( )}"
        #echo $firstline
        if [[ $firstline != $rootline ]] ; then
            if [[ $firstline =~ %.*TEX.*root.* ]] ; then
                #echo "Need to replace rootline"
                action="replace"
            else
                #echo "Need to add rootline"
                action="addline"
            fi
            #echo $firstline
        else
            #echo "Firstline already correct"
            action="ok"
            #echo $firstline
        fi
        if [[ $action = "replace" ]] ; then 
            tf=$(mktemp)
            echo "$rootline" > $tf
            tail -n +2 $file >> $tf
            mv $file $file.back
            mv $tf $file
        else if [[ $action = "addline" ]] ; then
                tf=$(mktemp)
                echo "$rootline" > $tf
                cat $file >> $tf
                mv $file $file.back
                mv $tf $file
            fi
        fi
    fi
done

if [[ $cleanup = yes ]] ; then
    find . -name '*.tex.back' -delete
fi
