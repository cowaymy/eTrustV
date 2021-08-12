package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("roleManagementMapper")
public interface RoleManagementMapper {

	List<EgovMap> selectRolesByParentRole(int parentRole);

	List<EgovMap> selectRoleManagementList(Map<String, Object> params);

	List<EgovMap> selectUsersByRoleId(Map<String, Object> params);

	void insertRole(Map<String, Object> params);

	void updateActivateRole(Map<String, Object> params);

	void updateDeactivateRole(Map<String, Object> params);

	void updateRole(Map<String, Object> params);
}
