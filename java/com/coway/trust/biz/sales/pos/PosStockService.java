package com.coway.trust.biz.sales.pos;

import java.text.ParseException;


import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PosStockService {


	Map<String, Object> insertPosStock(Map<String, Object> params) throws Exception;
	Map<String, Object> insertTransPosStock(Map<String, Object> params) throws Exception;
	Map<String, Object> updateRecivedPosStock(Map<String, Object> params) throws Exception;
	Map<String, Object> updateAdjPosStock(Map<String, Object> params) throws Exception;

	Map<String, Object> updateApprovalPosStock(Map<String, Object> params) throws Exception;






	EgovMap  selectPosStockMgmtViewInfo(Map<String, Object> params)throws Exception;
	EgovMap  selectItemInvtQty(Map<String, Object> params)throws Exception;


	List<EgovMap> selectPosStockMgmtList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPosStockMgmtDetailsList(Map<String, Object> params) throws Exception;

	List<EgovMap>  selectPosStockMgmtViewList(Map<String, Object> params)throws Exception;

	List<EgovMap>  selectPosItmList(Map<String, Object> params)throws Exception;


}
