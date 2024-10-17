package com.coway.trust.biz.api.vo.selfcarePortal;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "VerifyOderNoReqForm", description = "VerifyOderNoReqForm")
public class VerifyOderNoReqForm
{
    private String orderNo;

    public String getOrderNo()
    {
        return orderNo;
    }

    public void setOrderNo( String orderNo )
    {
        this.orderNo = orderNo;
    }
}
