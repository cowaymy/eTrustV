package com.coway.trust.biz.payment.invoice.service;

import org.apache.commons.csv.CSVRecord;

public class InvcNoBulkUploadVO {

    private String docNo;
    private String invcNo;

    public static InvcNoBulkUploadVO create(CSVRecord CSVRecord) {
    	InvcNoBulkUploadVO vo = new InvcNoBulkUploadVO();

        vo.setDocNo(CSVRecord.get(0).trim());
        vo.setInvcNo(CSVRecord.get(1).trim());

        return vo;
    }

    public String getDocNo() {
        return docNo;
    }

    public void setDocNo(String docNo) {
        this.docNo = docNo;
    }

    public String getInvcNo() {
        return invcNo;
    }

    public void setInvcNo(String invcNo) {
        this.invcNo = invcNo;
    }

}
