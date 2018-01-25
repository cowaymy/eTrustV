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
import com.coway.trust.cmmn.model.SessionVO;

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
	
	@Override
	public List<EgovMap> selectSupplyCdcPop(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSupplyCdcPop(params);
	}	

	@Override
	public List<EgovMap> selectPlanDatePlanByCdc(Map<String, Object> params) {
		return salesPlanMngementMapper.selectPlanDatePlanByCdc(params);
	}	
	
	@Override
	public List<EgovMap> selectPlanIdByCdc(Map<String, Object> params) {
		return salesPlanMngementMapper.selectPlanIdByCdc(params);
	}	
	
	@Override
	public List<EgovMap> selectMonthPlanByCdc(Map<String, Object> params) {
		return salesPlanMngementMapper.selectMonthPlanByCdc(params);
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
	
	/* CDC Master Detail Insert  */
	@Override
	public int insertSalesPlanMstCdc(Map<String, Object> params, SessionVO sessionVO)
	{
		int saveCnt = 0;
		
		params.put("crtUserId", sessionVO.getUserId());
		// SCM0005M Insert
		//salesPlanMngementMapper.insertSalesPlanMstCdc(params);
		
		saveCnt++;
		// SCM0006D Insert
		salesPlanMngementMapper.insertSalesCdcDetail(params);
		
		LOGGER.debug(" return_Params : {} , SaveCnt: {} ", params.toString(), saveCnt );
		
		return saveCnt;
	}
	
	/* Order Summary Stored Procedure  */
	@Override
	public String callSpCreateSupplyPlanSummary(Map<String, Object> params, SessionVO sessionVO)
	{
		String returnValue = "OkSP";
		String selectPlanMonth = salesPlanMngementMapper.selectMonthCombo(params).get(0).get("scmMonth").toString();
		
		params.put("planMonth", selectPlanMonth);
		params.put("crtUserId", sessionVO.getUserId());
		
		salesPlanMngementMapper.callSpCreateSupplyPlanSummary(params); 
		
		LOGGER.debug("SupplyPlanSummary Return_Params : {} , returnValue: {} ", params.toString(), params.get("rtnVal").toString() );
		
		if (!"O.K".equals(params.get("rtnVal")))
		  returnValue = "FailSP"+ "_" + params.get("planMonth").toString();
		else
		  returnValue = returnValue + "_" + params.get("planMonth").toString();
		
		return returnValue;
	}
	
	@Override
	public int insertSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO)
	{
		int saveCnt = 0;
		
		params.put("crtUserId", sessionVO.getUserId());
		
		salesPlanMngementMapper.insertSalesPlanMaster(params);
		
		saveCnt++;
		
		salesPlanMngementMapper.callSpCreateSalesPlanDetail(params);
		
		LOGGER.debug(" return_Params : {} , SaveCnt: {} ", params.toString(), saveCnt );
		
		return saveCnt;
	}

	@Override
	public String callSpCreateMonthlyAccuracy(Map<String, Object> params)
	{
		String returnValue = "OkSP";
		
		salesPlanMngementMapper.callSpCreateMonthlyAccuracy(params);
		
		LOGGER.debug("Accruracy Return_Params : {} , returnValue: {} ", params.toString(), params.get("rtnVal").toString() );
		
		if (!"O.K".equals(params.get("rtnVal")))
		  returnValue = "FailSP";
		
		return returnValue;
	}
	
	@Override
	public int deleteStockCode(List<Object> delList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : delList) 
		{
			LOGGER.debug(" delList : {} ", delList.toString() );
			
			salesPlanMngementMapper.deleteStockCode((Map<String, Object>) obj);
			
			saveCnt++;
			
			LOGGER.debug(" saveCnt : {} ", saveCnt);

		}
		
		return saveCnt;
	}
	
	@Override
	public int updateSalesPlanUnConfirm(Map<String, Object> params, SessionVO sessionVO)
	{
        int saveCnt = 0;		
        int totCnt = 0;	
        
		params.put("updateSalesPlanUnConfirm_Params", params.toString() );
		
		saveCnt = salesPlanMngementMapper.updateSalesPlanUnConfirm(params);
  
		totCnt = totCnt + saveCnt;
		
		return totCnt;
	}
	
	@Override
	public int updateSalesPlanConfirm(Map<String, Object> params, SessionVO sessionVO)
	{
		int saveCnt = 0;		
		int totCnt = 0;	
		
		params.put("updateSalesPlanConfirm_Params", params.toString() );
		
		saveCnt = salesPlanMngementMapper.updateSalesPlanConfirm(params);
		
		totCnt = totCnt + saveCnt;
		
		return totCnt;
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
	@Override
	public List<EgovMap> selectAccuracyMonthlyReport(Map<String, Object> params) {
		return salesPlanMngementMapper.selectAccuracyMonthlyReport(params);
	}

}
