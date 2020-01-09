package com.coway.trust.api.mobile.logistics.stockAudit;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

/**
 * @ClassName : StockAuditApiFormDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.  KR-JAEMJAEM:) First creation
 * </pre>
 */
@ApiModel(value = "StockAuditApiFormDto", description = "StockAuditApiFormDto")
public class StockAuditApiFormDto {



	public static Map<String, Object> createMap(StockAuditApiFormDto vo) {
		Map<String, Object> params = new HashMap<>();
        params.put("regId", vo.getRegId());
		params.put("whLocId", vo.getWhLocId());
		params.put("stockAuditNo", vo.getStockAuditNo());
        params.put("viewGu", vo.getViewGu());
        params.put("docStartDt", vo.getDocStartDt());
        params.put("docEndDt", vo.getDocEndDt());
		return params;
	}



	private String regId;
	private int whLocId;
	private String stockAuditNo;
	private String viewGu;
    private String docStartDt;
    private String docEndDt;



    public String getRegId() {
        return regId;
    }
    public void setRegId(String regId) {
        this.regId = regId;
    }
    public int getWhLocId() {
        return whLocId;
    }
    public void setWhLocId(int whLocId) {
        this.whLocId = whLocId;
    }
    public String getStockAuditNo() {
        return stockAuditNo;
    }
    public void setStockAuditNo(String stockAuditNo) {
        this.stockAuditNo = stockAuditNo;
    }
    public String getViewGu() {
        return viewGu;
    }
    public void setViewGu(String viewGu) {
        this.viewGu = viewGu;
    }
    public String getDocStartDt() {
        return docStartDt;
    }
    public void setDocStartDt(String docStartDt) {
        this.docStartDt = docStartDt;
    }
    public String getDocEndDt() {
        return docEndDt;
    }
    public void setDocEndDt(String docEndDt) {
        this.docEndDt = docEndDt;
    }
}
