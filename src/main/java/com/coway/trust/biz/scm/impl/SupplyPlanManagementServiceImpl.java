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

import com.coway.trust.biz.scm.SupplyPlanManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplyPlanManagementService")
public class SupplyPlanManagementServiceImpl implements SupplyPlanManagementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SupplyPlanManagementServiceImpl.class);

	@Autowired
	private SupplyPlanManagementMapper supplyPlanManagementMapper;
	
	/*
	 * Supply Plan Management
	 */
	public List<EgovMap> selectScmYear(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectScmYear(params);
	}
	public List<EgovMap> selectScmWeekByYear(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectScmWeekByYear(params);
	}
	public List<EgovMap> selectScmCdc(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectScmCdc(params);
	}
	public List<EgovMap> selectScmStockType(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectScmStockType(params);
	}
	public List<EgovMap> selectScmStockCode(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectScmStockCode(params);
	}
}