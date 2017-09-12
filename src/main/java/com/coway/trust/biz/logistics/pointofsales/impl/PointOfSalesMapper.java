package com.coway.trust.biz.logistics.pointofsales.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("PointOfSalesMapper")
public interface PointOfSalesMapper {
	
	List<EgovMap> PosSearchList(Map<String, Object> params);

	List<EgovMap> PosItemList(Map<String, Object> params);
	
	List<EgovMap> selectPointOfSalesSerial(Map<String, Object> params);
	
	String selectPosSeq();
	
	void  insOtherReceiptHead(Map<String, Object> params);
	void  insRequestItem(Map<String, Object> params);
	void  insertSerial(Map<String, Object> params);
	void  updateReqstStus(Map<String, Object> params);


}
