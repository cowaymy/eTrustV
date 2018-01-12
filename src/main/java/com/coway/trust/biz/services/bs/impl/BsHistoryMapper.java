package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("bsHistoryMapper")
public interface BsHistoryMapper {
	
	List<EgovMap> selectOrderList(Map<String, Object> params);
	
	int selectFilterCnt(Map<String, Object> params);
	
	List<EgovMap> filterInfo(Map<String, Object> params);
	
	List<EgovMap> filterTree(Map<String, Object> params);
}
