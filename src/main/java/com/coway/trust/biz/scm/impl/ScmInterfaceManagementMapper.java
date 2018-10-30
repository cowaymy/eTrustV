package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ScmInterfaceManagementMapper")
public interface ScmInterfaceManagementMapper
{
	//	Interface
	List<EgovMap> selectInterfaceList(Map<String, Object> params);
	void doInterface(Map<String, Object> params);
	void scmIf155(Map<String, Object> params);
}