package com.coway.trust.biz.homecare.po;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcSettlementService {

	// Main Grid
	public int selectHcSettlementMainCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectHcSettlementMain(Map<String, Object> params) throws Exception;

	// Detail Grid
	public List<EgovMap> selectHcSettlementSub(Map<String, Object> params) throws Exception;

	// SAVE
	public int multiHcSettlement(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// Confirm
	public int confirmHcSettlement(Map<String, Object> params, SessionVO sessionVO) throws Exception;
}