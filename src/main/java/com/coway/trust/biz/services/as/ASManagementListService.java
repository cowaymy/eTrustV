package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ASManagementListService {

	List<EgovMap> selectASManagementList(Map<String, Object> params);
	
	List<EgovMap> getASHistoryList(Map<String, Object> params);
	 List<EgovMap> selectASDataInfo(Map<String, Object> params);

	List<EgovMap> getBSHistoryList(Map<String, Object> params);
	List<EgovMap> getBrnchId(Map<String, Object> params);
	
	EgovMap  getMemberBymemberID(Map<String, Object> params);
	
	
	EgovMap selectOrderBasicInfo(Map<String, Object> params);
	
	EgovMap getASEntryId(Map<String, Object> params);
	
	EgovMap getResultASEntryId(Map<String, Object> params);
	
	
	EgovMap selASEntryView(Map<String, Object> params);
	
	
	EgovMap getASEntryDocNo(Map<String, Object> params);
	
	EgovMap   saveASEntry(Map<String, Object> params);
	
	EgovMap   saveASInHouseEntry(Map<String, Object> params);
	 
	EgovMap   spFilterClaimCheck(Map<String, Object> params);
	
	EgovMap   updateASEntry(Map<String, Object> params);
	
	List<EgovMap> getASOrderInfo(Map<String, Object> params);

	List<EgovMap> getASEvntsInfo(Map<String, Object> params);

	List<EgovMap> getASHistoryInfo(Map<String, Object> params);
	
	List<EgovMap> getASStockPrice(Map<String, Object> params);
	
	List<EgovMap> getASFilterInfo(Map<String, Object> params);

	List<EgovMap> getASReasonCode(Map<String, Object> params);
	
	List<EgovMap> getASMember(Map<String, Object> params);
	
	List<EgovMap> getASReasonCode2(Map<String, Object> params);
	List<EgovMap> getCallLog(Map<String, Object> params);
	
	List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params);
	List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params);
	
	
	
	boolean insertASNo(Map<String, Object> params,SessionVO sessionVO);
	
	EgovMap asResult_insert (Map<String, Object> params);
	EgovMap asResult_update (Map<String, Object> params);
	int asResultBasic_update (Map<String, Object> params);
	int addASRemark (Map<String, Object> params);
	int updateAssignCT (Map<String, Object> params);
	
	

	List<EgovMap> assignCtOrderList(Map<String, Object> params);
	List<EgovMap> assignCtList(Map<String, Object> params);
	List<EgovMap> selectCTByDSC(Map<String, Object> params);
	
	
}
