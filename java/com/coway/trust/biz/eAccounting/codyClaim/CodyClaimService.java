package com.coway.trust.biz.eAccounting.codyClaim;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CodyClaimService {
	
	List<EgovMap> selectCodyClaimList(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeCodyClaimFlag();
	
	void insertCodyClaimExp(Map<String, Object> params);
	
	List<EgovMap> selectCodyClaimItems(String clmNo);
	
	EgovMap selectCodyClaimInfo(Map<String, Object> params);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	void updateCodyClaimExp(Map<String, Object> params);
	
	void insertApproveManagement(Map<String, Object> params);
	
	void deleteCodyClaimExpItem(Map<String, Object> params);
	
	void deleteCodyClaimExpMileage(Map<String, Object> params);
	
	void updateCodyClaimExpTotAmt(Map<String, Object> params);
	
	List<EgovMap> selectCodyClaimItemGrp(Map<String, Object> params);
	
	EgovMap selectSchemaOfMemType(Map<String, Object> params);
}
