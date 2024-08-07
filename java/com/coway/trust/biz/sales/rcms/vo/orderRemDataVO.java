package com.coway.trust.biz.sales.rcms.vo;

import org.apache.commons.csv.CSVRecord;

public class orderRemDataVO {

	private String orderNo;
	private String remark;
	
	public static orderRemDataVO create(CSVRecord CSVRecord){
		
		orderRemDataVO vo = new orderRemDataVO();
		
		vo.setOrderNo(CSVRecord.get(0));
		vo.setRemark(CSVRecord.get(1));
		
		return vo;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	@Override
	public String toString() {
		return "orderRemDataVO [orderNo=" + orderNo + ", remark=" + remark + "]";
	}
	
}
