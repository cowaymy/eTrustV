package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BranchListService {

	
	List<EgovMap> selectBranchList(Map<String, Object> params);

	EgovMap getBranchDetailPop(Map<String, Object> params);

	List<EgovMap> getBranchType(Map<String, Object> params);

	int branchListUpdate(Map<String, Object> params);

	int branchListInsert(Map<String, Object> params);

	List<EgovMap> getStateList(Map<String, Object> params);

	List<EgovMap> getAreaList(Map<String, Object> params);

	List<EgovMap> getPostcodeList(Map<String, Object> params);
	
	EgovMap getBranchAddrDetail(Map<String, Object> params);
	
	List<EgovMap> selectBranchCdInfo(Map<String, Object> params);
	
	
	
}
