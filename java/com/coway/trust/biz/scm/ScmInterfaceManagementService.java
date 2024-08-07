package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ScmInterfaceManagementService
{
	/*
	 * SCM Interface
	 */
	//	Search & etc
	List<EgovMap> selectInterfaceList(Map<String, Object> params);
	int scmIf155(List<Map<String, Object>> chkList, SessionVO sessionVO);
	int insertSCM0039M(List<Map<String, Object>> chkList, SessionVO sessionVO);
	
	//	log
	void insertLog(Map<String, Object> params);
	
	//	Procedure Batch
	void executeProcedureBatch(Map<String, Object> params);
	
	//	FTP Supply Plan RTP Batch
	List<EgovMap> selectTodayWeekTh(Map<String, Object> params);
	List<EgovMap> selectScmIfSeq(Map<String, Object> params);
	void deleteSupplyPlanRtp(Map<String, Object> params);
	void mergeSupplyPlanRtp(Map<String, Object> params);
	void updateSupplyPlanRtp(Map<String, Object> params);
	void testSupplyPlanRtp(Map<String, Object> params);
	
	//	FTP OTD SO Batch
	void updateOtdSo(Map<String, Object> params);
	
	//	FTP OTD PP Batch
	void deleteOtdPp(Map<String, Object> params);
	void mergeOtdPp(Map<String, Object> params);
	
	//	FTP OTD GI Batch
	void mergeOtdGi(Map<String, Object> params);
}