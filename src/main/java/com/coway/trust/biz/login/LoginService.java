package com.coway.trust.biz.login;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LoginService {

	LoginVO getLoginInfo(Map<String, Object> params);

	void logout(Map<String, Object> params);

	LoginVO loginByMobile(Map<String, Object> params);

	void logoutByMobile(Map<String, Object> params);

	List<EgovMap> getLanguages();
}
