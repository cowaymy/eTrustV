package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplyPlanManagementService
{
	//	Supply Plan Management
	List<EgovMap> selectSupplyPlanPsi1(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanHeader(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanInfo(Map<String, Object> params);
	List<EgovMap> selectSupplyPlanList(Map<String, Object> params);
	List<EgovMap> selectGetPoCntTargetCnt(Map<String, Object> params);
	int insertSupplyPlanMaster(Map<String, Object> params, SessionVO sessionVO);
	void deleteSupplyPlanMaster(Map<String, Object> params, SessionVO sessionVO);
	int updateSupplyPlanDetail(List<Object> updList, SessionVO sessionVO);
	int updateSupplyPlanMaster(Map<String, Object> params, SessionVO sessionVO);
	
	//	Supply Plan Summary View
	List<EgovMap> selectSupplyPlanSummaryList(Map<String, Object> params);
	
	//List<EgovMap> selectTotalSplitInfo(Map<String, Object> params);
	//int insertSupplyPlanDetail(Map<String, Object> params, SessionVO sessionVO);
}