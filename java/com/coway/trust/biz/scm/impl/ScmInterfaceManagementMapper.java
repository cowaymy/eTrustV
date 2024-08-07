package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ScmInterfaceManagementMapper")
public interface ScmInterfaceManagementMapper
{
	//	Interface
	List<EgovMap> selectInterfaceList(Map<String, Object> params);
	void doInterface(Map<String, Object> params);
	void scmIf155(Map<String, Object> params);
	void insertSCM0039M(Map<String, Object> params);
	
	//	Log
	void insertLog(Map<String, Object> params);
	
	//	Procedure Batch
	void executeSP_SCM_0039M_ITF0156(Map<String, Object> params);
	void executeSP_SCM_0039M_ITF0160(Map<String, Object> params);
	void executeSP_SCM_0050S_INSERT(Map<String, Object> params);
	void executeSP_SCM_0051S_INSERT(Map<String, Object> params);
	void executeSP_SCM_0051S_INSERT_CALL(Map<String, Object> params);
	void executeSP_SCM_0052S_INSERT(Map<String, Object> params);
	void executeSP_SCM_0053S_INSERT(Map<String, Object> params);
	void executeSP_MTH_SCM_FILTER_FRCST(Map<String, Object> params);
	
	//	FTP Supply Plan RTP Batch
	List<EgovMap> selectTodayWeekTh(Map<String, Object> params);
	List<EgovMap> selectScmIfSeq(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanRtpCommon(Map<String, Object> params);
	List<EgovMap> selectUpdateTarget(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanPsi3(Map<String, Object> params);
	void deleteSupplyPlanRtp(Map<String, Object> params);
	void updateSupplyPlanRtp(Map<String, Object> params);
	void mergeSupplyPlanRtp(Map<String, Object> params);
	
	//	FTP OTD SO Batch
	void updateOtdSo(Map<String, Object> params);
	
	//	FTP OTD PP Batch
	void deleteOtdPp(Map<String, Object> params);
	void mergeOtdPp(Map<String, Object> params);
	
	//	FTP OTD GI Batch
	void mergeOtdGi(Map<String, Object> params);
}