package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PoMngementService 
{
	// OTD Status Viewer
	List<EgovMap> selectOtdStatusView(Map<String, Object> params); 
	List<EgovMap> selectOtdSOGIDetailPop(Map<String, Object> params); 
	List<EgovMap> selectOtdSOPPDetailPop(Map<String, Object> params); 
	
	
	//Interface
	List<EgovMap> selectInterfaceList(Map<String, Object> params);
	List<EgovMap> selectInterfaceLastState(Map<String, Object> params);
	
	
	// PO Management - PO Approval
	List<EgovMap> selectPoApprovalSummary(Map<String, Object> params);
	List<EgovMap> selectPoApprovalSummaryHidden(Map<String, Object> params);
	List<EgovMap> selectPoApprovalMainList(Map<String, Object> params);
	List<EgovMap> selectPoRightMove(Map<String, Object> params);
	int updatePoApprovalDetail(List<Object> addList, Integer updUserId);
	
	// PO Management - PO Issue
	List<EgovMap> selectScmPrePoItemView(Map<String, Object> params);
	List<EgovMap> selectScmPoView(Map<String, Object> params);
	List<EgovMap> selectScmPoStatusCnt(Map<String, Object> params);
	EgovMap selectPOIssueNewPoNo(Map<String, Object> params);
	
	int updatePOIssuItem(List<Map<String, Object>> addList, Integer updUserId);
	int insertPOIssueDetail(List<Object> addList, Integer crtUserId);
	int deletePOMaster(List<Object> delList, Integer updUserId);
	
}
