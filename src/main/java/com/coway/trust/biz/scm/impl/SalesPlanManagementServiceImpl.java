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
	public int insertSalesPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		LOGGER.debug("insertSalesPlanMaster : {}", params);
		
		//	variables
		String issDtFrom	= "";	String issDtTo	= "";	String m1OrdDtFrom	= "";	String m1OrdDtTo	= "";	String m0OrdDtFrom	= "";	String m0OrdDtTo	= "";
		String team		= "";
		int	planId		= 0;	int planDtlId		= 0;
		int planYear	= 0;	int planMonth		= 0;	int planWeek	= 0;
		int befWeekYear	= 0;	int befWeekMonth	= 0;	int befWeekWeek	= 0;
		int year		= 0;	int month			= 0;	int week		= 0;
		int planWeekSpltCnt	= 0;
		//int planWeekTh	= 0;
		int leadTm		= 0;
		int splitCnt	= 0;
		int crtUserId	= 0;
		//int fstWeek		= 0;	int lstWeek		= 0;
		String fstSplitYn	= "";	String lstSplitYn	= "";
		int m0WeekCnt	= 0;	int m1WeekCnt	= 0;	int m2WeekCnt	= 0;	int m3WeekCnt	= 0;	int m4WeekCnt	= 0;
		
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
		//planWeekTh	= Integer.parseInt(selectTotalSplitInfo.get(0).get("planWeekTh").toString());
		//fstWeek		= Integer.parseInt(selectTotalSplitInfo.get(0).get("fstWeek").toString());
		//lstWeek		= Integer.parseInt(selectTotalSplitInfo.get(0).get("lstWeek").toString());
		//splitCnt	= Integer.parseInt(selectTotalSplitInfo.get(0).get("splitCnt").toString());
		leadTm		= Integer.parseInt(selectScmTotalInfo.get(0).get("leadTm").toString());
		m0WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0WeekCnt").toString());
		m1WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1WeekCnt").toString());
		m2WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2WeekCnt").toString());
		m3WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3WeekCnt").toString());
		m4WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4WeekCnt").toString());
		planWeekSpltCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeekSpltCnt").toString());
		
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
		issDtFrom	= selectScmTotalInfo.get(0).get("issDtFrom").toString();
		issDtTo		= selectScmTotalInfo.get(0).get("issDtTo").toString();
		m1OrdDtFrom	= selectScmTotalInfo.get(0).get("ordDtFrom").toString();
		m1OrdDtTo	= selectScmTotalInfo.get(0).get("ordDtTo").toString();
		m0OrdDtFrom	= selectScmTotalInfo.get(0).get("m0DtFrom").toString();
		m0OrdDtTo	= selectScmTotalInfo.get(0).get("m0DtTo").toString();
		
		Map<String, Object> dtlParams = new HashMap<String, Object>();
		dtlParams.put("planId", planId);
		dtlParams.put("issDtFrom", issDtFrom);
		dtlParams.put("issDtTo", issDtTo);
		dtlParams.put("m1OrdDtFrom", m1OrdDtFrom);
		dtlParams.put("m1OrdDtTo", m1OrdDtTo);
		dtlParams.put("m0OrdDtFrom", m0OrdDtFrom);
		dtlParams.put("m0OrdDtTo", m0OrdDtTo);
		dtlParams.put("team", team);
		try {
			LOGGER.debug(" dtlParams : {} ", dtlParams);
			salesPlanManagementMapper.insertSalesPlanDetail(dtlParams);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		//	3. update Sales Plan Detail
		listParams.put("year", befWeekYear);
		listParams.put("week", befWeekWeek);
		listParams.put("team", team);
		LOGGER.debug("selectBefWeekList listParams : {}", listParams);
		List<EgovMap> selectBefWeekList		= salesPlanManagementMapper.selectSalesPlanForUpdate(listParams);
		listParams.put("year", planYear);
		listParams.put("week", planWeek);
		listParams.put("team", team);
		LOGGER.debug("selectPlanWeekList listParams : {}", listParams);
		List<EgovMap> selectPlanWeekList	= salesPlanManagementMapper.selectSalesPlanForUpdate(listParams);
		LOGGER.debug("selectBefWeekList : {}", selectBefWeekList);
		LOGGER.debug("selectPlanWeekList : {}", selectPlanWeekList);
		try {
			if ( 0 == selectBefWeekList.size() ) {
				LOGGER.debug("Sales Plan Error");
				return	0;
			}
			
			int	m0Sum	= 0;	int m1Sum	= 0;	int m2Sum	= 0;	int m3Sum	= 0;	int m4Sum	= 0;
			int	weekQty	= 0;
			//	every stock
			for ( int i = 0 ; i < selectBefWeekList.size() ; i++ ) {
				//planDtlId	= Integer.parseInt(selectBefWeekList.get(i).get("planDtlId").toString());
				planDtlId	= Integer.parseInt(selectPlanWeekList.get(i).get("planDtlId").toString());	//	must using selectPlanWeekList
				updParams.put("planDtlId", planDtlId);
				m0Sum	= 0;	m1Sum	= 0;	m2Sum	= 0;	m3Sum	= 0;	m4Sum	= 0;
				if ( planMonth == befWeekMonth ) {
					LOGGER.debug("planMonth == befWeekMonth : " + planMonth + ", " + befWeekMonth);
					String intToStrFieldCnt1	= "";	int iLoopDataFieldCnt1	= 1;	//	전주의 실적을 가져오기 위해서 계산하는 주차변수
					String intToStrFieldCnt2	= "";	int iLoopDataFieldCnt2	= 1;	//	이번주의 실적을 저장하기 위해서 계산하는 주차변수
					/*if ( 2 == planWeekSpltCnt ) {
						//	planWeek가 해당 월의 가장 마지막 주이고, planWeek 가 split week인 경우
						if ( 4 == m0WeekCnt ) {
							iLoopDataFieldCnt1	= 5;
						} else if ( 5 == m0WeekCnt ) {
							iLoopDataFieldCnt1	= 6;
						} else if ( 6 == m0WeekCnt ) {
							iLoopDataFieldCnt1	= 7;
						} else {
							LOGGER.debug("Same : m0WeekCnt is wrong");
						}
					} else {
						LOGGER.debug("Same : plan calendar is wroong");
					}
					LOGGER.debug("Same : Start iLoopDataFieldCnt1 : " + iLoopDataFieldCnt1 + ", planWeekSpltCnt : " + planWeekSpltCnt + ", m0WeekCnt : " + m0WeekCnt);*/
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
						weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
						m0Sum	= m0Sum + weekQty;
						updParams.put("w" + intToStrFieldCnt2, weekQty);
						iLoopDataFieldCnt1++;
						iLoopDataFieldCnt2++;
					}
					updParams.put("m0", m0Sum);
					
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
						weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
						m3Sum	= m3Sum + weekQty;
						updParams.put("w" + intToStrFieldCnt2, weekQty);
						iLoopDataFieldCnt1++;
						iLoopDataFieldCnt2++;
					}
					updParams.put("m3", m3Sum);
					
					/*if ( 2 == planWeekSpltCnt ) {
						//	빈 주차 채우기
						int totWeekCnt	= m0WeekCnt + m1WeekCnt + m2WeekCnt + m3WeekCnt;
						for ( int remain = totWeekCnt + 1 ; remain < 31 ; remain++ ) {
							updParams.put("w" + remain, 0);
						}
						updParams.put("m4", 0);
					} else {*/
						//	3.5 m4
						for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
						//	if ( 1 == intToStrFieldCnt1.length() ) {
						//		intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
						//	}
						//	if ( 1 == intToStrFieldCnt2.length() ) {
						//		intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
						//	}
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
					//}
					
					//LOGGER.debug("updParams : {}", updParams);
					salesPlanManagementMapper.updateSalesPlanDetail(updParams);
				} else {
					LOGGER.debug("planMonth != befWeekMonth : " + planMonth + ", " + befWeekMonth);
					String intToStrFieldCnt1	= "";	int iLoopDataFieldCnt1	= 1;	//	전주의 실적을 가져오기 위해서 계산하는 주차변수
					String intToStrFieldCnt2	= "";	int iLoopDataFieldCnt2	= 1;	//	이번주의 실적을 저장하기 위해서 계산하는 주차변수
					//if ( 2 == planWeekSpltCnt ) {
						//	planWeek가 해당 월의 가장 마지막 주이고, planWeek 가 split week인 경우
						if ( 4 == m0WeekCnt ) {
							iLoopDataFieldCnt1	= 5;
						} else if ( 5 == m0WeekCnt ) {
							iLoopDataFieldCnt1	= 6;
						} else if ( 6 == m0WeekCnt ) {
							iLoopDataFieldCnt1	= 7;
						} else {
							LOGGER.debug("Diff : m0WeekCnt is wrong");
						}
					//} else {
					//	LOGGER.debug("Diff : plan calendar is wroong");
					//}
					//LOGGER.debug("Diff : Start iLoopDataFieldCnt1 : " + iLoopDataFieldCnt1 + ", planWeekSpltCnt : " + planWeekSpltCnt + ", m0WeekCnt : " + m0WeekCnt);
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
						weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
						m0Sum	= m0Sum + weekQty;
						updParams.put("w" + intToStrFieldCnt2, weekQty);
						iLoopDataFieldCnt1++;
						iLoopDataFieldCnt2++;
					}
					updParams.put("m0", m0Sum);
					
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
						weekQty	= Integer.parseInt(selectBefWeekList.get(i).get("w" + intToStrFieldCnt1).toString());
						m2Sum	= m2Sum + weekQty;
						updParams.put("w" + intToStrFieldCnt2, weekQty);
						iLoopDataFieldCnt1++;
						iLoopDataFieldCnt2++;
					}
					updParams.put("m2", m2Sum);
					
					//	3.4 m3
					for ( int m3 = 1 ; m3 < m0WeekCnt + 1 ; m3++ ) {
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
					
					//if ( 2 == planWeekSpltCnt ) {
						//	빈 주차 채우기
						int totWeekCnt	= m0WeekCnt + m1WeekCnt + m2WeekCnt + m3WeekCnt;
						for ( int remain = totWeekCnt + 1 ; remain < 31 ; remain++ ) {
							updParams.put("w" + remain, 0);
						}
						updParams.put("m4", 0);
						/*} else {
						//	3.5 m4
						for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
							intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
							intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
						//	if ( 1 == intToStrFieldCnt1.length() ) {
						//		intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
						//	}
						//	if ( 1 == intToStrFieldCnt2.length() ) {
						//		intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
						//	}
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
					//}
					//LOGGER.debug("updParams : {}", updParams);*/
					salesPlanManagementMapper.updateSalesPlanDetail(updParams);
				}
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	@Override
	public int updateSalesPlanDetail(List<Object> updList, SessionVO sessionVO) {
		
		int updCnt	= 0;
		
		try {
			for ( Object obj : updList ) {
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