package com.coway.trust.api.mobile.payment.mobileTicket;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;


@ApiModel(value = "MobileTicketForm", description = "MobileTicket Form")
public class MobileTicketForm {

	@ApiModelProperty(value = "userId 예)1 ", example = "1")
	private String userId;

	@ApiModelProperty(value = "fromDate 예)20191108 ", example = "20191108")
	private String fromDate;

	@ApiModelProperty(value = "toDate 예)20191108", example = "20191108")
	private String toDate;

	@ApiModelProperty(value = "ticketType 예)0000", example = "0000")
	private String ticketType;

	@ApiModelProperty(value = "mobTicketNo 예)00", example = "00")
	private int mobTicketNo;

	@ApiModelProperty(value = "ticketTypeId 예)00", example = "00")
	private String ticketTypeId;

	@ApiModelProperty(value = "salesOrdNo 예)00", example = "00")
	private String salesOrdNo;

	public static Map<String, Object> createMap(MobileTicketForm from){
		Map<String, Object> params = new HashMap<>();

		params.put("userId",   				from.getUserId());
		params.put("fromDate",   			from.getFromDate());
		params.put("toDate",   				from.getToDate());
		params.put("ticketType",   		from.getTicketType());
		params.put("mobTicketNo",	 	from.getMobTicketNo());
		params.put("ticketTypeId",	 		from.getTicketTypeId());
		params.put("salesOrdNo",	 		from.getSalesOrdNo());

		return params;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFromDate() {
		return fromDate;
	}

	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}

	public String getToDate() {
		return toDate;
	}

	public void setToDate(String toDate) {
		this.toDate = toDate;
	}

	public String getTicketType() {
		return ticketType;
	}

	public void setTicketType(String ticketType) {
		this.ticketType = ticketType;
	}

	public int getMobTicketNo() {
		return mobTicketNo;
	}

	public void setMobTicketNo(int mobTicketNo) {
		this.mobTicketNo = mobTicketNo;
	}

	public String getTicketTypeId() {
		return ticketTypeId;
	}

	public void setTicketTypeId(String ticketTypeId) {
		this.ticketTypeId = ticketTypeId;
	}

}
