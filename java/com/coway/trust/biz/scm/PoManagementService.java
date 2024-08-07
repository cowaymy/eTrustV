package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PoManagementService
{
	//	PO Issue
	List<EgovMap> selectPoStatus(Map<String, Object> params);
	List<EgovMap> selectLeadTm(Map<String, Object> params);
	List<EgovMap> selectLastWeekTh(Map<String, Object> params);
	List<EgovMap> selectSplitCnt(Map<String, Object> params);
	/*List<EgovMap> selectSplitCnt1(Map<String, Object> params);
	List<EgovMap> selectSplitCnt2(Map<String, Object> params);*/
	List<EgovMap> selectLastWeekSplitYn(Map<String, Object> params);
	/*List<EgovMap> selectLastWeekSplitYn1(Map<String, Object> params);
	List<EgovMap> selectLastWeekSplitYn2(Map<String, Object> params);*/
	List<EgovMap> selectPoCreatedList(Map<String, Object> params);
	List<EgovMap> selectPoTargetList(Map<String, Object> params);
	List<EgovMap> selectPoInfo(Map<String, Object> params);
	int insertPoMaster(Map<String, Object> params, SessionVO sessionVO);
	//int insertPoDetail(Map<String, Object> params, SessionVO sessionVO);
	int insertPoDetail(List<Map<String, Object>> addList, SessionVO sessionVO);
	List<EgovMap> selectGetPoNo(Map<String, Object> params);
	int updatePoMaster(Map<String, Object> params, SessionVO sessionVO);
	int updatePoDetail(List<Map<String, Object>> updList, SessionVO sessionVO);
	int updatePoDetailDel(List<Map<String, Object>> delList, SessionVO sessionVO);
	
	//	PO Approval
	List<EgovMap> selectPoSummary(Map<String, Object> params);
	List<EgovMap> selectPoApprList(Map<String, Object> params);
	int updatePoApprove(List<Map<String, Object>> delList, SessionVO sessionVO);
}