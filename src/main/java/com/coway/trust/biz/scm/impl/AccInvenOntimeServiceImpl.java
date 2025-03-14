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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.scm.AccInvenOntimeService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AccInvenOntimeService")
public class AccInvenOntimeServiceImpl implements AccInvenOntimeService {

	@Autowired
	private AccInvenOntimeMapper accInvenOntimeMapper;
	
	
	// 	//On-Time Delivery
	@Override
	public List<EgovMap> selectOnTimeDeliverySearch(Map<String, Object> params) {
		return accInvenOntimeMapper.selectOnTimeDeliverySearch(params);
	}
	
	@Override
	public List<EgovMap> selectOnTimeWeeklyStartPoint(Map<String, Object> params) {
		return accInvenOntimeMapper.selectOnTimeWeeklyStartPoint(params);
	}
	
	@Override
	public List<EgovMap> selectOnTimeCalculStatus(Map<String, Object> params) {
		return accInvenOntimeMapper.selectOnTimeCalculStatus(params);
	}
	
	
	@Override
	public List<EgovMap> selectOnTimeWeeklyList(Map<String, Object> params) {
		return accInvenOntimeMapper.selectOnTimeWeeklyList(params);
	}
	
	@Override
	public List<EgovMap> selectOnTimeMonthly(Map<String, Object> params) {
		return accInvenOntimeMapper.selectOnTimeMonthly(params);
	}
	
	
	// Inventory Report	
	@Override
	public List<EgovMap> selectInvenRptTotalStatus(Map<String, Object> params) {
		return accInvenOntimeMapper.selectInvenRptTotalStatus(params);
	}
	@Override
	public List<EgovMap> selectPreviosMonth(Map<String, Object> params) {
		return accInvenOntimeMapper.selectPreviosMonth(params);
	}
	@Override
	public List<EgovMap> selectInvenMainAmountList(Map<String, Object> params) {
		return accInvenOntimeMapper.selectInvenMainAmountList(params);
	}
	@Override
	public List<EgovMap> selectInvenMainQtyList(Map<String, Object> params) {
		return accInvenOntimeMapper.selectInvenMainQtyList(params);
	}
	@Override
	public List<EgovMap> selectDetailAmountList(Map<String, Object> params) {
		return accInvenOntimeMapper.selectDetailAmountList(params);
	}
	@Override
	public List<EgovMap> selectDetailQuantityList(Map<String, Object> params) {
		return accInvenOntimeMapper.selectDetailQuantityList(params);
	}

}
