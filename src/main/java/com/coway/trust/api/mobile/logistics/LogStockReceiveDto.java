package com.coway.trust.api.mobile.logistics;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "LogStockReceiveDto", description = "공통코드 Dto")
public class LogStockReceiveDto {

	@ApiModelProperty(value = "SMO no")
	private String smoNo;
	
	@ApiModelProperty(value = "type(auto / manual)")
	private String reqType;
	
	@ApiModelProperty(value = "상태")
	private String reqStatus;
	
	@ApiModelProperty(value = "gi 요청자")
	private String giCustName;
	
	@ApiModelProperty(value = "gi locationCode")
	private String giLocationCode;
	
	@ApiModelProperty(value = "gi 날짜")
	private String giDate;
	
	@ApiModelProperty(value = "gr 날짜")
	private int grDate;
	
	
	List<LogStockPartsReceiveDto> sList =null;
	
	
	
	public static LogStockReceiveDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, LogStockReceiveDto.class);
	}


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


	public int getGrDate() {
		return grDate;
	}


	public void setGrDate(int grDate) {
		this.grDate = grDate;
	}
		

}
