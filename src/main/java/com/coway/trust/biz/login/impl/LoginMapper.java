package com.coway.trust.biz.login.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.cmmn.model.LoginSubAuthVO;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("loginMapper")
public interface LoginMapper {
	LoginVO selectLoginInfo(Map<String, Object> params);

	/**
	 * [WARNNING] : use only callcenter ........
	 *
	 * @param params
	 * @return
	 */
	LoginVO selectLoginInfoById(Map<String, Object> params);

	List<LoginSubAuthVO> selectSubAuthInfo(Map<String, Object> params);

	LoginVO selectFindUserIdPop(Map<String, Object> params);

	int updatePassWord(Map<String, Object> params);

	int updateUserSetting(Map<String, Object> params);

	void insertLoginHistory(LoginHistory loginHistory);

	List<EgovMap> selectLanguages();

	List<EgovMap> selectSecureResnList(Map<String, Object> params);

	EgovMap selectUserByUserName(String userName);

	EgovMap checkByPass(Map<String, Object> params);

	LoginVO getAplcntInfo(Map<String, Object> params);
}
