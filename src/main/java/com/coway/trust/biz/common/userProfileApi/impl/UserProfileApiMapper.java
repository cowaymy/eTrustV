package com.coway.trust.biz.common.userProfileApi.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : UserProfileApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 10. 21.   KR-JAEMJAEM:)   First creation
 * 2023. 03. 30    MY-ONGHC         ADD BUSINESS CARD FEATURE
 * 2023. 09. 05    MY-ONGHC         ADD E-TAG FEATURE
 * </pre>
 */
@Mapper("UserProfileApiMapper")
public interface UserProfileApiMapper {

  EgovMap selectUserProfile(Map<String, Object> params);

  EgovMap selectUserRole(Map<String, Object> params);

  EgovMap selectProfileImg(Map<String, Object> params);

  int updateParticular(Map<String, Object> params);

}
