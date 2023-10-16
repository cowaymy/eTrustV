package com.coway.trust.api.mobile.logistics.requestresult;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RequestResultMListDto", description = "공통코드 Dto")
public class RequestResultMListDto {

  @ApiModelProperty(value = "SMO no")
  private String smoNo;

  @ApiModelProperty(value = "type(auto / manual)")
  private String reqType;

  @ApiModelProperty(value = "상태")
  private String reqStatus;

  @ApiModelProperty(value = "gi 요청자")
  private String giCustName;

  @ApiModelProperty(value = "gr 요청자")
  private String grCustName;

  @ApiModelProperty(value = "gi locationCode")
  private String giLocationCode;

  @ApiModelProperty(value = "gi locationName")
  private String giLocationName;

  @ApiModelProperty(value = "gi 날짜")
  private String giDate;

  @ApiModelProperty(value = "gr 날짜")
  private String grDate;

  @ApiModelProperty(value = "Location ID")
  private int rdcCode;

  private List<RequestResultDListDto> partsList = null;

  public static RequestResultMListDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, RequestResultMListDto.class);
  }

  public String getSmoNo() {
    return smoNo;
  }

  public void setSmoNo(String smoNo) {
    this.smoNo = smoNo;
  }

  public String getReqType() {
    return reqType;
  }

  public void setReqType(String reqType) {
    this.reqType = reqType;
  }

  public String getReqStatus() {
    return reqStatus;
  }

  public void setReqStatus(String reqStatus) {
    this.reqStatus = reqStatus;
  }

  public String getGiCustName() {
    return giCustName;
  }

  public void setGiCustName(String giCustName) {
    this.giCustName = giCustName;
  }

  public String getGiLocationCode() {
    return giLocationCode;
  }

  public void setGiLocationCode(String giLocationCode) {
    this.giLocationCode = giLocationCode;
  }

  public String getGiDate() {
    return giDate;
  }

  public void setGiDate(String giDate) {
    this.giDate = giDate;
  }

  public String getGrDate() {
    return grDate;
  }

  public void setGrDate(String grDate) {
    this.grDate = grDate;
  }

  public List<RequestResultDListDto> getPartsList() {
    return partsList;
  }

  public void setPartsList(List<RequestResultDListDto> partsList) {
    this.partsList = partsList;
  }

  public String getGiLocationName() {
    return giLocationName;
  }

  public void setGiLocationName(String giLocationName) {
    this.giLocationName = giLocationName;
  }

  public int getRdcCode() {
    return rdcCode;
  }

  public void setRdcCode(int rdcCode) {
    this.rdcCode = rdcCode;
  }

  public String getGrCustName() {
    return grCustName;
  }

  public void setGrCustName(String grCustName) {
    this.grCustName = grCustName;
  }
}
