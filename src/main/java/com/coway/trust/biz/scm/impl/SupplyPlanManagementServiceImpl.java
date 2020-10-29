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
	private ScmCommonMapper scmCommonMapper;

	/*
	 * Supply Plan By CDC
	 */
	@Override
	public List<EgovMap> selectSupplyPlanPsi1(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanPsi1(params);
	}
	@Override
	public List<EgovMap> selectSupplyPlanHeader(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanHeader(params);
	}
	@Override
	public List<EgovMap> selectSupplyPlanInfo(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanInfo(params);
	}
	@Override
	public List<EgovMap> selectSupplyPlanList(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanList(params);
	}
	@Override
	public List<EgovMap> selectGetPoCntTargetCnt(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectGetPoCntTargetCnt(params);
	}
	@Override
	public int insertSupplyPlanMaster(Map<String, Object> params, SessionVO sessionVO) {

		int saveCnt	= 0;
		LOGGER.debug("insertSupplyPlanMaster : {}", params);

		//	variables
		String issDtFrom	= "";	String planWeekStart	= "";
		String issDtTo		= "";	String planWeekEnd		= "";
		String cdc			= "";
		int crtUserId		= 0;
		int planId			= 0;	int planDtlId		= 0;
		int planYear		= 0;	int planMonth		= 0;	int planWeek	= 0;
		int befWeekYear		= 0;	int befWeekMonth	= 0;	int befWeekWeek	= 0;
		//int invenYear		= 0;	int invenMonth		= 0;
		int scmWeekSeq		= 0;	int isSplt			= 0;
		int leadTm			= 0;
		int planWeekTh		= 0;
		int planFstSpltWeek		= 0;
		int planFstWeek			= 0;
		int planYearLstWeek		= 0;
		int fromPlanToPoSpltCnt		= 0;	//	SplitCnt
		int closeYear		= 0;
		int closeMonth	= 0;
		int m0WeekCnt	= 0;	int m1WeekCnt	= 0;	int m2WeekCnt	= 0;	int m3WeekCnt	= 0;	int m4WeekCnt	= 0;

		// Insert by Hui Ding -- set max dummy weeks -- 18
		int maxDumWeek = 18;

		//	0.0 set from params
		cdc	= params.get("scmCdcCbBox").toString();
		crtUserId	= sessionVO.getUserId();

		//	0. set from SCM Total Info
		List<EgovMap> selectScmTotalInfo	= scmCommonMapper.selectScmTotalInfo(params);
		//List<EgovMap> selectSalesplanMonth	= salesPlanManagementMapper.selectSalesPlanMonth(params);
		//List<EgovMap> selectTotalSplitInfo	= supplyPlanManagementMapper.selectTotalSplitInfo(params);
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planMonth	= Integer.parseInt(selectScmTotalInfo.get(0).get("planMonth").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		befWeekYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekYear").toString());
		befWeekMonth	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekMonth").toString());
		befWeekWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekWeek").toString());
		leadTm		= Integer.parseInt(selectScmTotalInfo.get(0).get("leadTm").toString());
		planWeekTh	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeekTh").toString());
		planFstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planFstWeek").toString());
		planFstSpltWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planFstSpltWeek").toString());
		planYearLstWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYearLstWeek").toString());
		fromPlanToPoSpltCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("fromPlanToPoSpltCnt").toString());
		closeYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("closeYear").toString());
		closeMonth	= Integer.parseInt(selectScmTotalInfo.get(0).get("closeMonth").toString());
		issDtFrom	= selectScmTotalInfo.get(0).get("issDtFrom").toString();
		issDtTo		= selectScmTotalInfo.get(0).get("issDtTo").toString();
		m0WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0WeekCnt").toString());
		m1WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1WeekCnt").toString());
		m2WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2WeekCnt").toString());
		m3WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3WeekCnt").toString());
		m4WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m4WeekCnt").toString());

		if ( planFstWeek == planFstSpltWeek ) {
			planWeekTh	= planWeekTh + 1;
		}

		//	1. insert Supply Plan Master
		Map<String, Object> mstParams = new HashMap<String, Object>();
		mstParams.put("planYear", planYear);
		mstParams.put("planMonth", planMonth);
		mstParams.put("planWeek", planWeek);
		mstParams.put("cdc", cdc);
		mstParams.put("crtUserId", crtUserId);
		try {
			LOGGER.debug("mstParams : {} ", mstParams);
			supplyPlanManagementMapper.insertSupplyPlanMaster(mstParams);
			saveCnt++;
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		//	2. insert Supply Plan Detail
		List<EgovMap> selectGetSupplyPlanId	= supplyPlanManagementMapper.selectGetSupplyPlanId(params);
		planId	= Integer.parseInt(selectGetSupplyPlanId.get(0).get("planId").toString());

		Map<String, Object> psi1InsParams = new HashMap<String, Object>();
		//	2-1. psi #1 : Sales Plan insert
		psi1InsParams.put("planId", planId);
		psi1InsParams.put("planYear", planYear);
		psi1InsParams.put("planWeek", planWeek);
		psi1InsParams.put("cdc", cdc);
		psi1InsParams.put("issDtFrom", issDtFrom);
		psi1InsParams.put("issDtTo", issDtTo);
		psi1InsParams.put("closeYear", closeYear);
		psi1InsParams.put("closeMonth", closeMonth);
		psi1InsParams.put("crtUserId", crtUserId);
		try {
			LOGGER.debug("psi1InsParams : {} ", psi1InsParams);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi1(psi1InsParams);
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		Map<String, Object> psi235InsParams = new HashMap<String, Object>();
		//	2-2. psi #2, #3, #5 : Safety Stock, Inventory by CDC
		psi235InsParams.put("planId", planId);
		psi235InsParams.put("planYear", planYear);
		psi235InsParams.put("planWeek", planWeek);
		psi235InsParams.put("cdc", cdc);
		psi235InsParams.put("closeYear", closeYear);
		psi235InsParams.put("closeMonth", closeMonth);
		psi235InsParams.put("crtUserId", crtUserId);
		try {
			LOGGER.debug("psi235InsParams : {} ", psi235InsParams);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi235(psi235InsParams);
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		Map<String, Object> psi4InsParams = new HashMap<String, Object>();
		//	2-3. psi #4 : Before Week Supply Plan
		psi4InsParams.put("planId", planId);
		psi4InsParams.put("planYear", planYear);
		psi4InsParams.put("planMonth", planMonth);
		psi4InsParams.put("planWeek", planWeek);
		psi4InsParams.put("cdc", cdc);
		psi4InsParams.put("befWeekYear", befWeekYear);
		psi4InsParams.put("befWeekWeek", befWeekWeek);
		psi4InsParams.put("crtUserId", crtUserId);
		try {
			LOGGER.debug("psi4InsParams : {} ", psi4InsParams);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi4(psi4InsParams);
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		//	3. update Supply Plan Detail
		String stockCode	= "";
		int m0Psi1	= 0;	int m0Psi2	= 0;	int m0Psi3	= 0;	int m0Psi5	= 0;
		int m1Psi1	= 0;	int m1Psi2	= 0;	int m1Psi3	= 0;	int m1Psi5	= 0;
		int m2Psi1	= 0;	int m2Psi2	= 0;	int m2Psi3	= 0;	int m2Psi5	= 0;
		int m3Psi1	= 0;	int m3Psi2	= 0;	int m3Psi3	= 0;	int m3Psi5	= 0;
		int m4Psi1	= 0;	int m4Psi2	= 0;	int m4Psi3	= 0;	int m4Psi5	= 0;
		int planGrYear	= 0;
		int planGrWeek	= 0;

		params.put("psiId", 1);	List<EgovMap> selectPsi1	= supplyPlanManagementMapper.selectPsi1(params);		//	psi1
		params.put("psiId", 2);	List<EgovMap> selectPsi2	= supplyPlanManagementMapper.selectEachPsi(params);		//	psi2
		params.put("psiId", 4);	List<EgovMap> selectPsi4	= supplyPlanManagementMapper.selectEachPsi(params);		//	psi4
		params.put("psiId", 5);	List<EgovMap> selectPsi5	= supplyPlanManagementMapper.selectEachPsi(params);		//	psi5
		LOGGER.debug("selectPsi1 : {}", selectPsi1);
		LOGGER.debug("selectPsi2 : {}", selectPsi2);
		LOGGER.debug("selectPsi4 : {}", selectPsi4);
		LOGGER.debug("selectPsi5 : {}", selectPsi5);

		//	psi2, psi5
		Map<String, Object> psi1UpdParams = new HashMap<String, Object>();
		Map<String, Object> psi2UpdParams = new HashMap<String, Object>();
		Map<String, Object> psi3UpdParams = new HashMap<String, Object>();
		Map<String, Object> psi5UpdParams = new HashMap<String, Object>();

		int moq	= 0;
		int safetyStock	= 0;
		//int loadingQty	= 0;
		int basicQty	= 0;
		int earlyGr		= 0;
		int overdue		= 0;
		int totLeadTm	= leadTm + planWeekTh + fromPlanToPoSpltCnt;	//	stock의 leadTm, 수립주차(planWeek), 수립주차의 해당월의 주차순서, leadTm 내의 스플릿주차 등을 감안한 최종 leadTm
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
			//loadingQty	= Integer.parseInt(selectPsi1.get(i).get("loadingQty").toString());
			basicQty	= Integer.parseInt(selectPsi5.get(i).get("overdue").toString());	//	psi1의 overdue는 전월 기초재고
			overdue		= Integer.parseInt(selectPsi1.get(i).get("overdue").toString());	//	psi5의 overdue는 전월 Overdue
			earlyGr		= Integer.parseInt(selectPsi4.get(i).get("overdue").toString());	//	psi4의 overdue는 수립월 기준 early gr

			//	basicQty다시 계산
			basicQty	= basicQty - overdue - earlyGr;

			psi1UpdParams.put("planId", planId);
			psi1UpdParams.put("psiId", 1);
			psi1UpdParams.put("stockCode", stockCode);
			psi2UpdParams.put("planId", planId);
			psi2UpdParams.put("psiId", 2);
			psi2UpdParams.put("stockCode", stockCode);
			psi3UpdParams.put("planId", planId);
			psi3UpdParams.put("psiId", 3);
			psi3UpdParams.put("stockCode", stockCode);
			psi5UpdParams.put("planId", planId);
			psi5UpdParams.put("psiId", 5);
			psi5UpdParams.put("stockCode", stockCode);

			//	to get po cnt
			Map<String, Object> targetParams = new HashMap<String, Object>();
			//LOGGER.debug("planFstWeek : " + planFstWeek + ", planFstSpltWeekk : " + planFstSpltWeek + ", planWeekTh : " + planWeekTh);
			targetParams.put("planYear", planYear);
			targetParams.put("planMonth", planMonth);
			targetParams.put("planWeekTh", planWeekTh);
			targetParams.put("planFstSpltWeek", planFstSpltWeek);
			targetParams.put("planYearLstWeek", planYearLstWeek);
			targetParams.put("leadTm", leadTm);
			List<EgovMap> selectGetPoCntTarget	= supplyPlanManagementMapper.selectGetPoCntTarget(targetParams);
			Map<String, Object> poParams = new HashMap<String, Object>();
			//int poLoop	= leadTm + planWeekTh;	//	공급계획에서 처음 리드타임 구간동안 PO발주량을 갖고올건데 그 횟수
			//for ( int j = 0 ; j < poLoop ; j++ ) {
			int seq	= 0;
			for ( int j = 0 ; j < selectGetPoCntTarget.size() ; j++ ) {
				isSplt		= Integer.parseInt(selectGetPoCntTarget.get(j).get("isSplt").toString());
				scmWeekSeq	= Integer.parseInt(selectGetPoCntTarget.get(j).get("scmWeekSeq").toString());
				planGrYear	= Integer.parseInt(selectGetPoCntTarget.get(j).get("scmYear").toString());
				planGrWeek	= Integer.parseInt(selectGetPoCntTarget.get(j).get("scmWeek").toString());

				seq	= j + 1;
				if ( 1 == isSplt ) {
					if ( 1 == scmWeekSeq ) {
						//	split 앞주차
						poParams.put("year" + seq, 9999);		//	split 앞주차는 PO값을 안가져오기 위해서 파라미터 99 : dummy
						poParams.put("week" + seq, 99);
					} else {
						//	split 뒷주차
						poParams.put("year" + seq, planGrYear);	//	split 뒷주차는 PO값을 가져오기 위해서 파라미터 planWeek
						poParams.put("week" + seq, planGrWeek);
					}
				} else {
					poParams.put("year" + seq, planGrYear);
					poParams.put("week" + seq, planGrWeek);
				}
				LOGGER.debug("j : " + j + ", seq : " + seq + ", year" + seq + " : " + poParams.get("year" + seq) + ", week" + seq + " : " + poParams.get("week" + seq));
			}
			//	fill dummy params
			for ( int j = selectGetPoCntTarget.size() + 1 ; j < 18 ; j++ ) {
			//for ( int j = poLoop + 1 ; j < 16 ; j++ ) {
				poParams.put("year" + j, 9999);
				poParams.put("week" + j, 99);
			}
			poParams.put("cdc", cdc);
			poParams.put("stockCode", stockCode);
			LOGGER.debug("poParams : {}", poParams);
			LOGGER.debug("This week confirm section : " + selectGetPoCntTarget.size());
			List<EgovMap> selectGetPoCnt	= supplyPlanManagementMapper.selectGetPoCnt(poParams);

			//	each sum var init
			m0Psi1	= 0;	m0Psi3	= 0;
			m1Psi1	= 0;	m1Psi3	= 0;
			m2Psi1	= 0;	m2Psi3	= 0;
			m3Psi1	= 0;	m3Psi3	= 0;
			m4Psi1	= 0;	m4Psi3	= 0;

			//	m0
			//	get m0Psi1
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
				LOGGER.debug("m0Psi1 : " + m0Psi1 + ", psi1 : " + psi1);
			}
			psi1UpdParams.put("m0", m0Psi1);
			for ( int m0 = 1 ; m0 < m0WeekCnt + 1 ; m0++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				if ( 1 == intToStrFieldCnt2.length() ) {
					intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				}
				//	psi2
				//m0Psi2	= (int)((double)(m0Psi1 / 30) * safetyStock);
				m0Psi2	= (int) Math.ceil((m0Psi1 / 30.0) * safetyStock);
				LOGGER.debug("before calc : " + (m0Psi1 / 30.0 * safetyStock) + ", after calc : " + (int) Math.ceil((m0Psi1 / 30.0) * safetyStock));
				psi2UpdParams.put("m0", m0Psi2);
				psi2UpdParams.put("w" + intToStrFieldCnt2, m0Psi2);

				//	psi3
				// Added by Hui Ding -- set max dummy week, 2020-10-29
				if (iLoopDataFieldCnt2 < maxDumWeek)
					psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m0Psi2;	//	ok
				//	check leadTm
				if ( totLeadTm >= iLoopDataFieldCnt2 ) {
				//if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					if ( 1 == m0 ) {
						//psi5	= basicQty - overdue - earlyGr;
						psi5	= basicQty;
					}
					// Added by Hui Ding -- set max dummy week, 2020-10-29
					if (iLoopDataFieldCnt2 < maxDumWeek)
						psi3	= Integer.parseInt(selectGetPoCnt.get(0).get("w" + intToStrFieldCnt2).toString());

					//LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
					psi5	= psi5 - psi1 + psi3;
				} else {
					if ( 1 == m0 ) {
						//psi5	= basicQty - overdue - earlyGr;
						psi5	= basicQty;
					}
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
					psi5	= psi5 - psi1 + psi3;
					//LOGGER.debug("2. m0 : " + m0 + ", psi1 : " + psi1 + ", psi2 : " + psi2 + ", psi3 : " + psi3 + ", psi5 : " + psi5 + ", m0Psi3 : " + m0Psi3);
				}
				//	moq와 비교
				if ( psi3 < moq && psi3 > 0 ) {
					//LOGGER.debug("stockCode : " + stockCode + ", psi3 : " + psi3 + ", moq : " + moq);
					psi3	= moq;
				}
				m0Psi3	= m0Psi3 + psi3;
				psi3UpdParams.put("w" + intToStrFieldCnt2, psi3);
				psi5UpdParams.put("m0", psi5);	//	하나씩 덮어넣다보면 제일 마지막것이 들어간다.
				psi5UpdParams.put("w" + intToStrFieldCnt2, psi5);

				iLoopDataFieldCnt2++;
			}
			psi3UpdParams.put("m0", m0Psi3);

			//	m1
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
			psi1UpdParams.put("m1", m1Psi1);
			for ( int m1 = 1 ; m1 < m1WeekCnt + 1 ; m1++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				if ( 1 == intToStrFieldCnt2.length() ) {
					intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				}
				//	psi2
				//m1Psi2	= m1Psi1 / 30 * safetyStock;
				m1Psi2	= (int) Math.ceil((m1Psi1 / 30.0) * safetyStock);
				LOGGER.debug("before calc : " + (m1Psi1 / 30.0 * safetyStock) + ", after calc : " + (int) Math.ceil((m1Psi1 / 30.0) * safetyStock));
				psi2UpdParams.put("m1", m1Psi2);
				psi2UpdParams.put("w" + intToStrFieldCnt2, m1Psi2);
				//	psi3, psi5
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m1Psi2;
				if ( totLeadTm >= iLoopDataFieldCnt2 ) {
				//if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					// Added by Hui Ding -- set max dummy week, 2020-10-29
					if (iLoopDataFieldCnt2 < maxDumWeek)
						psi3	= Integer.parseInt(selectGetPoCnt.get(0).get("w" + intToStrFieldCnt2).toString());
					//LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
				} else {
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
				}
				//	moq와 비교
				if ( psi3 < moq && psi3 > 0 ) {
					//LOGGER.debug("stockCode : " + stockCode + ", psi3 : " + psi3 + ", moq : " + moq);
					psi3	= moq;
				}
				psi5	= psi5 - psi1 + psi3;
				/*if ( totLeadTm == iLoopDataFieldCnt2 ) {
					if ( psi5 < 0 ) {
						psi5	= 0 - psi1 + psi3;
					} else {
						psi5	= psi5 - psi1 + psi3;
					}
				} else {
					psi5	= psi5 - psi1 + psi3;
				}*/
				m1Psi3	= m1Psi3 + psi3;
				psi3UpdParams.put("w" + intToStrFieldCnt2, psi3);
				psi5UpdParams.put("m1", psi5);
				psi5UpdParams.put("w" + intToStrFieldCnt2, psi5);

				iLoopDataFieldCnt2++;
			}
			psi3UpdParams.put("m1", m1Psi3);

			//	m2
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
			psi1UpdParams.put("m2", m2Psi1);
			for ( int m2 = 1 ; m2 < m2WeekCnt + 1 ; m2++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				if ( 1 == intToStrFieldCnt2.length() ) {
					intToStrFieldCnt2	= "0" + intToStrFieldCnt2;
				}
				//	psi2
				//m2Psi2	= m2Psi1 / 30 * safetyStock;
				m2Psi2	= (int) Math.ceil((m2Psi1 / 30.0) * safetyStock);
				LOGGER.debug("before calc : " + (m2Psi1 / 30.0 * safetyStock) + ", after calc : " + (int) Math.ceil((m2Psi1 / 30.0) * safetyStock));
				psi2UpdParams.put("m2", m2Psi2);
				psi2UpdParams.put("w" + intToStrFieldCnt2, m2Psi2);
				//	psi3, psi5
				// Added by Hui Ding -- set max dummy week, 2020-10-29
				if (iLoopDataFieldCnt2 < maxDumWeek)
					psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m2Psi2;
				if ( totLeadTm >= iLoopDataFieldCnt2 ) {
				//if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					// Added by Hui Ding -- set max dummy week, 2020-10-29
					if (iLoopDataFieldCnt2 < maxDumWeek)
						psi3	= Integer.parseInt(selectGetPoCnt.get(0).get("w" + intToStrFieldCnt2).toString());
					//LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
				} else {
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
				}
				//	moq와 비교
				if ( psi3 < moq && psi3 > 0 ) {
					//LOGGER.debug("stockCode : " + stockCode + ", psi3 : " + psi3 + ", moq : " + moq);
					psi3	= moq;
				}
				psi5	= psi5 - psi1 + psi3;
				/*if ( totLeadTm == iLoopDataFieldCnt2 ) {
					if ( psi5 < 0 ) {
						psi5	= 0 - psi1 + psi3;
					} else {
						psi5	= psi5 - psi1 + psi3;
					}
				} else {
					psi5	= psi5 - psi1 + psi3;
				}*/
				m2Psi3	= m2Psi3 + psi3;
				psi3UpdParams.put("w" + intToStrFieldCnt2, psi3);
				psi5UpdParams.put("m2", psi5);
				psi5UpdParams.put("w" + intToStrFieldCnt2, psi5);

				iLoopDataFieldCnt2++;
			}
			psi3UpdParams.put("m2", m2Psi3);

			//	m3
			for ( int m3 = 1 ; m3 < m3WeekCnt + 1 ; m3++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt1).toString());
				if ( 0 == selectPsi1.size() ) {
					m3Psi1	= 0;
				} else {
					m3Psi1	= m3Psi1 + psi1;
				}
				iLoopDataFieldCnt1++;
			}
			psi1UpdParams.put("m3", m3Psi1);
			for ( int m3 = 1 ; m3 < m3WeekCnt + 1 ; m3++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				//	psi2
				//m3Psi2	= m3Psi1 / 30 * safetyStock;
				m3Psi2	= (int) Math.ceil((m3Psi1 / 30.0) * safetyStock);
				LOGGER.debug("before calc : " + (m3Psi1 / 30.0 * safetyStock) + ", after calc : " + (int) Math.ceil((m3Psi1 / 30.0) * safetyStock));
				psi2UpdParams.put("m3", m3Psi2);
				psi2UpdParams.put("w" + intToStrFieldCnt2, m3Psi2);
				//	psi3, psi5
				// Added by Hui Ding -- set max dummy week, 2020-10-29
				if (iLoopDataFieldCnt2 < maxDumWeek)
					psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m3Psi2;
				if ( totLeadTm >= iLoopDataFieldCnt2 ) {
				//if ( totLeadTm > iLoopDataFieldCnt2 || totLeadTm == iLoopDataFieldCnt2 ) {
					LOGGER.debug("###iLoopDataFieldCnt2: " + iLoopDataFieldCnt2);
					// Added by Hui Ding -- set max dummy week, 2020-10-29
					if (iLoopDataFieldCnt2 < maxDumWeek)
						psi3	= Integer.parseInt(selectGetPoCnt.get(0).get("w" + intToStrFieldCnt2).toString());
					//LOGGER.debug("In leadTm get PO cnt : " + intToStrFieldCnt2);
				} else {
					if ( 0 > psi1 + psi2 - psi5 ) {
						psi3	= 0;
					} else {
						psi3	= psi1 + psi2 - psi5;
					}
				}
				//	moq와 비교
				if ( psi3 < moq && psi3 > 0 ) {
					//LOGGER.debug("stockCode : " + stockCode + ", psi3 : " + psi3 + ", moq : " + moq);
					psi3	= moq;
				}
				psi5	= psi5 - psi1 + psi3;
				/*if ( totLeadTm == iLoopDataFieldCnt2 ) {
					if ( psi5 < 0 ) {
						psi5	= 0 - psi1 + psi3;
					} else {
						psi5	= psi5 - psi1 + psi3;
					}
				} else {
					psi5	= psi5 - psi1 + psi3;
				}*/
				m3Psi3	= m3Psi3 + psi3;
				psi3UpdParams.put("w" + intToStrFieldCnt2, psi3);
				psi5UpdParams.put("m3", psi5);
				psi5UpdParams.put("w" + intToStrFieldCnt2, psi5);

				iLoopDataFieldCnt2++;
			}
			psi3UpdParams.put("m3", m3Psi3);

			//	m4
			for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt1).toString());
				if ( 0 == selectPsi1.size() ) {
					m4Psi1	= 0;
				} else {
					m4Psi1	= m4Psi1 + psi1;
				}
				iLoopDataFieldCnt1++;
			}
			psi1UpdParams.put("m4", m4Psi1);
			for ( int m4 = 1 ; m4 < m4WeekCnt + 1 ; m4++ ) {
				intToStrFieldCnt2	= String.valueOf(iLoopDataFieldCnt2);
				//	psi2
				//m4Psi2	= m4Psi1 / 30 * safetyStock;
				m4Psi2	= (int) Math.ceil((m4Psi1 / 30.0) * safetyStock);
				LOGGER.debug("before calc : " + (m4Psi1 / 30.0 * safetyStock) + ", after calc : " + (int) Math.ceil((m4Psi1 / 30.0) * safetyStock));
				psi2UpdParams.put("m4", m4Psi2);
				psi2UpdParams.put("w" + intToStrFieldCnt2, m4Psi2);
				//	psi3, psi5
				// Added by Hui Ding -- set max dummy week, 2020-10-29
				if (iLoopDataFieldCnt2 < maxDumWeek)
					psi1	= Integer.parseInt(selectPsi1.get(i).get("w" + intToStrFieldCnt2).toString());
				psi2	= m4Psi2;
				if ( 0 > psi1 + psi2 - psi5 ) {
					psi3	= 0;
				} else {
					psi3	= psi1 + psi2 - psi5;
				}
				//	moq와 비교
				if ( psi3 < moq && psi3 > 0 ) {
					//LOGGER.debug("stockCode : " + stockCode + ", psi3 : " + psi3 + ", moq : " + moq);
					psi3	= moq;
				}
				psi5	= psi5 - psi1 + psi3;
				/*if ( totLeadTm == iLoopDataFieldCnt2 ) {
					if ( psi5 < 0 ) {
						psi5	= 0 - psi1 + psi3;
					} else {
						psi5	= psi5 - psi1 + psi3;
					}
				} else {
					psi5	= psi5 - psi1 + psi3;
				}*/
				m4Psi3	= m4Psi3 + psi3;
				psi3UpdParams.put("w" + intToStrFieldCnt2, psi3);
				psi5UpdParams.put("m4", psi5);
				psi5UpdParams.put("w" + intToStrFieldCnt2, psi5);

				iLoopDataFieldCnt2++;
			}
			psi3UpdParams.put("m4", m4Psi3);

			//	set last week to 30 week
			int totWeekCnt	= m0WeekCnt + m1WeekCnt + m2WeekCnt + m3WeekCnt + m4WeekCnt;
			for ( int remain = totWeekCnt + 1 ; remain < 31 ; remain++ ) {
				psi1UpdParams.put("w" + remain, 0);
				psi2UpdParams.put("w" + remain, 0);
				psi3UpdParams.put("w" + remain, 0);
				psi5UpdParams.put("w" + remain, 0);
			}
			LOGGER.debug("psi1UpdParams : {}", psi1UpdParams);
			LOGGER.debug("psi2UpdParams : {}", psi2UpdParams);
			LOGGER.debug("psi3UpdParams : {}", psi3UpdParams);
			LOGGER.debug("psi5UpdParams : {}", psi5UpdParams);
			psi5UpdParams.put("basicQty", basicQty);	//	마지막에 basicQty 수정
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi1(psi1UpdParams);
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi23(psi2UpdParams);
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi23(psi3UpdParams);
			supplyPlanManagementMapper.updateSupplyPlanDetailPsi5(psi5UpdParams);
		}

		return	saveCnt;
	}
	@Override
	public void deleteSupplyPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		int dtlCnt	= 0;
		int mstCnt	= 0;

		try {
			dtlCnt	= supplyPlanManagementMapper.deleteSupplyPlanDetail(params);
			LOGGER.debug("Supply Plan Detail Delete cnt : " + dtlCnt);
			mstCnt	= supplyPlanManagementMapper.deleteSupplyPlanMaster(params);
			LOGGER.debug("Supply Plan Master Delete cnt : " + mstCnt);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	@Override
	public int updateSupplyPlanDetail(List<Object> updList, SessionVO sessionVO) {
		//	int var
		int saveCnt	= 0;
		int updUserId	= sessionVO.getUserId();

		try {
			for ( Object obj : updList ) {
				((Map<String, Object>) obj).put("updUserId", updUserId);
				supplyPlanManagementMapper.updateSupplyPlanDetail((Map<String, Object>) obj);
				LOGGER.debug("planDtlId : ", ((Map<String, Object>) obj).get("planDtlId"));
				saveCnt++;
			}
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

	/*
	 * Supply Plan Summary View
	 */
	@Override
	public List<EgovMap> selectSupplyPlanSummaryList(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectSupplyPlanSummaryList(params);
	}
	/*
	//	이하 미사용
	@Override
	public int insertSupplyPlanDetail(Map<String, Object> params, SessionVO sessionVO) {
		int saveCnt	= 0;

		String planId		= "";
		String planYear		= "";	String befWeekYear	= "";
		String planMonth	= "";	String befWeekMonth	= "";
		String planWeek		= "";	String befWeekWeek	= "";
		String issDtFrom	= "";
		String issDtTo		= "";

		List<EgovMap> selectSupplyPlanInfo	= supplyPlanManagementMapper.selectSupplyPlanInfo(params);	//	planId, planMonth
		planId		= selectSupplyPlanInfo.get(0).get("planId").toString();
		planYear	= params.get("scmYearCbBox").toString();
		planMonth	= selectSupplyPlanInfo.get(0).get("planMonth").toString();
		planWeek	= params.get("scmWeekCbBox").toString();
		params.put("planId", Integer.parseInt(planId));
		params.put("planMonth", Integer.parseInt(planMonth));
		LOGGER.debug("selectSupplyPlanInfo : {}", selectSupplyPlanInfo);
		List<EgovMap> selectSplitInfo	= salesPlanManagementMapper.selectSplitInfo(params);			//	m0WeekCnt ~ m4WeekCnt
		List<EgovMap> selectBefWeekInfo	= supplyPlanManagementMapper.selectBefWeekInfo(params);			//	befWeekYear, befWeekMonth, befWeekWeek
		LOGGER.debug("selectSplitInfo : {}", selectSplitInfo);
		LOGGER.debug("selectBefWeekInfo : {}", selectBefWeekInfo);

		if ( 1 == planMonth.length() ) {
			planMonth	= "0" + planMonth;
		}
		issDtFrom	= planYear + planMonth + "01";
		issDtTo		= planYear + planMonth + "31";
		params.put("issDtFrom", issDtFrom);
		params.put("issDtTo", issDtTo);

		//	1. psi #1 : Sales Plan insert
		try {
			LOGGER.debug("insert psi#1 -> issDtFrom : " + issDtFrom + ", issDtTo : " + issDtTo);
			supplyPlanManagementMapper.insertSupplyPlanDetailPsi1(params);
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		//	2. psi #4 : Before Week Supply Plan
		befWeekYear		= selectBefWeekInfo.get(0).get("befWeekYear").toString();
		befWeekMonth	= selectBefWeekInfo.get(0).get("befWeekMonth").toString();
		befWeekWeek		= selectBefWeekInfo.get(0).get("befWeekWeek").toString();
		params.put("befWeekYear", Integer.parseInt(befWeekYear));
		params.put("befWeekMonth", Integer.parseInt(befWeekMonth));
		params.put("befWeekWeek", Integer.parseInt(befWeekWeek));

		try {
			LOGGER.debug("insert psi 4 -> befWeekYear : " + befWeekYear + ", befWeekMonth : " + befWeekMonth + ", befWeekWeek : " + befWeekWeek);
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

	public static String getReplaceStr(String str, String oldChar, String newChar) {
		if ( null == str )	return	"";

		StringBuffer out	= new StringBuffer();
		StringTokenizer st	= new StringTokenizer(str.toString(), oldChar);
		while ( st.hasMoreTokens() ) {
			out.append(st.nextToken() + newChar);
		}

		return	out.toString();
	}
	@Override
	public List<EgovMap> selectTotalSplitInfo(Map<String, Object> params) {
		return	supplyPlanManagementMapper.selectTotalSplitInfo(params);
	}*/
}