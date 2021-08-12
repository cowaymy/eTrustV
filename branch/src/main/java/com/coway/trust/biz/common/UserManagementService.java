package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface UserManagementService {

	List<EgovMap> selectUserList(Map<String, Object> params);

	List<EgovMap> selectUserDetailList(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectDeptList(Map<String, Object> params);

	List<EgovMap> selectUserStatusList(Map<String, Object> params);

	List<EgovMap> selectRoleList(Map<String, Object> params);

	List<EgovMap> selectUserTypeList(Map<String, Object> params);

	List<EgovMap> selectMemberList(Map<String, Object> params);

	void saveUserManagementList(Map<String, Object> params, SessionVO sessionVO);

	void editUserManagementList(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> selectUserRoleList(Map<String, Object> params);

	void saveUserRoleList(Map<String, Object> params, SessionVO sessionVO);

	List<EgovMap> getDeptList(Map<String, Object> params);

	ReturnMessage checkUserNric(Map<String, Object> params) throws Exception;
}