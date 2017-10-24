package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.common.AccessMonitoringService;
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
}
