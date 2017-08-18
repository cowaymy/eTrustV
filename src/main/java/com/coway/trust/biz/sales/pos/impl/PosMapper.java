package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posMapper")
public interface PosMapper {

	List<EgovMap> selectWhList();
	
	List<EgovMap> selectPosJsonList(Map<String, Object> params);
	
	EgovMap selectPosViewPurchaseInfo(Map<String, Object> params);
	
	List<EgovMap> selectPosDetailJsonList(Map<String, Object> params);
	
	EgovMap selectPosViewPayInfo(Map<String, Object> params);
	
	List<EgovMap> selectPosPaymentJsonList(Map<String, Object> params);
}
