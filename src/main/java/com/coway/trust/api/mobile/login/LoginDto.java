package com.coway.trust.api.mobile.login;

import com.coway.trust.cmmn.model.LoginVO;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "LoginDto", description = "LoginDto")
public class LoginDto {
  @ApiModelProperty(value = "사용자 id 에 대한 지역 (MY? TH?)")
  private String timezoneVal;

  @ApiModelProperty(value = "userName")
  private String userNm;

  @ApiModelProperty(value = "userFullName")
  private String userFullNm;

  @ApiModelProperty(value = "userId")
  private int userId;

  @ApiModelProperty(value = "userPassWord")
  private String userPassWord;

  @ApiModelProperty(value = "사업장 이름")
  private String companyName;

  @ApiModelProperty(value = "사업장 주소")
  private String companyAddress;

  @ApiModelProperty(value = "사업장 전화번호")
  private String companyTelNo1;

  @ApiModelProperty(value = "사업장 무료전화 번호")
  private String companyTelNo2;

  @ApiModelProperty(value = "접속한 계정이 Manager 권한인지 확인 필요.")
  private String managerYn;

  @ApiModelProperty(value = "사용자 그룹 ID [codeMasterId=1]")
  private int userGroupId;

  @ApiModelProperty(value = "userTypeId")
  private int userTypeId;

  @ApiModelProperty(value = "userMainDeptId")
  private String userMainDeptId;

  @ApiModelProperty(value = "serialRequireChkYn")
  private String serialRequireChkYn;

  @ApiModelProperty(value = "memId")
  private String memId;

  private String properiesUserSessionKey;

  public static LoginDto create( LoginVO loginVO ) {
    LoginDto dto = new LoginDto();
    dto.setTimezoneVal( "-" );
    dto.setUserNm( loginVO.getUserName() );
    dto.setUserFullNm( loginVO.getUserFullname() );
    dto.setUserId( loginVO.getUserId() );
    dto.setCompanyName( loginVO.getBranchName() );
    dto.setCompanyAddress( loginVO.getBranchAddr() );
    dto.setCompanyTelNo1( loginVO.getBranchTel1() );
    dto.setCompanyTelNo2( loginVO.getBranchTel2() );
    dto.setManagerYn( loginVO.getMgrYn() );
    dto.setUserGroupId( loginVO.getUserTypeId() );
    dto.setUserPassWord( loginVO.getUserPassWord() );
    dto.setUserTypeId( loginVO.getUserTypeId() );
    dto.setUserMainDeptId( loginVO.getUserMainDeptId() );
    dto.setSerialRequireChkYn( loginVO.getSerialRequireChkYn() );
    dto.setMemId( loginVO.getMemId() );
    dto.setProperiesUserSessionKey( loginVO.getProperiesUserSessionKey() );
    return dto;
  }

  public String getTimezoneVal() {
    return timezoneVal;
  }

  public void setTimezoneVal( String timezoneVal ) {
    this.timezoneVal = timezoneVal;
  }

  public String getUserNm() {
    return userNm;
  }

  public void setUserNm( String userNm ) {
    this.userNm = userNm;
  }

  public String getUserFullNm() {
    return userFullNm;
  }

  public void setUserFullNm( String userFullNm ) {
    this.userFullNm = userFullNm;
  }

  public int getUserId() {
    return userId;
  }

  public void setUserId( int userId ) {
    this.userId = userId;
  }

  public String getUserPassWord() {
    return userPassWord;
  }

  public void setUserPassWord( String userPassWord ) {
    this.userPassWord = userPassWord;
  }

  public String getCompanyName() {
    return companyName;
  }

  public void setCompanyName( String companyName ) {
    this.companyName = companyName;
  }

  public String getCompanyAddress() {
    return companyAddress;
  }

  public void setCompanyAddress( String companyAddress ) {
    this.companyAddress = companyAddress;
  }

  public String getCompanyTelNo1() {
    return companyTelNo1;
  }

  public void setCompanyTelNo1( String companyTelNo1 ) {
    this.companyTelNo1 = companyTelNo1;
  }

  public String getCompanyTelNo2() {
    return companyTelNo2;
  }

  public void setCompanyTelNo2( String companyTelNo2 ) {
    this.companyTelNo2 = companyTelNo2;
  }

  public String getManagerYn() {
    return managerYn;
  }

  public void setManagerYn( String managerYn ) {
    this.managerYn = managerYn;
  }

  public int getUserGroupId() {
    return userGroupId;
  }

  public void setUserGroupId( int userGroupId ) {
    this.userGroupId = userGroupId;
  }

  public int getUserTypeId() {
    return userTypeId;
  }

  public void setUserTypeId( int userTypeId ) {
    this.userTypeId = userTypeId;
  }

  public String getUserMainDeptId() {
    return userMainDeptId;
  }

  public void setUserMainDeptId( String userMainDeptId ) {
    this.userMainDeptId = userMainDeptId;
  }

  public String getSerialRequireChkYn() {
    return serialRequireChkYn;
  }

  public void setSerialRequireChkYn( String serialRequireChkYn ) {
    this.serialRequireChkYn = serialRequireChkYn;
  }

  public String getMemId() {
    return memId;
  }

  public void setMemId( String memId ) {
    this.memId = memId;
  }

  public String getProperiesUserSessionKey() {
    return properiesUserSessionKey;
  }

  public void setProperiesUserSessionKey( String properiesUserSessionKey ) {
    this.properiesUserSessionKey = properiesUserSessionKey;
  }

}
