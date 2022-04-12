package com.coway.trust.biz.common.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("accessMonitoringService")
public class AccessMonitoringServiceImpl implements AccessMonitoringService {

	@Autowired
	private AccessMonitoringMapper accessMonitoringMapper;

	public List<EgovMap> selectAccessMonitoringList(Map<String, Object> params) {
		return accessMonitoringMapper.selectAccessMonitoringList(params);
	}

	public List<EgovMap> selectAccessMonitoringDtmList(Map<String, Object> params) {
		return accessMonitoringMapper.selectAccessMonitoringDtmList(params);
	}

	public List<EgovMap> selectAccessMonitoringUserList(Map<String, Object> params) {
		return accessMonitoringMapper.selectAccessMonitoringUserList(params);
	}

	public void insertAccessMonitoring(Map<String, Object> params) {
		accessMonitoringMapper.insertAccessMonitoring(params);
	}

	public void insertSubAccessMonitoring(String requestUrl, Map<String, Object>searchParams, HttpServletRequest request, SessionVO sessionVO) {
    	Map<String, Object> monitorData = new HashMap<>();

		monitorData.put("userId", sessionVO.getUserId());
		monitorData.put("pgmPath", requestUrl);
		monitorData.put("userName", sessionVO.getUserName());
		monitorData.put("systemId", AppConstants.LOGIN_WEB);
		monitorData.put("pgmCode", "-");
		monitorData.put("ipAddr", CommonUtils.getClientIp(request));
		monitorData.put("pgmPathParam", searchParams.toString());

		accessMonitoringMapper.insertAccessMonitoring(monitorData);
	}
}
