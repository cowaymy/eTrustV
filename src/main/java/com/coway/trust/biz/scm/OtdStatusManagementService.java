package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OtdStatusManagementService
{
	//	Scm Common
	List<EgovMap> selectOtdStatus(Map<String, Object> params);
}