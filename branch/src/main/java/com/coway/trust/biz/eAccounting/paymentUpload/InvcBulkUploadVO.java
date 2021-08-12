package com.coway.trust.biz.eAccounting.paymentUpload;

import org.apache.commons.csv.CSVRecord;

public class InvcBulkUploadVO {

    private String docNo;
    private String clmSeq;
    private String costCentr;
    private String supplier;
    private String invcDt;
    private String invcNo;
    private String payDueDt;
    private String billPeriodFr;
    private String billPeriodTo;
    private String bgtCd;
    private String amt;
    private String expDesc;
    private String utilNo;
    private String jPayNo;

    public static InvcBulkUploadVO create(CSVRecord CSVRecord) {
        InvcBulkUploadVO vo = new InvcBulkUploadVO();

        vo.setDocNo(CSVRecord.get(0).trim());
        vo.setClmSeq(CSVRecord.get(1).trim());
        vo.setCostCentr(CSVRecord.get(2).trim());
        vo.setSupplier(CSVRecord.get(3).trim());
        vo.setInvcDt(CSVRecord.get(4).trim());
        vo.setInvcNo(CSVRecord.get(5).trim());
        vo.setPayDueDt(CSVRecord.get(6).trim());
        vo.setBillPeriodFr(CSVRecord.get(7).trim());
        vo.setBillPeriodTo(CSVRecord.get(8).trim());
        vo.setBgtCd(CSVRecord.get(9).trim());
        vo.setAmt(CSVRecord.get(10).trim());
        vo.setUtilNo(CSVRecord.get(11).trim());
        vo.setJPayNo(CSVRecord.get(12).trim());
        vo.setExpDesc(CSVRecord.get(13).trim());

        return vo;
    }

    public String getDocNo() {
        return docNo;
    }

    public void setDocNo(String docNo) {
        this.docNo = docNo;
    }

    public String getClmSeq() {
        return clmSeq;
    }

    public void setClmSeq(String clmSeq) {
        this.clmSeq = clmSeq;
    }

    public String getCostCentr() {
        return costCentr;
    }

    public void setCostCentr(String costCentr) {
        this.costCentr = costCentr;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getInvcDt() {
        return invcDt;
    }

    public void setInvcDt(String invcDt) {
        this.invcDt = invcDt;
    }

    public String getInvcNo() {
        return invcNo;
    }

    public void setInvcNo(String invcNo) {
        this.invcNo = invcNo;
    }

    public String getPayDueDt() {
        return payDueDt;
    }

    public void setPayDueDt(String payDueDt) {
        this.payDueDt = payDueDt;
    }

    public String getBillPeriodFr() {
        return billPeriodFr;
    }

    public void setBillPeriodFr(String billPeriodFr) {
        this.billPeriodFr = billPeriodFr;
    }

    public String getBillPeriodTo() {
        return billPeriodTo;
    }

    public void setBillPeriodTo(String billPeriodTo) {
        this.billPeriodTo = billPeriodTo;
    }

    public String getBgtCd() {
        return bgtCd;
    }

    public void setBgtCd(String bgtCd) {
        this.bgtCd = bgtCd;
    }

    public String getAmt() {
        return amt;
    }

    public void setAmt(String amt) {
        this.amt = amt;
    }

    public String getExpDesc() {
        return expDesc;
    }

    public void setExpDesc(String expDesc) {
        this.expDesc = expDesc;
    }

    public String getUtilNo() {
        return utilNo;
    }

    public void setUtilNo(String utilNo) {
        this.utilNo = utilNo;
    }

    public String getJPayNo() {
        return jPayNo;
    }

    public void setJPayNo(String jPayNo) {
        this.jPayNo = jPayNo;
    }
}
