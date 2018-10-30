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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.ScmInterfaceManagementService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ScmInterfaceManagementService")
public class ScmInterfaceManagementServiceImpl implements ScmInterfaceManagementService {
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmInterfaceManagementServiceImpl.class);

	@Autowired
	private ScmInterfaceManagementMapper	scmInterfaceManagementMapper;

	//	Interface
	@Override
	public List<EgovMap> selectInterfaceList(Map<String, Object> params) {
		String tranDtFrom	= params.get("tranDtFrom").toString();
		String tranDtTo		= params.get("tranDtTo").toString();
		LOGGER.debug("tranDtFrom : " + tranDtFrom + ", tranDtTo : " + tranDtTo);
		tranDtFrom	= tranDtFrom.replace("/", "");
		tranDtTo	= tranDtTo.replace("/", "");
		
		tranDtFrom	= tranDtFrom.substring(4, 8) + tranDtFrom.substring(2, 4) + tranDtFrom.substring(0, 2);
		tranDtTo	= tranDtTo.substring(4, 8) + tranDtTo.substring(2, 4) + tranDtTo.substring(0, 2);
		
		params.put("tranDtFrom", tranDtFrom);
		params.put("tranDtTo", tranDtTo);
		LOGGER.debug("tranDtFrom : " + tranDtFrom + ", tranDtTo : " + tranDtTo);
		return	scmInterfaceManagementMapper.selectInterfaceList(params);
	}
	@Override
	public int doInterface(List<Map<String, Object>> chkList, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		int crtUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();
		
		try {
			for ( Map<String, Object> list : chkList ) {
				//	do anything
				
				scmInterfaceManagementMapper.doInterface(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	@Override
	public int scmIf155(List<Map<String, Object>> chkList, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		int crtUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();
		
		try {
			for ( Map<String, Object> list : chkList ) {
				LOGGER.debug("chkList : ", list);
				params.put("crtUserId", crtUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemNo", list.get("poItemNo"));
				scmInterfaceManagementMapper.scmIf155(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
}