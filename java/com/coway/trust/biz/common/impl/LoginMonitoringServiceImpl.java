package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.common.LoginMonitoringService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loginMonitoringService")
public class LoginMonitoringServiceImpl implements LoginMonitoringService {

	@Autowired
	private LoginMonitoringMapper loginMonitoringMapper;

	public List<EgovMap> selectLoginMonitoringList(Map<String, Object> params) {
		return loginMonitoringMapper.selectLoginMonitoringList(params);
	}

	public List<EgovMap> selectCommonCodeSystemList(Map<String, Object> params) {
		return loginMonitoringMapper.selectCommonCodeSystemList(params);
	}
}
