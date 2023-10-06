package com.coway.trust.biz.scm;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ScmMasterManagementService
{
	//	SCM Master Manager
	List<EgovMap> selectScmMasterList(Map<String, Object> params);
	int saveScmMaster(List<Object> addList, SessionVO sessionVO);
	int saveScmMaster2(List<Object> addList, SessionVO sessionVO);
	
	//	CDC Warehouse Mapping
	List<EgovMap> selectCdcWhMappingList(Map<String, Object> params);
	List<EgovMap> selectCdcWhUnmappingList(Map<String, Object> params);
	int insertCdcWhMapping(List<Object> insList, Integer crtUserId);
	int deleteCdcWhMapping(List<Object> delList, Integer crtUserId);
	
	//	CDC Branch Mapping
	List<EgovMap> selectCdcBrMappingList(Map<String, Object> params);
	List<EgovMap> selectCdcBrUnmappingList(Map<String, Object> params);
	int insertCdcBrMapping(List<Object> insList, Integer crtUserId);
	int deleteCdcBrMapping(List<Object> delList, Integer crtUserId);

	int updateCdcLeadTimeMapping(List<Object> insList, Integer crtUserId);
}