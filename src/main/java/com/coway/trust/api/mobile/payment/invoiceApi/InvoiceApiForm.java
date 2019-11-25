package com.coway.trust.api.mobile.payment.invoiceApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : InvoiceApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "InvoiceApiForm", description = "InvoiceApiForm")
public class InvoiceApiForm {



	public static Map<String, Object> createMap(InvoiceApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("selectInvoiceType", vo.getSelectInvoiceType());
		params.put("selectType", vo.getSelectType());
		params.put("selectKeyword", vo.getSelectKeyword());
		params.put("salesDt", vo.getSalesDt());
		params.put("custId", vo.getCustId());
		params.put("taxInvcRefDt", vo.getTaxInvcRefDt());
		return params;
	}



	private String selectInvoiceType;
    private String selectType;
    private String selectKeyword;
	private String salesDt;
	private int custId;
	private String taxInvcRefDt;



    public String getSelectInvoiceType() {
        return selectInvoiceType;
    }
    public void setSelectInvoiceType(String selectInvoiceType) {
        this.selectInvoiceType = selectInvoiceType;
    }
    public String getSelectType() {
        return selectType;
    }
    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }
    public String getSelectKeyword() {
        return selectKeyword;
    }
    public void setSelectKeyword(String selectKeyword) {
        this.selectKeyword = selectKeyword;
    }
    public String getSalesDt() {
        return salesDt;
    }
    public void setSalesDt(String salesDt) {
        this.salesDt = salesDt;
    }
    public int getCustId() {
        return custId;
    }
    public void setCustId(int custId) {
        this.custId = custId;
    }
    public String getTaxInvcRefDt() {
        return taxInvcRefDt;
    }
    public void setTaxInvcRefDt(String taxInvcRefDt) {
        this.taxInvcRefDt = taxInvcRefDt;
    }
}
