package com.coway.trust.cmmn.model;

import java.util.Collections;
import java.util.Date;
import java.util.List;

public class LoginVO {
  private int userId;

  private String userName; // AS-IS 에서 userName을 실제적인 로그인 ID로 사용함.

  private String userFullname;

  private String userEmail;

  private int userStatusId;

  private int userTypeId;

  private String userMainDeptId;

  private String userDeptId;

  private int roleId;

  private Integer memberLevel;

  private Date userUpdateAt;

  private Date userPasswdLastUpdateAt;

  private String userMobileNo;

  private String userExtNo;

  private int userIsPartTime;

  private int userIsExternal;

  private String statusName;

  private String code;

  private int userBranchId;

  private String branchName;

  private String branchAddr;

  private String branchTel1;

  private String branchTel2;

  private String deptName;

  private String diffDay;

  private String userSecQuesId;

  private String securityQuestion;

  private String userSecQuesAns;

  private String userPassWord;

  private String userNric;

  private String userWorkNo;

  private String mgrYn;

  private String memId;

  private String costCentr;

  private String agrmtAppStat; //ADD AGREEMENT APPROVAL STATUS FOR MOBILE

  private String agrmt; //ADD AGREEMENT STATUS FOR MOBILE

  private String mobileUseYn;

  private String serialRequireChkYn;

  private String hpStus;

  private String memStus;

  private String rank;

  private String vacStatus;  // ADDED VACCINATION INFO BY HUI DING, 13/09/2021

  private String diffVacDay;

  private int bizType;

  private String userMemCode;

  private int isAC;

  private String orgCode;

  private String groupCode;

  private String deptCode;

  private int checkMfaFlag;

  private String sKey;

  public String getUserMemCode() {
    return userMemCode;
  }

  public void setUserMemCode( String userMemCode ) {
    this.userMemCode = userMemCode;
  }

  public String getVacStatus() {
    return vacStatus;
  }

  public void setVacStatus( String vacStatus ) {
    this.vacStatus = vacStatus;
  }

  public void setBizType( int bizType ) {
    this.bizType = bizType;
  }

  public int getBizType() {
    return bizType;
  }

  public String getDiffVacDay() {
    return diffVacDay;
  }

  public void setDiffVacDay( String diffVacDay ) {
    this.diffVacDay = diffVacDay;
  }

  public String getUserNric() {
    return userNric;
  }

  public void setUserNric( String userNric ) {
    this.userNric = userNric;
  }

  public String getUserWorkNo() {
    return userWorkNo;
  }

  public void setUserWorkNo( String userWorkNo ) {
    this.userWorkNo = userWorkNo;
  }

  private List<LoginSubAuthVO> loginSubAuthVOList;

  public String getDiffDay() {
    return diffDay;
  }

  public void setDiffDay( String diffDay ) {
    this.diffDay = diffDay;
  }

  public int getUserId() {
    return userId;
  }

  public void setUserId( int userId ) {
    this.userId = userId;
  }

  public String getUserName() {
    return userName;
  }

  public void setUserName( String userName ) {
    this.userName = userName;
  }

  public String getUserFullname() {
    return userFullname;
  }

  public void setUserFullname( String userFullname ) {
    this.userFullname = userFullname;
  }

  public String getUserEmail() {
    return userEmail;
  }

  public void setUserEmail( String userEmail ) {
    this.userEmail = userEmail;
  }

  public int getUserStatusId() {
    return userStatusId;
  }

  public void setUserStatusId( int userStatusId ) {
    this.userStatusId = userStatusId;
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

  public String getUserDeptId() {
    return userDeptId;
  }

  public void setUserDeptId( String userDeptId ) {
    this.userDeptId = userDeptId;
  }

  public int getRoleId() {
    return roleId;
  }

  public void setRoleId( int roleId ) {
    this.roleId = roleId;
  }

  public Integer getMemberLevel() {
    return memberLevel;
  }

  public void setMemberLevel( Integer memberLevel ) {
    this.memberLevel = memberLevel;
  }

  public Date getUserUpdateAt() {
    return userUpdateAt;
  }

  public void setUserUpdateAt( Date userUpdateAt ) {
    this.userUpdateAt = userUpdateAt;
  }

  public Date getUserPasswdLastUpdateAt() {
    return userPasswdLastUpdateAt;
  }

  public void setUserPasswdLastUpdateAt( Date userPasswdLastUpdateAt ) {
    this.userPasswdLastUpdateAt = userPasswdLastUpdateAt;
  }

  public String getUserMobileNo() {
    return userMobileNo;
  }

  public void setUserMobileNo( String userMobileNo ) {
    this.userMobileNo = userMobileNo;
  }

  public String getUserExtNo() {
    return userExtNo;
  }

  public void setUserExtNo( String userExtNo ) {
    this.userExtNo = userExtNo;
  }

  public int getUserIsPartTime() {
    return userIsPartTime;
  }

  public void setUserIsPartTime( int userIsPartTime ) {
    this.userIsPartTime = userIsPartTime;
  }

  public int getUserIsExternal() {
    return userIsExternal;
  }

  public void setUserIsExternal( int userIsExternal ) {
    this.userIsExternal = userIsExternal;
  }

  public String getStatusName() {
    return statusName;
  }

  public void setStatusName( String statusName ) {
    this.statusName = statusName;
  }

  public String getCode() {
    return code;
  }

  public void setCode( String code ) {
    this.code = code;
  }

  public int getUserBranchId() {
    return userBranchId;
  }

  public void setUserBranchId( int userBranchId ) {
    this.userBranchId = userBranchId;
  }

  public String getBranchName() {
    return branchName;
  }

  public void setBranchName( String branchName ) {
    this.branchName = branchName;
  }

  public String getBranchAddr() {
    return branchAddr;
  }

  public void setBranchAddr( String branchAddr ) {
    this.branchAddr = branchAddr;
  }

  public String getBranchTel1() {
    return branchTel1;
  }

  public void setBranchTel1( String branchTel1 ) {
    this.branchTel1 = branchTel1;
  }

  public String getBranchTel2() {
    return branchTel2;
  }

  public void setBranchTel2( String branchTel2 ) {
    this.branchTel2 = branchTel2;
  }

  public String getDeptName() {
    return deptName;
  }

  public void setDeptName( String deptName ) {
    this.deptName = deptName;
  }

  public String getUserSecQuesId() {
    return userSecQuesId;
  }

  public void setUserSecQuesId( String userSecQuesId ) {
    this.userSecQuesId = userSecQuesId;
  }

  public String getSecurityQuestion() {
    return securityQuestion;
  }

  public void setSecurityQuestion( String securityQuestion ) {
    this.securityQuestion = securityQuestion;
  }

  public String getUserSecQuesAns() {
    return userSecQuesAns;
  }

  public void setUserSecQuesAns( String userSecQuesAns ) {
    this.userSecQuesAns = userSecQuesAns;
  }

  public String getUserPassWord() {
    return userPassWord;
  }

  public void setUserPassWord( String userPassWord ) {
    this.userPassWord = userPassWord;
  }

  public List<LoginSubAuthVO> getLoginSubAuthVOList() {
    if ( loginSubAuthVOList == null ) {
      loginSubAuthVOList = Collections.emptyList();
    }
    return loginSubAuthVOList;
  }

  public void setLoginSubAuthVOList( List<LoginSubAuthVO> loginSubAuthVOList ) {
    this.loginSubAuthVOList = loginSubAuthVOList;
  }

  public String getMgrYn() {
    return mgrYn;
  }

  public void setMgrYn( String mgrYn ) {
    this.mgrYn = mgrYn;
  }

  public String getMemId() {
    return memId;
  }

  public void setMemId( String memId ) {
    this.memId = memId;
  }

  public String getCostCentr() {
    return costCentr;
  }

  public void setCostCentr( String costCentr ) {
    this.costCentr = costCentr;
  }

  public String getAgrmtAppStat() {
    if ( agrmtAppStat == null ) {
      return "";
    }
    return agrmtAppStat;
  }

  public void setAgrmtAppStat( String agrmtAppStat ) {
    this.agrmtAppStat = agrmtAppStat;
  }

  public String getAgrmt() {
    if ( agrmt == null ) {
      return "";
    }
    return agrmt;
  }

  public void setAgrmt( String agrmt ) {
    this.agrmt = agrmt;
  }

  public String getMobileUseYn() {
    return mobileUseYn;
  }

  public void setMobileUseYn( String mobileUseYn ) {
    this.mobileUseYn = mobileUseYn;
  }

  public String getSerialRequireChkYn() {
    return serialRequireChkYn;
  }

  public void setSerialRequireChkYn( String serialRequireChkYn ) {
    this.serialRequireChkYn = serialRequireChkYn;
  }

  public void setHpStus( String hpStus ) {
    this.hpStus = hpStus;
  }

  public String getHpStus() {
    return hpStus;
  }

  public void setMemStus( String memStus ) {
    this.memStus = memStus;
  }

  public String getMemStus() {
    return memStus;
  }

  public void setRank( String rank ) {
    this.rank = rank;
  }

  public String getRank() {
    return rank;
  }

  public int getIsAC() {
    return isAC;
  }

  public void setIsAC( int isAC ) {
    this.isAC = isAC;
  }

  public String getOrgCode() {
    return orgCode;
  }

  public void setOrgCode( String orgCode ) {
    this.orgCode = orgCode;
  }

  public String getGroupCode() {
    return groupCode;
  }

  public void setGroupCode( String groupCode ) {
    this.groupCode = groupCode;
  }

  public String getDeptCode() {
    return deptCode;
  }

  public void setDeptCode( String deptCode ) {
    this.deptCode = deptCode;
  }

  public int getCheckMfaFlag() {
    return checkMfaFlag;
  }

  public void setCheckMfaFlag( int checkMfaFlag ) {
    this.checkMfaFlag = checkMfaFlag;
  }

  public String getsKey() {
    return sKey;
  }

  public void setsKey( String sKey ) {
    this.sKey = sKey;
  }
}
