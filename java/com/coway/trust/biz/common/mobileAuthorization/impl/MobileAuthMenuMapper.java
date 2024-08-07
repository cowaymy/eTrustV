/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.common.mobileAuthorization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileAuthMenuMapper.java
 * @Description : MobileAuthMenuMapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 30.   KR-HAN        First creation
 * </pre>
 */
@Mapper("mobileAuthMenuMapper")
public interface MobileAuthMenuMapper {

	 /**
	 * selectMobileRoleAuthMappingAdjustList
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileRoleAuthMappingAdjustList(Map<String, Object> params);

	 /**
	 * insertMobileMenuAuthRoleMapping
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	int insertMobileMenuAuthRoleMapping(Map<String, Object> params);

//	int updateMobileMenu(Map<String, Object> params);

	 /**
	 * deleteMobileMenuAuthRoleMapping
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	int deleteMobileMenuAuthRoleMapping(Map<String, Object> params);

	 /**
	 * deleteMobileMenuMapping
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	int deleteMobileMenuMapping(Map<String, Object> params);

	int saveMobileMenuAuthAllRoleMapping(Map<String, Object> params);
}
