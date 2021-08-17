package com.coway.trust.api.mobile.sales.eSVM;

import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "eSVMApiDto", description = "eSVMApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class eSVMApiDto {

    @SuppressWarnings("unchecked")
    public static eSVMApiDto create(EgovMap egvoMap) {
      return BeanConverter.toBean(egvoMap, eSVMApiDto.class);
    }

    private String regId;
    private String custName;
    private String salesOrdNo;
    private String quotNo;
    private String psmNo;
    private String orderType;
    private String custType;
    private String status;

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
