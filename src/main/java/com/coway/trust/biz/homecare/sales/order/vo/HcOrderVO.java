package com.coway.trust.biz.homecare.sales.order.vo;

import java.util.Date;

/**
 * @ClassName : HcOrderVO.java
 * @Description : HMC0011D Table Vo
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 23.   KR-SH        First creation
 * </pre>
 */
public class HcOrderVO {
	/** Sequence */
	private int ordSeqNo;
	/** Customer ID */
	private int custId;
	/** Sales date */
	private Date salesDt;
	/** Mattress Order No */
	private String matOrdNo;
	/** Frame Order No */
	private String fraOrdNo;
	/** Create Date */
	private Date crtDt;
	/** Create User Id */
	private int crtUserId;
	/** Update Date */
	private Date updDt;
	/** Update User Id */
	private int updUserId;
	/** eKeyin Mat ord_id */
	private int matPreOrdId;
	/** eKeyin Fra Ord_id */
	private int fraPreOrdId;
	/** eKeyin Status id */
	private int stusId;
	/** bndl No */
	private String bndlNo;
	/** Mattress Order Id */
	private int srvOrdId;

	public int getOrdSeqNo() {
		return ordSeqNo;
	}
	public String getBndlNo() {
		return bndlNo;
	}
	public void setBndlNo(String bndlNo) {
		this.bndlNo = bndlNo;
	}
	public void setOrdSeqNo(int ordSeqNo) {
		this.ordSeqNo = ordSeqNo;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}
	public Date getSalesDt() {
		return salesDt;
	}
	public void setSalesDt(Date salesDt) {
		this.salesDt = salesDt;
	}
	public String getMatOrdNo() {
		return matOrdNo;
	}
	public void setMatOrdNo(String matOrdNo) {
		this.matOrdNo = matOrdNo;
	}
	public String getFraOrdNo() {
		return fraOrdNo;
	}
	public void setFraOrdNo(String fraOrdNo) {
		this.fraOrdNo = fraOrdNo;
	}
	public Date getCrtDt() {
		return crtDt;
	}
	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}
	public int getCrtUserId() {
		return crtUserId;
	}
	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}
	public Date getUpdDt() {
		return updDt;
	}
	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}
	public int getUpdUserId() {
		return updUserId;
	}
	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}
	public int getMatPreOrdId() {
		return matPreOrdId;
	}
	public void setMatPreOrdId(int matPreOrdId) {
		this.matPreOrdId = matPreOrdId;
	}
	public int getFraPreOrdId() {
		return fraPreOrdId;
	}
	public void setFraPreOrdId(int fraPreOrdId) {
		this.fraPreOrdId = fraPreOrdId;
	}
	public int getStusId() {
		return stusId;
	}
	public void setStusId(int stusId) {
		this.stusId = stusId;
	}
	public int getSrvOrdId() {
		return srvOrdId;
	}
	public void setSrvOrdId(int srvOrdId) {
		this.srvOrdId = srvOrdId;
	}

}