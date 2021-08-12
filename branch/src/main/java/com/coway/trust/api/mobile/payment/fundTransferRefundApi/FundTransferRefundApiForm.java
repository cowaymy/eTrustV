package com.coway.trust.api.mobile.payment.fundTransferRefundApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : FundTransferRefundApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 10. 10.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "FundTransferRefundApiForm", description = "FundTransferRefundApiForm")
public class FundTransferRefundApiForm {



	public static Map<String, Object> createMap(FundTransferRefundApiForm vo){
		Map<String, Object> params = new HashMap<>();
        params.put("type", vo.getType());
		params.put("selectType", vo.getSelectType());
		params.put("selectKeyword", vo.getSelectKeyword());
        params.put("transactionDateFrom", vo.getTransactionDateFrom());
        params.put("transactionDateTo", vo.getTransactionDateTo());
		return params;
	}



	private String type;
    private String selectType;
    private String selectKeyword;
	private String transactionDateFrom;
	private String transactionDateTo;



    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
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
    public String getTransactionDateFrom() {
        return transactionDateFrom;
    }
    public void setTransactionDateFrom(String transactionDateFrom) {
        this.transactionDateFrom = transactionDateFrom;
    }
    public String getTransactionDateTo() {
        return transactionDateTo;
    }
    public void setTransactionDateTo(String transactionDateTo) {
        this.transactionDateTo = transactionDateTo;
    }


}
