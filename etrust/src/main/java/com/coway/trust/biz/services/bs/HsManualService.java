package com.coway.trust.biz.services.bs;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HsManualService {

	List<EgovMap> selectHsManualList(Map<String, Object> params);

	List<EgovMap> selectHsAssiinlList(Map<String, Object> params);
	
	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectCtList(Map<String, Object> params);

	List<EgovMap> getCdList(Map<String, Object> params);

	List<EgovMap> getCdUpMemList(Map<String, Object> params);

	List<EgovMap> getCdList_1(Map<String, Object> params);

	List<EgovMap> selectHsManualListPop(Map<String, Object> params);

	EgovMap selectHsInitDetailPop(Map<String, Object> params);
	
	List<EgovMap> cmbCollectTypeComboList(Map<String, Object> params);

	List<EgovMap> cmbServiceMemList(Map<String, Object> params);
	
	Boolean insertHsResult(Map<String, Object> params, List<Object> docType);

	boolean addIHsResult(Map<String, Object> params,  List<Object> docType, SessionVO sessionVO)  throws ParseException;

	List<EgovMap> selectHsFilterList(Map<String, Object> params);

	EgovMap selectHsViewBasicInfo(Map<String, Object> params);
	
	
	
}
