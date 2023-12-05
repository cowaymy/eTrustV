package com.coway.trust.api.mobile.services.as;

import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import java.math.BigDecimal;
import java.util.List;



@ApiModel(value = "HomecareServiceApiDto", description = "HomecareServiceApiDto")
public class HomecareAfterServiceApiDto {

	@SuppressWarnings("unchecked")
	public static HomecareAfterServiceApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, HomecareAfterServiceApiDto.class);
	}

	private String regId;
	private String MemCode;
	private String SalesOrdNo;
	private int dtId;


	public String getSalesOrdNo() {
		return SalesOrdNo;
	}
	public void setSalesOrdNo(String salesOrdNo) {
		SalesOrdNo = salesOrdNo;
	}
	public String getRegId() {
		return regId;
	}
	public String getMemCode() {
		return MemCode;
	}
	public int getDtId() {
		return dtId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public void setMemCode(String memCode) {
		MemCode = memCode;
	}
	public void setDtId(int dtId) {
		this.dtId = dtId;
	}

}
