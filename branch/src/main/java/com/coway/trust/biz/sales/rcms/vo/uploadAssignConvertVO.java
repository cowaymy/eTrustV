package com.coway.trust.biz.sales.rcms.vo;

import org.apache.commons.csv.CSVRecord;

public class uploadAssignConvertVO {

	private String orderNo;
	private String item;
	private String remark;

	public static uploadAssignConvertVO create(CSVRecord CSVRecord){

		uploadAssignConvertVO vo = new uploadAssignConvertVO();

		vo.setOrderNo(CSVRecord.get(0));
		vo.setItem(CSVRecord.get(1));
		vo.setRemark(CSVRecord.get(2));

		return vo;
	}

	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getItem() {
		return item;
	}
	public void setItem(String item) {
		this.item = item;
	}
	public String getRemark() {
      return remark;
  }
  public void setRemark(String remark) {
      this.remark = remark;
  }
}
