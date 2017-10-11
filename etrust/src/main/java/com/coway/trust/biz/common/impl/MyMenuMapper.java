package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("myMenuMapper")
public interface MyMenuMapper {

	List<EgovMap> selectMyMenuList(Map<String, Object> params);
	
	void insertMyMenu(Map<String, Object> params);
	
	void updateMyMenu(Map<String, Object> params);
	
	void deleteMyMenu(Map<String, Object> params);		
	
	List<EgovMap> selectMyMenuProgrmList(Map<String, Object> params);
	
	void insertMyMenuProgrm(Map<String, Object> params);
	
	void updateMyMenuProgrm(Map<String, Object> params);
	
	void deleteMyMenuProgrm(Map<String, Object> params);
	
	List<EgovMap> selectMyMenuProgrmPopupList(Map<String, Object> params);
	
	List<EgovMap> selectMenuPop(Map<String, Object> params);
	
	
}
