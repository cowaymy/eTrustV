package com.coway.trust.biz.services.as;

import java.util.List;

import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface PreASManagementListService {

	List<EgovMap> selectPreASManagementList(Map<String, Object> params);

	List<EgovMap> selectPreAsStat();

	Map<String, Object> updateRejectedPreAS(Map<String, Object> params) throws Exception;

}
