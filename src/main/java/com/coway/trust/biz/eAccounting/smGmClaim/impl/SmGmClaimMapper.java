package com.coway.trust.biz.eAccounting.smGmClaim.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("smGmClaimMapper")
public interface SmGmClaimMapper {
	
	List<EgovMap> selectSmGmClaimList(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeSmGmClaimFlag();
	
	String selectNextClmNo();
	
	void insertSmGmClaimExp(Map<String, Object> params);
	
	int selectNextClmSeq(String clmNo);
	
	void insertSmGmClaimExpItem(Map<String, Object> params);
	
	void insertSmGmClaimExpMileage(Map<String, Object> params);
	
	List<EgovMap> selectSmGmClaimItems(String clmNo);
	
	EgovMap selectSmGmClaimInfo(Map<String, Object> params);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	void updateSmGmClaimExp(Map<String, Object> params);
	
	void updateSmGmClaimExpItem(Map<String, Object> params);
	
	void updateSmGmClaimExpMileage(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);
	
	void updateAppvPrcssNo(Map<String, Object> params);
	
	void deleteSmGmClaimExpItem(Map<String, Object> params);
	
	void deleteSmGmClaimExpMileage(Map<String, Object> params);
	
	void updateSmGmClaimExpTotAmt(Map<String, Object> params);
	
	List<EgovMap> selectSmGmClaimItemGrp(Map<String, Object> params);

}
