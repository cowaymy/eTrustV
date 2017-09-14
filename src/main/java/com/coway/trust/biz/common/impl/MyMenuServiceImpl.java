package com.coway.trust.biz.common.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MyMenuService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("myMenuService")
public class MyMenuServiceImpl implements MyMenuService {
	
	@Autowired
	private MyMenuMapper myMenuMapper;
	
	@Override
	public List<EgovMap> selectMyMenuList(Map<String, Object> params, SessionVO sessionVO) { 		
				
		int loginId = 0;
		if(sessionVO != null){		
			loginId = sessionVO.getUserId();
		}								
		
		params.put("userId", loginId); // session Id Setting
		
		return myMenuMapper.selectMyMenuList(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveMyMenu(Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList		
		List<Object> deleteList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList				
		
		int loginId = 0;
		if(sessionVO != null){		
			loginId = sessionVO.getUserId();
		}
		
		for (Object list : addList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("userId", loginId);
			myMenuMapper.insertMyMenu(map);			
		}
		
		for (Object list : updateList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("userId", loginId);
			myMenuMapper.updateMyMenu(map);
		}

		for (Object list : deleteList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("userId", loginId);
			myMenuMapper.deleteMyMenu(map);
		}
				
	}

	@Override
	public List<EgovMap> selectMyMenuProgrmList(Map<String, Object> params,SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){		
			loginId = sessionVO.getUserId();
		}								
		
		params.put("userId", loginId); // session Id Setting
		
		return myMenuMapper.selectMyMenuProgrmList(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	@CacheEvict(value = AppConstants.LEFT_MY_MENU_CACHE, allEntries = true)
	public void saveMyMenuProgrm(Map<String, ArrayList<Object>> params,SessionVO sessionVO) {
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList		
		List<Object> deleteList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList				
		
		int loginId = 0;
		if(sessionVO != null){		
			loginId = sessionVO.getUserId();
		}
		
		for (Object list : addList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("userId", loginId);
			myMenuMapper.insertMyMenuProgrm(map);			
		}
		
		for (Object list : updateList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("userId", loginId);
			myMenuMapper.updateMyMenuProgrm(map);
		}

		for (Object list : deleteList){
			Map<String, Object> map = (Map<String, Object>) list;
			map.put("userId", loginId);
			myMenuMapper.deleteMyMenuProgrm(map);
		}
	}

	@Override
	public List<EgovMap> selectMenuPop(Map<String, Object> params) {		
		return myMenuMapper.selectMenuPop(params);
	}
}
