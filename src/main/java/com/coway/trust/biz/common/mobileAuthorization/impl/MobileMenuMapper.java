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
 * @ClassName : MobileMenuMapper.java
 * @Description : MobileMenuMapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 30.   KR-HAN        First creation
 * </pre>
 */
@Mapper("mobileMenuMapper")
public interface MobileMenuMapper {

	 /**
	 * 모바일 메뉴 저장
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	int insertMobileMenu(Map<String, Object> params);

	 /**
	 * 모바일 메뉴 수정
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	int updateMobileMenu(Map<String, Object> params);

	 /**
	 * 모바일 메뉴 삭제
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	int deleteMobileMenu(Map<String, Object> params);

	 /**
	 * 모바일 메뉴 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileMenuList(Map<String, Object> params);

	 /**
	 * 모바일 메뉴 팝업 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileMenuPopList(Map<String, Object> params);

	 /**
	 * 모바일 메뉴 상위 메뉴 조회 ( 모바일 메뉴 삭제시 유효성 처리시 사용 )
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	int selectUpperMobileMenuCount(Map<String, Object> params);
}
