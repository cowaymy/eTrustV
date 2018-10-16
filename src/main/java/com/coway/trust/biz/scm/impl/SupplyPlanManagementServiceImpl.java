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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.coway.trust.AppConstants;

import com.coway.trust.biz.scm.SupplyPlanManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplyPlanManagementService")
public class SupplyPlanManagementServiceImpl implements SupplyPlanManagementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SupplyPlanManagementServiceImpl.class);

	@Autowired
	private SupplyPlanManagementMapper supplyPlanManagementMapper;
	
	@Autowired
	private SalesPlanManagementMapper salesPlanManagementMapper;
	
	/*
	 * Supply Plan Management
	 */
	@Override
	public List<EgovMap> selectSupplyPlanHeader(Map<String, Object> params) {
		
		List<EgovMap> selectSupplyPlanMonth	= salesPlanManagementMapper.selectSalesPlanMonth(params);
		
		String planYear		= params.get("scmYearCbBox").toString();
		String planMonth	= selectSupplyPlanMonth.get(0).get("planMonth").toString();
		
		if ( 2 > planMonth.length() ) {
			planMonth	= "0" + planMonth;
		}
		
		DateFormat dateFormat	= new SimpleDateFormat("yyyyMM");
		DateFormat yearFormat	= new SimpleDateFormat("yyyy");
		DateFormat monthFormat	= new SimpleDateFormat("MM");
		Date date	= null;
		
		try {
			date	= dateFormat.parse(planYear + planMonth);
		} catch ( ParseException e ) {
			e.printStackTrace();
		}
		
		Calendar cal	= Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.MONTH, 4);
		
		String supplyPlanFrom	= planYear + planMonth;
		String supplyPlanTo		= yearFormat.format(cal.getTime()) + monthFormat.format(cal.getTime());
		
		params.put("salesPlanFrom", supplyPlanFrom);
		params.put("salesPlanTo", supplyPlanTo);
		
		return	supplyPlanManagementMapper.selectSupplyPlanHeader(params);
	}
	@Override
	public List<EgovMap> selectSupplyPlanInfo(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanInfo(params);
	}
	@Override
	public List<EgovMap> selectTotalSplitInfo(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectTotalSplitInfo(params);
	}
	
	@Override
	public List<EgovMap> selectSupplyPlanList(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanList(params);
	}
	
	@Override
	public int insertSupplyPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		
		String befDtFrom	= "";	String planWeekStart	= "";
		String befDtTo		= "";	String planWeekEnd		= "";
		int planId			= 0;	int planDtlId		= 0;
		int planYear		= 0;	int planMonth		= 0;	int planWeek	= 0;
		int befPlanYear		= 0;	int befPlanMonth	= 0;	int befPlanWeek	= 0;
		int invenYear		= 0;	int invenMonth		= 0;
		int planWeekSn		= 0;	int isSrptd			= 0;
		int leadTm			= 0;
		int planWeekTh		= 0;
		int fstWeek			= 0;
		int splitCnt		= 0;
		
		LOGGER.debug("insertSupplyPlanMaster : {}", params);
		
		//List<EgovMap> selectSalesplanMonth	= salesPlanManagementMapper.selectSalesPlanMonth(params);
		List<EgovMap> selectTotalSplitInfo	= supplyPlanManagementMapper.selectTotalSplitInfo(params);
		planYear	= Integer.parseInt(selectTotalSplitInfo.get(0).get("planYear").toString());
		planMonth	= Integer.parseInt(selectTotalSplitInfo.get(0).get("planMonth").toString());
		leadTm		= Integer.parseInt(selectTotalSplitInfo.get(0).get("leadTm").toString());
		planWeekTh	= Integer.parseInt(selectTotalSplitInfo.get(0).get("planWeekTh").toString());
		fstWeek		= Integer.parseInt(selectTotalSplitInfo.get(0).get("fstWeek").toString());
		splitCnt	= Integer.parseInt(selectTotalSplitInfo.get(0).get("splitCnt").toString());
		befPlanYear	= Integer.parseInt(selectTotalSplitInfo.get(0).get("befPlanYear").toString());
		befPlanMonth	= Integer.parseInt(selectTotalSplitInfo.get(0).get("befPlanMonth").toString());
		befPlanWeek	= Integer.parseInt(selectTotalSplitInfo.get(0).get("befPlanWeek").toString());
		
		params.put("planYear", planYear);
		params.put("planMonth", planMonth);
		params.put("leadTm", leadTm);
		params.put("planWeekTh", planWeekTh);
		params.put("fstWeek", fstWeek);
		params.put("splitCnt", splitCnt);
		params.put("befPlanYear", befPlanYear);
		params.put("befPlanMonth", befPlanMonth);
		params.put("befPlanWeek", befPlanWeek);
		
		//	1. insert Supply Plan Master
		try {
			supplyPlanManagementMapper.insertSupplyPlanMaster(params);
			saveCnt++;
			LOGGER.debug(" createCnt : {} ", saveCnt);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	2. insert Supply Plan Detail
		List<EgovMap> selectSupplyPlanInfo	= supplyPlanManagementMapper.selectSupplyPlanInfo(params);	//	planId, planMonth
		List<EgovMap> selectSplitInfo	= salesPlanManagementMapper.selectSplitInfo(params);			//	m0WeekCnt ~ m4WeekCnt
		List<EgovMap> selectBefWeekInfo	= supplyPlanManagementMapper.selectBefWeekInfo(params);			//	befPlanYear, befPlanMonth, befPlanWeek
		List<EgovMap> selectChildField	= salesPlanManagementMapper.selectChildField(params);
		
		planId		= Integer.parseInt(selectSupplyPlanInfo.get(0).get("planId").toString());
		params.put("planId", planId);
		
		LOGGER.debug("selectSplitInfo : {}", selectSplitInfo);
		LOGGER.debug("selectBefWeekInfo : {}", selectBefWeekInfo);
		
		//	set params before from - to
		if ( planMonth < 10 ) {
			befDtFrom	= planYear + "0" + planMonth + "01";
			befDtTo		= planYear + "0" + planMonth + "31";
		} else {
			befDtFrom	= planYear + planMonth + "01";
			befDtTo		= planYear + planMonth + "31";
		}
		params.put("befDtFrom", befDtFrom);
		params.put("befDtTo", befDtTo);
		
		//	set invenYear, invenMonth
		if ( 1 == planMonth ) {
			params.put("invenYear", planYear - 1);
			params.put("invenMonth", 12);
		} else {
			params.put("invenYear", planYear);
			params.put("invenMonth", planMonth - 1);
		}
		
		//	2-1. psi #1 : Sales Plan insert
		try {
			LOGGER.debug("insert psi#1 -> befDtFrom : " + befDtFrom + ", befDtTo : " + befDtTo);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi1(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	2-2. psi #4 : Before Week Supply Plan
		try {
			LOGGER.debug("insert psi 4 -> befPlanYear : " + befPlanYear + ", befPlanMonth : " + befPlanMonth + ", befPlanWeek : " + befPlanWeek);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi4(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	2-3. psi #2, #3, #5 : Safety Stock, Inventory by CDC
		try {
			LOGGER.debug("insert psi 2 & & 3 & 5");
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi235(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	3. update Supply Plan Detail
		String stockCode	= "";
		int m0Psi1	= 0;	int m0Psi2	= 0;	int m0Psi3	= 0;	int m0Psi5	= 0;	int m0WeekCnt	= Integer.parseInt(selectSplitInfo.get(0).get("m0WeekCnt").toString());
		int m1Psi1	= 0;	int m1Psi2	= 0;	int m1Psi3	= 0;	int m1Psi5	= 0;	int m1WeekCnt	= Integer.parseInt(selectSplitInfo.get(0).get("m1WeekCnt").toString());
		int m2Psi1	= 0;	int m2Psi2	= 0;	int m2Psi3	= 0;	int m2Psi5	= 0;	int m2WeekCnt	= Integer.parseInt(selectSplitInfo.get(0).get("m2WeekCnt").toString());
		int m3Psi1	= 0;	int m3Psi2	= 0;	int m3Psi3	= 0;	int m3Psi5	= 0;	int m3WeekCnt	= Integer.parseInt(selectSplitInfo.get(0).get("m3WeekCnt").toString());
		int m4Psi1	= 0;	int m4Psi2	= 0;	int m4Psi3	= 0;	int m4Psi5	= 0;	int m4WeekCnt	= Integer.parseInt(selectSplitInfo.get(0).get("m4WeekCnt").toString());
		
		params.put("psiId", 1);	List<EgovMap> selectPsi1	= supplyPlanManagementMapper.selectPsi1(params);		//	psi1
		params.put("psiId", 2);	List<EgovMap> selectPsi2	= supplyPlanManagementMapper.selectEachPsi(params);		//	psi2
		params.put("psiId", 5);	List<EgovMap> selectPsi5	= supplyPlanManagementMapper.selectEachPsi(params);		//	psi5
		LOGGER.debug("selectPsi1 : {}", selectPsi1);
		LOGGER.debug("selectPsi2 : {}", selectPsi2);
		LOGGER.debug("selectPsi5 : {}", selectPsi5);
		
		//	set params to get po cnt
		
		for ( int i = 0 ; i < selectTotalSplitInfo.size() ; i++ ) {
			isSrptd	= Integer.parseInt(selectTotalSplitInfo.get(i).get("isSrptd").toString());
			planWeek	= Integer.parseInt(selectTotalSplitInfo.get(i).get("planWeek").toString());
			planWeekSn	= Integer.parseInt(selectTotalSplitInfo.get(i).get("planWeekSn").toString());
			LOGGER.debug("isSrptd : " + isSrptd + ", planWeek : " + planWeek + ", planWeekSn : " + planWeekSn);
			if ( 1 == isSrptd ) {
				if ( 1 == planWeekSn ) {
					//	split 앞주차
					params.put("week" + (fstWeek + i), 0);			//	split 앞주차는 PO값을 안가져오기 위해서 파라미터 0
				} else {
					//	split 뒷주차
					params.put("week" + (fstWeek + i), planWeek);	//	split 뒷주차는 PO값을 가져오기 위해서 파라미터 planWeek
				}
			} else {
				params.put("week" + (fstWeek + i), planWeek);
			}
		}
		for ( int i = selectTotalSplitInfo.size() + 1 ; i < 16 ; i++ ) {
			params.put("week" + i, 9999);	//	dummy params
		}
		LOGGER.debug("params : {}", params);
		List<EgovMap> selectPoInLeadTm	= supplyPlanManagementMapper.selectPoInLeadTm(params);
		
		//	psi2, psi5
		Map<String, Object> psi1Params = new HashMap<String, Object>();
		Map<String, Object> psi2Params = new HashMap<String, Object>();
		Map<String, Object> psi3Params = new HashMap<String, Object>();
		Map<String, Object> psi5Params = new HashMap<String, Object>();
		
		int moq	= 0;
		int safetyStock	= 0;
		int loadingQty	= 0;
		int basicQty	= 0;
		int overdue		= 0;
		int totLeadTm	= leadTm + planWeekTh + splitCnt;	//	stock의 leadTm, 수립주차(planWeek), 수립주차의 해당월의 주차순서, leadTm 내의 스플릿주차 등을 감안한 최종 leadTm
		//	selectPsi1.size() == selectPsi2.size() == selectPsi5.size()
		for ( int i = 0 ; i < selectPsi1.size() ; i++ ) {
			String intToStrFieldCnt1	= "";	int iLoopDataFieldCnt1	= 1;
			String intToStrFieldCnt2	= "";	int iLoopDataFieldCnt2	= 1;
			int psi1	= 0;	//	ex) w01 Sales plan
			int psi2	= 0;	//	ex) m01 Safety qty
			int psi3	= 0;	//	ex) w01 Supply plan
			int psi5	= 0;	//	ex) w01 - 1 Inventory qty
			
			stockCode	= selectPsi1.get(i).get("stockCode").toString();
			planDtlId	= Integer.parseInt(selectPsi1.get(i).get("planDtlId").toString());
			moq			= Integer.parseInt(selectPsi1.get(i).get("moq").toString());
			safetyStock	= Integer.parseInt(selectPsi1.get(i).get("safetyStock").toString());
			loadingQty	= Integer.parseInt(selectPsi1.get(i).get("loadingQty").toString());
			basicQty	= Integer.parseInt(selectPsi1.get(i).get("overdue").toString());	//	psi1의 overdue는 전월 기초재고
			overdue		= Integer.parseInt(selectPsi5.get(i).get("overdue").toString());	//	psi5의 overdue는 전월 Overdue
			
			psi1Params.put("planId", planId);
			psi1Params.put("psiId", 1);
			psi1Params.put("stockCode", stockCode);
			psi2Params.put("planId", planId);
			psi2Params.put("psiId", 2);
			psi2Params.put("stockCode", stockCode);
			psi3Params.put("planId", planId);
			psi3Params.put("psiId", 3);
			psi3Params.put("stockCode", stockCode);
			psi5Params.put("planId", planId);
			psi5Params.put("psiId", 5);
			psi5Params.put("stockCode", stockCode);
			
			//	m0
			//	get m0Psi1
			m0Psi3	= 0;
			for ( int m0 = 1 ; m0 < m0WeekCnt + 1 ; m0++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				if ( 1 == intToStrFieldCnt1.length() ) {
					intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				}
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt1).toString());
				if ( 0 == selectPsi1.size() ) {
					m0Psi1	= 0;
				} else {
					m0Psi1	= m0Psi1 + psi1;
				}
				iLoopDataFieldCnt1++;
			}
			psi1Params.put("m0", m0Psi1);
			for ( int m0 = 1 ; m0 < m0WeekCnt + 1 ; m0++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				if ( 1 == intToStrFieldCnt2.length() ) {
					intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				}
				//	psi2
				m0Psi2	= m0Psi1 / 30 * safetyStock;
				psi2Params.put("m0", m0Psi2);
				psi2Params.put("w" + intToStrFieldCnt2, m0Psi2);
				
				//	psi3
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m0Psi2;	//	ok
				//	check leadTm
				if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					if ( 1 == m0 ) {
						psi5	= basicQty - overdue;
					}
					psi3	= Integer.parseInt(selectPoInLeadTm.get(i).get("w" + intToStrFieldCnt2).toString());
					LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
					psi5	= psi5 - psi1 + psi3;
				} else {
					if ( 1 == m0 ) {
						psi5	= basicQty - overdue;
					}
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
					psi5	= psi5 - psi1 + psi3;
					LOGGER.debug("2. m0 : " + m0 + ", psi1 : " + psi1 + ", psi2 : " + psi2 + ", psi3 : " + psi3 + ", psi5 : " + psi5 + ", m0Psi3 : " + m0Psi3);
				}
				m0Psi3	= m0Psi3 + psi3;
				psi3Params.put("w" + intToStrFieldCnt2, psi3);
				psi5Params.put("m0", psi5);	//	하나씩 덮어넣다보면 제일 마지막것이 들어간다.
				psi5Params.put("w" + intToStrFieldCnt2, psi5);
				
				iLoopDataFieldCnt2++;
			}
			psi3Params.put("m0", m0Psi3);
			
			//	m1
			m1Psi3	= 0;
			for ( int m1 = 1 ; m1 < m1WeekCnt + 1 ; m1++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				if ( 1 == intToStrFieldCnt1.length() ) {
					intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				}
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt1).toString());
				if ( 0 == selectPsi1.size() ) {
					m1Psi1	= 0;
				} else {
					m1Psi1	= m1Psi1 + psi1;
				}
				iLoopDataFieldCnt1++;
			}
			psi1Params.put("m1", m1Psi1);
			for ( int m1 = 1 ; m1 < m1WeekCnt + 1 ; m1++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				if ( 1 == intToStrFieldCnt2.length() ) {
					intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				}
				//	psi2
				m1Psi2	= m1Psi1 / 30 * safetyStock;
				psi2Params.put("m1", m1Psi2);
				psi2Params.put("w" + intToStrFieldCnt2, m1Psi2);
				//	psi3, psi5
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m1Psi2;
				if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					psi3	= Integer.parseInt(selectPoInLeadTm.get(i).get("w" + intToStrFieldCnt2).toString());
					LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
				} else {
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
				}
				psi5	= psi5 - psi1 + psi3;
				m1Psi3	= m1Psi3 + psi3;
				psi3Params.put("w" + intToStrFieldCnt2, psi3);
				psi5Params.put("m1", psi5);
				psi5Params.put("w" + intToStrFieldCnt2, psi5);
				
				iLoopDataFieldCnt2++;
			}
			psi3Params.put("m1", m1Psi3);
			
			//	m2
			m2Psi3	= 0;
			for ( int m2 = 1 ; m2 < m2WeekCnt + 1 ; m2++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				if ( 1 == intToStrFieldCnt1.length() ) {
					intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				}
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt1).toString());
				if ( 0 == selectPsi1.size() ) {
					m2Psi1	= 0;
				} else {
					m2Psi1	= m2Psi1 + psi1;
				}
				iLoopDataFieldCnt1++;
			}
			psi1Params.put("m2", m2Psi1);
			for ( int m2 = 1 ; m2 < m2WeekCnt + 1 ; m2++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				if ( 1 == intToStrFieldCnt2.length() ) {
					intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				}
				//	psi2
				m2Psi2	= m2Psi1 / 30 * safetyStock;
				psi2Params.put("m2", m2Psi2);
				psi2Params.put("w" + intToStrFieldCnt2, m2Psi2);
				//	psi3, psi5
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m2Psi2;
				if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					psi3	= Integer.parseInt(selectPoInLeadTm.get(i).get("w" + intToStrFieldCnt2).toString());
					LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
				} else {
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
				}
				psi5	= psi5 - psi1 + psi3;
				m2Psi3	= m2Psi3 + psi3;
				psi3Params.put("w" + intToStrFieldCnt2, psi3);
				psi5Params.put("m1", psi5);
				psi5Params.put("w" + intToStrFieldCnt2, psi5);
				
				iLoopDataFieldCnt2++;
			}
			psi3Params.put("m2", m2Psi3);
			
			//	m3
			m3Psi3	= 0;
			for ( int m3 = 1 ; m3 < m3WeekCnt + 1 ; m3++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				//if ( 1 == intToStrFieldCnt1.length() ) {
				//	intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				//}
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt1).toString());
				if ( 0 == selectPsi1.size() ) {
					m3Psi1	= 0;
				} else {
					m3Psi1	= m3Psi1 + psi1;
				}
				iLoopDataFieldCnt1++;
			}
			psi1Params.put("m3", m3Psi1);
			for ( int m3 = 1 ; m3 < m3WeekCnt + 1 ; m3++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				//if ( 1 == intToStrFieldCnt2.length() ) {
				//	intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				//}
				//	psi2
				m3Psi2	= m3Psi1 / 30 * safetyStock;
				psi2Params.put("m3", m3Psi2);
				psi2Params.put("w" + intToStrFieldCnt2, m3Psi2);
				//	psi3, psi5
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m1Psi2;
				if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					psi3	= Integer.parseInt(selectPoInLeadTm.get(i).get("w" + intToStrFieldCnt2).toString());
					LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
				} else {
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
				}
				psi5	= psi5 - psi1 + psi3;
				m3Psi3	= m3Psi3 + psi3;
				psi3Params.put("w" + intToStrFieldCnt2, psi3);
				psi5Params.put("m3", psi5);
				psi5Params.put("w" + intToStrFieldCnt2, psi5);
				
				iLoopDataFieldCnt2++;
			}
			psi3Params.put("m3", m3Psi3);
			
			//	m4
			m4Psi3	= 0;
			for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				//if ( 1 == intToStrFieldCnt1.length() ) {
				//	intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				//}
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt1).toString());
				if ( 0 == selectPsi1.size() ) {
					m4Psi1	= 0;
				} else {
					m4Psi1	= m4Psi1 + psi1;
				}
				iLoopDataFieldCnt1++;
			}
			psi1Params.put("m4", m4Psi1);
			for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				//if ( 1 == intToStrFieldCnt2.length() ) {
				//	intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				//}
				//	psi2
				m4Psi2	= m4Psi1 / 30 * safetyStock;
				psi2Params.put("m1", m4Psi2);
				psi2Params.put("w" + intToStrFieldCnt2, m4Psi2);
				//	psi3, psi5
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m4Psi2;
				if ( 0 > psi1 + psi2 - psi5 ) {
					psi3	= 0;
				} else {
					psi3	= psi1 + psi2 - psi5;
				}
				psi5	= psi5 - psi1 + psi3;
				m4Psi3	= m4Psi3 + psi3;
				psi3Params.put("w" + intToStrFieldCnt2, psi3);
				psi5Params.put("m4", psi5);
				psi5Params.put("w" + intToStrFieldCnt2, psi5);
				
				iLoopDataFieldCnt2++;
			}
			psi3Params.put("m4", m4Psi3);
			
			//	set last week to 30 week
			int totWeekCnt	= m0WeekCnt + m1WeekCnt + m2WeekCnt + m3WeekCnt + m4WeekCnt;
			for ( int remain = totWeekCnt + 1 ; remain < 31 ; remain++ ) {
				psi1Params.put("w" + remain, 0);
				psi2Params.put("w" + remain, 0);
				psi3Params.put("w" + remain, 0);
				psi5Params.put("w" + remain, 0);
			}
			LOGGER.debug("psi1Params : {}", psi1Params);
			LOGGER.debug("psi2Params : {}", psi2Params);
			LOGGER.debug("psi3Params : {}", psi3Params);
			LOGGER.debug("psi5Params : {}", psi5Params);
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi1(psi1Params);
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi235(psi2Params);
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi235(psi3Params);
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi235(psi5Params);
		}
		
		return	saveCnt;
	}
	
	@Override
	public List<EgovMap> selectSupplyPlanSummaryList(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanSummaryList(params);
	}
	
	//	이하 미사용
	
	@Override
	public int insertSupplyPlanDetail(Map<String, Object> params, SessionVO sessionVO) {
		int saveCnt	= 0;
		
		String planId		= "";
		String planYear		= "";	String befPlanYear	= "";
		String planMonth	= "";	String befPlanMonth	= "";
		String planWeek		= "";	String befPlanWeek	= "";
		String befDtFrom	= "";
		String befDtTo		= "";
		
		List<EgovMap> selectSupplyPlanInfo	= supplyPlanManagementMapper.selectSupplyPlanInfo(params);	//	planId, planMonth
		planId		= selectSupplyPlanInfo.get(0).get("planId").toString();
		planYear	= params.get("scmYearCbBox").toString();
		planMonth	= selectSupplyPlanInfo.get(0).get("planMonth").toString();
		planWeek	= params.get("scmWeekCbBox").toString();
		params.put("planId", Integer.parseInt(planId));
		params.put("planMonth", Integer.parseInt(planMonth));
		LOGGER.debug("selectSupplyPlanInfo : {}", selectSupplyPlanInfo);
		List<EgovMap> selectSplitInfo	= salesPlanManagementMapper.selectSplitInfo(params);			//	m0WeekCnt ~ m4WeekCnt
		List<EgovMap> selectBefWeekInfo	= supplyPlanManagementMapper.selectBefWeekInfo(params);			//	befPlanYear, befPlanMonth, befPlanWeek
		LOGGER.debug("selectSplitInfo : {}", selectSplitInfo);
		LOGGER.debug("selectBefWeekInfo : {}", selectBefWeekInfo);
		
		if ( 1 == planMonth.length() ) {
			planMonth	= "0" + planMonth;
		}
		befDtFrom	= planYear + planMonth + "01";
		befDtTo		= planYear + planMonth + "31";
		params.put("befDtFrom", befDtFrom);
		params.put("befDtTo", befDtTo);
		
		//	1. psi #1 : Sales Plan insert
		try {
			LOGGER.debug("insert psi#1 -> befDtFrom : " + befDtFrom + ", befDtTo : " + befDtTo);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi1(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	2. psi #4 : Before Week Supply Plan
		befPlanYear		= selectBefWeekInfo.get(0).get("befPlanYear").toString();
		befPlanMonth	= selectBefWeekInfo.get(0).get("befPlanMonth").toString();
		befPlanWeek		= selectBefWeekInfo.get(0).get("befPlanWeek").toString();
		params.put("befPlanYear", Integer.parseInt(befPlanYear));
		params.put("befPlanMonth", Integer.parseInt(befPlanMonth));
		params.put("befPlanWeek", Integer.parseInt(befPlanWeek));
		
		try {
			LOGGER.debug("insert psi 4 -> befPlanYear : " + befPlanYear + ", befPlanMonth : " + befPlanMonth + ", befPlanWeek : " + befPlanWeek);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi4(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	3. psi #2, #5 : Safety Stock, Inventory by CDC
		try {
			LOGGER.debug("insert psi 2 & 5");
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi235(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	
	@Override
	public int updateSupplyPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		int saveCnt	= 0;
		
		try {
			supplyPlanManagementMapper.updateSupplyPlanMaster(params);
			saveCnt++;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	
	@Override
	public int updateSupplyPlanDetail(List<Object> updList, SessionVO sessionVO) {
		//	int var
		int saveCnt	= 0;
		
		try {
			for ( Object obj : updList ) {
				supplyPlanManagementMapper.updateSupplyPlanDetail((Map<String, Object>) obj);
				LOGGER.debug("planDtlId : ", ((Map<String, Object>) obj).get("planDtlId"));
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	
	public static String getReplaceStr(String str, String oldChar, String newChar) {
		if ( null == str )	return	"";
		
		StringBuffer out	= new StringBuffer();
		StringTokenizer st	= new StringTokenizer(str.toString(), oldChar);
		while ( st.hasMoreTokens() ) {
			out.append(st.nextToken() + newChar);
		}
		
		return	out.toString();
	}
}