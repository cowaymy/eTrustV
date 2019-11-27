package com.coway.trust.biz.common.userProfileApi;

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
 * </pre>
 */
public interface UserProfileApiService {



	EgovMap selectUserProfile(UserProfileApiForm param) throws Exception;
}
