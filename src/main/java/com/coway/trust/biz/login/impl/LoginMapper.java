package com.coway.trust.biz.login.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("loginMapper")
public interface LoginMapper {
	LoginVO selectLoginInfo(Map<String, Object> params);

	LoginVO selectFindUserIdPop(Map<String, Object> params);

	int updatePassWord(Map<String, Object> params);

	void insertLoginHistory(LoginHistory loginHistory);

	List<EgovMap> selectLanguages();
}
