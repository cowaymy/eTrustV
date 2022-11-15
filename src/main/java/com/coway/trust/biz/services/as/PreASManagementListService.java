package com.coway.trust.biz.services.as;

import java.util.List;

import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface PreASManagementListService {

	List<EgovMap> selectPreASManagementList(Map<String, Object> params);

	List<EgovMap> selectPreAsStat();

	List<EgovMap> selectPreAsUpd();

	int updatePreAsStatus(Map<String, Object> params) throws Exception;

	List<EgovMap> getCityList(Map<String, Object> params);

	List<EgovMap> getAreaList(Map<String, Object> params);

	EgovMap checkOrder(Map<String, Object> params) throws Exception;

	EgovMap checkSubmissionRecords(Map<String, Object> params) throws Exception;

	EgovMap selectOrderInfo(Map<String, Object> params) throws Exception;

	List<EgovMap> getErrorCodeList(Map<String, Object> params);

	int submitPreAsSubmission(Map<String, Object> params) throws Exception;

	List<EgovMap> searchPreAsSubmissionList(Map<String, Object> params);

	List<EgovMap> asProd(Map<String, Object> params);

	List<EgovMap> searchBranchList(Map<String, Object> params);

}
