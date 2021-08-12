package com.coway.trust.biz.common.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.UserAddAuthService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("userAddAuthService")
public class UserAddAuthServiceImpl implements UserAddAuthService {

	@Autowired
	private UserAddAuthMapper userAddAuthMapper;

	public List<EgovMap> selectUserAddAuthList(Map<String, Object> params,SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}

		params.put("updUserId", loginId); // session Id Setting

		return userAddAuthMapper.selectUserAddAuthList(params);
	}

	@SuppressWarnings("unchecked")
	public void saveUserAddAuthList(Map<String, ArrayList<Object>> params,SessionVO sessionVO)  {
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> deleteList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList

		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		try{

    		for (Object list : addList){
    			Map<String, Object> map = (Map<String, Object>) list;
    			map.put("updUserId", loginId);
    			map.put("crtUserId", loginId);

    			userAddAuthMapper.insertUserAddAuthList(map);
    		}

    		for (Object list : updateList){
    			Map<String, Object> map = (Map<String, Object>) list;
    			map.put("updUserId", loginId);
    			map.put("crtUserId", loginId);
    			userAddAuthMapper.updateUserAddAuthList(map);
    		}

    		for (Object list : deleteList){
    			Map<String, Object> map = (Map<String, Object>) list;
    			map.put("updUserId", loginId);
    			map.put("crtUserId", loginId);
    			userAddAuthMapper.deleteUserAddAuthList(map);
    		}

		}catch(Exception e){
			if("ORA-00001".indexOf(e.toString())>0){

			}else{
				throw e;
			}
		}
	}

	public List<EgovMap> selectCommonCodeList(Map<String, Object> params) {
		return userAddAuthMapper.selectCommonCodeList(params);
	}
}
