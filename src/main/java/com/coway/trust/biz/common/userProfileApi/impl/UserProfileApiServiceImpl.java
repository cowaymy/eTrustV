package com.coway.trust.biz.common.userProfileApi.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiDto;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiForm;
import com.coway.trust.biz.common.userProfileApi.UserProfileApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : UserProfileApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 01.   KR-JAEMJAEM:)   First creation
 * 2023. 03. 30    MY-ONGHC         ADD BUSINESS CARD FEATURE
 * 2023. 09. 05    MY-ONGHC         ADD E-TAG FEATURE
 * </pre>
 */
@Service("UserProfileApiService")
public class UserProfileApiServiceImpl extends EgovAbstractServiceImpl implements UserProfileApiService {

  @Resource(name = "UserProfileApiMapper")
  private UserProfileApiMapper userProfileApiMapper;

  @Override
  public UserProfileApiDto selectUserProfile(UserProfileApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getUserName())) {
      throw new ApplicationException(AppConstants.FAIL, "User name value does not exist.");
    }
    EgovMap selectUserProfile = userProfileApiMapper.selectUserProfile(UserProfileApiForm.createMap(param));
    UserProfileApiDto rtn = new UserProfileApiDto();
    if (MapUtils.isNotEmpty(selectUserProfile)) {
      return rtn.create(selectUserProfile);
    }
    return rtn;
  }

  @Override
  public UserProfileApiDto selectUserRole(UserProfileApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getUserName())) {
      throw new ApplicationException(AppConstants.FAIL, "User name value does not exist.");
    }
    EgovMap selectUserProfile = userProfileApiMapper.selectUserRole(UserProfileApiForm.createMap(param));
    UserProfileApiDto rtn = new UserProfileApiDto();
    if (MapUtils.isNotEmpty(selectUserProfile)) {
      return rtn.create(selectUserProfile);
    }
    return rtn;
  }

  @Override
  public UserProfileApiDto selectProfileImg(UserProfileApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getImgGrpId())) {
      throw new ApplicationException(AppConstants.FAIL, "Image Group ID value does not exist.");
    }
    EgovMap selectProfileImg = userProfileApiMapper.selectProfileImg(UserProfileApiForm.createMap(param));
    UserProfileApiDto rtn = new UserProfileApiDto();
    if (MapUtils.isNotEmpty(selectProfileImg)) {
      return rtn.create(selectProfileImg);
    }
    return rtn;
  }

  @Override
  public boolean updateParticular(Map<String, Object> params) throws Exception {
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>IN 1");
    if (null == params) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>IN  " + params.get( "userName" ));
    if (CommonUtils.isEmpty(params.get( "userName" ))) {
      throw new ApplicationException(AppConstants.FAIL, "User Name value does not exist.");
    }
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>IN 3");
    if (CommonUtils.isEmpty(params.get( "data" ))) {
      throw new ApplicationException(AppConstants.FAIL, "Data value does not exist.");
    }
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>IN 4");
    int count = userProfileApiMapper.updateParticular(params);
    System.out.println(">>>>>>>>>>>>>>>>> " + count);

    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

}
