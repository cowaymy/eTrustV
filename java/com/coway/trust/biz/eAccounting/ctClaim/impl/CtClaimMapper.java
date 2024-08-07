package com.coway.trust.biz.eAccounting.ctClaim.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ctClaimMapper")
public interface CtClaimMapper {
	
	List<EgovMap> selectCtClaimList(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeCtClaimFlag();
	
	String selectNextClmNo();
	
	void insertCtClaimExp(Map<String, Object> params);
	
	int selectNextClmSeq(String clmNo);
	
	void insertCtClaimExpItem(Map<String, Object> params);
	
	void insertCtClaimExpMileage(Map<String, Object> params);
	
	List<EgovMap> selectCtClaimItems(String clmNo);
	
	EgovMap selectCtClaimInfo(Map<String, Object> params);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	void updateCtClaimExp(Map<String, Object> params);
	
	void updateCtClaimExpItem(Map<String, Object> params);
	
	void updateCtClaimExpMileage(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);
	
	void updateAppvPrcssNo(Map<String, Object> params);
	
	void deleteCtClaimExpItem(Map<String, Object> params);
	
	void deleteCtClaimExpMileage(Map<String, Object> params);
	
	void updateCtClaimExpTotAmt(Map<String, Object> params);
	
	List<EgovMap> selectCtClaimItemGrp(Map<String, Object> params);
}
