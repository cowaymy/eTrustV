package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MyMenuService {

	List<EgovMap> selectMyMenuList(Map<String, Object> params, SessionVO sessionVO);
	
	void saveMyMenu(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
	
	List<EgovMap> selectMyMenuProgrmList(Map<String, Object> params, SessionVO sessionVO);
	
	void saveMyMenuProgrm(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
	
	List<EgovMap> selectMenuPop(Map<String, Object> params);
}
