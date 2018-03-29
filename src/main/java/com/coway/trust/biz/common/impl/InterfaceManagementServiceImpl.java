package com.coway.trust.biz.common.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.InterfaceManagementService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("interfaceManagementService")
public class InterfaceManagementServiceImpl implements InterfaceManagementService {

	@Autowired
	private InterfaceManagementMapper interfaceManagementMapper;

	public List<EgovMap> selectInterfaceManagementList(Map<String, Object> params,SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}

		params.put("updUserId", loginId); // session Id Setting

		return interfaceManagementMapper.selectInterfaceManagementList(params);
	}

	@SuppressWarnings("unchecked")
	public void saveInterfaceManagementList(Map<String, ArrayList<Object>> params,SessionVO sessionVO)  {
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

    			interfaceManagementMapper.insertInterfaceManagementList(map);

    			interfaceManagementMapper.insertInterfaceItfKey(map);
    		}

    		for (Object list : updateList){
    			Map<String, Object> map = (Map<String, Object>) list;
    			map.put("updUserId", loginId);
    			map.put("crtUserId", loginId);
    			interfaceManagementMapper.updateInterfaceManagementList(map);
    		}

    		for (Object list : deleteList){
    			Map<String, Object> map = (Map<String, Object>) list;
    			map.put("updUserId", loginId);
    			map.put("crtUserId", loginId);
    			interfaceManagementMapper.deleteInterfaceManagementList(map);
    		}

		}catch(Exception e){
			if("ORA-00001".indexOf(e.toString())>0){

			}else{
				throw e;
			}
		}
	}
}
