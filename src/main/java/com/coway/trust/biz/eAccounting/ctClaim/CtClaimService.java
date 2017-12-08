package com.coway.trust.biz.eAccounting.ctClaim;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CtClaimService {
	
	List<EgovMap> selectCtClaimList(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeCtClaimFlag();
	
	void insertCtClaimExp(Map<String, Object> params);
	
	List<EgovMap> selectCtClaimItems(String clmNo);
	
	EgovMap selectCtClaimInfo(Map<String, Object> params);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	void updateCtClaimExp(Map<String, Object> params);
	
	void insertApproveManagement(Map<String, Object> params);
	
	void deleteCtClaimExpItem(Map<String, Object> params);
	
	void deleteCtClaimExpMileage(Map<String, Object> params);
	
	void updateCtClaimExpTotAmt(Map<String, Object> params);
	
	List<EgovMap> selectCtClaimItemGrp(Map<String, Object> params);
}
