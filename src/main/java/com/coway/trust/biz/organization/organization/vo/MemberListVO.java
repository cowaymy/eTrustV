package com.coway.trust.biz.organization.organization.vo;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 *
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class MemberListVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private GridDataSet<DocSubmissionVO> docSubmissionVOList;
	
	private List<DocSubmissionVO> docSubVOList;
	
	private int custTypeId;

	private int raceId;

	private String billGrp;
	
	private int orderAppType;
	
	private String sInstallDate;
	
	private int itmStkId;
	
	private String dInstallDate;
	
	private int salesOrdId;
	
	public GridDataSet<DocSubmissionVO> getDocSubmissionVOList() {
		return docSubmissionVOList;
	}
	
	

	public void setDocSubmissionVOList(GridDataSet<DocSubmissionVO> docSubmissionVOList) {
		this.docSubmissionVOList = docSubmissionVOList;
	}


	public int getCustTypeId() {
		return custTypeId;
	}

	public void setCustTypeId(int custTypeId) {
		this.custTypeId = custTypeId;
	}

	public int getRaceId() {
		return raceId;
	}

	public void setRaceId(int raceId) {
		this.raceId = raceId;
	}

	public String getBillGrp() {
		return billGrp;
	}

	public void setBillGrp(String billGrp) {
		this.billGrp = billGrp;
	}

	public List<DocSubmissionVO> getDocSubVOList() {
		return docSubVOList;
	}

	public void setDocSubVOList(List<DocSubmissionVO> docSubVOList) {
		this.docSubVOList = docSubVOList;
	}

	public int getOrderAppType() {
		return orderAppType;
	}

	public void setOrderAppType(int orderAppType) {
		this.orderAppType = orderAppType;
	}

	public String getsInstallDate() {
		return sInstallDate;
	}

	public void setsInstallDate(String sInstallDate) {
		this.sInstallDate = sInstallDate;
	}

	public int getItmStkId() {
		return itmStkId;
	}

	public void setItmStkId(int itmStkId) {
		this.itmStkId = itmStkId;
	}

	public String getdInstallDate() {
		return dInstallDate;
	}

	public void setdInstallDate(String dInstallDate) {
		this.dInstallDate = dInstallDate;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

}