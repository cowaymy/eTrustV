package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AuthMenuMappingService {

	List<EgovMap> selectAuthList(Map<String, Object> params, SessionVO sessionVO);
			
	List<EgovMap> selectAuthMenuMappingList(Map<String, Object> params, SessionVO sessionVO);
	
	void saveAuthMenuMappingList(Map<String, ArrayList<Object>> params, SessionVO sessionVO);

	List<EgovMap> selectMultAuthMenuMappingList(Map<String, Object> params, SessionVO sessionVO);

	void saveMultAuthMenuMappingList(Map<String, Object> params, SessionVO sessionVO);

}
