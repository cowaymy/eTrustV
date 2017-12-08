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

import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.model.LoginSubAuthVO;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loginService")
public class LoginServiceImpl implements LoginService {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginServiceImpl.class);

	@Autowired
	private LoginMapper loginMapper;

	@Override
	public LoginVO getLoginInfo(Map<String, Object> params) {
		LOGGER.debug("loginInfo");
		LoginVO loginVO = loginMapper.selectLoginInfo(params);

		if (loginVO != null) {
			addSubAuthToLoginVO(params, loginVO);
		}

		return loginVO;
	}

	@Override
	public LoginVO selectFindUserIdPop(Map<String, Object> params) {
		LOGGER.debug("findLoginInfo");
		LoginVO loginVO = loginMapper.selectFindUserIdPop(params);
		return loginVO;
	}

	@Override
	public LoginVO loginByMobile(Map<String, Object> params) {
		LOGGER.debug("loginByMobile");
		// TODO : deviceImei 체크 필요.
		LoginVO loginVO = getLoginInfo(params);
		return loginVO;
	}

	@Override
	public LoginVO loginByCallcenter(Map<String, Object> params) {
		LOGGER.debug("loginByCallcenter");
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);

		if (loginVO != null) {
			addSubAuthToLoginVO(params, loginVO);
		}
		return loginVO;
	}

	private void addSubAuthToLoginVO(Map<String, Object> params, LoginVO loginVO) {
		params.put("userId", loginVO.getUserId());
		List<LoginSubAuthVO> loginSubAuthVOList = loginMapper.selectSubAuthInfo(params);
		loginVO.setLoginSubAuthVOList(loginSubAuthVOList);
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

	@Override
	public int updatePassWord(Map<String, Object> params, Integer crtUserId) {
		int saveCnt = 0;

		// for (Object obj : addList)
		// {
		params.put("crtUserId", crtUserId);
		params.put("updUserId", crtUserId);

		LOGGER.debug(" >>>>> insertUserExceptAuthMapping ");
		LOGGER.debug(" Login_UserId : {}", params.get("newUserIdTxt"));

		// String tmpStr = (String) ((Map<String, Object>) obj).get("hidden");
		// ((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );

		saveCnt++;

		loginMapper.updatePassWord(params);
		// }

		return saveCnt;
	}

	@Override
	public int updateUserSetting(Map<String, Object> params, Integer crtUserId) {
		int saveCnt = 0;

		params.put("crtUserId", crtUserId);
		params.put("updUserId", crtUserId);

		LOGGER.debug(" >>>>> updateUserSetting ");
		LOGGER.debug(" Login_UserId : {}", params.get("newUserIdTxt"));

		saveCnt = loginMapper.updateUserSetting(params);

		return saveCnt;
	}

	@Override
	public List<EgovMap> selectSecureResnList(Map<String, Object> params) {
		return loginMapper.selectSecureResnList(params);
	}

	@Override
	public void saveLoginHistory(LoginHistory loginHistory) {
		loginMapper.insertLoginHistory(loginHistory);
	}

}
