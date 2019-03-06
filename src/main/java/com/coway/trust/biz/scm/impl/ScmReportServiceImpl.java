/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.scm.impl;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.ScmReportService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("scmReportService")
public class ScmReportServiceImpl implements ScmReportService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmReportServiceImpl.class);

	@Autowired
	private ScmCommonMapper scmCommonMapper;
	@Autowired
	private ScmReportMapper scmReportMapper;
	
	//	Business Plan Report
	@Override
	public List<EgovMap> selectPlanVer(Map<String, Object> params) {
		return	scmReportMapper.selectPlanVer(params);
	}
	@Override
	public List<EgovMap> selectBusinessPlanSummary(Map<String, Object> params) {
		return	scmReportMapper.selectBusinessPlanSummary(params);
	}
	@Override
	public List<EgovMap> selectBusinessPlanDetail(Map<String, Object> params) {
		return	scmReportMapper.selectBusinessPlanDetail(params);
	}
	
	//	Sales Plan Accuracy
	@Override
	public List<EgovMap> selectSalesAccuracyWeeklyDetailHeader(Map<String, Object> params) {
		return	scmReportMapper.selectSalesAccuracyWeeklyDetailHeader(params);
	}
	@Override
	public List<EgovMap> selectSalesAccuracyMonthlyDetailHeader(Map<String, Object> params) {
		return	scmReportMapper.selectSalesAccuracyMonthlyDetailHeader(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyWeeklySummary(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyWeeklySummary(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyMonthlySummary(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyMonthlySummary(params);
	}
	@Override
	public List<EgovMap> selectWeekly16Week(Map<String, Object> params) {
		return	scmReportMapper.selectWeekly16Week(params);
	}
	@Override
	public List<EgovMap> selectWeeklyStartEnd(Map<String, Object> params) {
		return	scmReportMapper.selectWeeklyStartEnd(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyWeeklyDetail(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyWeeklyDetail(params);
	}
	@Override
	public List<EgovMap> selectMonthly16Week(Map<String, Object> params) {
		return	scmReportMapper.selectMonthly16Week(params);
	}
	@Override
	public List<EgovMap> selectMonthlyStartEnd(Map<String, Object> params) {
		return	scmReportMapper.selectMonthlyStartEnd(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyMonthlyDetail(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyMonthlyDetail(params);
	}
	
	//	Ontime Delivery Report
	@Override
	public List<EgovMap> selectOntimeDeliverySummary(Map<String, Object> params) {
		return	scmReportMapper.selectOntimeDeliverySummary(params);
	}
	@Override
	public List<EgovMap> selectOntimeDeliveryDetail(Map<String, Object> params) {
		return	scmReportMapper.selectOntimeDeliveryDetail(params);
	}
	
	//	Inventory Report
	@Override
	public List<EgovMap> selectInventoryReportTotalHeader(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportTotalHeader(params);
	}
	@Override
	public List<EgovMap> selectInventoryReportDetailHeader(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportDetailHeader(params);
	}
	@Override
	public List<EgovMap> selectInventoryReportTotal(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportTotal(params);
	}
	@Override
	public List<EgovMap> selectInventoryReportDetail(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportDetail(params);
	}
}