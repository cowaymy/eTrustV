package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
  
import com.coway.trust.biz.services.as.CompensationService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("CompensationService")
public class  CompensationServiceImpl  extends EgovAbstractServiceImpl implements CompensationService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CompensationServiceImpl.class);
	
	@Resource(name = "CompensationMapper")
	private CompensationMapper compensationMapper;
	 
	@Override
	public List<EgovMap> selCompensationList(Map<String, Object> params) {
		return compensationMapper.selCompensationList(params);
	}
	
} 
