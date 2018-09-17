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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.scm.ScmCommonService;
import com.coway.trust.biz.scm.ScmMasterManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.crystaldecisions.reports.common.value.StringValue;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("scmMasterManagementService")
public class ScmMasterManagementServiceImpl implements ScmMasterManagementService
{
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterManagementServiceImpl.class);
	
	@Autowired
	private ScmMasterManagementMapper scmMasterManagementMapper;
	
	@Autowired
	private ScmCommonMapper scmCommonMapper;
	
	//	Master Management
	@Override
	public List<EgovMap> selectScmMasterList(Map<String, Object> params) {
		return	scmMasterManagementMapper.selectScmMasterList(params);
	}
	@Override
	public int saveScmMaster(List<Object> params, SessionVO sessionVO) {
		int cnt	= 0;
		
		for ( Object obj : params ) {
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster((Map<String, Object>) obj);
		}
		
		return	cnt;
	}
	@Override
	public int saveScmMaster2(List<Object> params, SessionVO sessionVO) {
		
		int row	= params.size();
		int cnt	= 0;
		Map<String, Object> map	= new HashMap<>();
		
		for ( Object obj : params ) {
			LOGGER.debug("saveScmMaster2 : {}", params.toString());
			((Map<String, Object>) obj).put("stockId", ((Map<String, Object>) obj).get("stockId"));
			((Map<String, Object>) obj).put("stockCode", ((Map<String, Object>) obj).get("stockCode"));
			
			((Map<String, Object>) obj).put("cdcCode", "2010");
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("klMoq"));
			((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("klTarget"));
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "2020");
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("pnMoq"));
			((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("pnTarget"));
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "2030");
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("jbMoq"));
			((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("jbTarget"));
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "2040");
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kkMoq"));
			((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("kkTarget"));
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "2050");
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kcMoq"));
			((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("kcTarget"));
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
		}
		
		return	cnt;
	}
}