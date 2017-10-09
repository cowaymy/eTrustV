package com.coway.trust.api.mobile.logistics;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockByHolderListDto", description = "공통코드 Dto")
public class StockByHolderListDto {

	@ApiModelProperty(value = "Ct_CodyName")
	private String ctCodyName;

	@ApiModelProperty(value = "Ct_CodyId")
	private String ctCodyId;

	@ApiModelProperty(value = "CDC CODE")
	private String cdcCode;

	@ApiModelProperty(value = "RDC CODE")
	private String rdcCode;

	@ApiModelProperty(value = "Login CODE")
	private String loginCode;

	@ApiModelProperty(value = "parts CODE")
	private String stkCode;
	
	@ApiModelProperty(value = "STK CTGRY ID")
	private String stkId;
	

	public String getStkId() {
		return stkId;
	}

	public void setStkId(String stkId) {
		this.stkId = stkId;
	}

	public static StockByHolderListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockByHolderListDto.class);
	}

	public String getCtCodyName() {
		return ctCodyName;
	}

	public void setCtCodyName(String ctCodyName) {
		this.ctCodyName = ctCodyName;
	}

	public String getCtCodyId() {
		return ctCodyId;
	}

	public void setCtCodyId(String ctCodyId) {
		this.ctCodyId = ctCodyId;
	}

	public String getCdcCode() {
		return cdcCode;
	}

	public void setCdcCode(String cdcCode) {
		this.cdcCode = cdcCode;
	}

	public String getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(String rdcCode) {
		this.rdcCode = rdcCode;
	}

	public String getLoginCode() {
		return loginCode;
	}

	public void setLoginCode(String loginCode) {
		this.loginCode = loginCode;
	}

	public String getStkCode() {
		return stkCode;
	}

	public void setStkCode(String stkCode) {
		this.stkCode = stkCode;
	}

}
