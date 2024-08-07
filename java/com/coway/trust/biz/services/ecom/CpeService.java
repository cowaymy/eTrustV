package com.coway.trust.biz.services.ecom;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CpeService {

	List<EgovMap> getCpeStat(Map<String, Object> params);

	List<EgovMap> getMainDeptList();

	List<EgovMap> getSubDeptList(Map<String, Object> params);

	EgovMap getOrderId(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRequestType() throws Exception;

	List<EgovMap> getSubRequestTypeList(Map<String, Object> params);

	int selectNextCpeId();

	String selectNextCpeAppvPrcssNo();

	void insertCpeRqstApproveMgmt(Map<String, Object> params);

	List<EgovMap> selectCpeRequestList(Map<String, Object> params);

	EgovMap selectRequestInfo(Map<String, Object> params);

	List<EgovMap> selectCpeDetailList(Map<String, Object> params);

	String getApproverList(Map<String, Object> params);

	void sendNotificationEmail(Map<String, Object> params);

	void insertCpe(Map<String, Object> params);

	void updateCpe(Map<String, Object> params);

	EgovMap getOrderDscCode(String orderDscCode);

	List<EgovMap> getIssueTypeList(Map<String, Object> params);

    List<EgovMap> selectCpeHistoryDetailPop(Map<String, Object> params);

	boolean checkCpeRequestStatusActiveExist(Map<String, Object> params);
}
