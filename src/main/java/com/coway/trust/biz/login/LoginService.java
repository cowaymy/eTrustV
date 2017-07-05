package com.coway.trust.biz.login;

import java.util.Map;

import com.coway.trust.cmmn.model.LoginVO;

public interface LoginService {

	LoginVO getLoginInfo(Map<String, Object> params);

	void logout(Map<String, Object> params);

}
