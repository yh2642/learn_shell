#!/bin/bash

# program try to auto backup databases
# History:
# 2015/9/6 YichaoHu First Release

PATH = /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1.input filename by user
echo -e "I will use 'touch' command to create 3 files"
read -p "Please input your filename: " fileuser

# 2.avoid nothing input
filename=${fileuser:-"filename"}

# 3. use command Date to determine filenames
date1=$(date --date='2 days ago' +%Y%m%d)
date2=$(date --date='1 days ago' +%Y%m%d)
date3=$(date +%Y%m%d)
file1=${filename}${date1}
file2=${filename}${date2}
file3=${filename}${date3}


# 4. create filename
touch "$file1"
touch "$file2"
touch "$file3"

echo -e "Done!!! \a \n"

exit 0
