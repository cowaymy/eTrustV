package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("allocationMapper")
public interface AllocationMapper {

	List<EgovMap> selectList(Map<String, Object> params);
	List<EgovMap> selectDetailList(Map<String, Object> params);


	List<EgovMap> selectBaseList(Map<String, Object> params);
	List<EgovMap> isSubGroupHoliDay(Map<String, Object> params);
	List<EgovMap> isHcSubGroupHoliDay(Map<String, Object> params);
	EgovMap  selectVacationList(Map<String, Object> params);
	EgovMap  makeViewList(Map<String, Object> params);

	int isMergeNosvcDay(Map<String, Object> params);


}
