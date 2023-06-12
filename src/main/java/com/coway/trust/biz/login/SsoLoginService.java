package com.coway.trust.biz.login;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SsoLoginService {

	Map<String, Object> ssoCreateUser(Map<String, Object> params);
	Map<String, Object> ssoUpdateUserStatus(Map<String, Object> params);
	Map<String, Object> ssoDeleteUserStatus(Map<String, Object> params);
	Map<String, Object> ssoUpdateUserPassword(Map<String, Object> params);
	Map<String, Object> ssoUpdateUserInfo(Map<String, Object> params);

	LoginVO selectSSOcredential(Map<String, Object> params);
	Map<String, Object> getAdminAccessToken(Map<String, Object> params);
	Map<String, Object> userCreation(Map<String, Object> params);
	Map<String, Object> getUserId(Map<String, Object> params);
	Map<String, Object> userResetPassword(Map<String, Object> params);
	Map<String, Object> userActivateDeactivate(Map<String, Object> params);
	Map<String, Object> userDelete(Map<String, Object> params);
	Map<String, Object> userInfoUpdate(Map<String, Object> params);

	void rtnRespMsg(Map<String, Object> params);
}
