package com.coway.trust.api.mobile.services.as;

import com.coway.trust.api.mobile.services.as.SyncIhrApiDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "SyncIhrApiDto", description = "SyncIhrApiDto")
public class SyncIhrApiDto {

	@SuppressWarnings("unchecked")
	public static SyncIhrApiDto create(EgovMap egovMap) {
		return BeanConverter.toBean(egovMap, SyncIhrApiDto.class);
	}

	private String salesOrdNo ;
	//private String asSetlDt ;
	private String defectCode;
	private String defectDesc;
	private String asDefectPartId;
	private String asDefectDtlResnId;
	private String asDefectId;
	private String asResultStusId;


	public String getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}
	public String getDefectCode() {
		return defectCode;
	}
	public void setDefectCode(String defectCode) {
		this.defectCode = defectCode;
	}
	public String getDefectDesc() {
		return defectDesc;
	}
	public void setDefectDesc(String defectDesc) {
		this.defectDesc = defectDesc;
	}
	public String getAsDefectPartId() {
		return asDefectPartId;
	}
	public void setAsDefectPartId(String asDefectPartId) {
		this.asDefectPartId = asDefectPartId;
	}
	public String getAsDefectDtlResnId() {
		return asDefectDtlResnId;
	}
	public void setAsDefectDtlResnId(String asDefectDtlResnId) {
		this.asDefectDtlResnId = asDefectDtlResnId;
	}
	public String getAsDefectId() {
		return asDefectId;
	}
	public void setAsDefectId(String asDefectId) {
		this.asDefectId = asDefectId;
	}
	public String getAsResultStusId() {
		return asResultStusId;
	}
	public void setAsResultStusId(String asResultStusId) {
		this.asResultStusId = asResultStusId;
	}

}
