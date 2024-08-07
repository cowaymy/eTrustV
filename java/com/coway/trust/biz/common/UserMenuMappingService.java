package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface UserMenuMappingService {

	List<EgovMap> selectUserList(Map<String, Object> params, SessionVO sessionVO);
			
	List<EgovMap> selectUserMenuMappingList(Map<String, Object> params, SessionVO sessionVO);
	
	void saveUserMenuMappingList(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
		
}
