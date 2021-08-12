package com.coway.trust.api.mobile.payment.fundTransferRefundApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : FundTransferRefundApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 10. 10.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "FundTransferRefundApiDto", description = "FundTransferRefundApiDto")
public class FundTransferRefundApiDto {



	@SuppressWarnings("unchecked")
	public static FundTransferRefundApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, FundTransferRefundApiDto.class);
	}



	public static Map<String, Object> createMap(FundTransferRefundApiDto vo){
		Map<String, Object> params = new HashMap<>();
        params.put("type", vo.getType());
        params.put("seq", vo.getSeq());
        params.put("custId", vo.getCustId());
        params.put("custNm", vo.getCustNm());
        params.put("salesOrdNo", vo.getSalesOrdNo());
        params.put("appType", vo.getAppType());
        params.put("transactionDate", vo.getTransactionDate());
        params.put("payMode", vo.getPayMode());
        params.put("orNo", vo.getOrNo());
        params.put("totAmt", vo.getTotAmt());
        params.put("stusCodeName", vo.getStusCodeName());
        params.put("productName", vo.getProductName());
        params.put("appTypeId", vo.getAppTypeId());
        params.put("payId", vo.getPayId());
        params.put("payItmModeId", vo.getPayItmModeId());
		return params;
	}



    private String type;
	private int seq;
	private int custId;
	private String custNm;
	private String salesOrdNo;
	private String appType;
	private String transactionDate;
	private String payMode;
	private String orNo;
	private int totAmt;
	private String stusCodeName;
	private String productName;
	private int appTypeId;
	private int payId;
    private int payItmModeId;



    public int getPayItmModeId() {
        return payItmModeId;
    }

    public void setPayItmModeId(int payItmModeId) {
        this.payItmModeId = payItmModeId;
    }

    public int getPayId() {
        return payId;
    }

    public void setPayId(int payId) {
        this.payId = payId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getSeq() {
        return seq;
    }

    public void setSeq(int seq) {
        this.seq = seq;
    }

    public int getCustId() {
        return custId;
    }

    public void setCustId(int custId) {
        this.custId = custId;
    }

    public String getCustNm() {
        return custNm;
    }

    public void setCustNm(String custNm) {
        this.custNm = custNm;
    }

    public String getSalesOrdNo() {
        return salesOrdNo;
    }

    public void setSalesOrdNo(String salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }

    public String getAppType() {
        return appType;
    }

    public void setAppType(String appType) {
        this.appType = appType;
    }

    public String getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(String transactionDate) {
        this.transactionDate = transactionDate;
    }

    public String getPayMode() {
        return payMode;
    }

    public void setPayMode(String payMode) {
        this.payMode = payMode;
    }

    public String getOrNo() {
        return orNo;
    }

    public void setOrNo(String orNo) {
        this.orNo = orNo;
    }

    public int getTotAmt() {
        return totAmt;
    }

    public void setTotAmt(int totAmt) {
        this.totAmt = totAmt;
    }

    public String getStusCodeName() {
        return stusCodeName;
    }

    public void setStusCodeName(String stusCodeName) {
        this.stusCodeName = stusCodeName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getAppTypeId() {
        return appTypeId;
    }

    public void setAppTypeId(int appTypeId) {
        this.appTypeId = appTypeId;
    }
}
