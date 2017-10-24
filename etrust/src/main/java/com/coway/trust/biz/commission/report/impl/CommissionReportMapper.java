/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 */
package com.coway.trust.biz.commission.report.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

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
	int selectMemberCount(Map<String, Object> param);
}
