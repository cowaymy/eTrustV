package com.coway.trust.biz.common.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AuthMenuMappingService;
import com.coway.trust.biz.common.MyMenuService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("authMenuMappingService")
public class AuthMenuMappingServiceImpl implements AuthMenuMappingService {
	
	@Autowired
	private AuthMenuMappingMapper authMenuMappingMapper;
	
	@Override
	public List<EgovMap> selectAuthList(Map<String, Object> params, SessionVO sessionVO) { 						
		int loginId = 0;
		if(sessionVO != null){		
			loginId = sessionVO.getUserId();
		}			
		params.put("userId", loginId); // session Id Setting
		
		return authMenuMappingMapper.selectAuthList(params);
	}

	@Override
	public List<EgovMap> selectAuthMenuMappingList(Map<String, Object> params,SessionVO sessionVO) {				
		int loginId = 0;
		if(sessionVO != null){		
			loginId = sessionVO.getUserId();
		}			
		params.put("userId", loginId); // session Id Setting
		
		return authMenuMappingMapper.selectAuthMenuMappingList(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	@CacheEvict(value = AppConstants.LEFT_MENU_CACHE, allEntries = true)
	public void saveAuthMenuMappingList(Map<String, ArrayList<Object>> params,SessionVO sessionVO) {		
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList		
		
		int loginId = 0;
		if(sessionVO != null){		
			loginId = sessionVO.getUserId();
		}					
		
		for (Object list : updateList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("userId", loginId);
			authMenuMappingMapper.updateAuthMenuMapping(map);
		}
	}

	@Override
	public List<EgovMap> selectMultAuthMenuMappingList(Map<String, Object> params,SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		params.put("userId", loginId); // session Id Setting

		return authMenuMappingMapper.selectMultAuthMenuMappingList(params);
	}

	@Override
	public void saveMultAuthMenuMappingList(Map<String, Object> params,SessionVO sessionVO) {
		List<Map<String, Object>> gridList = (List<Map<String, Object>>) params.get("gridList");
		//List<Object> updateList = params.get(AppConstants.AUIGRID_ALL); 	// Get gride UpdateList

		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}

		for (int i = 0 ; i < gridList.size() ; i ++){
			Map<String, Object> map = (Map<String, Object>) gridList.get(i);
			map.put("userId", loginId);
			map.put("authCode", params.get("newAuthCode").toString());
			if(map.get("funcYn").toString().equals("Y")){
				authMenuMappingMapper.updateAuthMenuMapping(map);
			}
		}
	}
}
