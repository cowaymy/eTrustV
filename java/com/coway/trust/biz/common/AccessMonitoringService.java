package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AccessMonitoringService {
	List<EgovMap> selectAccessMonitoringList(Map<String, Object> params);

	List<EgovMap> selectAccessMonitoringDtmList(Map<String, Object> params);

	List<EgovMap> selectAccessMonitoringUserList(Map<String, Object> params);

	void insertAccessMonitoring(Map<String, Object> params);

	void insertSubAccessMonitoring(String requestUrl, Map<String, Object>searchParams, HttpServletRequest request,SessionVO sessionVO);
}
