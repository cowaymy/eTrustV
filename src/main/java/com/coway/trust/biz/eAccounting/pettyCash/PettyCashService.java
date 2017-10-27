package com.coway.trust.biz.eAccounting.pettyCash;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PettyCashService {
	
	List<EgovMap> selectCustodianList(Map<String, Object> params);
	
	String selectUserNric(String memAccId);
	
	void insertCustodian(Map<String, Object> params);
	
	EgovMap selectCustodianInfo(Map<String, Object> params);
	
	void updateCustodian(Map<String, Object> params);
	
	void deleteCustodian(Map<String, Object> params);
	
	List<EgovMap> selectRequestList(Map<String, Object> params);
	
	String selectNextClmNo();
	
	void insertPettyCashReqst(Map<String, Object> params);
	
	EgovMap selectRequestInfo(Map<String, Object> params);
	
	void updatePettyCashReqst(Map<String, Object> params);
	
	void insertApproveManagement(Map<String, Object> params);
	
	List<EgovMap> selectExpenseList(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodePettyCashFlag();
	
	
}
