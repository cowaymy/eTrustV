package com.coway.trust.api.mobile.sales.eSVM;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "eSVMApiForm", description = "eSVMApiForm")
public class eSVMApiForm {

    public static eSVMApiForm create(Map<String, Object> map) {
        return BeanConverter.toBean(map, eSVMApiForm.class);
    }

    public static Map<String, Object> createMap(eSVMApiForm vo) {
        Map<String, Object> params = new HashMap<>();
        params.put("reqstDtFrom", vo.getReqstDtFrom());
        params.put("reqstDtTo", vo.getReqstDtTo());
        params.put("selectType", vo.getSelectType());
        params.put("selectKeyword", vo.getSelectKeyword());
        params.put("regId", vo.getRegId());
        params.put("custName", vo.getCustName());
        params.put("salesOrdNo", vo.getSalesOrdNo());
        params.put("quotNo", vo.getQuotNo());
        params.put("psmNo", vo.getPsmNo());
        params.put("orderType", vo.getOrderType());
        params.put("custType", vo.getCustType());
        params.put("status", vo.getStatus());
        return params;
    }

    private String reqstDtFrom;
    private String reqstDtTo;
    private String selectType;
    private String selectKeyword;
    private String regId;
    private String custName;
    private String salesOrdNo;
    private String quotNo;
    private String psmNo;
    private String orderType;
    private String custType;
    private String status;

    public String getReqstDtFrom() {
        return reqstDtFrom;
    }

    public void setReqstDtFrom(String reqstDtFrom) {
        this.reqstDtFrom = reqstDtFrom;
    }

    public String getReqstDtTo() {
        return reqstDtTo;
    }

    public void setReqstDtTo(String reqstDtTo) {
        this.reqstDtTo = reqstDtTo;
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

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getSalesOrdNo() {
        return salesOrdNo;
    }

    public void setSalesOrdNo(String salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }

    public String getQuotNo() {
        return quotNo;
    }

    public void setQuotNo(String quotNo) {
        this.quotNo = quotNo;
    }

    public String getPsmNo() {
        return psmNo;
    }

    public void setPsmNo(String psmNo) {
        this.psmNo = psmNo;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getCustType() {
        return custType;
    }

    public void setCustType(String custType) {
        this.custType = custType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
