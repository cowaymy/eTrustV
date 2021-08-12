package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("bsReversalMapper")
public interface BsReversalMapper {
	
	List<EgovMap> selectOrderList(Map<String, Object> params);
	
	EgovMap selectConfigBasicInfo(Map<String, Object> params);
	
	List<EgovMap> selectReverseReason();
	List<EgovMap> selectFailReason();
	
}
