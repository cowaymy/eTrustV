package com.coway.trust.biz.logistics.pointofsales.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("PointOfSalesMapper")
public interface PointOfSalesMapper {

	List<EgovMap> PosSearchList(Map<String, Object> params);

	List<EgovMap> posItemList(Map<String, Object> params);

	List<EgovMap> selectTypeList(Map<String, Object> params);
	
	List<EgovMap> selectPointOfSalesSerial(Map<String, Object> params);

	String selectPosSeq();

	void insOtherReceiptHead(Map<String, Object> params);

	void insRequestItem(Map<String, Object> params);

	void insertSerial(Map<String, Object> params);

	void updateReqstStus(Map<String, Object> params);

	void GIRequestIssue(Map<String, Object> formMap);

	void GICancelIssue(Map<String, Object> formMap);

	Map<String, Object> selectPosHead(String param);

	List<EgovMap> selectPosItem(String param);

	List<EgovMap> selectPosToItem(Map<String, Object> params);

	List<EgovMap> selectSerial(Map<String, Object> params);

	void insertStockBooking(Map<String, Object> params);

	List<EgovMap> selectMaterialDocList(Map<String, Object> params);

}
