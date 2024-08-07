package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the LOG0038D database table.
 * 
 */
public class StkReturnEntryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int stkRetnId;
	
	private int stusCodeId;
	
	private int typeId;
	
	private int salesOrdId;
	
	private int movId;
	
	private String reqstDt;
	
	private String crtDt;
	
	private int crtUserId;
	
	private String updDt;
	
	private int updUserId;
	
	private int refId;
	
	private int stockId;
	
	private int isSynch;
	
	private String retnNo;
	
	private String appDt;
	
	private int ctId;
	
	private String ctGrp;
	
	private int callEntryId;
	
	private String rtSesionCode;

	public int getStkRetnId() {
		return stkRetnId;
	}

	public void setStkRetnId(int stkRetnId) {
		this.stkRetnId = stkRetnId;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getMovId() {
		return movId;
	}

	public void setMovId(int movId) {
		this.movId = movId;
	}

	public String getReqstDt() {
		return reqstDt;
	}

	public void setReqstDt(String reqstDt) {
		this.reqstDt = reqstDt;
	}

	public String getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(String crtDt) {
		this.crtDt = crtDt;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public String getUpdDt() {
		return updDt;
	}

	public void setUpdDt(String updDt) {
		this.updDt = updDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

	public int getRefId() {
		return refId;
	}

	public void setRefId(int refId) {
		this.refId = refId;
	}

	public int getStockId() {
		return stockId;
	}

	public void setStockId(int stockId) {
		this.stockId = stockId;
	}

	public int getIsSynch() {
		return isSynch;
	}

	public void setIsSynch(int isSynch) {
		this.isSynch = isSynch;
	}

	public String getRetnNo() {
		return retnNo;
	}

	public void setRetnNo(String retnNo) {
		this.retnNo = retnNo;
	}

	public String getAppDt() {
		return appDt;
	}

	public void setAppDt(String appDt) {
		this.appDt = appDt;
	}

	public int getCtId() {
		return ctId;
	}

	public void setCtId(int ctId) {
		this.ctId = ctId;
	}

	public String getCtGrp() {
		return ctGrp;
	}

	public void setCtGrp(String ctGrp) {
		this.ctGrp = ctGrp;
	}

	public int getCallEntryId() {
		return callEntryId;
	}

	public void setCallEntryId(int callEntryId) {
		this.callEntryId = callEntryId;
	}

	public String getRtSesionCode() {
		return rtSesionCode;
	}

	public void setRtSesionCode(String rtSesionCode) {
		this.rtSesionCode = rtSesionCode;
	}
		
}