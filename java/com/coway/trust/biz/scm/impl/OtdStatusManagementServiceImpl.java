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
import com.coway.trust.biz.scm.OtdStatusManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("otdStatusManagementService")
public class OtdStatusManagementServiceImpl implements OtdStatusManagementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(OtdStatusManagementServiceImpl.class);

	@Autowired
	private OtdStatusManagementMapper otdStatusManagementMapper;
	
	@Override
	public List<EgovMap> selectOtdStatus(Map<String, Object> params) {
		String startDate	= "";
		String endDate		= "";
		
		startDate	= params.get("startDate").toString();
		endDate		= params.get("endDate").toString();
		
		startDate	= startDate.replace("/", "");	startDate	= startDate.replace(".", "");	startDate	= startDate.replace("-", "");
		endDate		= endDate.replace("/", "");		endDate		= endDate.replace(".", "");		endDate		= endDate.replace("-", "");
		
		startDate	= startDate.substring(4, 8) + startDate.substring(2, 4) + startDate.substring(0, 2);
		endDate		= endDate.substring(4, 8) + endDate.substring(2, 4) + endDate.substring(0, 2);
		
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		LOGGER.debug("startDate : " + startDate + ", endDate : " + endDate);
		
		return	otdStatusManagementMapper.selectOtdStatus(params);
	}
}