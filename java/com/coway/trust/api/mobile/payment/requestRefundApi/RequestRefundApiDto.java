package com.coway.trust.api.mobile.payment.requestRefundApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : RequestRefundApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 10. 21.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "RequestRefundApiDto", description = "RequestRefundApiDto")
public class RequestRefundApiDto {
	@SuppressWarnings("unchecked")
	public static RequestRefundApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, RequestRefundApiDto.class);
	}

	public static Map<String, Object> createMap(RequestRefundApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("refReqId", vo.getRefReqId());
		params.put("ordNo", vo.getOrdNo());
        params.put("custName", vo.getCustName());
        params.put("worNo", vo.getWorNo());
        params.put("amt", vo.getAmt());
        params.put("refResn", vo.getRefResn());
        params.put("refAttchImg", vo.getRefAttchImg());
        params.put("issuBankId", vo.getIssuBankId());
        params.put("custAccNo", vo.getCustAccNo());
        params.put("regId", vo.getRegId());
        params.put("payId", vo.getPayId());
		return params;
	}
	private int refReqId;
	private String ordNo;
    private String custName;
    private String worNo;
    private int amt;
    private int refResn;
    private String refAttchImg;
    private int issuBankId;
    private int custAccNo;
    private String regId;
    private int payId;

    public int getPayId() {
        return payId;
    }

    public void setPayId(int payId) {
        this.payId = payId;
    }

    public int getRefReqId() {
        return refReqId;
    }

    public void setRefReqId(int refReqId) {
        this.refReqId = refReqId;
    }

    public String getOrdNo() {
        return ordNo;
    }

    public void setOrdNo(String ordNo) {
        this.ordNo = ordNo;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getWorNo() {
        return worNo;
    }

    public void setWorNo(String worNo) {
        this.worNo = worNo;
    }

    public int getAmt() {
        return amt;
    }

    public void setAmt(int amt) {
        this.amt = amt;
    }

    public int getRefResn() {
        return refResn;
    }

    public void setRefResn(int refResn) {
        this.refResn = refResn;
    }

    public String getRefAttchImg() {
        return refAttchImg;
    }

    public void setRefAttchImg(String refAttchImg) {
        this.refAttchImg = refAttchImg;
    }

    public int getIssuBankId() {
        return issuBankId;
    }

    public void setIssuBankId(int issuBankId) {
        this.issuBankId = issuBankId;
    }

    public int getCustAccNo() {
        return custAccNo;
    }

    public void setCustAccNo(int custAccNo) {
        this.custAccNo = custAccNo;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }
}
