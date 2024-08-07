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
import com.coway.trust.util.CommonUtils;
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

	/*
	 * SCM Master Manager
	 */
	//	search
	@Override
	public List<EgovMap> selectScmMasterList(Map<String, Object> params) {
		return	scmMasterManagementMapper.selectScmMasterList(params);
	}
	//	save
	@Override
	public int saveScmMaster(List<Object> params, SessionVO sessionVO) {
		int cnt	= 0;
		String startDt	= "";
		String endDt		= "";

		for ( Object obj : params ) {
			LOGGER.debug("saveScmMaster : {}", params.toString());

			if ( null != ((Map<String, Object>) obj).get("startDt") && ! "".equals(((Map<String, Object>) obj).get("startDt").toString())) {
				startDt	= ((Map<String, Object>) obj).get("startDt").toString();
				LOGGER.debug("startDt : " + startDt);
				if ( ! startDt.equals(startDt.replace("-", "")) ) {
					startDt	= startDt.replace("-", "");	startDt	= startDt.replace("/", "");
					startDt	= startDt.substring(4, 8) + startDt.substring(0, 2) + startDt.substring(2, 4);
					((Map<String, Object>) obj).put("startDt", startDt);
				}
				LOGGER.debug("startDt : " + startDt);
			} else {
				((Map<String, Object>) obj).put("startDt", "19000101");
			}
			if ( null != ((Map<String, Object>) obj).get("endDt") && ! "".equals(((Map<String, Object>) obj).get("endDt").toString()) ) {
				endDt	= ((Map<String, Object>) obj).get("endDt").toString();
				LOGGER.debug("endDt : " + endDt);
				if ( ! endDt.equals(endDt.replace("-", "")) ) {
					endDt	= endDt.replace("-", "");	endDt	= endDt.replace("/", "");
					endDt	= endDt.substring(4, 8) + endDt.substring(0, 2) + endDt.substring(2, 4);
					((Map<String, Object>) obj).put("endDt", endDt);
				}
				LOGGER.debug("endDt : " + endDt);
			} else {
				((Map<String, Object>) obj).put("endDt", "19000101");
			}
			scmMasterManagementMapper.saveScmMaster((Map<String, Object>) obj);
			cnt++;
		}

		return	cnt;
	}
	//	save
	@Override
	public int saveScmMaster2(List<Object> params, SessionVO sessionVO) {

		int cnt	= 0;
		int moq	= 0;
		int leadTm	= 0;
		int loadingQty	= 0;
		String cdc	= "";
		String isTrget	= "";
		Map<String, Object> map	= new HashMap<>();

		for ( Object obj : params ) {
			LOGGER.debug("saveScmMaster2 : {}", params.toString());
			//	Common
			((Map<String, Object>) obj).put("stockId", ((Map<String, Object>) obj).get("stockId"));
			((Map<String, Object>) obj).put("stockCode", ((Map<String, Object>) obj).get("stockCode"));

			//	KL
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("klMoq")).isEmpty()){
				((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("klMoq").toString());
			}
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("klTarget")).isEmpty()){
				((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("klTarget"));
			}
			((Map<String, Object>) obj).put("cdc", "2010");
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);

			//	PN
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("pnMoq")).isEmpty()){
				((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("pnMoq"));
			}
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("pnTarget")).isEmpty()){
				((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("pnTarget"));
			}
			((Map<String, Object>) obj).put("cdc", "2020");
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);

			//	JB
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("jbMoq")).isEmpty()){
				((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("jbMoq"));
			}
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("jbTarget")).isEmpty()){
				((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("jbTarget"));
			}
			((Map<String, Object>) obj).put("cdc", "2030");
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);

			//	KK
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("kkMoq")).isEmpty()){
				((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kkMoq"));
			}
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("kkTarget")).isEmpty()){
				((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("kkTarget"));
			}
			((Map<String, Object>) obj).put("cdc", "2040");
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);

			//	KC
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("kcMoq")).isEmpty()){
				((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kcMoq"));
			}
			if(!CommonUtils.nvl(((Map<String, Object>) obj).get("kcTarget")).isEmpty()){
				((Map<String, Object>) obj).put("isTrget", ((Map<String, Object>) obj).get("kcTarget"));
			}
			((Map<String, Object>) obj).put("cdc", "2050");
			cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
		}

		return	cnt;
	}

	/*
	 * CDC Warehouse Mapping
	 */
	//	search
	@Override
	public List<EgovMap> selectCdcWhMappingList(Map<String, Object> params) {
		return	scmMasterManagementMapper.selectCdcWhMappingList(params);
	}
	@Override
	public List<EgovMap> selectCdcWhUnmappingList(Map<String, Object> params) {
		return	scmMasterManagementMapper.selectCdcWhUnmappingList(params);
	}

	//	save Unmap
	@Override
	public int insertCdcWhMapping(List<Object> insList, Integer crtUserId) {
		int saveCnt	= 0;

		for ( Object obj : insList ) {
			scmMasterManagementMapper.insertCdcWhMapping((Map<String, Object>) obj);
			saveCnt++;
		}

		return	saveCnt;
	}

	//	save Map
	@Override
	public int deleteCdcWhMapping(List<Object> delList, Integer crtUserId) {
		int saveCnt	= 0;

		for ( Object obj : delList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			scmMasterManagementMapper.deleteCdcWhMapping((Map<String, Object>) obj);
			saveCnt++;
		}

		return	saveCnt;
	}

	/*
	 * CDC Branch Mapping
	 */
	//	search
	@Override
	public List<EgovMap> selectCdcBrMappingList(Map<String, Object> params) {
		return	scmMasterManagementMapper.selectCdcBrMappingList(params);
	}
	@Override
	public List<EgovMap> selectCdcBrUnmappingList(Map<String, Object> params) {
		return	scmMasterManagementMapper.selectCdcBrUnmappingList(params);
	}

	//	save Unmap
	@Override
	public int insertCdcBrMapping(List<Object> insList, Integer crtUserId) {
		int saveCnt	= 0;

		for ( Object obj : insList ) {
			scmMasterManagementMapper.insertCdcBrMapping((Map<String, Object>) obj);
			saveCnt++;
		}

		return	saveCnt;
	}

	//	save Map
	@Override
	public int deleteCdcBrMapping(List<Object> delList, Integer crtUserId) {
		int saveCnt	= 0;

		for ( Object obj : delList ) {
			scmMasterManagementMapper.deleteCdcBrMapping((Map<String, Object>) obj);
			saveCnt++;
		}

		return	saveCnt;
	}

//	save Unmap
	@Override
	public int updateCdcLeadTimeMapping(List<Object> insList, Integer crtUserId) {
		int saveCnt	= 0;

		for ( Object obj : insList ) {
			scmMasterManagementMapper.updateCdcLeadTimeMapping((Map<String, Object>) obj);
			saveCnt++;
		}

		return	saveCnt;
	}
}