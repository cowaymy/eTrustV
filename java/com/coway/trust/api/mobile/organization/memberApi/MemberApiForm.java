package com.coway.trust.api.mobile.organization.memberApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

/**
 * @ClassName : MemberApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 09.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 06.    MY-ONGHC         Add UserName Getter and Setter
 *          </pre>
 */
@ApiModel(value = "MemberApiForm", description = "MemberApiForm")
public class MemberApiForm {

  public static Map<String, Object> createMap(MemberApiForm vo) {
    Map<String, Object> params = new HashMap<>();
    params.put("selectType", vo.getSelectType());
    params.put("selectKeyword", vo.getSelectKeyword());
    params.put("memType", vo.getMemType());
    params.put("selectDivision", vo.getSelectDivision());
    params.put("memId", vo.getMemId());
    params.put("userName", vo.getUserName());
    return params;
  }

  private String selectType;
  private String selectKeyword;
  private int memType;
  private String selectDivision;
  private int memId;
  private String userName;

  public String getSelectType() {
    return selectType;
  }

  public void setSelectType(String selectType) {
    this.selectType = selectType;
  }

  public String getSelectKeyword() {
    return selectKeyword;
  }

  public void setSelectKeyword(String selectKeyword) {
    this.selectKeyword = selectKeyword;
  }

  public int getMemType() {
    return memType;
  }

  public void setMemType(int memType) {
    this.memType = memType;
  }

  public String getSelectDivision() {
    return selectDivision;
  }

  public void setSelectDivision(String selectDivision) {
    this.selectDivision = selectDivision;
  }

  public int getMemId() {
    return memId;
  }

  public void setMemId(int memId) {
    this.memId = memId;
  }

  public String getUserName() {
    return userName;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }

}
