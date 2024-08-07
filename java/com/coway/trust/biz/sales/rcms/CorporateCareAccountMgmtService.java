package com.coway.trust.biz.sales.rcms;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CorporateCareAccountMgmtService {

	List<EgovMap> selectPortalList(Map<String, Object> params)throws Exception;

	List<EgovMap> selectPortalNameList(Map<String, Object> params)throws Exception;

	List<EgovMap> selectPortalStusList()throws Exception;

	List<EgovMap> selectPICList()throws Exception;

	List<EgovMap> selectCareAccMgmtList(Map<String, Object> params)throws Exception;

	EgovMap selectPortalDetails(Map<String, Object> params);

	void addPortal(Map<String, Object> params);

	void updatePortal(Map<String, Object> params);

	String getNextDocNo(String prefixNo, String docNo);

	EgovMap getDocNo(String docNoId);

	void updatePortalStatus(Map<String, Object> params);
}
