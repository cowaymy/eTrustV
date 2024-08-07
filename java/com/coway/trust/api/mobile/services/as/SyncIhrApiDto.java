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
	private String asSetlDt ;
	private String defectCodeDp;
	private String defectDescDp;

	private String defectCodeDd;
	private String defectDescDd;

	private String defectCodeDc;
	private String defectDescDc;

	private String defectCodeDt;
	private String defectDescDt;

	private String defectCodeSc;
	private String defectDescSc;

	private int asDefectPartId;
	private int asDefectDtlResnId;
	private int asDefectId;
	private int asDefectTypeId;
	private int asSlutnResnId;
	private String asResultStusId;


	public String getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
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
	public String getDefectCodeDp() {
		return defectCodeDp;
	}
	public void setDefectCodeDp(String defectCodeDp) {
		this.defectCodeDp = defectCodeDp;
	}
	public String getDefectDescDp() {
		return defectDescDp;
	}
	public void setDefectDescDp(String defectDescDp) {
		this.defectDescDp = defectDescDp;
	}
	public String getDefectCodeDd() {
		return defectCodeDd;
	}
	public void setDefectCodeDd(String defectCodeDd) {
		this.defectCodeDd = defectCodeDd;
	}
	public String getDefectDescDd() {
		return defectDescDd;
	}
	public void setDefectDescDd(String defectDescDd) {
		this.defectDescDd = defectDescDd;
	}
	public String getDefectCodeDc() {
		return defectCodeDc;
	}
	public void setDefectCodeDc(String defectCodeDc) {
		this.defectCodeDc = defectCodeDc;
	}
	public String getDefectDescDc() {
		return defectDescDc;
	}
	public void setDefectDescDc(String defectDescDc) {
		this.defectDescDc = defectDescDc;
	}
	public String getAsSetlDt() {
		return asSetlDt;
	}
	public void setAsSetlDt(String asSetlDt) {
		this.asSetlDt = asSetlDt;
	}
	public int getAsDefectTypeId() {
		return asDefectTypeId;
	}
	public void setAsDefectTypeId(int asDefectTypeId) {
		this.asDefectTypeId = asDefectTypeId;
	}
	public int getAsSlutnResnId() {
		return asSlutnResnId;
	}
	public void setAsSlutnResnId(int asSlutnResnId) {
		this.asSlutnResnId = asSlutnResnId;
	}
	public String getDefectCodeDt() {
		return defectCodeDt;
	}
	public void setDefectCodeDt(String defectCodeDt) {
		this.defectCodeDt = defectCodeDt;
	}
	public String getDefectDescDt() {
		return defectDescDt;
	}
	public void setDefectDescDt(String defectDescDt) {
		this.defectDescDt = defectDescDt;
	}
	public String getDefectCodeSc() {
		return defectCodeSc;
	}
	public void setDefectCodeSc(String defectCodeSc) {
		this.defectCodeSc = defectCodeSc;
	}
	public String getDefectDescSc() {
		return defectDescSc;
	}
	public void setDefectDescSc(String defectDescSc) {
		this.defectDescSc = defectDescSc;
	}

}
