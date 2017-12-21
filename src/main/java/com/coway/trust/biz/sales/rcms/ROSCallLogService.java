package com.coway.trust.biz.sales.rcms;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ROSCallLogService {

	List<EgovMap> getAppTypeList(Map<String, Object> params)throws Exception;
	
	List<EgovMap> selectRosCallLogList(Map<String, Object> params)throws Exception;
	
	EgovMap getRentInstallLatestNo(Map<String, Object> params) throws Exception;
	
	EgovMap getRentalStatus(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectROSSMSCodyTicketLogList(Map<String, Object> params)throws Exception;
	
	List<EgovMap> getReasonCodeList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> getFeedbackCodeList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectROSCallLogBillGroupOrderCnt(Map<String, Object> params)throws Exception;
	
	EgovMap getOrderServiceMemberViewByOrderID(Map<String, Object> params)throws Exception;
	
	boolean insertNewRosCall(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectOrderRemList(Map<String, Object> params) throws Exception;
	
	Map<String, Object> uploadOrdRem(Map<String, Object> params) throws Exception;
	
	EgovMap selectBatchViewInfo(Map<String, Object> params)throws Exception;
}
