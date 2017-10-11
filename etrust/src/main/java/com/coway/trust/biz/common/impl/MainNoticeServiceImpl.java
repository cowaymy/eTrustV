/*
\ * Copyright 2008-2009 the original author or authors.
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
package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.MainNoticeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MainNoticeService")
public class MainNoticeServiceImpl extends EgovAbstractServiceImpl implements MainNoticeService {

	private static final Logger Logger = LoggerFactory.getLogger(MainNoticeServiceImpl.class);

	@Resource(name = "MainNoticeMapper")
	private MainNoticeMapper mainNoticeMapper;

		
	/************************** Main Notice ****************************/
	
	@Override
	public List<EgovMap> selectDailyCount(Map<String, Object> params) 
	{
		Logger.debug("ServiceImple MainNotice Info");
		return  mainNoticeMapper.selectDailyCount(params);
	}
	
}