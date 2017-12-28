package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TerritoryManagementService {	
	List<EgovMap> selectList(Map<String, Object> params);
	
	EgovMap  uploadVaild(Map<String, Object> params,SessionVO sessionVO);
	
	List<EgovMap> selectTerritory(Map<String, Object> params);
	
	List<EgovMap> selectMagicAddress(Map<String, Object> params); 
	
	boolean updateMagicAddressCode(Map<String, Object> params);

	List<EgovMap> selectCodyBranch(Map<String, Object> params);

	List<EgovMap> selectCTBranch(Map<String, Object> params);

	List<EgovMap> selectCurrentTerritory(Map<String, Object> params);
}
