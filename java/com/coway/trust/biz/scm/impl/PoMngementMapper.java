package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("POMngementMapper")
public interface PoMngementMapper 
{
	/* ODT Status Viewer */
	List<EgovMap> selectOtdStatusView(Map<String, Object> params);
	List<EgovMap> selectOtdSOGIDetailPop(Map<String, Object> params);
	List<EgovMap> selectOtdSOPPDetailPop(Map<String, Object> params);
	
	/* Interface */
	List<EgovMap> selectInterfaceList(Map<String, Object> params);
	List<EgovMap> selectInterfaceLastState(Map<String, Object> params);
	
	/* PO Approval */
	List<EgovMap> selectPoApprovalSummary(Map<String, Object> params);
	List<EgovMap> selectPoApprovalSummaryHidden(Map<String, Object> params);
	List<EgovMap> selectPoApprovalMainList(Map<String, Object> params);
	int updatePoApprovalDetail(Map<String, Object> params);
	String callSpPoApprovalINF155(Map<String, Object> params);	
	
	/* PO Management - PO Issue */
	List<EgovMap> selectScmPrePoItemView(Map<String, Object> params);
	List<EgovMap> selectScmPoView(Map<String, Object> params);
	List<EgovMap> selectScmPoStatusCnt(Map<String, Object> params); 
	List<EgovMap> selectPoRightMove(Map<String, Object> params); 
	EgovMap selectPOIssueNewPoNo(Map<String, Object> params); 
	
	int updatePoIssueStatus(Map<String, Object> params);
	int updatePOIssuItem(Map<String, Object> params);
	int insertPOIssueDetail(Map<String, Object> params);
	int insertPOIssueMaster(Map<String, Object> params);
	int deletePODetail(Map<String, Object> params);
	int deletePOMaster(Map<String, Object> params);
	int updatePOQtinty(Map<String, Object> params);
}
