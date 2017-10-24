package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource; 

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.AllocationService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("allocationService")
public class AllocationServiceImpl extends EgovAbstractServiceImpl implements AllocationService{
	private static final Logger logger = LoggerFactory.getLogger(AllocationService.class);
	
	@Resource(name = "allocationMapper")
	private AllocationMapper allocationMapper;

	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		return allocationMapper.selectList(params);
	}
	
	@Override
	public List<EgovMap> selectDetailList(Map<String, Object> params) {
		return allocationMapper.selectDetailList(params);
	}
	
	
	
}
