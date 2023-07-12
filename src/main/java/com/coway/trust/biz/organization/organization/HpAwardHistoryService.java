package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HpAwardHistoryService {

	List <EgovMap> selectHpAwardHistoryListing(Map<String, Object> params);

	List <EgovMap> selectHpAwardHistoryDetails(Map<String, Object> params);

	List <EgovMap> selectIncentiveCode(Map<String, Object> params);

	List <EgovMap> selectEachHpAwardHistory(Map<String, Object> params);

	List <EgovMap> selectHpAwardHistoryReport(Map<String, Object> params);

	List <EgovMap> selectYearList(Map<String, Object> params);

	List <EgovMap> selectMonthList(Map<String, Object> params);

	int insertHpAwardHistoryMaster(Map<String, Object> params);

	int insertHpAwardHistoryDetails(Map<String, Object> params);

	int updateHpAwardHistoryStatus(Map<String, Object> params);

	int updateHpAwardHistoryDetails(Map<String, Object> params);

	Map<String, Object> updateIncentiveCode(Map<String, Object> params);

}