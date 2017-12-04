package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("mileageCalculationMapper")
public interface MileageCalculationMapper {

	void insertDCPMaster(Map<String, Object> params);
	
	void updatetDCPMaster(Map<String, Object> params);
	
	void deleteDCPMaster(Map<String, Object> params);
	
	List<EgovMap> selectDCPMaster(Map<String, Object> params);
	
	List<EgovMap> selectArea(Map<String, Object> params);
	
	void insertSchemaMgmt(Map<String, Object> params);
	
	void updateSchemaMgmt(Map<String, Object> params);
	
	void deleteSchemaMgmt(Map<String, Object> params);
	
	// 171123 :: 선한이
	void updateDCPMasterByExcel(Map<String, Object> updateValue);
	
	List<EgovMap> selectSchemaMgmt(Map<String, Object> params);
	
	List<EgovMap> selectSchemaResultMgmt(Map<String, Object> params);
	
	List<EgovMap> selectBranch(Map<String, Object> params);
	
	List<EgovMap> selectMemberCode(Map<String, Object> params);

	// 171127 :: 선한이
	List<EgovMap> selectDCPFrom(Map<String, Object> params);
	
	List<EgovMap> selectDCPTo(Map<String, Object> params);

	// 171130 :: 선한이
	int selectDCPMasterCount(Map<String, Object> params);

	List<EgovMap> selectCity(Map<String, Object> params);
	
}
