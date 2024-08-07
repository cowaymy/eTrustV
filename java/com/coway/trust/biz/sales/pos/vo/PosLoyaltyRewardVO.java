package com.coway.trust.biz.sales.pos.vo;

import org.apache.commons.csv.CSVRecord;

public class PosLoyaltyRewardVO {

    private String memCode;
    private double balanceCapped;
    private double discount;
    private String startDate;
    private String endDate;

    public static PosLoyaltyRewardVO create(CSVRecord CSVRecord){

        PosLoyaltyRewardVO vo = new PosLoyaltyRewardVO();

        vo.setMemCode(CSVRecord.get(0));
        vo.setBalanceCapped(Double.parseDouble(CSVRecord.get(1)));
        vo.setDiscount(Double.parseDouble(CSVRecord.get(2)));
        vo.setStartDate(CSVRecord.get(3));
        vo.setEndDate(CSVRecord.get(4));

        return vo;
    }

    public String getMemCode() {
      return memCode;
    }

    public double getBalanceCapped() {
      return balanceCapped;
    }

    public double getDiscount() {
      return discount;
    }

    public String getStartDate() {
      return startDate;
    }

    public String getEndDate() {
      return endDate;
    }

    public void setMemCode(String memCode) {
      this.memCode = memCode;
    }

    public void setBalanceCapped(double balanceCapped) {
      this.balanceCapped = balanceCapped;
    }

    public void setDiscount(double discount) {
      this.discount = discount;
    }

    public void setStartDate(String startDate) {
      this.startDate = startDate;
    }

    public void setEndDate(String endDate) {
      this.endDate = endDate;
    }


}
