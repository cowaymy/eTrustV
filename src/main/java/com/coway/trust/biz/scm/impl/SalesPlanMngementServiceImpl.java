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

import com.coway.trust.biz.scm.SalesPlanMngementService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("salesPlanMngementService")
public class SalesPlanMngementServiceImpl implements SalesPlanMngementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SalesPlanMngementServiceImpl.class);

	@Autowired
	private SalesPlanMngementMapper salesPlanMngementMapper;
	
	
	// Supply-CDC
	@Override
	public List<EgovMap> selectSupplyCDC(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSupplyCDC(params);
	}
	@Override
	public List<EgovMap> selectSupplyPlanMaster(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSupplyPlanMaster(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanMaster(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSalesPlanMaster(params);
	}
	@Override
	public List<EgovMap> selectComboSupplyCDC(Map<String, Object> params) {
		return salesPlanMngementMapper.selectComboSupplyCDC(params);
	}
	@Override
	public List<EgovMap> selectSupplyCdcSaveFlag(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSupplyCdcSaveFlag(params);
	}
	@Override
	public List<EgovMap> selectSupplyCdcMainList(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSupplyCdcMainList(params);
	}	
	
	
	// Supply-Corp
	@Override
	public List<EgovMap> selectSupplyCorpList(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSupplyCorpList(params);
	}
	
	
	
	// Sales
	@Override
	public List<EgovMap> selectStockCtgrySummary(Map<String, Object> params) {
		return salesPlanMngementMapper.selectStockCtgrySummary(params);
	}
	
	@Override
	public List<EgovMap> selectCalendarHeader(Map<String, Object> params) {
		return salesPlanMngementMapper.selectCalendarHeader(params);
	}
	
	@Override
	public List<EgovMap> selectAccuracyMonthlyHeaderList(Map<String, Object> params) {
		return salesPlanMngementMapper.selectAccuracyMonthlyHeaderList(params);
	}
	
	@Override
	public List<EgovMap> selectExcuteYear(Map<String, Object> params) {
		return salesPlanMngementMapper.selectExcuteYear(params);
	}
	
	@Override
	public List<EgovMap> selectPeriodByYear(Map<String, Object> params) {
		return salesPlanMngementMapper.selectPeriodByYear(params);
	}
	
	@Override
	public List<EgovMap> selectScmTeamCode(Map<String, Object> params) {
		return salesPlanMngementMapper.selectScmTeamCode(params);
	}
	
	@Override
	public List<EgovMap> selectStockCategoryCode(Map<String, Object> params) {
		return salesPlanMngementMapper.selectStockCategoryCode(params);
	}
	
	@Override
	public List<EgovMap> selectStockCode(Map<String, Object> params) {
		return salesPlanMngementMapper.selectStockCode(params);
	}
	
	@Override
	public List<EgovMap> selectDefaultStockCode(Map<String, Object> params) {
		return salesPlanMngementMapper.selectDefaultStockCode(params);
	}
	
	@Override
	public List<EgovMap> selectSalesPlanMngmentList(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSalesPlanMngmentList(params);
	}
	
	@Override
	public List<EgovMap> selectStockIdByStCode(Map<String, Object> params) {
		return salesPlanMngementMapper.selectStockIdByStCode(params);
	}
	
	//
	@Override
	public int updateSCMPlanMaster(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" >>>>> updateSCMPlanMaster ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			
			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );
			
			saveCnt++;
			
			salesPlanMngementMapper.updateScmPlanMaster((Map<String, Object>) obj);
		}
		
		return saveCnt;
	}
	
	//updatePlanByCDC
	@Override
	public int updatePlanByCDC(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" >>>>> updatePlanByCDC ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			
			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );
			
			saveCnt++;
			
			salesPlanMngementMapper.updatePlanByCDC((Map<String, Object>) obj);
		}
		
		return saveCnt;
	}
	
	// INSERT
	@Override
	public int insertSalesPlanDetail(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			LOGGER.debug(" >>>>> insertSalesPlanDetail ");
			saveCnt++;
			salesPlanMngementMapper.insertSalesPlanDetail((Map<String, Object>) obj);
		}
		
		return saveCnt;
	}
	
	@Override
	public List<EgovMap> selectSalesPlanMngmentPeriod(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSalesPlanMngmentPeriod(params);
	}
	
	@Override
	public List<EgovMap> selectPlanId(Map<String, Object> params) {
		return salesPlanMngementMapper.selectPlanId(params);
	}
	
	@Override
	public List<EgovMap> selectSalesCnt(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSalesCnt(params);
	}
	
	@Override
	public List<EgovMap> selectSeperation(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSeperation(params);
	}
	
	@Override
	public List<EgovMap> selectChildField(Map<String, Object> params) {
		return salesPlanMngementMapper.selectChildField(params);
	}
	
	@Override
	public List<EgovMap> selectWeekThSn(Map<String, Object> params) {
		return salesPlanMngementMapper.selectWeekThSn(params);
	}
	
	@Override
	public List<EgovMap> selectRemainWeekTh(Map<String, Object> params) {
		return salesPlanMngementMapper.selectRemainWeekTh(params);
	}
	@Override
	public List<EgovMap> selectMonthCombo(Map<String, Object> params) {
		return salesPlanMngementMapper.selectMonthCombo(params);
	}
	@Override
	public List<EgovMap> selectPlanDetailIdSeq(Map<String, Object> params) {
		return salesPlanMngementMapper.selectPlanDetailIdSeq(params);
	}
	@Override
	public List<EgovMap> selectPlanMasterId(Map<String, Object> params) {
		return salesPlanMngementMapper.selectPlanMasterId(params);
	}
	@Override
	public List<EgovMap> selectAccuracyWeeklyDetail(Map<String, Object> params) {
		return salesPlanMngementMapper.selectAccuracyWeeklyDetail(params);
	}

}
