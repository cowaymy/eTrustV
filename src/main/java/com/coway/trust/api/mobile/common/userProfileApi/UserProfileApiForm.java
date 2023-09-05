package com.coway.trust.api.mobile.common.userProfileApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : UserProfileApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 01.   KR-JAEMJAEM:)   First creation
 * 2023. 09. 05    MY-ONGHC         ADD E-TAG FEATURE
 * </pre>
 */
@ApiModel(value = "UserProfileApiForm", description = "UserProfileApiForm")
public class UserProfileApiForm {
  public static Map<String, Object> createMap(UserProfileApiForm vo){
    Map<String, Object> params = new HashMap<>();
    params.put("userName", vo.getUserName());
    params.put("imgGrpId", vo.getImgGrpId());
    return params;
  }

  private String userName;
  private String imgGrpId;

  public String getUserName() {
    return userName;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }

  public String getImgGrpId() {
    return imgGrpId;
  }

  public void setImgGrpId(String imgGrpId) {
    this.imgGrpId = imgGrpId;
  }

}
