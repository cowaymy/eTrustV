package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posMapper")
public interface PosMapper {

	List<EgovMap> selectWhList() throws Exception;
	
	List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception;
	
	EgovMap selectPosViewPurchaseInfo(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectPosDetailJsonList(Map<String, Object> params) throws Exception;
	
	EgovMap selectPosViewPayInfo(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectPosPaymentJsonList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectPosUserInfo(Map<String, Object> params) throws Exception;
	
	EgovMap selectPosUserWarehoseIdJson(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectPosReasonJsonList() throws Exception;
	
}
