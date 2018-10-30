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
			if ( null != ((Map<String, Object>) obj).get("startDt") ) {
				startDt	= ((Map<String, Object>) obj).get("startDt").toString();
				LOGGER.debug("startDt : " + startDt);
				startDt	= startDt.replace("-", "");	startDt	= startDt.replace("/", "");
				startDt	= startDt.substring(4, 8) + startDt.substring(0, 2) + startDt.substring(2, 4);
				((Map<String, Object>) obj).put("startDt", startDt);
				LOGGER.debug("startDt : " + startDt);
			}
			if ( null != ((Map<String, Object>) obj).get("endDt") ) {
				endDt	= ((Map<String, Object>) obj).get("endDt").toString();
				LOGGER.debug("startDt : " + startDt);
				endDt	= endDt.replace("-", "");	endDt	= endDt.replace("/", "");
				endDt	= endDt.substring(4, 8) + endDt.substring(0, 2) + endDt.substring(2, 4);
				((Map<String, Object>) obj).put("endDt", endDt);
				LOGGER.debug("endDt : " + endDt);
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
			((Map<String, Object>) obj).put("stockId", ((Map<String, Object>) obj).get("stockId"));
			
			//	KL
			((Map<String, Object>) obj).put("cdc", "2010");
			if ( null != ((Map<String, Object>) obj).get("klTarget") ) {
				isTrget	= ((Map<String, Object>) obj).get("klTarget").toString();
				if ( "1".equals(isTrget) ) {
					if ( null != ((Map<String, Object>) obj).get("klMoq") ) {
						((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("klMoq"));
					} else {
						((Map<String, Object>) obj).put("moq", 0);
					}
					((Map<String, Object>) obj).put("isTrget", 1);
					cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
				} else {
					scmMasterManagementMapper.deleteScmMaster2((Map<String, Object>) obj);
				}
			}
			isTrget	= "";
			
			//	PN
			((Map<String, Object>) obj).put("cdc", "2020");
			if ( null != ((Map<String, Object>) obj).get("pnTarget") ) {
				isTrget	= ((Map<String, Object>) obj).get("pnTarget").toString();
				if ( "1".equals(isTrget) ) {
					if ( null != ((Map<String, Object>) obj).get("pnMoq") ) {
						((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("pnMoq"));
					} else {
						((Map<String, Object>) obj).put("moq", 0);
					}
					((Map<String, Object>) obj).put("isTrget", 1);
					cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
				} else {
					scmMasterManagementMapper.deleteScmMaster2((Map<String, Object>) obj);
				}
			}
			isTrget	= "";
			
			//	JB
			((Map<String, Object>) obj).put("cdc", "2030");
			if ( null != ((Map<String, Object>) obj).get("jbTarget") ) {
				isTrget	= ((Map<String, Object>) obj).get("jbTarget").toString();
				if ( "1".equals(isTrget) ) {
					if ( null != ((Map<String, Object>) obj).get("jbMoq") ) {
						((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("jbMoq"));
					} else {
						((Map<String, Object>) obj).put("moq", 0);
					}
					((Map<String, Object>) obj).put("isTrget", 1);
					cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
				} else {
					scmMasterManagementMapper.deleteScmMaster2((Map<String, Object>) obj);
				}
			}
			isTrget	= "";
			
			//	KK
			((Map<String, Object>) obj).put("cdc", "2040");
			if ( null != ((Map<String, Object>) obj).get("kkTarget") ) {
				isTrget	= ((Map<String, Object>) obj).get("kkTarget").toString();
				if ( "1".equals(isTrget) ) {
					if ( null != ((Map<String, Object>) obj).get("kkMoq") ) {
						((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kkMoq"));
					} else {
						((Map<String, Object>) obj).put("moq", 0);
					}
					((Map<String, Object>) obj).put("isTrget", 1);
					cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
				} else {
					scmMasterManagementMapper.deleteScmMaster2((Map<String, Object>) obj);
				}
			}
			isTrget	= "";
			
			//	KC
			((Map<String, Object>) obj).put("cdc", "2050");
			if ( null != ((Map<String, Object>) obj).get("kcTarget") ) {
				isTrget	= ((Map<String, Object>) obj).get("kcTarget").toString();
				if ( "1".equals(isTrget) ) {
					if ( null != ((Map<String, Object>) obj).get("kcMoq") ) {
						((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kcMoq"));
					} else {
						((Map<String, Object>) obj).put("moq", 0);
					}
					((Map<String, Object>) obj).put("isTrget", 1);
					cnt	= cnt + scmMasterManagementMapper.saveScmMaster2((Map<String, Object>) obj);
				} else {
					scmMasterManagementMapper.deleteScmMaster2((Map<String, Object>) obj);
				}
			}
			isTrget	= "";
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
			scmMasterManagementMapper.deleteCdcWhMapping((Map<String, Object>) obj);
			saveCnt++;
		}
		
		return	saveCnt;
	}
}