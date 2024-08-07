package com.coway.trust.api.mobile.services.heartService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServiceResultDetailForm", description = "HeartServiceResultDetailForm")
public class HeartServiceResultDetailForm {

  @ApiModelProperty(value = "필터 코드 [default : '' 전체] 예) T010", example = "CT100337")
  private String filterCode;

  @ApiModelProperty(value = "chgid예) 20170820", example = "28092017")
  private int exchangeId;

  @ApiModelProperty(value = "필터 교체 수량 예) 20170827", example = "29092017")
  private int filterChangeQty;

  @ApiModelProperty(value = "필터 교체 수량 예) 20170827", example = "29092017")
  private String filterChangeQtyTst;

  @ApiModelProperty(value = "대체 필터 코드(123456)", example = "")
  private int alternativeFilterCode;

  @ApiModelProperty(value = "교체 필터 바코드", example = "")
  private String filterBarcdSerialNo;

  @ApiModelProperty(value = "교체 필터 바코드", example = "")
  private String filterBarcdNewSerialNo;

  @ApiModelProperty(value = "교체 필터 바코드", example = "")
  private String filterSerialUnmatchReason;

  @ApiModelProperty(value = "교체 필터 바코드", example = "")
  private String sysFilterBarcdSerialNo;

  @ApiModelProperty(value = "교체 필터 바코드", example = "")
  private String filterBarcdSerialNoOld;

  public int getAlternativeFilterCode() {
    return alternativeFilterCode;
  }

  public void setAlternativeFilterCode(int alternativeFilterCode) {
    this.alternativeFilterCode = alternativeFilterCode;
  }

  public String getFilterBarcdSerialNo() {
    return filterBarcdSerialNo;
  }

  public void setFilterBarcdSerialNo(String filterBarcdSerialNo) {
    this.filterBarcdSerialNo = filterBarcdSerialNo;
  }

  public String getFilterCode() {
    return filterCode;
  }

  public void setFilterCode(String filterCode) {
    this.filterCode = filterCode;
  }

  public int getExchangeId() {
    return exchangeId;
  }

  public void setExchangeId(int exchangeId) {
    this.exchangeId = exchangeId;
  }

  public int getFilterChangeQty() {
    return filterChangeQty;
  }

  public void setFilterChangeQty(int filterChangeQty) {
    this.filterChangeQty = filterChangeQty;
  }

  public String getFilterChangeQtyTst() {
    return filterChangeQtyTst;
  }

  public void setFilterChangeQtyTst(String filterChangeQtyTst) {
    this.filterChangeQtyTst = filterChangeQtyTst;
  }

  public String getFilterBarcdNewSerialNo() {
	return filterBarcdNewSerialNo;
}

public String getFilterSerialUnmatchReason() {
	return filterSerialUnmatchReason;
}

public void setFilterBarcdNewSerialNo(String filterBarcdNewSerialNo) {
	this.filterBarcdNewSerialNo = filterBarcdNewSerialNo;
}

public void setFilterSerialUnmatchReason(String filterSerialUnmatchReason) {
	this.filterSerialUnmatchReason = filterSerialUnmatchReason;
}

public String getSysFilterBarcdSerialNo() {
	return sysFilterBarcdSerialNo;
}

public void setSysFilterBarcdSerialNo(String sysFilterBarcdSerialNo) {
	this.sysFilterBarcdSerialNo = sysFilterBarcdSerialNo;
}

public String getFilterBarcdSerialNoOld() {
	return filterBarcdSerialNoOld;
}

public void setFilterBarcdSerialNoOld(String filterBarcdSerialNoOld) {
	this.filterBarcdSerialNoOld = filterBarcdSerialNoOld;
}

public static List<Map<String, Object>> createMaps(List<HeartServiceResultDetailForm> heartServiceResultDetailForms) {

    List<Map<String, Object>> list = new ArrayList<>();
    Map<String, Object> map;

    for (HeartServiceResultDetailForm form : heartServiceResultDetailForms) {
      map = BeanConverter.toMap(form);
      list.add(map);
    }
    return list;
  }

  public static List<Object> createMaps1(List<HeartServiceResultDetailForm> heartServiceResultDetailForms) {

    List<Object> list = new ArrayList<>();
    Map<String, Object> map;

    for (HeartServiceResultDetailForm form : heartServiceResultDetailForms) {
      map = BeanConverter.toMap(form);
      map.put("stkId", map.get("filterCode"));
      map.put("exchangeId", map.get("exchangeId"));
      map.put("name", map.get("filterChangeQty"));
      map.put("filterBarcdSerialNo", map.get("filterBarcdSerialNo"));
      //map.put("filterBarcdNewSerialNo", map.get("filterBarcdNewSerialNo"));
      //map.put("filterSerialUnmatchReason", map.get("filterSerialUnmatchReason"));

      list.add(map);
    }
    return list;
  }

}
