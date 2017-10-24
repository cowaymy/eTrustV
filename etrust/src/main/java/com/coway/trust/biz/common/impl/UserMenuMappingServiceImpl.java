package com.coway.trust.biz.common.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.UserMenuMappingService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("userMenuMappingService")
public class UserMenuMappingServiceImpl implements UserMenuMappingService {

	@Autowired
	private UserMenuMappingMapper userMenuMappingMapper;

	@Override
	public List<EgovMap> selectUserList(Map<String, Object> params, SessionVO sessionVO) {
		params.put("updUserId", sessionVO.getUserId()); // session Id Setting

		return userMenuMappingMapper.selectUserList(params);
	}

	@Override
	public List<EgovMap> selectUserMenuMappingList(Map<String, Object> params,SessionVO sessionVO) {
		params.put("updUserId", sessionVO.getUserId()); // session Id Setting

		return userMenuMappingMapper.selectUserMenuMappingList(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	@CacheEvict(value = AppConstants.LEFT_MENU_CACHE, allEntries = true)
	public void saveUserMenuMappingList(Map<String, ArrayList<Object>> params,SessionVO sessionVO) {
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList

		int loginId = sessionVO.getUserId();

		for (Object list : updateList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("updUserId", loginId);
			map.put("crtUserId", loginId);
			userMenuMappingMapper.updateUserMenuMapping(map);
		}
	}
}
