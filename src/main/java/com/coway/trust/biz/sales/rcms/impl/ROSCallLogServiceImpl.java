package com.coway.trust.biz.sales.rcms.impl;


import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.rcms.ROSCallLogService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("rosCallLogService")
public class ROSCallLogServiceImpl extends EgovAbstractServiceImpl implements ROSCallLogService{

	//private static final Logger LOGGER = LoggerFactory.getLogger(ROSCallLogServiceImpl.class);
	
	@Resource(name = "rosCallLogMapper")
	private ROSCallLogMapper rosCallLogMapper;

	@Override
	public List<EgovMap> getAppTypeList(Map<String, Object> params) {
		
		return rosCallLogMapper.getAppTypeList(params);
	}

	@Override
	public List<EgovMap> selectRosCallLogList(Map<String, Object> params) {
		
		return rosCallLogMapper.selectRosCallLogList(params);
	}
	
}
