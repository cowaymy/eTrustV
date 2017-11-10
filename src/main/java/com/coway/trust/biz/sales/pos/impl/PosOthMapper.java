package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posOthMapper")
public interface PosOthMapper {

	
	List<EgovMap> selectPOthItmTypeList();
	
	//List<EgovMap> selectPOthItmList(Map<String, Object> params);
	
	int chkAllowSalesKeyInPrc(Map<String, Object> params);
	
	EgovMap posReversalOthDetail(Map<String, Object> params);
	
	EgovMap getAddressDetails(Map<String, Object> params);
}
