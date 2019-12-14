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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.mobileAuthorization.MobileAuthMenuService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("mobileAuthMenuService")
public class MobileAuthMenuServiceImpl implements MobileAuthMenuService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileAuthMenuServiceImpl.class);

	@Resource(name = "mobileAuthMenuMapper")
	private MobileAuthMenuMapper mobileAuthMenuMapper;

	@Resource(name = "mobileMenuMapper")
	private MobileMenuMapper mobileMenuMapper;


	@Override
	public List<EgovMap> selectMobileRoleAuthMappingAdjustList(Map<String, Object> params) {
		return mobileAuthMenuMapper.selectMobileRoleAuthMappingAdjustList(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public int saveMobileMenuAuthRoleMapping(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId) {
		int saveCnt = 0;

		// insert
		for (Object obj : addList) {
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveMobileMenu insertMobileMenu ");
			LOGGER.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode"));

			saveCnt++;

			mobileAuthMenuMapper.insertMobileMenuAuthRoleMapping((Map<String, Object>) obj);
		}

		// update
//		for (Object obj : udtList) {
//			((Map<String, Object>) obj).put("crtUserId", userId);
//			((Map<String, Object>) obj).put("updUserId", userId);
//
//			LOGGER.debug(" >>>>> saveMobileMenu updateMobileMenu ");
//			LOGGER.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode"));
//
//			saveCnt++;
//
//			mobileMenuMapper.updateMobileMenu((Map<String, Object>) obj);
//		}

		// delete
		for (Object obj : delList) {
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveMobileMenu deleteMobileMenu ");
			LOGGER.debug(" menuId : {}", ((Map<String, Object>) obj).get("menuCode"));

			saveCnt++;

			mobileAuthMenuMapper.deleteMobileMenuAuthRoleMapping((Map<String, Object>) obj);
		}

		return saveCnt;
	}

	@SuppressWarnings("unchecked")
	@Override
	public int saveMobileMenuAuthAllRoleMapping(Map<String, Object> params, Integer userId) {
		int saveCnt = 0;

		Map map = new HashMap<String, Object>();

		map.put("authCode", params.get("authCode"));
		map.put("crtUserId", userId);
		map.put("updUserId", userId);

		LOGGER.debug(" >>>>> saveMobileMenu insertMobileMenu ");

		mobileAuthMenuMapper.saveMobileMenuAuthAllRoleMapping(map);

		return saveCnt;
	}

	@Override
	public List<EgovMap> selectMobileMenuAuthMenuList(Map<String, Object> params) {

		params.put("useYn", "Y");

		return mobileMenuMapper.selectMobileMenuList(params);
	}
}
