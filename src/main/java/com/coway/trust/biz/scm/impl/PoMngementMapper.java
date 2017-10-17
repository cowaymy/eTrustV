package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("POMngementMapper")
public interface PoMngementMapper 
{
	/* PO Management */
	List<EgovMap> selectScmPrePoItemView(Map<String, Object> params);
	List<EgovMap> selectScmPoView(Map<String, Object> params);


	
	void updatePoManagement(Map<String, Object> params);
}
