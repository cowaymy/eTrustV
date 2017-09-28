package com.coway.trust.biz.logistics.stockmovement.vo;

import java.io.Serializable;
import java.util.List;

public class StrockMovementVoForMobile implements Serializable {

	private static final long serialVersionUID = -1031910048859710982L;

	private String smoNo;
	private String reqType;
	private String reqStatus;
	private String giCustName;
	private String giLocationCode;
	private String giDate;
	private String grDate;
	private List<StrockMovementVoForMobile> partsList;
	private String smoNoD;
	private String smoNoItem;
	private String partsCode;
	private String partsName;
	private String requestQty;
	private String serialNo;
	private String selectQty;

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

	public String getGiCustName() {
		return giCustName;
	}

	public void setGiCustName(String giCustName) {
		this.giCustName = giCustName;
	}

	public String getGiLocationCode() {
		return giLocationCode;
	}

	public void setGiLocationCode(String giLocationCode) {
		this.giLocationCode = giLocationCode;
	}

	public String getGiDate() {
		return giDate;
	}

	public void setGiDate(String giDate) {
		this.giDate = giDate;
	}

	public String getGrDate() {
		return grDate;
	}

	public void setGrDate(String grDate) {
		this.grDate = grDate;
	}

	public String getSmoNoD() {
		return smoNoD;
	}

	public void setSmoNoD(String smoNoD) {
		this.smoNoD = smoNoD;
	}

	public String getSmoNoItem() {
		return smoNoItem;
	}

	public void setSmoNoItem(String smoNoItem) {
		this.smoNoItem = smoNoItem;
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

	public String getPartsName() {
		return partsName;
	}

	public void setPartsName(String partsName) {
		this.partsName = partsName;
	}

	public String getRequestQty() {
		return requestQty;
	}

	public void setRequestQty(String requestQty) {
		this.requestQty = requestQty;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getSelectQty() {
		return selectQty;
	}

	public void setSelectQty(String selectQty) {
		this.selectQty = selectQty;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public List<StrockMovementVoForMobile> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<StrockMovementVoForMobile> partsList2) {
		this.partsList = partsList2;
	}

}
