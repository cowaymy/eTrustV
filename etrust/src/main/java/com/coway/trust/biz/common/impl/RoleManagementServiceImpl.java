package com.coway.trust.biz.common.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.RoleManagementService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("roleManagementService")
public class RoleManagementServiceImpl implements RoleManagementService {

	@Autowired
	private RoleManagementMapper roleManagementMapper;

	@Override
	public List<EgovMap> getRootRoles() {
		return this.getRolesByParentRole(0);
	}

	@Override
	public List<EgovMap> getRolesByParentRole(int parentRole) {
		return roleManagementMapper.selectRolesByParentRole(parentRole);
	}

	@Override
	public List<EgovMap> getRoleManagementList(Map<String, Object> params) {
		return roleManagementMapper.selectRoleManagementList(params);
	}

	@Override
	public List<EgovMap> getUsersByRoleId(Map<String, Object> params) {
		return roleManagementMapper.selectUsersByRoleId(params);
	}

	@Override
	public void saveRole(Map<String, Object> params, int userId) {
		params.put("userId", userId);
		roleManagementMapper.insertRole(params);
	}

	@Override
	public void updateActivateRole(int roleId, int userId) {
		Map<String, Object> params = new HashMap<>();
		params.put("roleId", roleId);
		params.put("userId", userId);
		roleManagementMapper.updateActivateRole(params);
	}

	@Override
	public void updateDeactivateRole(int roleId, int userId) {
		Map<String, Object> params = new HashMap<>();
		params.put("roleId", roleId);
		params.put("userId", userId);
		roleManagementMapper.updateDeactivateRole(params);
	}

	@Override
	public void updateRole(Map<String, Object> params, int userId) {
		params.put("userId", userId);
		roleManagementMapper.updateRole(params);
	}
}
