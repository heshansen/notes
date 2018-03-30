## 恢复异常主订单状态及其收货时间和完成时间
DROP PROCEDURE IF EXISTS emall_orders_errstatus_batchupdate; 
DELIMITER //
# 创建存储过程
CREATE PROCEDURE emall_orders_errstatus_batchupdate() 
BEGIN
	## 定义 变量  
    declare stopIdx int default 0;
    declare sub_receiptTime datetime;
    declare sub_finishTime datetime;
    declare m_id int;
    ## 声明游标m_orders（是个多行结果集）
    declare m_orders cursor for  
		select orderSeq from emall_orders where status='1' and subOrder=0 and needSplite=1 and orderSeq not in (select parentOrderSeq from emall_orders where status='1' and parentOrderSeq in (select orderSeq from emall_orders where status='1' and subOrder=0 and needSplite=1));
    ## 设置一个终止标记 
    declare CONTINUE HANDLER FOR SQLSTATE '02000' SET stopIdx = null;  
    ## 打开游标
    open m_orders;
     #获取游标当前指针的记录，读取一行数据并传给变量
	fetch m_orders into m_id;
    #开始循环，直到终止标记出现
    while ( stopIdx is not null) do
		## 查当前主订单下最迟收货的子订单，取出其收货时间和完成时间作为主订单的收货时间和完成时间。
        select receiptTime,finishTime into sub_receiptTime,sub_finishTime from emall_orders where status='C' and subOrder=1 and needSplite=0 and parentOrderSeq = m_id order by receiptTime DESC limit 1;
        ## 更新异常主订单状态为“已完成”，并更新收货时间和完成时间。
        if sub_receiptTime is not null then
			update emall_orders set status='C',receiptTime=sub_receiptTime,finishTime=sub_finishTime where orderSeq=m_id;
		end if;
        ## 读取下一行的数据
        fetch m_orders into m_id;
    end while;
    close m_orders;
END//
DELIMITER ;
#调用存储函数
CALL emall_orders_errstatus_batchupdate();