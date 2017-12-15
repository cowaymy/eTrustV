package com.coway.trust.biz.services.servicePlanning;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MileageCalculationService {

	void insertDCPMaster(List<Object> params, SessionVO sessionVO);
	
	void updateDCPMaster(List<Object> params, SessionVO sessionVO);
	
	void deleteDCPMaster(List<Object> params, SessionVO sessionVO);
	
	List<EgovMap> selectDCPMaster(Map<String, Object> params);
	
	List<EgovMap> selectArea(Map<String, Object> params);
	
	void insertSchemaMgmt(List<Object> params, SessionVO sessionVO);
	
	void updateSchemaMgmt(List<Object> params, SessionVO sessionVO);
	
	void deleteSchemaMgmt(List<Object> params, SessionVO sessionVO);
	
	void updateDCPMasterByExcel(List<Map<String, Object>> updateList, SessionVO sessionVO);
	
	List<EgovMap> selectSchemaMgmt(Map<String, Object> params);
	
	List<EgovMap> selectSchemaResultMgmt(Map<String, Object> params);
	
	List<EgovMap> selectBranch(Map<String, Object> params);
	
	List<EgovMap> selectMemberCode(Map<String, Object> params);

	List<EgovMap> selectDCPFrom(Map<String, Object> params);
	
	List<EgovMap> selectDCPTo(Map<String, Object> params);

	int selectDCPMasterCount(Map<String, Object> params);

	List<EgovMap> selectCity(Map<String, Object> params);

}
