package com.coway.trust.biz.logistics.mlog.vo;

import java.io.Serializable;
import java.util.List;

public class StrockMovementVoForMobile implements Serializable {

	private static final long serialVersionUID = -1031910048859710982L;

	private String smoNo;
	private String reqType;
	private String reqStatus;
	private String requestorId;
	private String requestorName;
	private String reqDate;
	private List<StrockMovementVoForMobile> partsList;
//	private String smoNoD;
//	private String smoNoItem;
//	private int partsId;
//	private int partsType;
//	private String partsCode;
//	private String partsName;
//	private String requestQty;
//	private String serialNo;
//	private String selectQty;

	public String getSmoNo() {
		return smoNo;
	}

	public void setSmoNo(String smoNo) {
		this.smoNo = smoNo;
	}

	public String getReqType() {
		return reqType;
	}

	public void setReqType(String reqType) {
		this.reqType = reqType;
	}

	public String getReqStatus() {
		return reqStatus;
	}

	public void setReqStatus(String reqStatus) {
		this.reqStatus = reqStatus;
	}

	public String getRequestorId() {
		return requestorId;
	}

	public void setRequestorId(String requestorId) {
		this.requestorId = requestorId;
	}

	public String getRequestorName() {
		return requestorName;
	}

	public void setRequestorName(String requestorName) {
		this.requestorName = requestorName;
	}

	public List<StrockMovementVoForMobile> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<StrockMovementVoForMobile> partsList) {
		this.partsList = partsList;
	}

//	public String getSmoNoD() {
//		return smoNoD;
//	}
//
//	public void setSmoNoD(String smoNoD) {
//		this.smoNoD = smoNoD;
//	}
//
//	public String getSmoNoItem() {
//		return smoNoItem;
//	}
//
//	public void setSmoNoItem(String smoNoItem) {
//		this.smoNoItem = smoNoItem;
//	}
//
//	public int getPartsId() {
//		return partsId;
//	}
//
//	public void setPartsId(int partsId) {
//		this.partsId = partsId;
//	}
//
//	public String getPartsCode() {
//		return partsCode;
//	}
//
//	public void setPartsCode(String partsCode) {
//		this.partsCode = partsCode;
//	}
//
//	public String getPartsName() {
//		return partsName;
//	}
//
//	public void setPartsName(String partsName) {
//		this.partsName = partsName;
//	}
//
//	public String getRequestQty() {
//		return requestQty;
//	}
//
//	public void setRequestQty(String requestQty) {
//		this.requestQty = requestQty;
//	}
//
//	public String getSerialNo() {
//		return serialNo;
//	}
//
//	public void setSerialNo(String serialNo) {
//		this.serialNo = serialNo;
//	}
//
//	public String getSelectQty() {
//		return selectQty;
//	}
//
//	public void setSelectQty(String selectQty) {
//		this.selectQty = selectQty;
//	}
//
//	public int getPartsType() {
//		return partsType;
//	}
//
//	public void setPartsType(int partsType) {
//		this.partsType = partsType;
//	}
	public String getReqDate() {
		return reqDate;
	}

	public void setReqDate(String reqDate) {
		this.reqDate = reqDate;
	}

	

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
