package com.coway.trust.api.mobile.payment.paymentList;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : PaymentListForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "PaymentListForm", description = "Payment List Form")
public class PaymentListForm {

	@ApiModelProperty(value = "fromDate", example = "1")
	private String fromDate;

	@ApiModelProperty(value = "toDate", example = "1")
	private String toDate;

	@ApiModelProperty(value = "userId", example = "1")
	private String userId;

	@ApiModelProperty(value = "userId", example = "1")
	private String ticketType;

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

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getTicketType() {
		return ticketType;
	}

	public void setTicketType(String ticketType) {
		this.ticketType = ticketType;
	}

	public static Map<String, Object> createMap(PaymentListForm paymentForm){
		Map<String, Object> params = new HashMap<>();

		params.put("fromDate",   		paymentForm.getFromDate());
		params.put("toDate",   			paymentForm.getToDate());
		params.put("userId",   			paymentForm.getUserId());
		params.put("ticketType",   	paymentForm.getTicketType());

		return params;
	}

}
