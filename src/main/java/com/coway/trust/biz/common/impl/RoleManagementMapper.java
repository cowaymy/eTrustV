package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("roleManagementMapper")
public interface RoleManagementMapper {

	List<EgovMap> selectRolesByParentRole(int parentRole);

	List<EgovMap> selectRoleManagementList(Map<String, Object> params);
}
