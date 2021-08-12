/**
 *
 */
package com.coway.trust.web.sales.ccp;

import org.apache.commons.csv.CSVRecord;

/**
 * @author HQIT-HUIDING
 * @date Jun 15, 2021
 *
 */
public class CcpUploadAssignUserVO {

	private String orderNo;
	private String username;
	private String Remarks;

	public static CcpUploadAssignUserVO create(CSVRecord CSVRecord){
		CcpUploadAssignUserVO vo = new CcpUploadAssignUserVO();
		vo.setOrderNo(CSVRecord.get(1));
		vo.setUsername(CSVRecord.get(2));
		vo.setRemarks(CSVRecord.get(3));

		return vo;
	}

	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getRemarks() {
		return Remarks;
	}
	public void setRemarks(String remarks) {
		Remarks = remarks;
	}


}
