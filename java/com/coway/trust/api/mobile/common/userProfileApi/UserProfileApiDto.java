package com.coway.trust.api.mobile.common.userProfileApi;

import java.util.HashMap;
import java.util.Map;
import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
/**
 * @ClassName : UserProfileApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 01.   KR-JAEMJAEM:)   First creation
 * 2023. 03. 30    MY-ONGHC         ADD BUSINESS CARD FEATURE
 * 2023. 09. 05    MY-ONGHC         ADD TAG-ID FEATURE
 * </pre>
 */
@ApiModel(value = "UserProfileApiDto", description = "UserProfileApiDto")
public class UserProfileApiDto {

  @SuppressWarnings("unchecked")
  public UserProfileApiDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, UserProfileApiDto.class);
  }

  public static Map<String, Object> createMap(UserProfileApiDto vo) {
    Map<String, Object> params = new HashMap<>();
    params.put("memCode", vo.getMemCode());
    params.put("memName", vo.getMemName());
    params.put("memTypeName", vo.getMemTypeName());
    params.put("memStatus", vo.getMemStatus());
    params.put("brnchCode", vo.getBrnchCode());
    params.put("brnchName", vo.getBrnchName());
    params.put("grpCode", vo.getGrpCode());
    params.put("orgCode", vo.getOrgCode());
    params.put("deptCode", vo.getDeptCode());
    params.put("bankName", vo.getBankName());
    params.put("bankAccNo", vo.getBankAccNo());
    params.put("memHpno", vo.getMemHpno());
    params.put("memEmail", vo.getMemEmail());
    params.put("brnchAddr", vo.getBrnchAddr());
    params.put("userRole", vo.getUserRole());
    params.put("agExprDt", vo.getAgExprDt());
    params.put("imgGrpId", vo.getImgGrpId());
    params.put("imgId", vo.getImgId());

    return params;
  }

  private String memCode;
  private String memName;
  private String memTypeName;
  private String memStatus;
  private String brnchCode;
  private String brnchName;
  private String grpCode;
  private String orgCode;
  private String deptCode;
  private String bankName;
  private String bankAccNo;
  private String memHpno;
  private String memEmail;
  private String brnchAddr;
  private String userRole;
  private String agExprDt;
  private String imgGrpId;
  private String imgId;

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

  public String getMemTypeName() {
    return memTypeName;
  }

  public void setMemTypeName(String memTypeName) {
    this.memTypeName = memTypeName;
  }

  public String getMemStatus() {
    return memStatus;
  }

  public void setMemStatus(String memStatus) {
    this.memStatus = memStatus;
  }

  public String getBrnchCode() {
    return brnchCode;
  }

  public void setBrnchCode(String brnchCode) {
    this.brnchCode = brnchCode;
  }

  public String getBrnchName() {
    return brnchName;
  }

  public void setBrnchName(String brnchName) {
    this.brnchName = brnchName;
  }

  public String getGrpCode() {
    return grpCode;
  }

  public void setGrpCode(String grpCode) {
    this.grpCode = grpCode;
  }

  public String getOrgCode() {
    return orgCode;
  }

  public void setOrgCode(String orgCode) {
    this.orgCode = orgCode;
  }

  public String getDeptCode() {
    return deptCode;
  }

  public void setDeptCode(String deptCode) {
    this.deptCode = deptCode;
  }

  public String getBankName() {
    return bankName;
  }

  public void setBankName(String bankName) {
    this.bankName = bankName;
  }

  public String getBankAccNo() {
    return bankAccNo;
  }

  public void setBankAccNo(String bankAccNo) {
    this.bankAccNo = bankAccNo;
  }

  public String getMemHpno() {
    return memHpno;
  }

  public void setMemHpno(String memHpno) {
    this.memHpno = memHpno;
  }

  public String getMemEmail() {
    return memEmail;
  }

  public void setMemEmail(String memEmail) {
    this.memEmail = memEmail;
  }

  public String getBrnchAddr() {
    return brnchAddr;
  }

  public void setBrnchAddr(String brnchAddr) {
    this.brnchAddr = brnchAddr;
  }

  public String getUserRole() {
    return userRole;
  }

  public void setUserRole(String userRole) {
    this.userRole = userRole;
  }

  public String getAgExprDt() {
    return agExprDt;
  }

  public void setAgExprDt(String agExprDt) {
    this.agExprDt = agExprDt;
  }

  public String getImgGrpId() {
    return imgGrpId;
  }

  public void setImgGrpId(String imgGrpId) {
    this.imgGrpId = imgGrpId;
  }

  public String getImgId() {
    return imgId;
  }

  public void setImgId(String imgId) {
    this.imgId = imgId;
  }

}
