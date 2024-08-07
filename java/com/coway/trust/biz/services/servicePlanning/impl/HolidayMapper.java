package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("holidayMapper")
public interface HolidayMapper {
	
	void insertHoliday(Map<String, Object> params);

	void updateHoliday(Map<String, Object> params);
	
	List<EgovMap> selectHolidayList(Map<String, Object> params);
	
	List<EgovMap> selectCTList(Map<String, Object> params);
	
	List<EgovMap> selectCTAssignList(Map<String, Object> params);
	
	void insertCTAssign(Map<String, Object> params);
	
	List<EgovMap> selectAssignCTList(Map<String, Object> params);
	
	void deleteCTAssign(Map<String, Object> params);
	
	List<EgovMap> selectCTInfo(Map<String, Object> params);
	
	List<EgovMap> selectState();
	
	List<EgovMap> selectCity(Map<String, Object> params);
	
	void deleteHoliday(Map<String, Object> params);
	
	List<EgovMap> selectBranch();
	
	List<EgovMap> selectBranchWithNM();

	EgovMap selectBeforeToday(Map<String, Object> params);

	List<EgovMap> selectAlreadyHoliday(Map<String, Object> params);

	EgovMap selectApplType(Map<String, Object> params);

	int insertApplType(Map<String, Object> params);

	int deleteApplType(Map<String, Object> params);
}
