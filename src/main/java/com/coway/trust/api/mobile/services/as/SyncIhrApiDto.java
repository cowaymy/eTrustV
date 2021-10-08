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
	private int asDefectPartId;
	private int asDefectDtlResnId;
	private int asDefectId;
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
	public int getAsDefectPartId() {
		return asDefectPartId;
	}
	public void setAsDefectPartId(int asDefectPartId) {
		this.asDefectPartId = asDefectPartId;
	}
	public int getAsDefectDtlResnId() {
		return asDefectDtlResnId;
	}
	public void setAsDefectDtlResnId(int asDefectDtlResnId) {
		this.asDefectDtlResnId = asDefectDtlResnId;
	}
	public int getAsDefectId() {
		return asDefectId;
	}
	public void setAsDefectId(int asDefectId) {
		this.asDefectId = asDefectId;
	}
	public String getAsResultStusId() {
		return asResultStusId;
	}
	public void setAsResultStusId(String asResultStusId) {
		this.asResultStusId = asResultStusId;
	}

}
