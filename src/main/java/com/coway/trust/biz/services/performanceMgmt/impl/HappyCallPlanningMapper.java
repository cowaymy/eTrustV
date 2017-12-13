package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("happyCallPlanningMapper")
public interface HappyCallPlanningMapper {
	
	List<EgovMap> selectCallTypeList();

	List<EgovMap> selectEvalCriteriaList();

	List<EgovMap> selectFeedbackTypeSearchList();
	
	List<EgovMap> selectFeedbackTypeGridList();

}
