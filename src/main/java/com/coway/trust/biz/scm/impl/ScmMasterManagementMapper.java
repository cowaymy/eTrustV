package com.coway.trust.biz.scm.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("scmMasterManagementMapper")
public interface ScmMasterManagementMapper
{
	List<EgovMap> selectScmMasterList(Map<String, Object> params);
	int saveScmMaster(Map<String, Object> params);
	int saveScmMaster2(Map<String, Object> params);
}