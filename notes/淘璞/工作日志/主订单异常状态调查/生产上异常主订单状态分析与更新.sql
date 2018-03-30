-- 主订单状态未正常更新订单及其所有子订单分析；
-- status=0-未支付，1-已支付，2-已发货，3，已收货，4-已取消，6-取消中，C-已完成;deliveryType=1-自提，2-快递；
-- 查所有已支付需拆分的主订单（去除正常状态），另外需要确认是否拆分订单splited=true and timestampdiff(day,'2017-12-14',submitTime)>0的订单情况，needSplite代表是否需要拆分订单
select * from emall_orders where status='1' and subOrder=0 and needSplite=1
	and orderSeq not in (select parentOrderSeq from emall_orders where status='1' and parentOrderSeq in (select orderSeq from emall_orders where status='1' and subOrder=0 and needSplite=1))
	ORDER BY payTime desc;
-- 查所上面主订单的所有子订单，
select orderSeq,splited,parentOrderSeq,status,deliveryType,submitTime,payTime,deliveryTime,cancelTime,needSplite,subOrder,removeTime,receiptTime,finishTime from emall_orders
 where parentOrderSeq in (select orderSeq from emall_orders where status='1' and subOrder=0 and needSplite=1)
 and parentOrderSeq not in(select parentOrderSeq from emall_orders where status='1' and parentOrderSeq in (select orderSeq from emall_orders where status='1' and subOrder=0 and needSplite=1))
 ORDER BY payTime desc;
-- 批量更新主订单状态,确认splited=true and timestampdiff(day,'2017-12-14',submitTime)>0的订单情况,如果无法批量更新需要手动一一更新
-- Update emall_orders set status='C' where status='1' and subOrder=false and needSplite=true and splited=true and timestampdiff(day,'2017-12-14',submitTime)>0 and orderSeq not in (select parentOrderSeq from emall_orders where status='1' and parentOrderSeq in (select orderSeq from emall_orders where status='1' and subOrder=false and needSplite=true));