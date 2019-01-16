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
import com.coway.trust.biz.scm.ScmCommonService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("scmCommonService")
public class ScmCommonServiceImpl implements ScmCommonService {

	//private static final Logger LOGGER = LoggerFactory.getLogger(SalesPlanMngementServiceImpl.class);
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmCommonServiceImpl.class);

	@Autowired
	private ScmCommonMapper scmCommonMapper;
	
	@Override
	public List<EgovMap> selectScmTotalPeriod(Map<String, Object> params) {
		return	scmCommonMapper.selectScmTotalPeriod(params);
	}
	@Override
	public List<EgovMap> selectScmYear(Map<String, Object> params) {
		return	scmCommonMapper.selectScmYear(params);
	}
	@Override
	public List<EgovMap> selectScmWeek(Map<String, Object> params) {
		return	scmCommonMapper.selectScmWeek(params);
	}
	@Override
	public List<EgovMap> selectScmTeam(Map<String, Object> params) {
		return	scmCommonMapper.selectScmTeam(params);
	}
	@Override
	public List<EgovMap> selectScmCdc(Map<String, Object> params) {
		return	scmCommonMapper.selectScmCdc(params);
	}
	@Override
	public List<EgovMap> selectScmIfType(Map<String, Object> params) {
		return	scmCommonMapper.selectScmIfType(params);
	}
	@Override
	public List<EgovMap> selectScmIfStatus(Map<String, Object> params) {
		return	scmCommonMapper.selectScmIfStatus(params);
	}
	@Override
	public List<EgovMap> selectScmIfErrCode(Map<String, Object> params) {
		return	scmCommonMapper.selectScmIfErrCode(params);
	}
	@Override
	public List<EgovMap> selectScmStockCategory(Map<String, Object> params) {
		return	scmCommonMapper.selectScmStockCategory(params);
	}
	@Override
	public List<EgovMap> selectScmStockType(Map<String, Object> params) {
		return	scmCommonMapper.selectScmStockType(params);
	}
	@Override
	public List<EgovMap> selectScmStockCode(Map<String, Object> params) {
		return	scmCommonMapper.selectScmStockCode(params);
	}
	@Override
	public List<EgovMap> selectScmStockCodeForMulti(Map<String, Object> params) {
		return	scmCommonMapper.selectScmStockCodeForMulti(params);
	}
	@Override
	public List<EgovMap> selectScmTotalInfo(Map<String, Object> params) {
		return	scmCommonMapper.selectScmTotalInfo(params);
	}
}