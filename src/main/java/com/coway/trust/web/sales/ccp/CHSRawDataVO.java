package com.coway.trust.web.sales.ccp;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.Row;

public class CHSRawDataVO {


  private String custId;
  private String month;
  private String year;
  private String chsStatus;
  private String chsRsn;



  public static CHSRawDataVO create(Row row) {

      CHSRawDataVO vo = new CHSRawDataVO();
      vo.setCustId(getValue(row.getCell(1)));
      vo.setMonth(getValue(row.getCell(2)));
      vo.setYear(getValue(row.getCell(3)));
      vo.setChsStatus(getValue(row.getCell(4)));
      vo.setChsRsn(getValue(row.getCell(5)));

      return vo;
  }


  @Override
  public String toString() {
      return "CHSRawDataVO [custId=" + custId + ", month =" + month
              + ", year = " + year +  ",  chsStatus = " + chsStatus + ", chsRsn =" + chsRsn + "]";
  }





  public String getCustId() {
      return custId;
  }


  public void setCustId(String custId) {
      this.custId = custId;
  }


  public String getMonth() {
      return month;
  }


  public void setMonth(String month) {
      this.month = month;
  }


  public String getYear() {
      return year;
  }


  public void setYear(String year) {
      this.year = year;
  }

  public String getChsStatus() {
    return chsStatus;
}


public void setChsStatus(String chsStatus) {
    this.chsStatus = chsStatus;
}

public String getChsRsn() {
  return chsRsn;
}


public void setChsRsn(String chsRsn) {
  this.chsRsn = chsRsn;
}

}
