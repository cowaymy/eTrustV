package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OTDStatusManagementService
{
	//	OTD Status Report
	List<EgovMap> selectOTDStatus(Map<String, Object> params);
}