package com.coway.trust.api.mobile.logistics.rdcstock;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RdcStockListDto", description = "공통코드 Dto")
public class RdcStockListDto {

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "rdc 위치 코드")
	private String locationCode;

	@ApiModelProperty(value = "rdc 명")
	private String locationName;

	@ApiModelProperty(value = "총 수량")
	private int totQty;

	@ApiModelProperty(value = "요청중 수량")
	private int inTransitQty;

	@ApiModelProperty(value = "예약 수량")
	private int bookingQty;

	@ApiModelProperty(value = "RDC/CDC")
	private String locationType;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static RdcStockListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, RdcStockListDto.class);
	}

	public String getPartsCode() {
		return partsCode;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

	public String getLocationCode() {
		return locationCode;
	}

	public void setLocationCode(String locationCode) {
		this.locationCode = locationCode;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public int getTotQty() {
		return totQty;
	}

	public void setTotQty(int totQty) {
		this.totQty = totQty;
	}

	public int getInTransitQty() {
		return inTransitQty;
	}

	public void setInTransitQty(int inTransitQty) {
		this.inTransitQty = inTransitQty;
	}

	public int getBookingQty() {
		return bookingQty;
	}

	public void setBookingQty(int bookingQty) {
		this.bookingQty = bookingQty;
	}

	public String getLocationType() {
		return locationType;
	}

	public void setLocationType(String locationType) {
		this.locationType = locationType;
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

}
