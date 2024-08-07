package com.coway.trust.api.mobile.logistics.returnonhandstock;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ReturnOnHandStockMListDto", description = "공통코드 Dto")
public class ReturnOnHandStockMListDto {

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

	@ApiModelProperty(value = "gi locationName")
	private String giLocationName;

	@ApiModelProperty(value = "gi 날짜")
	private String giDate;

	@ApiModelProperty(value = "gr 날짜")
	private String grDate;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	private List<ReturnOnHandStockDListDto> partsList = null;

	public static ReturnOnHandStockMListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ReturnOnHandStockMListDto.class);
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

	public String getGrDate() {
		return grDate;
	}

	public void setGrDate(String grDate) {
		this.grDate = grDate;
	}

	public String getGiLocationName() {
		return giLocationName;
	}

	public void setGiLocationName(String giLocationName) {
		this.giLocationName = giLocationName;
	}

	public List<ReturnOnHandStockDListDto> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<ReturnOnHandStockDListDto> partsList) {
		this.partsList = partsList;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
