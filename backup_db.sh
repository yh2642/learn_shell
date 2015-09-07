#!/bin/bash

# program try to auto backup databases
# History:
# 2015/9/6 YichaoHu First Release

PATH = /usr/local/mysql/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
MYSQLDBUSERNAME=root
MYSQLDBPASSWORD=password
MYSQBASEDIR=/usr/local/mysql
MYSQL=$MYSQBASEDIR/bin/mysql
MYSQLDUMP=$MYSQBASEDIR/bin/mysqldump
BACKDIR=/store/backup_data
MYSQDATADIR=/home/yichao/mysql_data/mysql
[ -x $MYSQL ] || MYSQL=mysql
[ -x $MYSQLDUMP ] || MYSQLDUMP=mysqldump
[ -d ${BACKDIR} ] || mkdir -p ${BACKDIR}



DATEFORMATTYPE1=$(date +%Y-%m-%d)
DATEFORMATTYPE2=$(date +%Y%m%d%H%M%S)


[ -d ${BACKDIR}/${DATEFORMATTYPE1} ] || mkdir ${BACKDIR}/${DATEFORMATTYPE1} # if the dir is not exist, created it
DBLIST=`ls -p $MYSQDATADIR | grep / |tr -d /`

# 1.input filename by user
echo -e "I will use 'touch' command to create 1 files"
read -p "Please input your filename: " fileuser

# 2.avoid nothing input
filename=${fileuser:-"filename"}


# 3. use command Date to determine filenames
date1=$(date +%Y%m%d)
file1=${filename}${date1}.sql



# 4. show it
echo -e "$file1\a \n"


# 5. start dump sql
mysqldump -uroot -p test1 > /store/backup_data/$file1












DBLIST=`ls -p $MYSQDATADIR | grep / |tr -d /`
for DBNAME in $DBLIST
    do ${MYSQLDUMP} --user=${MYSQLDBUSERNAME} --password=${MYSQLDBPASSWORD} --routines --events --triggers --single-transaction --flush-logs --databases ${DBNAME} | gzip > ${BACKDIR}/${DATEFORMATTYPE1}/${DBNAME}-backup-${DATEFORMATTYPE2}.sql.gz
    [ $? -eq 0 ] && echo "${DBNAME} has been backuped successful" || echo "${DBNAME} has been backuped failed"
    /bin/sleep 5
done
利用mysqldump命令备份MySQL数据库的脚本（带注释版，适合学习和测试使用）
#!/bin/bash
# MYSQLDBUSERNAME是MySQL数据库的用户名，可自定义
MYSQLDBUSERNAME=root
# MYSQLDBPASSWORD是MySQL数据库的密码，可自定义
MYSQLDBPASSWORD=password
# MYSQBASEDIR是MySQL数据库的安装目录，--prefix=$MYSQBASEDIR，可自定义
MYSQBASEDIR=/usr/local/mysql
# MYSQL是mysql命令的绝对路径，可自定义
MYSQL=$MYSQBASEDIR/bin/mysql
# MYSQLDUMP是mysqldump命令的绝对路径，可自定义
MYSQLDUMP=$MYSQBASEDIR/bin/mysqldump
# BACKDIR是数据库备份的存放地址，可以自定义修改成远程地址
BACKDIR=/var/backup/db
# 获取当前时间，格式为：年-月-日，用于生成以这种时间格式的目录名称
DATEFORMATTYPE1=$(date +%Y-%m-%d)
# 获取当前时间，格式为：年月日时分秒，用于生成以这种时间格式的文件名称
DATEFORMATTYPE2=$(date +%Y%m%d%H%M%S)
# 如果存在MYSQBASEDIR目录，则将MYSQDATADIR设置为$MYSQBASEDIR/data，具体是什么路径，就把data改成什么路径，否则将MYSQBASEDIR设定为/var/lib/mysql，可自定义
[ -d $MYSQBASEDIR ] && MYSQDATADIR=$MYSQBASEDIR/data || MYSQDATADIR=/var/lib/mysql
# 如果mysql命令存在并可执行，则继续，否则将MYSQL设定为mysql，默认路径下的mysql
[ -x $MYSQL ] || MYSQL=mysql
# 如果mysqldump命令存在并可执行，则继续，否则将MYSQLDUMP设定为mysqldump，默认路径下的mysqldump
[ -x $MYSQLDUMP ] || MYSQLDUMP=mysqldump
# 如果不存在备份目录则创建这个目录
[ -d ${BACKDIR} ] || mkdir -p ${BACKDIR}
[ -d ${BACKDIR}/${DATEFORMATTYPE1} ] || mkdir ${BACKDIR}/${DATEFORMATTYPE1}
# 获取MySQL中有哪些数据库，根据mysqldatadir下的目录名字来确认，此处可以自定义，TODO
DBLIST=`ls -p $MYSQDATADIR | grep / |tr -d /`
# 从数据库列表中循环取出数据库名称，执行备份操作
for DBNAME in $DBLIST
    # mysqldump skip one table
    # -- Warning: Skipping the data of table mysql.event. Specify the --events option explicitly.
    # mysqldump --ignore-table=mysql.event
    # http://serverfault.com/questions/376904/mysqldump-skip-one-table
    # --routines，备份存储过程和函数
    # --events，跳过mysql.event表
    # --triggers，备份触发器
    # --single-transaction，针对InnoDB，在单次事务中通过转储所有数据库表创建一个一致性的快照，此选项会导致自动锁表，因此不需要--lock-all-tables
    # --flush-logs，在dump转储前刷新日志
    # --ignore-table，忽略某个表，--ignore-table=database.table
    # --master-data=2 ，如果启用MySQL复制功能，则可以添加这个选项
    # 将dump出的sql语句用gzip压缩到一个以时间命名的文件
    do ${MYSQLDUMP} --user=${MYSQLDBUSERNAME} --password=${MYSQLDBPASSWORD} --routines --events --triggers --single-transaction --flush-logs --ignore-table=mysql.event --databases ${DBNAME} | gzip > ${BACKDIR}/${DATEFORMATTYPE1}/${DBNAME}-backup-${DATEFORMATTYPE2}.sql.gz
    # 检查执行结果，如果错误代码为0则输出成功，否则输出失败
    [ $? -eq 0 ] && echo "${DBNAME} has been backuped successful" || echo "${DBNAME} has been backuped failed"
    # 等待5s，可自定义
    /bin/sleep 5
done
