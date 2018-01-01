package com.coway.trust.biz.common.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.common.UserManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("userManagementService")
public class UserManagementServiceImpl implements UserManagementService {

	@Autowired
	private UserManagementMapper userManagementMapper;

	@Override
	public List<EgovMap> selectUserList(Map<String, Object> params) {
		return userManagementMapper.selectUserList(params);
	}

	@Override
	public List<EgovMap> selectUserDetailList(Map<String, Object> params) {
		return userManagementMapper.selectUserDetailList(params);
	}

	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		return userManagementMapper.selectBranchList(params);
	}

	@Override
	public List<EgovMap> selectDeptList(Map<String, Object> params) {
		return userManagementMapper.selectDeptList(params);
	}

	@Override
	public List<EgovMap> selectUserStatusList(Map<String, Object> params) {
		return userManagementMapper.selectUserStatusList(params);
	}

	@Override
	public List<EgovMap> selectRoleList(Map<String, Object> params) {
		return userManagementMapper.selectRoleList(params);
	}

	@Override
	public List<EgovMap> selectUserTypeList(Map<String, Object> params) {
		return userManagementMapper.selectUserTypeList(params);
	}

	@Override
	public void saveUserManagementList(Map<String,Object> params, SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		params.put("userUpdUserId", loginId);

		EgovMap userIdMap = userManagementMapper.createUserId();
		BigDecimal newUserId = (BigDecimal) userIdMap.get("userId");

		params.put("userId", newUserId);
		userManagementMapper.saveUserManagementList(params);

		params.put("crtUserId", loginId);
		params.put("updUserId", loginId);

		userManagementMapper.saveUserRoleList(params);

	}

	@Override
	public void editUserManagementList(Map<String,Object> params, SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		params.put("userUpdUserId", loginId);

		userManagementMapper.saveUserManagementList(params);
	}

	@Override
	public List<EgovMap> selectUserRoleList(Map<String, Object> params) {
		return userManagementMapper.selectUserRoleList(params);
	}

	@Override
	public void saveUserRoleList(Map<String,Object> params, SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		params.put("crtUserId", loginId);
		params.put("updUserId", loginId);

		userManagementMapper.saveUserRoleList(params);
		userManagementMapper.saveHistoryUserRoleList(params);
	}
	
	@Override
	public List<EgovMap> selectUserNameInfoList(Map<String, Object> params) {
		return userManagementMapper.selectUserNameInfoList(params);
	}
}

