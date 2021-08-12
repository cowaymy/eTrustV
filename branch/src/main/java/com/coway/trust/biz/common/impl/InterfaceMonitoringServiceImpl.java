package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.common.InterfaceMonitoringService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("interfaceMonitoringService")
public class InterfaceMonitoringServiceImpl implements InterfaceMonitoringService {

	@Autowired
	private InterfaceMonitoringMapper interfaceMonitoringMapper;

	public List<EgovMap> selectInterfaceMonitoringList(Map<String, Object> params) {
		return interfaceMonitoringMapper.selectInterfaceMonitoringList(params);
	}

	public List<EgovMap> selectInterfaceMonitoringDtmList(Map<String, Object> params) {
		return interfaceMonitoringMapper.selectInterfaceMonitoringDtmList(params);
	}

	public List<EgovMap> selectInterfaceMonitoringKeyList(Map<String, Object> params) {
		return interfaceMonitoringMapper.selectInterfaceMonitoringKeyList(params);
	}


	public List<EgovMap> selectCommonCodeStatusList(Map<String, Object> params) {
		return interfaceMonitoringMapper.selectCommonCodeStatusList(params);
	}

	@Override
	public List<EgovMap> selectInterfaceTypeList(Map<String, Object> params) {
		return interfaceMonitoringMapper.selectInterfaceTypeList(params);
	}
}
