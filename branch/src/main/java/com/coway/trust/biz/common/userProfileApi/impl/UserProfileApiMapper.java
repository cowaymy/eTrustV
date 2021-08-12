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
 * </pre>
 */
@Mapper("UserProfileApiMapper")
public interface UserProfileApiMapper {



	EgovMap selectUserProfile(Map<String, Object> params);
}
