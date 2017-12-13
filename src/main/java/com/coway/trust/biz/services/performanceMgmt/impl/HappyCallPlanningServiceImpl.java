package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.performanceMgmt.HappyCallPlanningService;
import com.coway.trust.biz.services.performanceMgmt.SurveyMgmtService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("happyCallPlanningService")
public class HappyCallPlanningServiceImpl implements HappyCallPlanningService{
	
	private static final Logger logger = LoggerFactory.getLogger(HappyCallPlanningService.class);

	@Resource(name = "happyCallPlanningMapper")
	private HappyCallPlanningMapper happyCallPlanningMapper;
	
	@Override
	public List<EgovMap> selectCallTypeList() {
		return happyCallPlanningMapper.selectCallTypeList();
	}

	@Override
	public List<EgovMap> selectEvalCriteriaList() {
		return happyCallPlanningMapper.selectEvalCriteriaList();
	}
	
}
