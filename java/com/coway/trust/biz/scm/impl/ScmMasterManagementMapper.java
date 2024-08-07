package com.coway.trust.biz.scm.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("scmMasterManagementMapper")
public interface ScmMasterManagementMapper
{
	//	SCM Master Manager
	List<EgovMap> selectScmMasterList(Map<String, Object> params);
	int saveScmMaster(Map<String, Object> params);
	int saveScmMaster2(Map<String, Object> params);
	int deleteScmMaster2(Map<String, Object> params);
	
	//	CDC Warehouse Mapping
	List<EgovMap> selectCdcWhMappingList(Map<String, Object> params);
	List<EgovMap> selectCdcWhUnmappingList(Map<String, Object> params);
	int insertCdcWhMapping(Map<String, Object> params);
	int deleteCdcWhMapping(Map<String, Object> params);
	
	//	CDC Branch Mapping
	List<EgovMap> selectCdcBrMappingList(Map<String, Object> params);
	List<EgovMap> selectCdcBrUnmappingList(Map<String, Object> params);
	int insertCdcBrMapping(Map<String, Object> params);
	int deleteCdcBrMapping(Map<String, Object> params);

	int updateCdcLeadTimeMapping(Map<String, Object> params);
}