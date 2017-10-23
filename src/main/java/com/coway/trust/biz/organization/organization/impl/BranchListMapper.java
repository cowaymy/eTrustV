package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("branchListMapper")
public interface BranchListMapper {

	List<EgovMap> selectBranchList(Map<String, Object> params);

	EgovMap getBranchDetailPop(Map<String, Object> params);

	List<EgovMap> getBranchType(Map<String, Object> params);

	int branchListUpdate(Map<String, Object> params);

	int branchListInsert(Map<String, Object> params);

	List<EgovMap> getStateList(Map<String, Object> params);

	List<EgovMap> getAreaList(Map<String, Object> params);

	List<EgovMap> getPostcodeList(Map<String, Object> params);
	
	EgovMap getBranchAddrDetail(Map<String, Object> params);

}
