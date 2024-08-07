package com.coway.trust.api.mobile.services.as;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiFormDto;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : ProductInfoListApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "HomecareAfterServiceApiForm", description = "HomecareAfterServiceApiForm")
public class HomecareAfterServiceApiForm {

	public static Map<String, Object> createMap(HomecareAfterServiceApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("regId", vo.getRegId());
		params.put("memCode", vo.getMemCode());
		params.put("salesOrdNo", vo.getSalesOrdNo());
		params.put("dtId", vo.getDtId());


		return params;
	}


	private String regId;
	private String MemCode;
	private String SalesOrdNo;
	private int dtId;

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
	public String getSalesOrdNo() {
		return SalesOrdNo;
	}
	public void setSalesOrdNo(String salesOrdNo) {
		SalesOrdNo = salesOrdNo;
	}

}
