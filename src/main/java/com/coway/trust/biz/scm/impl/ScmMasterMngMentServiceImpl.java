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

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.scm.ScmMasterMngMentService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ScmMasterMngMentService")
public class ScmMasterMngMentServiceImpl implements ScmMasterMngMentService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterMngMentServiceImpl.class);

	@Autowired
	private ScmMasterMngMentMapper scmMasterMngMentMapper;
	
	
	// Master Management
	@Override
	public List<EgovMap> selectMasterMngmentSearch(Map<String, Object> params) {
		return scmMasterMngMentMapper.selectMasterMngmentSearch(params);
	}
	
	// CDC WareHouse Mapping
	@Override
	public List<EgovMap> selectCdcWareMapping(Map<String, Object> params) {
		return scmMasterMngMentMapper.selectCdcWareMapping(params);
	}
	@Override
	public List<EgovMap> selectWhLocationMapping(Map<String, Object> params) {
		return scmMasterMngMentMapper.selectWhLocationMapping(params);
	}
	
	@Override
	public int insetCdcWhMapping(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" >>>>> insetCdcWhMapping ");
			LOGGER.debug(" hidden_Whid : {}", ((Map<String, Object>) obj).get("whId"));
			
			//String tmpStr =  (String) ((Map<String, Object>) obj).get("whId");

			saveCnt++;

			scmMasterMngMentMapper.insetCdcWhMapping((Map<String, Object>) obj);
		}

		return saveCnt;
	}
	
	@Override
	public int deleteCdcWhMapping(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" >>>>> deleteCdcWhMapping ");
			LOGGER.debug(" hidden_Whid : {}", ((Map<String, Object>) obj).get("whId"));
			
			//String tmpStr =  (String) ((Map<String, Object>) obj).get("whId");
			
			saveCnt++;
			
			scmMasterMngMentMapper.deleteCdcWhMapping((Map<String, Object>) obj);
		}
		
		return saveCnt;
	}
	
	// Business Plan Manager
	@Override
	public List<EgovMap> selectBizPlanManager(Map<String, Object> params) {
		return scmMasterMngMentMapper.selectBizPlanManager(params);
	}
	

}
