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
import com.coway.trust.biz.scm.SalesPlanManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("salesPlanManagementService")
public class SalesPlanManagementServiceImpl implements SalesPlanManagementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SalesPlanManagementServiceImpl.class);

	@Autowired
	private SalesPlanManagementMapper salesPlanManagementMapper;
	
	@Override
	public List<EgovMap> selectSalesPlanHeader(Map<String, Object> params) {
		
		List<EgovMap> selectSalesplanMonth	= salesPlanManagementMapper.selectSalesPlanMonth(params);
		
		//	월의 마지막주차가 SPLIT인 경우는 FROM월을 1개월 뒤로 미룸
		LOGGER.debug("selectSalesplanMonth : {} ", selectSalesplanMonth.toString());
		
		String planYear		= params.get("scmYearCbBox").toString();
		String planMonth	= selectSalesplanMonth.get(0).get("planMonth").toString();
		
		if ( 2 > planMonth.length() ) {
			planMonth	= "0" + planMonth;
		}
		
		DateFormat dateFormat	= new SimpleDateFormat("yyyyMM");
		DateFormat yearFormat	= new SimpleDateFormat("yyyy");
		DateFormat monthFormat	= new SimpleDateFormat("MM");
		Date date	= null;
		
		try {
			date	= dateFormat.parse(planYear + planMonth);
		} catch ( ParseException e ) {
			e.printStackTrace();
		}
		
		Calendar cal	= Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.MONTH, 4);
		
		String salesPlanFrom	= planYear + planMonth;
		String salesPlanTo		= yearFormat.format(cal.getTime()) + monthFormat.format(cal.getTime());
		
		params.put("salesPlanFrom", salesPlanFrom);
		params.put("salesPlanTo", salesPlanTo);
		
		return	salesPlanManagementMapper.selectSalesPlanHeader(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanInfo(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectSalesPlanInfo(params);
	}
	@Override
	public List<EgovMap> selectSplitInfo(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectSplitInfo(params);
	}
	@Override
	public List<EgovMap> selectChildField(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectChildField(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanList(Map<String, Object> params) {
		return salesPlanManagementMapper.selectSalesPlanList(params);
	}
	@Override
	public int insertSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		
		int cnt	= 0;
		int updCnt	= 0;
		
		List<EgovMap> selectSalesplanMonth	= salesPlanManagementMapper.selectSalesPlanMonth(params);
		
		params.put("planMonth", selectSalesplanMonth.get(0).get("planMonth"));
		params.put("crtUserId", sessionVO.getUserId());
		
		try {
			salesPlanManagementMapper.insertSalesPlanMaster(params);
			cnt++;
			LOGGER.debug(" createCnt : {} ", cnt);
			
			salesPlanManagementMapper.callSpScmInsSalesPlanDetail(params);
			//Map<String, Object> result	= params;
			if ( null != params.get("result") ) {
				String result	= params.get("result").toString();
				LOGGER.debug(" callSpScmInsSalesPlanDetail result : {} ", result);
			} else {
				LOGGER.debug(" callSpScmInsSalesPlanDetail result is null");
			}
			
			List<EgovMap> updList	= salesPlanManagementMapper.selectSalesPlanDetailSum(params);
			for ( Object obj : updList ) {
				salesPlanManagementMapper.updateSalesPlanDetailSum((Map<String, Object>) obj);
				updCnt++;
				LOGGER.debug("Monthly Sales Plan Sum (" + obj);
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	cnt;
	}
	@SuppressWarnings("unchecked")
	@Override
	public int updateSalesPlanDetail(List<Object> updList, SessionVO sessionVO) {
		
		int updCnt	= 0;
		
		try {
			for ( Object obj : updList ) {
				salesPlanManagementMapper.updateSalesPlanDetail((Map<String, Object>) obj);
				LOGGER.debug("planDtlId : ", ((Map<String, Object>) obj).get("planDtlId"));
				updCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	updCnt;
	}
	@Override
	public int updateSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		
		int updCnt	= 0;
		
		try {
			salesPlanManagementMapper.updateSalesPlanMaster(params);
			updCnt++;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	updCnt;
	}
}