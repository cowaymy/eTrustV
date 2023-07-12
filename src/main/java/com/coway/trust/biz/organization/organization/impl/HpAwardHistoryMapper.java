package com.coway.trust.biz.organization.organization.impl;
import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HpAwardHistoryMapper")
public interface HpAwardHistoryMapper {

	List <EgovMap> selectHpAwardHistoryListing(Map<String, Object>params);

	List <EgovMap> selectHpAwardHistoryDetails(Map<String, Object>params);

	List <EgovMap> selectIncentiveCode(Map<String, Object>params);

	List <EgovMap> selectEachHpAwardHistory(Map<String, Object>params);

	List <EgovMap> selectHpAwardHistoryReport(Map<String, Object>params);

	List <EgovMap> selectYearList(Map<String, Object>params);

	List <EgovMap> selectMonthList(Map<String, Object>params);

	int insertHpAwardHistoryMaster(Map<String, Object> params);

	int insertHpAwardHistoryDetails(Map<String, Object> params);

	int updateHpAwardHistoryStatus(Map<String, Object> params);

	int updateHpAwardHistoryDetails(Map<String, Object> params);

	int updateNewHpAwardHistoryDetails(Map<String, Object> params);

	int updateIncentiveCode(Map<String, Object> params);

	int updateNewIncentiveCode(Map<String, Object> params);

	EgovMap chkIncentiveCodeDup(Map<String, Object> params);

}