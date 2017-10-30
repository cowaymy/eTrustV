package com.coway.trust.biz.sales.pos;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PosService {

	List<EgovMap> selectPosModuleCodeList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectStatusCodeList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectWhBrnchList() throws Exception;
	
	EgovMap selectWarehouse(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectPSMItmTypeList(Map<String, Object> params)throws Exception;
	
	List<EgovMap> selectPIItmTypeList()throws Exception;
	
	List<EgovMap> selectPIItmList(Map<String, Object> params)throws Exception;
	
	List<EgovMap> selectPSMItmList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> chkStockList(Map<String, Object> params) throws Exception;
	
	EgovMap getMemCode(Map<String, Object> params)throws Exception;
	
	List<EgovMap> getReasonCodeList(Map<String, Object> params)throws Exception;
	
	List<EgovMap> getFilterSerialNum(Map<String, Object> params)throws Exception;
	
	List<EgovMap> getConfirmFilterListAjax(Map<String, Object> params) throws Exception;
	
	Map<String, Object> insertPos(Map<String, Object> params) throws Exception;
	
	List<EgovMap> getUploadMemList (Map<String, Object> params) throws Exception;
	
	EgovMap chkReveralBeforeReversal (Map<String, Object> params) throws Exception;
	
	EgovMap posReversalDetail(Map<String, Object> params) throws Exception;
	
	List<EgovMap> getPosDetailList(Map<String, Object> params)throws Exception;
	
	EgovMap insertPosReversal(Map<String, Object> params) throws Exception;
}
