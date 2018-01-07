package com.coway.trust.biz.eAccounting.codyClaim.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("codyClaimMapper")
public interface CodyClaimMapper {
	
	List<EgovMap> selectCodyClaimList(Map<String, Object> params);
	
	List<EgovMap> selectTaxCodeCodyClaimFlag();
	
	String selectNextClmNo();
	
	void insertCodyClaimExp(Map<String, Object> params);
	
	int selectNextClmSeq(String clmNo);
	
	void insertCodyClaimExpItem(Map<String, Object> params);
	
	void insertCodyClaimExpMileage(Map<String, Object> params);
	
	List<EgovMap> selectCodyClaimItems(String clmNo);
	
	EgovMap selectCodyClaimInfo(Map<String, Object> params);
	
	List<EgovMap> selectAttachList(String atchFileGrpId);
	
	void updateCodyClaimExp(Map<String, Object> params);
	
	void updateCodyClaimExpItem(Map<String, Object> params);
	
	void updateCodyClaimExpMileage(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);
	
	void updateAppvPrcssNo(Map<String, Object> params);
	
	void deleteCodyClaimExpItem(Map<String, Object> params);
	
	void deleteCodyClaimExpMileage(Map<String, Object> params);
	
	void updateCodyClaimExpTotAmt(Map<String, Object> params);
	
	List<EgovMap> selectCodyClaimItemGrp(Map<String, Object> params);
	
	EgovMap selectSchemaOfMemType(Map<String, Object> params);
}
