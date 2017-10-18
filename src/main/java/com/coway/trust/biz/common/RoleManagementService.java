package com.coway.trust.biz.common;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public interface RoleManagementService {

	List<EgovMap> getRootRoles();

	List<EgovMap> getRolesByParentRole(int parentRole);

	List<EgovMap> getRoleManagementList(Map<String, Object> params);

}
