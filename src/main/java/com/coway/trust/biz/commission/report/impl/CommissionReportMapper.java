/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 */
package com.coway.trust.biz.commission.report.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * Commission Mapper
 * </pre>
 */
@Mapper("commissionReportMapper")
public interface CommissionReportMapper {

	/**
	 * selectMemberCount
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	EgovMap selectMemberCount(Map<String, Object> param);
	List<EgovMap> commissionGroupType(Map<String, Object> params);
	Map commSHIMemberSearch (Map<String, Object> params);
	List<EgovMap> commSHIIndexCall (Map<String, Object> params);
	List<EgovMap> commSHIIndexDetailsCall (Map<String, Object> params);

	/**
	 * search Organization Gruop List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrList(Map<String, Object> params);

	/**
	 * search Organization  List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgList(Map<String, Object> params);

	/**
	 * search Organization Code List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgCdListAll(Map<String, Object> params);

	List<EgovMap>selectCodyRawData(Map<String, Object> params);
	List<EgovMap>selectCMRawData(Map<String, Object> params);
	List<EgovMap>selectHPRawData(Map<String, Object> params);
	List<EgovMap>selectCTRawData(Map<String, Object> params);

	List<EgovMap> commSHIIndexCall2 (Map<String, Object> params);
	List<EgovMap> commSHIIndexDetailsCall2 (Map<String, Object> params);
}
