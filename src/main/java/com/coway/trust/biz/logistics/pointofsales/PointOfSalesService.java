package com.coway.trust.biz.logistics.pointofsales;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PointOfSalesService {

	List<EgovMap> PosSearchList(Map<String, Object> params);
	
	List<EgovMap> posItemList(Map<String, Object> params);
	
	List<EgovMap> selectTypeList(Map<String, Object> params);
	
	List<EgovMap>  selectPointOfSalesSerial(Map<String, Object> params);
	
	//List<EgovMap>  selectPosReqNoList(Map<String, Object> params);
	
	String insertPosInfo(Map<String, Object> params);
	
	String  insertGiInfo(Map<String, Object> params);
	
	Map<String, Object> PosDataDetail(String param);
	
	List<EgovMap> selectSerial(Map<String, Object> params);
	
	void insertStockBooking(Map<String, Object> params);
	
	List<EgovMap> selectMaterialDocList(Map<String, Object> params);
	
	int selectOtherReqChk(Map<String, Object> params);
		
}
