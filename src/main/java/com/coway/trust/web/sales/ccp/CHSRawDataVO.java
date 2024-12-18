package com.coway.trust.web.sales.ccp;

/*import static com.coway.trust.config.excel.ExcelReadComponent.getValue;*/
import org.apache.commons.csv.CSVRecord;

import org.apache.poi.ss.usermodel.Row;


public class CHSRawDataVO {


  private String custId;
  private String month;
  private String year;
  private String chsStatus;
  private String chsRsn;
  private String custCat;
  private String renCat;
  private String scoreGrp;
  private String renUnitEntitle;

  public static CHSRawDataVO create(CSVRecord CSVRecord) {
    CHSRawDataVO vo = new CHSRawDataVO();
    vo.setCustId(CSVRecord.get(1));
    vo.setMonth(CSVRecord.get(2));
    vo.setYear(CSVRecord.get(3));
    vo.setChsStatus(CSVRecord.get(4));
    vo.setChsRsn(CSVRecord.get(5));
    vo.setCustCat(CSVRecord.get(6));
    vo.setRenCat(CSVRecord.get(7));
    vo.setScoreGrp(CSVRecord.get(8));
    vo.setRenUnitEntitle(CSVRecord.get(9));

    return vo;
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

public String getCustCat() {
	return custCat;
}

public void setCustCat(String custCat) {
	this.custCat = custCat;
}

public String getRenCat() {
	return renCat;
}

public void setRenCat(String renCat) {
	this.renCat = renCat;
}

public String getScoreGrp() {
	return scoreGrp;
}

public void setScoreGrp(String scoreGrp) {
	this.scoreGrp = scoreGrp;
}

public String getRenUnitEntitle() {
	return renUnitEntitle;
}

public void setRenUnitEntitle(String renUnitEntitle) {
	this.renUnitEntitle = renUnitEntitle;
}

}
