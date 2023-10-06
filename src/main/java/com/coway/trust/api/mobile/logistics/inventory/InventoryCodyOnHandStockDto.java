package com.coway.trust.api.mobile.logistics.inventory;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "Cody Consignment Transfer", description = "공통코드 Dto")
public class InventoryCodyOnHandStockDto {

  @ApiModelProperty(value = "Member ID ")
  private String memId;

  @ApiModelProperty(value = "Member Code")
  private String memCode;

  @ApiModelProperty(value = "Member Name")
  private String memName;

  public static InventoryCodyOnHandStockDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, InventoryCodyOnHandStockDto.class);
  }

  public String getMemId() {
    return memId;
  }

  public void setMemId(String memId) {
    this.memId = memId;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setMemCode(String memCode) {
    this.memCode = memCode;
  }

  public String getMemName() {
    return memName;
  }

  public void setMemName(String memName) {
    this.memName = memName;
  }
}
