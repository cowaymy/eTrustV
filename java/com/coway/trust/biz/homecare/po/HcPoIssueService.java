package com.coway.trust.biz.homecare.po;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcPoIssueService {

	// CDC 조회
	public List<EgovMap> selectCdcList() throws Exception;

	// main List 조회
	public int selectHcPoIssueMainListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectHcPoIssueMainList(Map<String, Object> params) throws Exception;

	// sub List 조회
	public List<EgovMap> selectHcPoIssueSubList(Map<String, Object> params) throws Exception;

	// save
	public int multiHcPoIssue(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// Issue
	public int multiIssueHcPoIssue(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// approval / denial
	public int multiApprovalHcPoIssue(Map<String, Object> params, SessionVO sessionVO) throws Exception;

}
