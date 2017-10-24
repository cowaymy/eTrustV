package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface RoleManagementService {

	List<EgovMap> getRootRoles();

	List<EgovMap> getRolesByParentRole(int parentRole);

	List<EgovMap> getRoleManagementList(Map<String, Object> params);

	List<EgovMap> getUsersByRoleId(Map<String, Object> params);

	void saveRole(Map<String, Object> params, int userId);

	void updateActivateRole(int roleId, int userId);

	void updateDeactivateRole(int roleId, int userId);

	void updateRole(Map<String, Object> params, int userId);
}
