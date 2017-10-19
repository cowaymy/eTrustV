package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PoMngementService 
{
	//Interface
	List<EgovMap> selectInterfaceList(Map<String, Object> params);
	List<EgovMap> selectInterfaceLastState(Map<String, Object> params);
	
	
	// PO Management - PO Issue
	List<EgovMap> selectScmPrePoItemView(Map<String, Object> params);
	List<EgovMap> selectScmPoView(Map<String, Object> params);
	List<EgovMap> selectScmPoStatusCnt(Map<String, Object> params);
	
	int updatePoManagement(List<Object> addList, Integer updUserId);
	
}
