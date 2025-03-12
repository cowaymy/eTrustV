package com.coway.trust.biz.common.userProfileApi;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiDto;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : UserProfileApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 01.   KR-JAEMJAEM:)   First creation
 * 2023. 03. 30    MY-ONGHC         ADD BUSINESS CARD FEATURE
 * 2023. 09. 05    MY-ONGHC         ADD E-TAG FEATURE
 * </pre>
 */
public interface UserProfileApiService {

  UserProfileApiDto selectUserProfile(UserProfileApiForm param) throws Exception;

  UserProfileApiDto selectUserRole(UserProfileApiForm param) throws Exception;

  UserProfileApiDto selectProfileImg(UserProfileApiForm param) throws Exception;

  List<EgovMap> updateParticular(Map<String, Object> params) throws Exception;

}
