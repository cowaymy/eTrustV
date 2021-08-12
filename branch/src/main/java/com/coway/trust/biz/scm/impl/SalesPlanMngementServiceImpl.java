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
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
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

		List<EgovMap> monthList = salesPlanMngementMapper.selectScmMonth(params);

		String calendarYear = params.get("scmYearCbBox").toString();
		String calendarMonth = monthList.get(0).get("scmMonth").toString();
		if(calendarMonth.length() < 2){
			calendarMonth = "0" + calendarMonth;
		}

		DateFormat dateFormat = new SimpleDateFormat("yyyyMM");
        DateFormat yyyyFormat = new SimpleDateFormat("yyyy");
        DateFormat mmFormat = new SimpleDateFormat("MM");
	    Date date = null;
	    try {
	           date = dateFormat.parse(calendarYear+calendarMonth);
	    } catch (ParseException e) {
	          e.printStackTrace();
	    }
	    Calendar cal = Calendar.getInstance();
	    cal.setTime(date);

	    cal.add(Calendar.MONTH, 3);

	    String yyyy = yyyyFormat.format(cal.getTime());
        String mm = mmFormat.format(cal.getTime());

		params.put("calendarFrom", calendarYear+calendarMonth);
		params.put("calendarTo", yyyy+mm);

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
	public List<EgovMap> selectSalesPlanMngmentGroupList(Map<String, Object> params) {
		return salesPlanMngementMapper.selectSalesPlanMngmentGroupList(params);
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


			List<EgovMap> yearMonthList = salesPlanMngementMapper.selectScmYearMonthWeek((Map<String, Object>) obj);

			String planYear = yearMonthList.get(0).get("planYear").toString();
			String planMonth = yearMonthList.get(0).get("planMonth").toString();
			String weekth = yearMonthList.get(0).get("planWeek").toString();

			((Map<String, Object>) obj).put("scmYearCbBox", planYear);
			((Map<String, Object>) obj).put("selectPlanMonth", planMonth);

			List<EgovMap> seperaionMap = salesPlanMngementMapper.selectSeperation2((Map<String, Object>) obj);
			List<EgovMap> chield = salesPlanMngementMapper.selectChildField((Map<String, Object>) obj);

			//Safety Stock 구하기
			String iM0TotCnt = seperaionMap.get(0).get("m0TotCnt").toString();
			String iM1TotCnt = seperaionMap.get(0).get("m1TotCnt").toString();
			String iM2TotCnt = seperaionMap.get(0).get("m2TotCnt").toString();
			String iM3TotCnt = seperaionMap.get(0).get("m3TotCnt").toString();
			String iM4TotCnt = seperaionMap.get(0).get("m4TotCnt").toString();

			String intToStrFieldCnt ="";
		    int iLootDataFieldCnt = 0;
		    int m0Sum = 0;
		    int m1Sum = 0;
		    int m2Sum = 0;
		    int m3Sum = 0;
		    int m4Sum = 0;

		    LOGGER.debug(" >>>>> iM0TotCnt : " + iM0TotCnt);
		    LOGGER.debug(" >>>>> iM1TotCnt : " + iM1TotCnt);
		    LOGGER.debug(" >>>>> iM2TotCnt : " + iM2TotCnt);
		    LOGGER.debug(" >>>>> iM3TotCnt : " + iM3TotCnt);
		    LOGGER.debug(" >>>>> iM4TotCnt : " + iM4TotCnt);

			for(int m1=0;m1<Integer.parseInt(iM0TotCnt);m1++){
				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            LOGGER.debug(" >>>>> intToStrFieldCnt : " + intToStrFieldCnt);

		        if (Integer.parseInt(chield.get(m1).get("weekTh").toString()) <  Integer.parseInt(weekth) && m1 != Integer.parseInt(iM0TotCnt)-1 ){
		        	LOGGER.debug(" >>>>> if true : " );
		        } else {
		        	LOGGER.debug(" >>>>> if false : " + ((Map<String, Object>) obj));
		        	LOGGER.debug(" >>>>> if false : " + ((Map<String, Object>) obj).get("w" + intToStrFieldCnt));
		        	//LOGGER.debug(" >>>>> if false : " + ((Map<String, Object>) obj).get("w" + intToStrFieldCnt).toString());
		        	//	w00이 null로 들어오는 경우가 있음 : 스플릿 주차
		        	if ( null !=  ((Map<String, Object>) obj).get("w" + intToStrFieldCnt) ) {
		        		m0Sum = m0Sum+Integer.parseInt(getReplaceStr(((Map<String, Object>) obj).get("w"+intToStrFieldCnt).toString(),",",""));
		        	}
		        	iLootDataFieldCnt++;
	            }
			}

			String intToStrFieldCnt2 ="";
			int iLootDataFieldCnt2 = 0;

			for(int m1=0;m1<Integer.parseInt(iM0TotCnt);m1++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }

		        if (Integer.parseInt(chield.get(m1).get("weekTh").toString()) <  Integer.parseInt(weekth) && m1 != Integer.parseInt(iM0TotCnt)-1 ){

		        } else {
		        	((Map<String, Object>) obj).put("m0", m0Sum);
		        	iLootDataFieldCnt2++;
		        }

			}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	            	intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m1Sum = m1Sum+Integer.parseInt(getReplaceStr(((Map<String, Object>) obj).get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
		 	}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            ((Map<String, Object>) obj).put("m1", m1Sum);
				iLootDataFieldCnt2++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m2Sum = m2Sum+Integer.parseInt(getReplaceStr(((Map<String, Object>) obj).get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            ((Map<String, Object>) obj).put("m2", m2Sum);
				iLootDataFieldCnt2++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m3Sum = m3Sum+Integer.parseInt(getReplaceStr(((Map<String, Object>) obj).get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            ((Map<String, Object>) obj).put("m3", m3Sum);
			    iLootDataFieldCnt2++;
			}

			for(int m4=0;m4<Integer.parseInt(iM4TotCnt);m4++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt-1);


	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m4Sum = m4Sum+Integer.parseInt(getReplaceStr(((Map<String, Object>) obj).get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m4=0;m4<Integer.parseInt(iM4TotCnt);m4++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            ((Map<String, Object>) obj).put("m4", m4Sum);
			    iLootDataFieldCnt2++;
			}

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

	/* CDC Master Insert  */
	@Override
	public String insertSalesPlanMstCdc(Map<String, Object> params, SessionVO sessionVO)
	{
		String planId = salesPlanMngementMapper.selectSalesPlanMstId(params).get(0).get("seq").toString();

		params.put("crtUserId", sessionVO.getUserId());
		params.put("salesPlanMstCdcSeq",planId);
		// SCM0005M Insert
		salesPlanMngementMapper.insertSalesPlanMstCdc(params);

		return planId;
	}

	/* CDC Master Detail Insert  */
	@Override
	public int insertSalesCdcDetail(Map<String, Object> params, SessionVO sessionVO)
	{
		int saveCnt = 0;

		params.put("crtUserId", sessionVO.getUserId());
		// SCM0005M Insert
		//salesPlanMngementMapper.insertSalesPlanMstCdc(params);

		saveCnt++;

		List<EgovMap> supplyList = salesPlanMngementMapper.selectSupplyPlanListByCdc(params);

		List<EgovMap> monthList = salesPlanMngementMapper.selectScmMonth(params);

		String planMonth = monthList.get(0).get("scmMonth").toString();

		params.put("selectPlanMonth", planMonth);

		List<EgovMap> chield = salesPlanMngementMapper.selectChildField(params);

		List<EgovMap> seperaionMap = salesPlanMngementMapper.selectSeperation2(params);

		int countBef = salesPlanMngementMapper.selectCountasIn(params);

		for(int i=0 ; i < supplyList.size(); i++){
			String stockCode = supplyList.get(i).get("stockCode").toString();
			int moq = Integer.parseInt(supplyList.get(i).get("moq").toString());
			params.put("stockCode", stockCode);

			Map<String, Object> psi1Params = new HashMap<String, Object>();
			Map<String, Object> psi2Params = new HashMap<String, Object>();
			Map<String, Object> psi3Params = new HashMap<String, Object>();
			Map<String, Object> psi4Params = new HashMap<String, Object>();
			Map<String, Object> psi5Params = new HashMap<String, Object>();

			psi1Params.put("psiId", "1");
			psi1Params.put("psiName", "Sales Plan/SO");
			psi1Params.put("scmYearCbBox", params.get("scmYearCbBox").toString());
			psi1Params.put("scmPeriodCbBox", params.get("scmPeriodCbBox").toString());
			psi1Params.put("cdcCbBox", params.get("cdcCbBox").toString());
			psi1Params.put("stockCodeCbBox", params.get("stockCodeCbBox").toString());
			psi1Params.put("scmStockType", params.get("scmStockType").toString());
			psi1Params.put("crtUserId", params.get("crtUserId").toString());
			psi1Params.put("salesPlanMstCdcSeq", params.get("salesPlanMstCdcSeq").toString());
			psi1Params.put("selectPlanMonth", params.get("selectPlanMonth").toString());
			psi1Params.put("stockCode", stockCode);

			psi2Params.put("psiId", "2");
			psi2Params.put("psiName", "Safety Stock");
			psi2Params.put("scmYearCbBox", params.get("scmYearCbBox").toString());
			psi2Params.put("scmPeriodCbBox", params.get("scmPeriodCbBox").toString());
			psi2Params.put("cdcCbBox", params.get("cdcCbBox").toString());
			psi2Params.put("stockCodeCbBox", params.get("stockCodeCbBox").toString());
			psi2Params.put("scmStockType", params.get("scmStockType").toString());
			psi2Params.put("crtUserId", params.get("crtUserId").toString());
			psi2Params.put("salesPlanMstCdcSeq", params.get("salesPlanMstCdcSeq").toString());
			psi2Params.put("selectPlanMonth", params.get("selectPlanMonth").toString());
			psi2Params.put("stockCode", stockCode);

			psi3Params.put("psiId", "3");
			psi3Params.put("psiName", "PO & FCST");
			psi3Params.put("scmYearCbBox", params.get("scmYearCbBox").toString());
			psi3Params.put("scmPeriodCbBox", params.get("scmPeriodCbBox").toString());
			psi3Params.put("cdcCbBox", params.get("cdcCbBox").toString());
			psi3Params.put("stockCodeCbBox", params.get("stockCodeCbBox").toString());
			psi3Params.put("scmStockType", params.get("scmStockType").toString());
			psi3Params.put("crtUserId", params.get("crtUserId").toString());
			psi3Params.put("salesPlanMstCdcSeq", params.get("salesPlanMstCdcSeq").toString());
			psi3Params.put("selectPlanMonth", params.get("selectPlanMonth").toString());
			psi3Params.put("stockCode", stockCode);

			psi4Params.put("psiId", "4");
			psi4Params.put("psiName", "Supply Plan");
			psi4Params.put("scmYearCbBox", params.get("scmYearCbBox").toString());
			psi4Params.put("scmPeriodCbBox", params.get("scmPeriodCbBox").toString());
			psi4Params.put("cdcCbBox", params.get("cdcCbBox").toString());
			psi4Params.put("stockCodeCbBox", params.get("stockCodeCbBox").toString());
			psi4Params.put("scmStockType", params.get("scmStockType").toString());
			psi4Params.put("crtUserId", params.get("crtUserId").toString());
			psi4Params.put("salesPlanMstCdcSeq", params.get("salesPlanMstCdcSeq").toString());
			psi4Params.put("selectPlanMonth", params.get("selectPlanMonth").toString());
			psi4Params.put("stockCode", stockCode);

			psi5Params.put("psiId", "5");
			psi5Params.put("psiName", "Inventory by CDC");
			psi5Params.put("scmYearCbBox", params.get("scmYearCbBox").toString());
			psi5Params.put("scmPeriodCbBox", params.get("scmPeriodCbBox").toString());
			psi5Params.put("cdcCbBox", params.get("cdcCbBox").toString());
			psi5Params.put("stockCodeCbBox", params.get("stockCodeCbBox").toString());
			psi5Params.put("scmStockType", params.get("scmStockType").toString());
			psi5Params.put("crtUserId", params.get("crtUserId").toString());
			psi5Params.put("salesPlanMstCdcSeq", params.get("salesPlanMstCdcSeq").toString());
			psi5Params.put("selectPlanMonth", params.get("selectPlanMonth").toString());
			psi5Params.put("stockCode", stockCode);

			if(params.get("selectPlanMonth").toString().equals("1")){
				params.put("selectYearBefore",  Integer.parseInt(params.get("scmYearCbBox").toString())-1);
				params.put("selectPlanMonthBefore",  12);
			} else {
				params.put("selectYearBefore",  Integer.parseInt(params.get("scmYearCbBox").toString()));
				params.put("selectPlanMonthBefore",  Integer.parseInt(params.get("selectPlanMonth").toString())-1);
			}

			params.put("selectYearBeforeWeekParam",  Integer.parseInt(params.get("scmYearCbBox").toString())-1);
			int weekBeforeYear = salesPlanMngementMapper.selectBeforeWeekYear(params);
			params.put("selectPlanWeekBeforeYear",  weekBeforeYear);


			List<EgovMap> leadTimeList = salesPlanMngementMapper.selectLeadTimeByCdc(params);

			int leadTime = Integer.parseInt(leadTimeList.get(0).get("leadTm").toString());

			int safetyStock = salesPlanMngementMapper.selectSafetyStock(params);

			int endingInventory = salesPlanMngementMapper.selectEndingInventory(params);

			//Sales Plan 값 구하기
			List<EgovMap> salesPlanList =   salesPlanMngementMapper.selectSalesPlanByStockCode(params);

			if(salesPlanList.size() > 0){

			psi1Params.put("w00", Integer.parseInt(salesPlanList.get(0).get("w00").toString()));
			psi1Params.put("w01", Integer.parseInt(salesPlanList.get(0).get("w01").toString()));
			psi1Params.put("w02", Integer.parseInt(salesPlanList.get(0).get("w02").toString()));
			psi1Params.put("w03", Integer.parseInt(salesPlanList.get(0).get("w03").toString()));
			psi1Params.put("w04", Integer.parseInt(salesPlanList.get(0).get("w04").toString()));
			psi1Params.put("w05", Integer.parseInt(salesPlanList.get(0).get("w05").toString()));
			psi1Params.put("w06", Integer.parseInt(salesPlanList.get(0).get("w06").toString()));
			psi1Params.put("w07", Integer.parseInt(salesPlanList.get(0).get("w07").toString()));
			psi1Params.put("w08", Integer.parseInt(salesPlanList.get(0).get("w08").toString()));
			psi1Params.put("w09", Integer.parseInt(salesPlanList.get(0).get("w09").toString()));
			psi1Params.put("w10", Integer.parseInt(salesPlanList.get(0).get("w10").toString()));
			psi1Params.put("w11", Integer.parseInt(salesPlanList.get(0).get("w11").toString()));
			psi1Params.put("w12", Integer.parseInt(salesPlanList.get(0).get("w12").toString()));
			psi1Params.put("w13", Integer.parseInt(salesPlanList.get(0).get("w13").toString()));
			psi1Params.put("w14", Integer.parseInt(salesPlanList.get(0).get("w14").toString()));
			psi1Params.put("w15", Integer.parseInt(salesPlanList.get(0).get("w15").toString()));
			psi1Params.put("w16", Integer.parseInt(salesPlanList.get(0).get("w16").toString()));
			psi1Params.put("w17", Integer.parseInt(salesPlanList.get(0).get("w17").toString()));
			psi1Params.put("w18", Integer.parseInt(salesPlanList.get(0).get("w18").toString()));
			psi1Params.put("w19", Integer.parseInt(salesPlanList.get(0).get("w19").toString()));
			psi1Params.put("w20", Integer.parseInt(salesPlanList.get(0).get("w20").toString()));
			psi1Params.put("w21", Integer.parseInt(salesPlanList.get(0).get("w21").toString()));
			psi1Params.put("w22", Integer.parseInt(salesPlanList.get(0).get("w22").toString()));
			psi1Params.put("w23", Integer.parseInt(salesPlanList.get(0).get("w23").toString()));
			psi1Params.put("w24", Integer.parseInt(salesPlanList.get(0).get("w24").toString()));
			psi1Params.put("w25", Integer.parseInt(salesPlanList.get(0).get("w25").toString()));
			psi1Params.put("w26", Integer.parseInt(salesPlanList.get(0).get("w26").toString()));
			psi1Params.put("w27", Integer.parseInt(salesPlanList.get(0).get("w27").toString()));
			psi1Params.put("w28", Integer.parseInt(salesPlanList.get(0).get("w28").toString()));
			psi1Params.put("w29", Integer.parseInt(salesPlanList.get(0).get("w29").toString()));
			psi1Params.put("w30", Integer.parseInt(salesPlanList.get(0).get("w30").toString()));


			for(int j=0; j  < countBef; j++ ){
				int k = j+1;
				int beforeWeek = Integer.parseInt(params.get("scmPeriodCbBox").toString()) - k;
				params.put("scmPeriodCbBoxBefore", beforeWeek);
				int befOrdCnt = salesPlanMngementMapper.selectBeforeOrdCnt(params);
				psi1Params.put("ws" + j, befOrdCnt);
			}



			//Safety Stock 구하기
			String iM0TotCnt = seperaionMap.get(0).get("m0TotCnt").toString();
			String iM1TotCnt = seperaionMap.get(0).get("m1TotCnt").toString();
			String iM2TotCnt = seperaionMap.get(0).get("m2TotCnt").toString();
			String iM3TotCnt = seperaionMap.get(0).get("m3TotCnt").toString();
			String iM4TotCnt = seperaionMap.get(0).get("m4TotCnt").toString();

			String weekth = params.get("scmPeriodCbBox").toString();

			int m0Sum = 0;
			int m1Sum = 0;
			int m2Sum = 0;
			int m3Sum = 0;
			int m4Sum = 0;

			psi2Params.put("w08",0);
			psi2Params.put("w09",0);
			psi2Params.put("w10",0);
			psi2Params.put("w11",0);
			psi2Params.put("w12",0);
			psi2Params.put("w13",0);
			psi2Params.put("w14",0);
			psi2Params.put("w15",0);
			psi2Params.put("w16",0);
			psi2Params.put("w17",0);
			psi2Params.put("w18",0);
			psi2Params.put("w19",0);
			psi2Params.put("w20",0);
			psi2Params.put("w21",0);
			psi2Params.put("w22",0);
			psi2Params.put("w23",0);
			psi2Params.put("w24",0);
			psi2Params.put("w25",0);
			psi2Params.put("w26",0);
			psi2Params.put("w27",0);
			psi2Params.put("w28",0);
			psi2Params.put("w29",0);
			psi2Params.put("w30",0);

			/**
			 *  m0, m1, m2, m3, m4  각 달에 해당하는 주차들의 판매계획  합 구하기  => safetystock 공식을 위해 계산
			*/

		    String intToStrFieldCnt ="";
		    int iLootDataFieldCnt = 0;

			for(int m1=0;m1<Integer.parseInt(iM0TotCnt);m1++){
				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

		        if (Integer.parseInt(chield.get(m1).get("weekTh").toString()) <  Integer.parseInt(weekth) && m1 != Integer.parseInt(iM0TotCnt)-1 ){
		        } else {
		        	m0Sum = m0Sum+Integer.parseInt(getReplaceStr(psi1Params.get("w"+intToStrFieldCnt).toString(),",",""));
		        	iLootDataFieldCnt++;
	            }
			}

			String intToStrFieldCnt2 ="";
			int iLootDataFieldCnt2 = 0;

			for(int m1=0;m1<Integer.parseInt(iM0TotCnt);m1++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }

		        if (Integer.parseInt(chield.get(m1).get("weekTh").toString()) <  Integer.parseInt(weekth) && m1 != Integer.parseInt(iM0TotCnt)-1 ){

		        } else {
		        	psi1Params.put("m0", m0Sum);
		        	psi2Params.put("m0", (safetyStock*m0Sum)/30);
		        	psi2Params.put("w"+intToStrFieldCnt2, m0Sum);
		        	iLootDataFieldCnt2++;
		        }

			}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	            	intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m1Sum = m1Sum+Integer.parseInt(getReplaceStr(psi1Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
		 	}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi1Params.put("m1", m1Sum);
	            psi2Params.put("m1", (safetyStock*m1Sum)/30);
	            psi2Params.put("w"+intToStrFieldCnt2, m1Sum);
				iLootDataFieldCnt2++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m2Sum = m2Sum+Integer.parseInt(getReplaceStr(psi1Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi1Params.put("m2", m2Sum);
	            psi2Params.put("m2", (safetyStock*m2Sum)/30);
	            psi2Params.put("w"+intToStrFieldCnt2, m2Sum);
				iLootDataFieldCnt2++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m3Sum = m3Sum+Integer.parseInt(getReplaceStr(psi1Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi1Params.put("m3", m3Sum);
	            psi2Params.put("m3", (safetyStock*m3Sum)/30);
	            psi2Params.put("w"+intToStrFieldCnt2, m3Sum);
			    iLootDataFieldCnt2++;
			}

			for(int m4=0;m4<Integer.parseInt(iM4TotCnt);m4++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt-1);


	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m4Sum = m4Sum+Integer.parseInt(getReplaceStr(psi1Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m4=0;m4<Integer.parseInt(iM4TotCnt);m4++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi1Params.put("m4", m4Sum);
	            psi2Params.put("m4", (safetyStock*m4Sum)/30);
	            psi2Params.put("w"+intToStrFieldCnt2, m4Sum);
			    iLootDataFieldCnt2++;
			}

		      /**
		       *  주차가 1-1 1-2 처럼 쪼개져 있으면  리드타임 +1 해준다. 1-1, 1-2 는 한 셋트이다.
		       */
			 for(int sn=0; sn < chield.size(); sn++){
				 String weekThSn = chield.get(sn).get("weekThSn").toString();
				 if(weekThSn.equals("2")){
					 leadTime = leadTime + 1;
				 }
			 }

			 /**
			  *  safestock 공식  = (safestock * 해당 주차가 속한 월의 판매계획들의  합)/30
			  *
			  */

			/* if(leadTime==8){
				 psi2Params.put("w08",(safetyStock*Integer.parseInt(psi2Params.get("w08").toString()))/30);
				 psi2Params.put("w09",(safetyStock*Integer.parseInt(psi2Params.get("w09").toString()))/30);
				 psi2Params.put("w10",(safetyStock*Integer.parseInt(psi2Params.get("w10").toString()))/30);
			 }else if(leadTime==9){
				 psi2Params.put("w09",(safetyStock*Integer.parseInt(psi2Params.get("w09").toString()))/30);
				 psi2Params.put("w10",(safetyStock*Integer.parseInt(psi2Params.get("w10").toString()))/30);
			 }else if(leadTime==10){
				 psi2Params.put("w10",(safetyStock*Integer.parseInt(psi2Params.get("w10").toString()))/30);
			 }*/

			 psi2Params.put("w00",(safetyStock*Integer.parseInt(psi2Params.get("w00").toString()))/30);
			 psi2Params.put("w01",(safetyStock*Integer.parseInt(psi2Params.get("w02").toString()))/30);
			 psi2Params.put("w02",(safetyStock*Integer.parseInt(psi2Params.get("w02").toString()))/30);
			 psi2Params.put("w03",(safetyStock*Integer.parseInt(psi2Params.get("w03").toString()))/30);
			 psi2Params.put("w04",(safetyStock*Integer.parseInt(psi2Params.get("w04").toString()))/30);
			 psi2Params.put("w05",(safetyStock*Integer.parseInt(psi2Params.get("w05").toString()))/30);
			 psi2Params.put("w06",(safetyStock*Integer.parseInt(psi2Params.get("w06").toString()))/30);
			 psi2Params.put("w07",(safetyStock*Integer.parseInt(psi2Params.get("w07").toString()))/30);
			 psi2Params.put("w08",(safetyStock*Integer.parseInt(psi2Params.get("w08").toString()))/30);
			 psi2Params.put("w09",(safetyStock*Integer.parseInt(psi2Params.get("w09").toString()))/30);
			 psi2Params.put("w10",(safetyStock*Integer.parseInt(psi2Params.get("w10").toString()))/30);
			 psi2Params.put("w11",(safetyStock*Integer.parseInt(psi2Params.get("w11").toString()))/30);
			 psi2Params.put("w12",(safetyStock*Integer.parseInt(psi2Params.get("w12").toString()))/30);
			 psi2Params.put("w13",(safetyStock*Integer.parseInt(psi2Params.get("w13").toString()))/30);
			 psi2Params.put("w14",(safetyStock*Integer.parseInt(psi2Params.get("w14").toString()))/30);
			 psi2Params.put("w15",(safetyStock*Integer.parseInt(psi2Params.get("w15").toString()))/30);
			 psi2Params.put("w16",(safetyStock*Integer.parseInt(psi2Params.get("w16").toString()))/30);
			 psi2Params.put("w17",(safetyStock*Integer.parseInt(psi2Params.get("w17").toString()))/30);
			 psi2Params.put("w18",(safetyStock*Integer.parseInt(psi2Params.get("w18").toString()))/30);
			 psi2Params.put("w19",(safetyStock*Integer.parseInt(psi2Params.get("w19").toString()))/30);
			 psi2Params.put("w20",(safetyStock*Integer.parseInt(psi2Params.get("w20").toString()))/30);
			 psi2Params.put("w21",(safetyStock*Integer.parseInt(psi2Params.get("w21").toString()))/30);
			 psi2Params.put("w22",(safetyStock*Integer.parseInt(psi2Params.get("w22").toString()))/30);
			 psi2Params.put("w23",(safetyStock*Integer.parseInt(psi2Params.get("w23").toString()))/30);
			 psi2Params.put("w24",(safetyStock*Integer.parseInt(psi2Params.get("w24").toString()))/30);
			 psi2Params.put("w25",(safetyStock*Integer.parseInt(psi2Params.get("w25").toString()))/30);
			 psi2Params.put("w26",(safetyStock*Integer.parseInt(psi2Params.get("w26").toString()))/30);
			 psi2Params.put("w27",(safetyStock*Integer.parseInt(psi2Params.get("w27").toString()))/30);
			 psi2Params.put("w28",(safetyStock*Integer.parseInt(psi2Params.get("w28").toString()))/30);
			 psi2Params.put("w29",(safetyStock*Integer.parseInt(psi2Params.get("w29").toString()))/30);
			 psi2Params.put("w30",(safetyStock*Integer.parseInt(psi2Params.get("w30").toString()))/30);


			//inventory 및 po 수량계산 (실적)
			for(int psi5=0; psi5  < countBef; psi5++ ){
				int beforeParam = psi5 + 1;
				int beforeWeek = Integer.parseInt(params.get("scmPeriodCbBox").toString()) - beforeParam;
				params.put("scmPeriodCbBoxBefore", beforeWeek);
				int befPoCnt = salesPlanMngementMapper.selectBeforePoCnt(params);
				psi3Params.put("ws" + psi5, befPoCnt);
				if(psi5 == 0){
					endingInventory = endingInventory - Integer.parseInt(psi1Params.get("ws" + psi5).toString()) + befPoCnt;
					psi5Params.put("ws" + psi5, endingInventory);
				} else {
					endingInventory = endingInventory - Integer.parseInt(psi1Params.get("ws" + psi5).toString()) + befPoCnt;
					psi5Params.put("ws" + psi5, endingInventory);
				}
			}

			//inventory 및 po 수량계산 (계획, 확정주차전)
			for(int psi3=0; psi3 < leadTime; psi3++ ){
				int k = psi3 + 1;
				params.put("scmPeriodCbBoxAfter", k);
				int afterPoCnt = salesPlanMngementMapper.selectAfterPoCnt(params);

				psi3Params.put("w0" + psi3, afterPoCnt);
				endingInventory = endingInventory - Integer.parseInt(psi1Params.get("w0" + psi3).toString()) + afterPoCnt;
				psi5Params.put("w0" + psi3, endingInventory);
			}

			//inventory 및 po 수량계산 (계획, 확정주차이후)
			for(int psi4=leadTime; psi4 < 30; psi4++ ){
				if(psi4 < 10){
					if(endingInventory - Integer.parseInt(psi1Params.get("w0" + psi4).toString()) < Integer.parseInt(psi2Params.get("w0" + psi4).toString())){
						int fsctQty = Integer.parseInt(psi2Params.get("w0" + psi4).toString()) - (endingInventory - Integer.parseInt(psi1Params.get("w0" + psi4).toString()));
						if(fsctQty >= moq){
							psi3Params.put("w0" + psi4, fsctQty);
							endingInventory = endingInventory - Integer.parseInt(psi1Params.get("w0" + psi4).toString()) + fsctQty;
							psi5Params.put("w0" + psi4, endingInventory);
						} else {
							psi3Params.put("w0" + psi4, moq);
							endingInventory = endingInventory - Integer.parseInt(psi1Params.get("w0" + psi4).toString()) + moq;
							psi5Params.put("w0" + psi4, endingInventory);
						}
					} else {
						psi3Params.put("w0" + psi4, 0);
						endingInventory = endingInventory - Integer.parseInt(psi1Params.get("w0" + psi4).toString());
						psi5Params.put("w0" + psi4, endingInventory);
					}
				} else {
					if(endingInventory - Integer.parseInt(psi1Params.get("w" + psi4).toString()) < Integer.parseInt(psi2Params.get("w" + psi4).toString())){
						int fsctQty = Integer.parseInt(psi2Params.get("w" + psi4).toString()) - (endingInventory - Integer.parseInt(psi1Params.get("w" + psi4).toString()));
						if(fsctQty >= moq){
							psi3Params.put("w" + psi4, fsctQty);
							endingInventory = endingInventory - Integer.parseInt(psi1Params.get("w" + psi4).toString()) + fsctQty;
							psi5Params.put("w" + psi4, endingInventory);
						} else {
							psi3Params.put("w" + psi4, moq);
							endingInventory = endingInventory - Integer.parseInt(psi1Params.get("w" + psi4).toString()) + moq;
							psi5Params.put("w" + psi4, endingInventory);
						}
					} else {
						psi3Params.put("w" + psi4, 0);
						endingInventory = endingInventory - Integer.parseInt(psi1Params.get("w" + psi4).toString());
						psi5Params.put("w" + psi4, endingInventory);
					}
				}

			}

			m0Sum = 0;
			m1Sum = 0;
			m2Sum = 0;
			m3Sum = 0;
			m4Sum = 0;

			/**
			 *  m0, m1, m2, m3, m4  각 달에 해당하는 주차들의 PO수량 및 Inventory 합 계산
			*/

		    intToStrFieldCnt ="";
		    iLootDataFieldCnt = 0;

			for(int m1=0;m1<Integer.parseInt(iM0TotCnt);m1++){
				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

		        if (Integer.parseInt(chield.get(m1).get("weekTh").toString()) <  Integer.parseInt(weekth) && m1 != Integer.parseInt(iM0TotCnt)-1 ){
		        } else {
		        	m0Sum = m0Sum+Integer.parseInt(getReplaceStr(psi3Params.get("w"+intToStrFieldCnt).toString(),",",""));
		        	iLootDataFieldCnt++;
	            }
			}

			intToStrFieldCnt2 ="";
			iLootDataFieldCnt2 = 0;

			for(int m1=0;m1<Integer.parseInt(iM0TotCnt);m1++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt;
	            }

		        if (Integer.parseInt(chield.get(m1).get("weekTh").toString()) <  Integer.parseInt(weekth) && m1 != Integer.parseInt(iM0TotCnt)-1 ){

		        } else {
		        	psi3Params.put("m0", m0Sum);
		        	psi5Params.put("m0", psi5Params.get("w"+intToStrFieldCnt).toString());
		        	iLootDataFieldCnt2++;
		        }

			}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	            	intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m1Sum = m1Sum+Integer.parseInt(getReplaceStr(psi3Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
		 	}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi3Params.put("m1", m1Sum);
	        	psi5Params.put("m1", psi5Params.get("w"+intToStrFieldCnt).toString());
				iLootDataFieldCnt2++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m2Sum = m2Sum+Integer.parseInt(getReplaceStr(psi3Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi3Params.put("m2", m2Sum);
	        	psi5Params.put("m2", psi5Params.get("w"+intToStrFieldCnt).toString());
				iLootDataFieldCnt2++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m3Sum = m3Sum+Integer.parseInt(getReplaceStr(psi3Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi3Params.put("m3", m3Sum);
	        	psi5Params.put("m3", psi5Params.get("w"+intToStrFieldCnt).toString());
			    iLootDataFieldCnt2++;
			}

			for(int m4=0;m4<31-Integer.parseInt(iM0TotCnt+iM1TotCnt+iM2TotCnt+iM3TotCnt);m4++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt-1);


	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m4Sum = m4Sum+Integer.parseInt(getReplaceStr(psi3Params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m4=0;m4<31-Integer.parseInt(iM0TotCnt+iM1TotCnt+iM2TotCnt+iM3TotCnt);m4++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            psi3Params.put("m4", m4Sum);
	        	psi5Params.put("m4", psi5Params.get("w"+intToStrFieldCnt).toString());
			    iLootDataFieldCnt2++;
			}

			salesPlanMngementMapper.insertSalesCdcDetailNew(psi1Params);
			salesPlanMngementMapper.insertSalesCdcDetailNew(psi2Params);
			salesPlanMngementMapper.insertSalesCdcDetailNew(psi3Params);
			salesPlanMngementMapper.insertSalesCdcDetailNew(psi4Params);
			salesPlanMngementMapper.insertSalesCdcDetailNew(psi5Params);
		}
	}

		// SCM0006D Insert
		//salesPlanMngementMapper.insertSalesCdcDetail(params);

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

		salesPlanMngementMapper.insertITF189(params);

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
		return salesPlanMngementMapper.selectSeperation2(params);
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

	/**
	 * 스트링에서 oldChar을 newChar로 대체
	 * @param str
	 * @return
	 */
	public static String getReplaceStr(String str, String oldChar, String newChar) {

		if (str == null)
			return "";

		StringBuffer out = new StringBuffer();
		StringTokenizer st = new StringTokenizer(str.toString(), oldChar);
		while (st.hasMoreTokens()) {
			out.append(st.nextToken() + newChar);
		}
		return out.toString();
	}

	@Override
	public int updateSalesPlanMasterMonthly(Map<String, Object> params, SessionVO sessionVO)
	{

		List<EgovMap> salesList = salesPlanMngementMapper.selectSalesPlanList(params);	//	Plan 대상

		List<EgovMap> monthList = salesPlanMngementMapper.selectScmMonth(params);		//	선택한 주차의 월

		String planMonth = monthList.get(0).get("scmMonth").toString();

		params.put("selectPlanMonth", planMonth);

		List<EgovMap> chield = salesPlanMngementMapper.selectChildField(params);		//	M0 ~ M3 까지의 월별 주차수

		List<EgovMap> seperaionMap = salesPlanMngementMapper.selectSeperation2(params);

		int countBef = salesPlanMngementMapper.selectCountasIn(params);

		params.put("crtUserId", sessionVO.getUserId());

		for(int i=0 ; i < salesList.size(); i++){
			String stockCode = salesList.get(i).get("stockCode").toString();
			params.put("stockCode", stockCode);

			List<EgovMap> salesWeekCnt = salesPlanMngementMapper.selectSalesPlanWeekCnt(params);

			params.put("w00", Integer.parseInt(salesWeekCnt.get(0).get("w00").toString()));
			params.put("w01", Integer.parseInt(salesWeekCnt.get(0).get("w01").toString()));
			params.put("w02", Integer.parseInt(salesWeekCnt.get(0).get("w02").toString()));
			params.put("w03", Integer.parseInt(salesWeekCnt.get(0).get("w03").toString()));
			params.put("w04", Integer.parseInt(salesWeekCnt.get(0).get("w04").toString()));
			params.put("w05", Integer.parseInt(salesWeekCnt.get(0).get("w05").toString()));
			params.put("w06", Integer.parseInt(salesWeekCnt.get(0).get("w06").toString()));
			params.put("w07", Integer.parseInt(salesWeekCnt.get(0).get("w07").toString()));
			params.put("w08", Integer.parseInt(salesWeekCnt.get(0).get("w08").toString()));
			params.put("w09", Integer.parseInt(salesWeekCnt.get(0).get("w09").toString()));
			params.put("w10", Integer.parseInt(salesWeekCnt.get(0).get("w10").toString()));
			params.put("w11", Integer.parseInt(salesWeekCnt.get(0).get("w11").toString()));
			params.put("w12", Integer.parseInt(salesWeekCnt.get(0).get("w12").toString()));
			params.put("w13", Integer.parseInt(salesWeekCnt.get(0).get("w13").toString()));
			params.put("w14", Integer.parseInt(salesWeekCnt.get(0).get("w14").toString()));
			params.put("w15", Integer.parseInt(salesWeekCnt.get(0).get("w15").toString()));
			params.put("w16", Integer.parseInt(salesWeekCnt.get(0).get("w16").toString()));
			params.put("w17", Integer.parseInt(salesWeekCnt.get(0).get("w17").toString()));
			params.put("w18", Integer.parseInt(salesWeekCnt.get(0).get("w18").toString()));
			params.put("w19", Integer.parseInt(salesWeekCnt.get(0).get("w19").toString()));
			params.put("w20", Integer.parseInt(salesWeekCnt.get(0).get("w20").toString()));
			params.put("w21", Integer.parseInt(salesWeekCnt.get(0).get("w21").toString()));
			params.put("w22", Integer.parseInt(salesWeekCnt.get(0).get("w22").toString()));
			params.put("w23", Integer.parseInt(salesWeekCnt.get(0).get("w23").toString()));
			params.put("w24", Integer.parseInt(salesWeekCnt.get(0).get("w24").toString()));
			params.put("w25", Integer.parseInt(salesWeekCnt.get(0).get("w25").toString()));
			params.put("w26", Integer.parseInt(salesWeekCnt.get(0).get("w26").toString()));
			params.put("w27", Integer.parseInt(salesWeekCnt.get(0).get("w27").toString()));
			params.put("w28", Integer.parseInt(salesWeekCnt.get(0).get("w28").toString()));
			params.put("w29", Integer.parseInt(salesWeekCnt.get(0).get("w29").toString()));
			params.put("w30", Integer.parseInt(salesWeekCnt.get(0).get("w30").toString()));

			String iM0TotCnt = seperaionMap.get(0).get("m0TotCnt").toString();
			String iM1TotCnt = seperaionMap.get(0).get("m1TotCnt").toString();
			String iM2TotCnt = seperaionMap.get(0).get("m2TotCnt").toString();
			String iM3TotCnt = seperaionMap.get(0).get("m3TotCnt").toString();
			String iM4TotCnt = seperaionMap.get(0).get("m4TotCnt").toString();

			String weekth = params.get("scmPeriodCbBox").toString();

			int m0Sum = 0;
			int m1Sum = 0;
			int m2Sum = 0;
			int m3Sum = 0;
			int m4Sum = 0;

			String intToStrFieldCnt ="";
		    int iLootDataFieldCnt = 0;

		    for ( int j = 0 ; j < Integer.parseInt(iM0TotCnt) ; j++ ) {
		    	LOGGER.debug(" 0 loop ========== j : " + j);
		    	intToStrFieldCnt	= String.valueOf(iLootDataFieldCnt);
		    	LOGGER.debug(" 1 loop ========== intToStrFieldCnt : " + intToStrFieldCnt);
		    	if ( 1 == intToStrFieldCnt.length() ) {
		    		intToStrFieldCnt	= "0" + intToStrFieldCnt;
		    		LOGGER.debug(" 2 loop ========== intToStrFieldCnt : " + intToStrFieldCnt);
		    	}
		    	LOGGER.debug(" 3 loop ========== Integer.parseInt(chield.get(j).get('weekTh').toString()) : " + Integer.parseInt(chield.get(j).get("weekTh").toString()));
		    	LOGGER.debug(" 4 loop ========== Integer.parseInt(weekth) : " + Integer.parseInt(weekth));
		    	LOGGER.debug(" 5 loop ========== Integer.parseInt(iM0TotCnt) - 1 : " + (Integer.parseInt(iM0TotCnt) - 1));
		    	if ( Integer.parseInt(chield.get(j).get("weekTh").toString()) < Integer.parseInt(weekth) && j != Integer.parseInt(iM0TotCnt) - 1 ) {
		    		LOGGER.debug(" 6 loop ========== true : ");
		    	} else {
		    		m0Sum	= m0Sum + Integer.parseInt(getReplaceStr(params.get("w" + intToStrFieldCnt).toString(), ",", ""));
		    		LOGGER.debug(" 7 loop ========== m0Sum : " + m0Sum);
		    		iLootDataFieldCnt++;
		    	}
		    }
/*			for(int i=0;i<Integer.parseInt(iM0TotCnt);i++){
				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

		        if (Integer.parseInt(chield.get(i).get("weekTh").toString()) <  Integer.parseInt(weekth) && i != Integer.parseInt(iM0TotCnt)-1 ){
		        } else {
		        	m0Sum = m0Sum+Integer.parseInt(getReplaceStr(params.get("w"+intToStrFieldCnt).toString(),",",""));
		        	iLootDataFieldCnt++;
	            }
			}*/

			String intToStrFieldCnt2 ="";
			int iLootDataFieldCnt2 = 0;

			for(int m1=0;m1<Integer.parseInt(iM0TotCnt);m1++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }

		        if (Integer.parseInt(chield.get(m1).get("weekTh").toString()) <  Integer.parseInt(weekth) && m1 != Integer.parseInt(iM0TotCnt)-1 ){

		        } else {
		        	params.put("m0", m0Sum);
		        	iLootDataFieldCnt2++;
		        }

			}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	            	intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m1Sum = m1Sum+Integer.parseInt(getReplaceStr(params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
		 	}

			for(int m1=0;m1<Integer.parseInt(iM1TotCnt);m1++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            params.put("m1", m1Sum);
				iLootDataFieldCnt2++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m2Sum = m2Sum+Integer.parseInt(getReplaceStr(params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m2=0;m2<Integer.parseInt(iM2TotCnt);m2++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            params.put("m2", m2Sum);
				iLootDataFieldCnt2++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt);

	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m3Sum = m3Sum+Integer.parseInt(getReplaceStr(params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m3=0;m3<Integer.parseInt(iM3TotCnt);m3++){
				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            params.put("m3", m3Sum);
			    iLootDataFieldCnt2++;
			}

			for(int m4=0;m4<Integer.parseInt(iM4TotCnt);m4++){

				intToStrFieldCnt = String.valueOf(iLootDataFieldCnt-1);


	            if (intToStrFieldCnt.length() == 1)
	            {
	         	   intToStrFieldCnt =  "0" + intToStrFieldCnt;
	            }

	            m4Sum = m4Sum+Integer.parseInt(getReplaceStr(params.get("w"+intToStrFieldCnt).toString(),",",""));
	            iLootDataFieldCnt++;
			}

			for(int m4=0;m4<Integer.parseInt(iM4TotCnt);m4++){

				intToStrFieldCnt2 = String.valueOf(iLootDataFieldCnt2);

	            if (intToStrFieldCnt2.length() == 1)
	            {
	         	   intToStrFieldCnt2 =  "0" + intToStrFieldCnt2;
	            }
	            params.put("m4", m4Sum);
			    iLootDataFieldCnt2++;
			}

			salesPlanMngementMapper.updateSalesPlanDetailMonthly(params);

		}

		LOGGER.debug(" return_Params : {} , SaveCnt: {} ", params.toString());

		return 0;
	}



	@Override
	public void saveConfirmPlanByCDC(Map<String, Object> params) {

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		 for (int i = 0; i < checkList.size(); i++) {
			 LOGGER.debug("checkList 값 ::::::::::: : {}", checkList.get(i));
		 }


		LOGGER.debug(" formMap ???????????  : {} ", formMap);


		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {

				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
				 insMap.put("scmYearCbBox", formMap.get("scmYearCbBox"));
				 insMap.put("scmPeriodCbBox", formMap.get("scmPeriodCbBox"));
				 insMap.put("cdcCbBox", formMap.get("cdcCbBox"));

				 if("PO & FCST".equals(insMap.get("psi"))){
					 LOGGER.debug(" psi 통과1111111 ???????????  : {} ");
					 insMap.put("selectPlanMonth", insMap.get("planMonth"));

					 List<EgovMap> chield = salesPlanMngementMapper.selectChildField(insMap);

					 for(int sn=0; sn < chield.size(); sn++){
						 String weekThSn = chield.get(sn).get("weekThSn").toString();
						 if(weekThSn.equals("2")){
							 insMap.put("w08",insMap.get("w09"));
							 break;
						 }
					 }

					 if(Integer.parseInt(insMap.get("w08").toString()) != 0){
						 salesPlanMngementMapper.insConfirmPlanByCDC(insMap);
					 }
				 }
			}
		}
	}


	@Override
	public int selectCreateCount(Map<String, Object> params) {
		return salesPlanMngementMapper.selectCreateCount(params);
	}


	@Override
	public int selectUnConfirmCnt(Map<String, Object> params) {
		return salesPlanMngementMapper.selectUnConfirmCnt(params);
	}

	@Override
	public int supplyPlancheck(Map<String, Object> params) {
		return salesPlanMngementMapper.supplyPlancheck(params);
	}

	@Override
	public int SelectConfirmPlanCheck(Map<String, Object> params) {
		return salesPlanMngementMapper.SelectConfirmPlanCheck(params);
	}


}