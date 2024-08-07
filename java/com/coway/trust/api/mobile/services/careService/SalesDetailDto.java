package com.coway.trust.api.mobile.services.careService;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/*********************************************************************************************
 * DATE             PIC           VERSION  COMMENT
 * -----------------------------------------------------------------------------
 * 22/04/2020    ONGHC      1.0.0       - Create SalesDetailDto
 *********************************************************************************************/

@ApiModel(value = "SalesDetailDto", description = "SalesDetailDto")
public class SalesDetailDto {

  @ApiModelProperty(value = "Order No.")
  private String ordNo;

  @ApiModelProperty(value = "Product")
  private String prod;

  @ApiModelProperty(value = "Installation Addess Line 1")
  private String instAdds1;

  @ApiModelProperty(value = "Installation Addess Line 1")
  private String instAdds2;

  @ApiModelProperty(value = "Area")
  private String area;

  @ApiModelProperty(value = "Post Code")
  private String postCde;

  @ApiModelProperty(value = "City")
  private String city;

  @ApiModelProperty(value = "State")
  private String state;

  @ApiModelProperty(value = "Country")
  private String country;

  @ApiModelProperty(value = "Contact Person")
  private String contPsn;

  @ApiModelProperty(value = "Mobile No.")
  private String hpNo;

  @ApiModelProperty(value = "House Phone No.")
  private String hmNo;

  @ApiModelProperty(value = "Office Phone No")
  private String offNo;

  @ApiModelProperty(value = "Email")
  private String email;

  public String getOrdNo() {
    return ordNo;
  }

  public void setOrdNo(String ordNo) {
    this.ordNo = ordNo;
  }

  public String getProd() {
    return prod;
  }

  public void setProd(String prod) {
    this.prod = prod;
  }

  public String getInstAdds1() {
    return instAdds1;
  }

  public void setInstAdds1(String instAdds1) {
    this.instAdds1 = instAdds1;
  }

  public String getInstAdds2() {
    return instAdds2;
  }

  public void setInstAdds2(String instAdds2) {
    this.instAdds2 = instAdds2;
  }

  public String getArea() {
    return area;
  }

  public void setArea(String area) {
    this.area = area;
  }

  public String getPostCde() {
    return postCde;
  }

  public void setPostCde(String postCde) {
    this.postCde = postCde;
  }

  public String getCity() {
    return city;
  }

  public void setCity(String city) {
    this.city = city;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

  public String getContPsn() {
    return contPsn;
  }

  public void setContPsn(String contPsn) {
    this.contPsn = contPsn;
  }

  public String getHpNo() {
    return hpNo;
  }

  public void setHpNo(String hpNo) {
    this.hpNo = hpNo;
  }

  public String getHmNo() {
    return hmNo;
  }

  public void setHmNo(String hmNo) {
    this.hmNo = hmNo;
  }

  public String getOffNo() {
    return offNo;
  }

  public void setOffNo(String offNo) {
    this.offNo = offNo;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  @SuppressWarnings("unchecked")
  public static SalesDetailDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, SalesDetailDto.class);
  }

}
