/*
\ * Copyright 2008-2009 the original author or authors.
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

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.mobileAuthorization.MobileMenuService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileMenuServiceImpl.java
 * @Description : MobileMenuServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 30.   KR-HAN        First creation
 * </pre>
 */
@Service("mobileMenuService")
public class MobileMenuServiceImpl implements MobileMenuService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileMenuServiceImpl.class);

	@Resource(name = "mobileMenuMapper")
	private MobileMenuMapper mobileMenuMapper;

	@Resource(name = "mobileAuthMenuMapper")
	private MobileAuthMenuMapper mobileAuthMenuMapper;

	/**
	 * 모바일 메뉴 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.common.mobileAuthorization.MobileMenuService#selectMobileMenuList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectMobileMenuList(Map<String, Object> params) {
		return mobileMenuMapper.selectMobileMenuList(params);
	}

	/**
	 * 모바일 메뉴 저장
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param addList
	 * @param udtList
	 * @param delList
	 * @param userId
	 * @return
	 * @see com.coway.trust.biz.common.mobileAuthorization.MobileMenuService#saveMobileMenu(java.util.List, java.util.List, java.util.List, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public int saveMobileMenu(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId) {
		int saveCnt = 0;

		// insert
		for (Object obj : addList) {
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveMobileMenu insertMobileMenu ");
			LOGGER.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode"));

			saveCnt++;

			mobileMenuMapper.insertMobileMenu((Map<String, Object>) obj);
		}

		// update
		for (Object obj : udtList) {
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveMobileMenu updateMobileMenu ");
			LOGGER.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode"));

			saveCnt++;

			mobileMenuMapper.updateMobileMenu((Map<String, Object>) obj);
		}

		// delete
		for (Object obj : delList) {
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveMobileMenu deleteMobileMenu ");
			LOGGER.debug(" menuId : {}", ((Map<String, Object>) obj).get("menuCode"));

			int cnt =  mobileMenuMapper.selectUpperMobileMenuCount((Map<String, Object>) obj);

			if( cnt > 0){
				throw new ApplicationException(AppConstants.FAIL, "Connected menu exists. Can be deleted after submenu modification.");
			}
			saveCnt++;

			// 모바일 권한 삭제
			mobileAuthMenuMapper.deleteMobileMenuMapping((Map<String, Object>) obj);

			mobileMenuMapper.deleteMobileMenu((Map<String, Object>) obj);
		}

		return saveCnt;
	}

	/**
	 * 모바일 메뉴 팝업 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.common.mobileAuthorization.MobileMenuService#selectMobileMenuPopList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectMobileMenuPopList(Map<String, Object> params) {

		return mobileMenuMapper.selectMobileMenuPopList(params);
	}
}
