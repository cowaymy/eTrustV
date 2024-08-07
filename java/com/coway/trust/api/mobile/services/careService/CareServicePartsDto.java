package com.coway.trust.api.mobile.services.careService;

import java.sql.Timestamp;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServicePartsDto", description = "공통코드 Dto")
public class CareServicePartsDto {

	@ApiModelProperty(value = "주문번호")
	private String salesOrderNo;

	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;

	@ApiModelProperty(value = "제품코드")
	private String productCode;

	@ApiModelProperty(value = "필터코드")
	private String partCode;

	@ApiModelProperty(value = "part id 값")
	private int partId;

	@ApiModelProperty(value = "필터명")
	private String partName;

	@ApiModelProperty(value = "필요수량")
	private int quanity;

	@ApiModelProperty(value = "chgid??")
	private String exChgid;

	@ApiModelProperty(value = "교체수량")
	private String chgQty;

	@ApiModelProperty(value = "교체여부")
	private String chgYN;

	@ApiModelProperty(value = "마지막교체일_날짜(YYYYMMDD)")
	private String lastChgDate;

	@ApiModelProperty(value = "마지막교체일_시간(HHMMSS)")
	private String lastChgTime;

	@ApiModelProperty(value = "필터교체 주기")
	private int partsPeriod;

	@ApiModelProperty(value = "대체필터 존재 유무")
	private String alternativeYN;

	@ApiModelProperty(value = "대체필터 사용여부(메인필터 재고 없을시 사용되는 대체필터)")
	private String alternativeUsedYN;

	@ApiModelProperty(value = "대체필터 코드")
	private String alternativeFilterCode;

	@ApiModelProperty(value = "대체필터 코드에 대한 id 값")
	private String alternativeFilterId;

	@ApiModelProperty(value = "대체필터명")
	private String alternativeFilterName;

	@ApiModelProperty(value = "Filter Barcode Check")
	private String filterBarcdChkYn;

	@ApiModelProperty(value = "필터 바코드 Serial No")
	private String filterBarcdSerialNo;

	public String getSalesOrderNo() {
		return salesOrderNo;
	}

	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}

	public String getServiceNo() {
		return serviceNo;
	}

	public void setServiceNo(String serviceNo) {
		this.serviceNo = serviceNo;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getPartCode() {
		return partCode;
	}

	public void setPartCode(String partCode) {
		this.partCode = partCode;
	}

	public int getPartId() {
		return partId;
	}

	public void setPartId(int partId) {
		this.partId = partId;
	}

	public String getPartName() {
		return partName;
	}

	public void setPartName(String partName) {
		this.partName = partName;
	}

	public int getQuanity() {
		return quanity;
	}

	public void setQuanity(int quanity) {
		this.quanity = quanity;
	}

	public String getExChgid() {
		return exChgid;
	}

	public void setExChgid(String exChgid) {
		this.exChgid = exChgid;
	}

	public String getChgQty() {
		return chgQty;
	}

	public void setChgQty(String chgQty) {
		this.chgQty = chgQty;
	}

	public String getChgYN() {
		return chgYN;
	}

	public void setChgYN(String chgYN) {
		this.chgYN = chgYN;
	}

	public String getLastChgDate() {
		return lastChgDate;
	}

	public void setLastChgDate(String lastChgDate) {
		this.lastChgDate = lastChgDate;
	}

	public String getLastChgTime() {
		return lastChgTime;
	}

	public void setLastChgTime(String lastChgTime) {
		this.lastChgTime = lastChgTime;
	}

	public int getPartsPeriod() {
		return partsPeriod;
	}

	public void setPartsPeriod(int partsPeriod) {
		this.partsPeriod = partsPeriod;
	}

	public String getAlternativeYN() {
		return alternativeYN;
	}

	public void setAlternativeYN(String alternativeYN) {
		this.alternativeYN = alternativeYN;
	}

	public String getAlternativeUsedYN() {
		return alternativeUsedYN;
	}

	public void setAlternativeUsedYN(String alternativeUsedYN) {
		this.alternativeUsedYN = alternativeUsedYN;
	}

	public String getAlternativeFilterCode() {
		return alternativeFilterCode;
	}

	public void setAlternativeFilterCode(String alternativeFilterCode) {
		this.alternativeFilterCode = alternativeFilterCode;
	}

	public String getAlternativeFilterId() {
		return alternativeFilterId;
	}

	public void setAlternativeFilterId(String alternativeFilterId) {
		this.alternativeFilterId = alternativeFilterId;
	}

	public String getAlternativeFilterName() {
		return alternativeFilterName;
	}

	public void setAlternativeFilterName(String alternativeFilterName) {
		this.alternativeFilterName = alternativeFilterName;
	}


	public String getFilterBarcdChkYN() {
		return filterBarcdChkYn;
	}

	public void setFilterBarcdChkYN(String filterBarcdChkYN) {
		this.filterBarcdChkYn = filterBarcdChkYN;
	}

	public String getFilterBarcdSerialNo() {
		return filterBarcdSerialNo;
	}

	public void setFilterBarcdSerialNo(String filterBarcdSerialNo) {
		this.filterBarcdSerialNo = filterBarcdSerialNo;
	}

	public static CareServicePartsDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CareServicePartsDto.class);
	}

}
