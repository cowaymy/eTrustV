package com.coway.trust.biz.sales.rcms.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.rcms.RCMSAgentManageService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("rcmsAgentManageService")
public class RCMSAgentManageServiceImpl extends EgovAbstractServiceImpl  implements RCMSAgentManageService{

	
	@Resource(name = "rcmsAgentManageMapper")
	private RCMSAgentManageMapper rcmsAgentManageMapper;
	
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RCMSAgentManageServiceImpl.class);

	@Override
	public List<EgovMap> selectAgentTypeList(Map<String, Object> params) throws Exception {
		
		return rcmsAgentManageMapper.selectAgentTypeList(params);
	}
	
}
