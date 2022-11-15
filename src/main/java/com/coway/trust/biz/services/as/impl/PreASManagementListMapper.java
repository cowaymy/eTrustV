package com.coway.trust.biz.services.as.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Mapper("PreASManagementListMapper")
public interface PreASManagementListMapper {

	List<EgovMap> selectPreASManagementList(Map<String, Object> params);

	List<EgovMap> selectPreAsStat();

	List<EgovMap> selectPreAsUpd();

	//void updateRejectedPreAS(Map<String, Object> params);

	int updatePreAsStatus(Map<String, Object> params);

	List<EgovMap> getCityList(Map<String, Object> params);

	List<EgovMap> getAreaList(Map<String, Object> params);

	EgovMap checkOrder(Map<String, Object> params);

	EgovMap checkSubmissionRecords(Map<String, Object> params);

	EgovMap selectOrderInfo(Map<String, Object> params);

	List<EgovMap> getErrorCodeList(Map<String, Object> params);

	int submitPreAsSubmission(Map<String, Object> params);

	List<EgovMap> searchPreAsSubmissionList(Map<String, Object> params);

	List<EgovMap> asProd(Map<String, Object> params);

	List<EgovMap> searchBranchList(Map<String, Object> params);

}
