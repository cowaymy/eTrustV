package com.coway.trust.biz.sales.rcms.vo;

import org.apache.commons.csv.CSVRecord;

public class uploadAssignAgentDataVO {

    private String orderNo;
    private String caller;
    private String renStus;

    public static uploadAssignAgentDataVO create(CSVRecord CSVRecord){

        uploadAssignAgentDataVO vo = new uploadAssignAgentDataVO();

        vo.setOrderNo(CSVRecord.get(0));
        vo.setCaller(CSVRecord.get(1));
        vo.setRenStus(CSVRecord.get(2));

        return vo;
    }

    public String getOrderNo() {
        return orderNo;
    }
    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }
    public String getCaller() {
        return caller;
    }
    public void setCaller(String caller) {
        this.caller = caller;
    }
    public String getRenStus() {
       return renStus;
    }
    public void setRenStus(String renStus) {
       this.renStus = renStus;
    }
}
