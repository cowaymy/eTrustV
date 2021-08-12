package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("userManagementMapper")
public interface UserManagementMapper {

	List<EgovMap> selectUserList(Map<String, Object> params);

	List<EgovMap> selectUserDetailList(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectDeptList(Map<String, Object> params);

	List<EgovMap> selectUserStatusList(Map<String, Object> params);

	List<EgovMap> selectRoleList(Map<String, Object> params);

	List<EgovMap> selectUserTypeList(Map<String, Object> params);

	List<EgovMap> selectMemberList(Map<String, Object> params);

	void saveUserManagementList(Map<String, Object> params);

	EgovMap createUserId();

	List<EgovMap> selectUserRoleList(Map<String, Object> params);

	void saveUserRoleList(Map<String, Object> params);

	List<EgovMap> getDeptList(Map<String, Object> params);

	void saveMemberDetails(Map<String, Object> params);

	void saveMemOrgDetails(Map<String, Object> params);

	int getTempStaffCodeType();

	List<EgovMap> checkSYS47(Map<String, Object> params);

	List<EgovMap> checkORG01(Map<String, Object> params);
}