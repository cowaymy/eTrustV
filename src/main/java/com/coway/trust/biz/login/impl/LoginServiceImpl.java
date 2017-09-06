/*
 * Copyright 2008-2009 the original author or authors.
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
package com.coway.trust.biz.login.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginServiceImpl.class);

	@Autowired
	private LoginMapper loginMapper;

	@Override
	public LoginVO getLoginInfo(Map<String, Object> params) {
		LOGGER.debug("loginInfo");
		LoginVO loginVO = loginMapper.selectLoginInfo(params);
		// TODO : 로그인 이력 처리 필요...
		return loginVO;
	}

	@Override
	public LoginVO loginByMobile(Map<String, Object> params) {
		LOGGER.debug("loginByMobile");
		// TODO : deviceImei, deviceNumber 체크 필요.
		LoginVO loginVO = getLoginInfo(params);
		return loginVO;
	}

	@Override
	public void logoutByMobile(Map<String, Object> params) {
		// TODO mobile 로그 아웃시 처리사항....
		logout(params);
	}

	@Override
	public void logout(Map<String, Object> params) {
		// TODO 로그 아웃시 처리사항....

	}

	@Override
	public List<EgovMap> getLanguages() {
		return loginMapper.selectLanguages();
	}
}
