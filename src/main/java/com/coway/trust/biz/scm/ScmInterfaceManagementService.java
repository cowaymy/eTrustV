package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ScmInterfaceManagementService
{
	//	Interface
	List<EgovMap> selectInterfaceList(Map<String, Object> params);
	int doInterface(List<Map<String, Object>> chkList, SessionVO sessionVO);
	int scmIf155(List<Map<String, Object>> chkList, SessionVO sessionVO);
}