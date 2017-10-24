package com.coway.trust.biz.eAccounting.pettyCash;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PettyCashService {
	
	List<EgovMap> selectCustodianList(Map<String, Object> params);
	
	String selectUserNric(String memAccId);
	
	Map<String, Object> insertCustodian(MultipartHttpServletRequest request, Map<String, Object> params)  throws Exception;
	
	EgovMap selectCustodianInfo(Map<String, Object> params);
	
	Map<String, Object> updateCustodian(MultipartHttpServletRequest request, Map<String, Object> params)  throws Exception;
	
	void deleteCustodian(Map<String, Object> params);
	
	List<EgovMap> selectRequestList(Map<String, Object> params);
	
	Map<String, Object> insertPettyCashReqst(MultipartHttpServletRequest request, Map<String, Object> params)  throws Exception;
	
	void insertApproveManagement(Map<String, Object> params);
	
	EgovMap selectRequestInfo(Map<String, Object> params);
	
}
