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
import com.coway.trust.biz.scm.SalesPlanManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("salesPlanManagementService")
public class SalesPlanManagementServiceImpl implements SalesPlanManagementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SalesPlanManagementServiceImpl.class);

	@Autowired
	private SalesPlanManagementMapper salesPlanManagementMapper;
	
	@Autowired
	private ScmCommonMapper scmCommonMapper;
	
	@Override
	public List<EgovMap> selectSalesPlanSummaryHeader(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectSalesPlanSummaryHeader(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanHeader(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectSalesPlanHeader(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanInfo(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectSalesPlanInfo(params);
	}

	@Override
	public List<EgovMap> selectSalesPlanList(Map<String, Object> params) {
		return salesPlanManagementMapper.selectSalesPlanList(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanListAll(Map<String, Object> params) {
		return salesPlanManagementMapper.selectSalesPlanListAll(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanSummaryList(Map<String, Object> params) {
		return salesPlanManagementMapper.selectSalesPlanSummaryList(params);
	}
	@Override
	public int insertSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		LOGGER.debug("insertSalesPlanMaster : {}", params);
		
		//	variables
		//String issDtFrom	= "";	String issDtTo	= "";	String m1OrdDtFrom	= "";	String m1OrdDtTo	= "";	String m0OrdDtFrom	= "";	String m0OrdDtTo	= "";
		String m0From	= "";	String m0To	= "";	String m1From	= "";	String m1To	= "";	String m2From	= "";	String m2To	= "";	String m3From	= "";	String m3To	= "";
		String team		= "";
		int	planId		= 0;	int planDtlId		= 0;
		int planYear	= 0;	int planMonth		= 0;	int planWeek	= 0;
		int befWeekYear	= 0;	int befWeekMonth	= 0;	int befWeekWeek	= 0;
		int year		= 0;	int month			= 0;	int week		= 0;
		int planWeekSpltCnt	= 0;
		int planWeekTh	= 0;
		int leadTm		= 0;
		int splitCnt	= 0;
		int crtUserId	= 0;
		int planFstWeek	= 0;	int planFstSpltWeek	= 0;
		//int fstWeek		= 0;	int lstWeek		= 0;
		String fstSplitYn	= "";	String lstSplitYn	= "";
		int mm1WeekCnt	= 0;	int m0WeekCnt	= 0;	int m1WeekCnt	= 0;	int m2WeekCnt	= 0;	int m3WeekCnt	= 0;	int m4WeekCnt	= 0;
		String endDt	= "";
		
		Map<String, Object> listParams = new HashMap<String, Object>();
		Map<String, Object> updParams = new HashMap<String, Object>();
		
		//	0.0 set from params
		team	= params.get("scmTeamCbBox").toString();
		crtUserId	= sessionVO.getUserId();
		
		//	0.1 set from Scm Total Info
		List<EgovMap> selectScmTotalInfo	= scmCommonMapper.selectScmTotalInfo(params);
		//List<EgovMap> selectTotalSplitInfo	= supplyPlanManagementMapper.selectTotalSplitInfo(params);
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planMonth	= Integer.parseInt(selectScmTotalInfo.get(0).get("planMonth").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		befWeekYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekYear").toString());
		befWeekMonth	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekMonth").toString());
		befWeekWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekWeek").toString());
		planWeekTh	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeekTh").toString());
		//fstWeek		= Integer.parseInt(selectTotalSplitInfo.get(0).get("fstWeek").toString());
		//lstWeek		= Integer.parseInt(selectTotalSplitInfo.get(0).get("lstWeek").toString());
		//splitCnt	= Integer.parseInt(selectTotalSplitInfo.get(0).get("splitCnt").toString());
		leadTm		= Integer.parseInt(selectScmTotalInfo.get(0).get("leadTm").toString());
		mm1WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("mm1WeekCnt").toString());
		m0WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0WeekCnt").toString());
		m1WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1WeekCnt").toString());
		m2WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2WeekCnt").toString());
		m3WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3WeekCnt").toString());
		m4WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4WeekCnt").toString());
		planWeekSpltCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeekSpltCnt").toString());
		planFstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planFstWeek").toString());
		planFstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planFstSpltWeek").toString());
		
		//	1. insert Sales Plan Master
		Map<String, Object> mstParams = new HashMap<String, Object>();
		mstParams.put("planYear", planYear);
		mstParams.put("planMonth", planMonth);
		mstParams.put("planWeek", planWeek);
		mstParams.put("team", team);
		mstParams.put("crtUserId", crtUserId);
		try {
			LOGGER.debug(" mstParams : {} ", mstParams);
			salesPlanManagementMapper.insertSalesPlanMaster(mstParams);
			saveCnt++;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	2. insert Sales Plan Detail
		List<EgovMap> selectGetSalesPlanId	= salesPlanManagementMapper.selectGetSalesPlanId(params);
		planId	= Integer.parseInt(selectGetSalesPlanId.get(0).get("planId").toString());
		m0From	= selectScmTotalInfo.get(0).get("m0DtFrom").toString();
		m0To	= selectScmTotalInfo.get(0).get("m0DtTo").toString();
		m1From	= selectScmTotalInfo.get(0).get("monFrom1").toString();
		m1To	= selectScmTotalInfo.get(0).get("monTo1").toString();
		m2From	= selectScmTotalInfo.get(0).get("monFrom2").toString();
		m2To	= selectScmTotalInfo.get(0).get("monTo2").toString();
		m3From	= selectScmTotalInfo.get(0).get("monFrom3").toString();
		m3To	= selectScmTotalInfo.get(0).get("monTo3").toString();
		endDt	= selectScmTotalInfo.get(0).get("endDt").toString();
		
		Map<String, Object> dtlParams = new HashMap<String, Object>();
		dtlParams.put("planId", planId);
		dtlParams.put("m0From", m0From);
		dtlParams.put("m0To", m0To);
		dtlParams.put("m1From", m1From);
		dtlParams.put("m1To", m1To);
		dtlParams.put("m2From", m2From);
		dtlParams.put("m2To", m2To);
		dtlParams.put("m3From", m3From);
		dtlParams.put("m3To", m3To);
		dtlParams.put("team", team);
		dtlParams.put("endDt", endDt);
		dtlParams.put("crtUserId", crtUserId);
		try {
			LOGGER.debug(" dtlParams : {} ", dtlParams);
			salesPlanManagementMapper.insertSalesPlanDetail(dtlParams);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	3. update Sales Plan Detail
		listParams.put("year", befWeekYear);
		listParams.put("month", befWeekMonth);
		listParams.put("week", befWeekWeek);
		listParams.put("planYear", planYear);
		listParams.put("planMonth", planMonth);
		listParams.put("planWeek", planWeek);
		listParams.put("team", team);
		listParams.put("endDt", endDt);
		//LOGGER.debug("selectBefWeekList listParams : {}", listParams);
		List<EgovMap> selectBefWeekList		= salesPlanManagementMapper.selectSalesPlanForUpdate(listParams);
		List<EgovMap> selectFilterPlan		= salesPlanManagementMapper.selectFilterPlan(listParams);
		
		List<EgovMap> selectThisMonthOrder	= salesPlanManagementMapper.selectThisMonthOrder(listParams);
		LOGGER.debug("selectThisMonthOrder : {}", selectThisMonthOrder);
		
		listParams.put("year", planYear);
		listParams.put("month", planMonth);
		listParams.put("week", planWeek);
		//listParams.put("team", team);
		//LOGGER.debug("selectPlanWeekList listParams : {}", listParams);
		List<EgovMap> selectPlanWeekList	= salesPlanManagementMapper.selectSalesPlanForUpdate(listParams);
		LOGGER.debug("selectPlanWeekList listParams : {}", listParams);
		
		LOGGER.debug("selectBefWeekList : {}", selectBefWeekList);
		LOGGER.debug("selectPlanWeekList : {}", selectPlanWeekList);
		
		
		try {
			if ( 0 == selectBefWeekList.size() ) {
				LOGGER.debug("Sales Plan Error");
				return	0;
			}
			
			int m0OrdSum	= 0;	int	m0Sum	= 0;	int m1Sum	= 0;	int m2Sum	= 0;	int m3Sum	= 0;	int m4Sum	= 0;
			int	weekQty		= 0;
			String stkTypeId	= "";
			String stockCode	= "";
			String stockCodePlan	= "";
			String stockCodeOrder	= "";
			String stockCodeFilter	= "";
			//	every stock
			for ( int i = 0 ; i < selectBefWeekList.size() ; i++ ) {
				//planDtlId	= Integer.parseInt(selectBefWeekList.get(i).get("planDtlId").toString());
				planDtlId	= Integer.parseInt(selectPlanWeekList.get(i).get("planDtlId").toString());	//	must using selectPlanWeekList
				stkTypeId	= selectBefWeekList.get(i).get("stkTypeId").toString();	//	필터류들을 별도로 생성하기 위해서
				stockCode	= selectBefWeekList.get(i).get("stockCode").toString();
				stockCodePlan	= selectPlanWeekList.get(i).get("stockCode").toString();
				stockCodeOrder	= selectThisMonthOrder.get(i).get("stockCode").toString();
				stockCodeFilter	= selectFilterPlan.get(i).get("stockCode").toString();
				updParams.put("planDtlId", planDtlId);
				m0OrdSum	= 0;	m0Sum	= 0;	m1Sum	= 0;	m2Sum	= 0;	m3Sum	= 0;	m4Sum	= 0;	weekQty		= 0;
				LOGGER.debug("Before stock : " + stockCode + ", Plan stock : " + stockCodePlan + ", Order stock ; " + stockCodeOrder + ", Filter stock : " + stockCodeFilter);
				//	수립주차의 월 / 수립전주차의 월 비교
				if ( planMonth == befWeekMonth ) {
					LOGGER.debug("planMonth == befWeekMonth : " + planMonth + ", " + befWeekMonth);
					String intToStrFieldCnt1	= "";	int iLoopDataFieldCnt1	= 1;	//	전주의 실적을 가져오기 위해서 계산하는 주차변수
					String intToStrFieldCnt2	= "";	int iLoopDataFieldCnt2	= 1;	//	이번주의 실적을 저장하기 위해서 계산하는 주차변수
					
					//	stkTypeId = 62(필터) 확인
					if ( "62".equals(stkTypeId) ) {
						m0OrdSum	= 0;	m0Sum	= 0;	m1Sum	= 0;	m2Sum	= 0;	m3Sum	= 0;	m4Sum	= 0;	weekQty		= 0;
						//	Filter
						if ( planFstWeek == planFstSpltWeek ) {
							//	첫주차가 스플릿 주차가 아닌 경우
							for ( int m0 = 1 ; m0 < m0WeekCnt + 1 ; m0++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								if ( 2 == m0 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
									updParams.put("m0", Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								updParams.put("m0OrdSum", 0);	//	m0월의 필터주문수량은 0으로
								iLoopDataFieldCnt2++;
								//LOGGER.debug("Filter : 1-1 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0 : " + updParams.get("m0").toString() + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);'
								LOGGER.debug("FILTER - 1 - M0 : " + updParams.get("m0").toString());
							}
							for ( int m1 = 1 ; m1 < m1WeekCnt + 1 ; m1++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m1 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
									updParams.put("m1", Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("i : " + i + ", m1 : " + m1 + ", STOCK_CODE : " + stockCode + ", m1 : " + Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
							for ( int m2 = 1 ; m2 < m2WeekCnt + 1 ; m2++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m2 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
									updParams.put("m2", Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("i : " + i + ", m2 : " + m2 + ", STOCK_CODE : " + stockCode + ", m2 : " + Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
							for ( int m3 = 1 ; m3 < m3WeekCnt + 1 ; m3++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m3 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
									updParams.put("m3", Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("i : " + i + ", m3 : " + m3 + ", STOCK_CODE : " + stockCode + ", m3 : " + Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
							for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m4 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
									updParams.put("m4", Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("i : " + i + ", m4 : " + m4 + ", STOCK_CODE : " + stockCode + ", m4 : " + Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
						} else {
							//	첫주차가 스플릿 주차인 경우
							for ( int m0 = 1 ; m0 < m0WeekCnt + 1 ; m0++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m0 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
									updParams.put("m0", Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								updParams.put("m0OrdSum", 0);	//	m0월의 필터주문수량은 0으로
								iLoopDataFieldCnt2++;
								//LOGGER.debug("Filter : 1-2 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0 : " + updParams.get("m0").toString() + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								LOGGER.debug("FILTER - 2 - M0 : " + updParams.get("m0").toString());
							}
							for ( int m1 = 1 ; m1 < m1WeekCnt + 1 ; m1++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m1 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
									updParams.put("m1", Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("1-i : " + i + ", m1 : " + m1 + ", STOCK_CODE : " + stockCode + ", m1 : " + Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
							for ( int m2 = 1 ; m2 < m2WeekCnt + 1 ; m2++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m2 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
									updParams.put("m2", Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("2-i : " + i + ", m2 : " + m2 + ", STOCK_CODE : " + stockCode + ", m2 : " + Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
							for ( int m3 = 1 ; m3 < m3WeekCnt + 1 ; m3++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m3 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
									updParams.put("m3", Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("3-i : " + i + ", m3 : " + m3 + ", STOCK_CODE : " + stockCode + ", m3 : " + Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
							for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m4 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
									updParams.put("m4", Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
								//LOGGER.debug("4-i : " + i + ", m4 : " + m4 + ", STOCK_CODE : " + stockCode + ", m4 : " + Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()) + ", w" + intToStrFieldCnt2);
							}
						}
					} else {
						//	Except Filter
						m0OrdSum	= 0;	m0Sum	= 0;	m1Sum	= 0;	m2Sum	= 0;	m3Sum	= 0;	m4Sum	= 0;	weekQty		= 0;
						//	3.1 m0
						for ( int m0 = 1 ; m0 < m0WeekCnt + 1 ; m0++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt1 " + iLoopDataFieldCnt1 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
							
							//	M0 월은 수립주차 기준 과거 주차이면 해당월의 주문실적 갖고오도록
							if ( planFstWeek == planFstSpltWeek ) {
								LOGGER.debug("1) planFstWeek == planFstSpltWeek AND planWeekTh : " + planWeekTh + "m0 : " + m0);
								if ( m0 <= planWeekTh ) {
									//	selectThisMonthOrder 결과는 오직 1row
									//	수립주차기준 과거주차
									weekQty	= Integer.parseInt(selectThisMonthOrder.get(i).get("w" + intToStrFieldCnt1).toString());
									m0OrdSum	= m0OrdSum + weekQty;
									LOGGER.debug("1-1 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								} else {
									//	수립주차기준 현재+미래주차(수립주차포함)
									weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
									m0Sum	= m0Sum + weekQty;
									LOGGER.debug("1-2 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0Sum : " + m0Sum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								}
							} else {
								LOGGER.debug("2) planFstWeek != planFstSpltWeek AND planWeekTh : " + planWeekTh + "m0 : " + m0);
								if ( m0 <= planWeekTh ) {
									//	selectThisMonthOrder 결과는 오직 1row
									//	수립주차기준 과거주차
									weekQty	= Integer.parseInt(selectThisMonthOrder.get(i).get("w" + intToStrFieldCnt1).toString());
									m0OrdSum	= m0OrdSum + weekQty;
									LOGGER.debug("2-1 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								} else {
									//	수립주차기준 현재+미래주차(수립주차포함)
									weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
									m0Sum	= m0Sum + weekQty;
									LOGGER.debug("2-2 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0Sum : " + m0Sum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								}
							}

							//weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							//m0Sum	= m0Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m0", m0Sum);
						updParams.put("m0OrdSum", m0OrdSum);
						LOGGER.debug("NOT FILTER - 1 - M0 : " + updParams.get("m0").toString());
						
						//	3.2 m1
						for ( int m1 = 1 ; m1 < m1WeekCnt + 1 ; m1++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt1 " + iLoopDataFieldCnt1 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
							weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							m1Sum	= m1Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m1", m1Sum);
						
						//	3.3 m2
						for ( int m2 = 1 ; m2 < m2WeekCnt + 1 ; m2++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt1 " + iLoopDataFieldCnt1 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
							weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							m2Sum	= m2Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m2", m2Sum);
						
						//	3.4 m3
						for ( int m3 = 1 ; m3 < m3WeekCnt + 1 ; m3++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt1 " + iLoopDataFieldCnt1 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
							weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							m3Sum	= m3Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m3", m3Sum);
						
						//	3.5 m4
						for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt1 " + iLoopDataFieldCnt1 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
							weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							m4Sum	= m4Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m4", m4Sum);
						
						//	빈 주차 채우기
						int totWeekCnt	= m0WeekCnt + m1WeekCnt + m2WeekCnt + m3WeekCnt + m4WeekCnt;
						for ( int remain = totWeekCnt + 1 ; remain < 31 ; remain++ ) {
							updParams.put("w" + remain, 0);
						}
					}
					
					LOGGER.debug("updParams : Sum : ", updParams.get("m0").toString());
					salesPlanManagementMapper.updateSalesPlanDetail(updParams);
				} else {
					LOGGER.debug("planMonth != befWeekMonth : " + planMonth + ", " + befWeekMonth);
					String intToStrFieldCnt1	= "";	int iLoopDataFieldCnt1	= 1;	//	전주의 실적을 가져오기 위해서 계산하는 주차변수
					String intToStrFieldCnt2	= "";	int iLoopDataFieldCnt2	= 1;	//	이번주의 실적을 저장하기 위해서 계산하는 주차변수
					//	planWeek가 해당 월의 가장 마지막 주이고, planWeek 가 split week인 경우
					if ( 4 == mm1WeekCnt ) {
						iLoopDataFieldCnt1	= 5;
					} else if ( 5 == mm1WeekCnt ) {
						iLoopDataFieldCnt1	= 6;
					} else if ( 6 == mm1WeekCnt ) {
						iLoopDataFieldCnt1	= 7;
					} else {
						LOGGER.debug("Diff : mm1WeekCnt is wrong");
					}
					//LOGGER.debug("mm1WeekCnt : " + mm1WeekCnt);
					
					//	stkTypeId = 62(필터) 확인
					if ( "62".equals(stkTypeId) ) {
						m0OrdSum	= 0;	m0Sum	= 0;	m1Sum	= 0;	m2Sum	= 0;	m3Sum	= 0;	m4Sum	= 0;	weekQty		= 0;
						//	Filter
						if ( planFstWeek == planFstSpltWeek ) {
							//	첫주차가 스플릿 주차가 아닌 경우
							for ( int m0 = 1 ; m0 < mm1WeekCnt + 1 ; m0++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m0 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
									updParams.put("m0", Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								updParams.put("m0OrdSum", 0);	//	m0월의 필터주문수량은 0으로
								iLoopDataFieldCnt2++;
								//LOGGER.debug("Filter : 2-1 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0 : " + updParams.get("m0").toString() + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								LOGGER.debug("FILTER - 3 - M0 : " + updParams.get("m0").toString());
							}
							for ( int m1 = 1 ; m1 < m0WeekCnt + 1 ; m1++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m1 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
									updParams.put("m1", Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
							for ( int m2 = 1 ; m2 < m1WeekCnt + 1 ; m2++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m2 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
									updParams.put("m2", Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
							for ( int m3 = 1 ; m3 < m2WeekCnt + 1 ; m3++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m3 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
									updParams.put("m3", Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
							for ( int m4 = 1 ; m4 < m3WeekCnt + 1 ; m4++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 2 == m4 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
									updParams.put("m4", Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
						} else {
							//	첫주차가 스플릿 주차인 경우
							for ( int m0 = 1 ; m0 < mm1WeekCnt + 1 ; m0++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m0 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
									updParams.put("m0", Integer.parseInt(selectFilterPlan.get(i).get("m0Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								updParams.put("m0OrdSum", 0);	//	m0월의 필터주문수량은 0으로
								iLoopDataFieldCnt2++;
								//LOGGER.debug("Filter : 2-2 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0 : " + updParams.get("m0").toString() + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								LOGGER.debug("FILTER - 4 - M0 : " + updParams.get("m0").toString());
							}
							for ( int m1 = 1 ; m1 < m0WeekCnt + 1 ; m1++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m1 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
									updParams.put("m1", Integer.parseInt(selectFilterPlan.get(i).get("m1Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
							for ( int m2 = 1 ; m2 < m1WeekCnt + 1 ; m2++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m2 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
									updParams.put("m2", Integer.parseInt(selectFilterPlan.get(i).get("m2Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
							for ( int m3 = 1 ; m3 < m2WeekCnt + 1 ; m3++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m3 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
									updParams.put("m3", Integer.parseInt(selectFilterPlan.get(i).get("m3Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
							for ( int m4 = 1 ; m4 < m3WeekCnt + 1 ; m4++ ) {
								intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
								if ( 1 == intToStrFieldCnt2.length() ) {
									intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
								}
								//LOGGER.debug("i : " + i + ", iLoopDataFieldCnt2 " + iLoopDataFieldCnt2 + ", iLoopDataFieldCnt2 : " + iLoopDataFieldCnt2);
								if ( 3 == m4 ) {
									//	제일 첫번째 주차에 월합계 입력
									updParams.put("w" + intToStrFieldCnt2, Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
									updParams.put("m4", Integer.parseInt(selectFilterPlan.get(i).get("m4Qty").toString()));
								} else {
									updParams.put("w" + intToStrFieldCnt2, 0);
								}
								iLoopDataFieldCnt2++;
							}
						}
					} else {
						//	Except Filter
						m0OrdSum	= 0;	m0Sum	= 0;	m1Sum	= 0;	m2Sum	= 0;	m3Sum	= 0;	m4Sum	= 0;	weekQty		= 0;
						//	3.1 m0
						for ( int m0 = 1 ; m0 < mm1WeekCnt + 1 ; m0++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							//LOGGER.debug("intToStrFieldCnt1 : " + intToStrFieldCnt1);
							
							if ( planFstWeek == planFstSpltWeek ) {
								//LOGGER.debug("3) planFstWeek == planFstSpltWeek AND planWeekTh : " + planWeekTh + "m0 : " + m0);
								//	M0 월은 수립주차 기준 과거 주차이면 해당월의 주문실적 갖고오도록
								if ( m0 <= planWeekTh ) {
									//	selectThisMonthOrder 결과는 오직 1row
									//	수립주차 기준 과거주차
									weekQty	= Integer.parseInt(selectThisMonthOrder.get(i).get("w" + intToStrFieldCnt2).toString());
									m0OrdSum	= m0OrdSum + weekQty;
									//LOGGER.debug("3-1 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								} else {
									//	수립주차기준 현재+미래주차(수립주차포함)
									weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
									m0Sum	= m0Sum + weekQty;
									//LOGGER.debug("3-2 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0Sum : " + m0Sum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								}
							} else {
								//LOGGER.debug("4) planFstWeek != planFstSpltWeek AND planWeekTh : " + planWeekTh + "m0 : " + m0);
								//	M0 월은 수립주차 기준 과거 주차이면 해당월의 주문실적 갖고오도록
								if ( m0 <= planWeekTh ) {
									//	selectThisMonthOrder 결과는 오직 1row
									//	수립주차 기준 과거주차
									weekQty	= Integer.parseInt(selectThisMonthOrder.get(i).get("w" + intToStrFieldCnt2).toString());
									m0OrdSum	= m0OrdSum + weekQty;
									//LOGGER.debug("4-1 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0OrdSum : " + m0OrdSum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								} else {
									//	수립주차기준 현재+미래주차(수립주차포함)
									weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
									m0Sum	= m0Sum + weekQty;
									//LOGGER.debug("4-2 stockCode : " + stockCode + ", weekQty : " + weekQty + ", m0Sum : " + m0Sum + ", intToStrFieldCnt1 : " + intToStrFieldCnt1);
								}
							}
							//weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							//m0Sum	= m0Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m0", m0Sum);
						updParams.put("m0OrdSum", m0OrdSum);
						LOGGER.debug("NOT FILTER - 2 - M0 : " + updParams.get("m0").toString());
						
						//	3.2 m1
						for ( int m1 = 1 ; m1 < m0WeekCnt + 1 ; m1++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							m1Sum	= m1Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m1", m1Sum);
						
						//	3.3 m2
						for ( int m2 = 1 ; m2 < m1WeekCnt + 1 ; m2++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							m2Sum	= m2Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m2", m2Sum);
						
						//	3.4 m3
						for ( int m3 = 1 ; m3 < m2WeekCnt + 1 ; m3++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
							if ( 1 == intToStrFieldCnt1.length() ) {
								intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
							}
							if ( 1 == intToStrFieldCnt2.length() ) {
								intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
							}
							weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
							m3Sum	= m3Sum + weekQty;
							updParams.put("w" + intToStrFieldCnt2, weekQty);
							iLoopDataFieldCnt1++;
							iLoopDataFieldCnt2++;
						}
						updParams.put("m3", m3Sum);
						
						//	빈 주차 채우기
						int totWeekCnt	= mm1WeekCnt + m0WeekCnt + m1WeekCnt + m2WeekCnt;
						for ( int remain = totWeekCnt + 1 ; remain < 31 ; remain++ ) {
							updParams.put("w" + remain, 0);
						}
						updParams.put("m4", 0);
					}
					salesPlanManagementMapper.updateSalesPlanDetail(updParams);
				}
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	@Override
	public void deleteSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		int dtlCnt	= 0;
		int mstCnt	= 0;
		
		try {
			dtlCnt	= salesPlanManagementMapper.deleteSalesPlanDetail(params);
			LOGGER.debug("Sales Plan Detail Delete cnt : " + dtlCnt);
			mstCnt	= salesPlanManagementMapper.deleteSalesPlanMaster(params);
			LOGGER.debug("Sales Plan Master Delete cnt : " + mstCnt);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	@Override
	public int updateSalesPlanDetail(List<Object> updList, SessionVO sessionVO) {
		
		int updCnt	= 0;
		int updUserId	= sessionVO.getUserId();
		
		try {
			for ( Object obj : updList ) {
				((Map<String, Object>) obj).put("updUserId", updUserId);
				salesPlanManagementMapper.updateSalesPlanDetail((Map<String, Object>) obj);
				LOGGER.debug("planDtlId : ", ((Map<String, Object>) obj).get("planDtlId"));
				updCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	updCnt;
	}
	@Override
	public int updateSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		
		int updCnt	= 0;
		
		try {
			salesPlanManagementMapper.updateSalesPlanMaster(params);
			updCnt++;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	updCnt;
	}
	/*	@Override
	public List<EgovMap> selectSplitInfo(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectSplitInfo(params);
	}
	@Override
	public List<EgovMap> selectChildField(Map<String, Object> params) {
		return	salesPlanManagementMapper.selectChildField(params);
	}
	@Override
	public List<EgovMap> selectCreateCheck(Map<String, Object> params) {
		int befWeekYear	= 0;	int befWeekWeek	= 0;
		
		List<EgovMap> selectTotalSplitInfo	= supplyPlanManagementMapper.selectTotalSplitInfo(params);
		
		befWeekYear	= Integer.parseInt(selectTotalSplitInfo.get(0).get("befWeekYear").toString());
		befWeekWeek	= Integer.parseInt(selectTotalSplitInfo.get(0).get("befWeekWeek").toString());
		
		params.put("befWeekYear", befWeekYear);
		params.put("befWeekWeek", befWeekWeek);
		
		return salesPlanManagementMapper.selectCreateCheck(params);
	}*/
}