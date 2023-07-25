package com.coway.trust.api.mobile.services.serviceMileage;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ServiceMileageDto", description = "SERVICE MILEAGE DTO")
public class ServiceMileageDto {

  @SuppressWarnings("unchecked")
  public static ServiceMileageDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, ServiceMileageDto.class);
  }

  public static Map<String, Object> createMap(ServiceMileageDto serviceMileageForm) {
    Map<String, Object> params = new HashMap<>();

    params.put("serviceNo", serviceMileageForm.getServiceNo());
    params.put("userName", serviceMileageForm.getUserName());
    params.put("checkInDate", serviceMileageForm.getCheckInDate());
    params.put("longtitude", serviceMileageForm.getLongtitude());
    params.put("latitude", serviceMileageForm.getLatitude());

    return params;
  }

  @ApiModelProperty(value = "serviceNo")
  private String serviceNo;

  @ApiModelProperty(value = "userName")
  private String userName;

  @ApiModelProperty(value = "checkInDate")
  private String checkInDate;

  @ApiModelProperty(value = "longtitude")
  private String longtitude;

  @ApiModelProperty(value = "latitude")
  private String latitude;

  public String getServiceNo() {
    return serviceNo;
  }

  public void setServiceNo(String serviceNo) {
    this.serviceNo = serviceNo;
  }

  public String getUserName() {
    return userName;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }

  public String getCheckInDate() {
    return checkInDate;
  }

  public void setCheckInDate(String checkInDate) {
    this.checkInDate = checkInDate;
  }

  public String getLongtitude() {
    return longtitude;
  }

  public void setLongtitude(String longtitude) {
    this.longtitude = longtitude;
  }

  public String getLatitude() {
    return latitude;
  }

  public void setLatitude(String latitude) {
    this.latitude = latitude;
  }
}
