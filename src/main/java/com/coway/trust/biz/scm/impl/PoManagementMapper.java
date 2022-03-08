package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("PoManagementMapper")
public interface PoManagementMapper
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
	List<EgovMap> selectGetGrYMW(Map<String, Object> params);
	void insertPoMaster(Map<String, Object> params);
	void insertPoDetail(Map<String, Object> params);
	List<EgovMap> selectGetPoNo(Map<String, Object> params);
	void updatePoMaster(Map<String, Object> params);
	void updatePoDetail(Map<String, Object> params);
	void updatePoDetailDel(Map<String, Object> params);
	void updateSupplyPlan(Map<String, Object> params);

	//	PO Approval
	List<EgovMap> selectPoSummary(Map<String, Object> params);
	List<EgovMap> selectPoApprList(Map<String, Object> params);
	void updatePoApprove(Map<String, Object> params);
}