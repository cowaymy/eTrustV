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
import com.coway.trust.biz.scm.ScmReportService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("scmReportService")
public class ScmReportServiceImpl implements ScmReportService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmReportServiceImpl.class);

	@Autowired
	private ScmCommonMapper scmCommonMapper;
	@Autowired
	private ScmReportMapper scmReportMapper;

	//	Business Plan Report
	@Override
	public List<EgovMap> selectPlanVer(Map<String, Object> params) {
		return	scmReportMapper.selectPlanVer(params);
	}
	@Override
	public List<EgovMap> selectBusinessPlanSummary(Map<String, Object> params) {
		return	scmReportMapper.selectBusinessPlanSummary(params);
	}
	@Override
	public List<EgovMap> selectBusinessPlanDetail(Map<String, Object> params) {
		return	scmReportMapper.selectBusinessPlanDetail(params);
	}
	@Override
	public List<EgovMap> selectBusinessPlanDetail1(Map<String, Object> params) {
		return	scmReportMapper.selectBusinessPlanDetail1(params);
	}
	@Override
	public int saveBusinessPlanAll(List<Map<String, Object>> allList, SessionVO sessionVO) {

		LOGGER.debug("saveBusinessPlanAll : {}", allList);
		int cnt = 0;
		String mcol = "";

		Map<String, Object> delParam = new HashMap<>();
		delParam.put("year", allList.get(0).get("year"));

		try {
			scmReportMapper.deleteBusinessPlan(delParam);

			for (Map<String, Object> list : allList) {

				if (!CommonUtils.nvl(((Map<String, Object>) list).get("stockCode")).isEmpty()) {
					for (int i = 1; i < 13; i++) {
						mcol = (i < 10) ? "m0" + i : "m" + String.valueOf(i);
						if (!CommonUtils.nvl(((Map<String, Object>) list).get(mcol)).isEmpty()) {
							if (((Map<String, Object>) list).get(mcol).toString().contains(",")) {
								((Map<String, Object>) list).put(mcol,
										((Map<String, Object>) list).get(mcol).toString().replaceAll(",", ""));
							}
						}
					}
					list.put("userId", sessionVO.getUserId());
					scmReportMapper.insertBusinessPlan(list);
					cnt++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return cnt;
	}
	@Override
	public int saveBusinessPlan(List<Map<String, Object>> updList, SessionVO sessionVO) {

		LOGGER.debug("saveBusinessPlanAll : {}", updList);
		int cnt	= 0;

		try {
			for ( Map<String, Object> list : updList ) {
				list.put("userId", sessionVO.getUserId());
				scmReportMapper.updateBusinessPlan(list);
				cnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return	cnt;
	}

	//	Sales Plan Accuracy
	@Override
	public List<EgovMap> selectSalesPlanAccuracyWeeklyDetailHeader(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyWeeklyDetailHeader(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyMonthlyDetailHeader(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyMonthlyDetailHeader(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyWeeklySummary(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyWeeklySummary(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyMonthlySummary(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyMonthlySummary(params);
	}
	@Override
	public List<EgovMap> selectWeekly16Week(Map<String, Object> params) {
		return	scmReportMapper.selectWeekly16Week(params);
	}
	@Override
	public List<EgovMap> selectWeeklyStartEnd(Map<String, Object> params) {
		return	scmReportMapper.selectWeeklyStartEnd(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyWeeklyDetail(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyWeeklyDetail(params);
	}
	@Override
	public List<EgovMap> selectMonthly16Week(Map<String, Object> params) {
		return	scmReportMapper.selectMonthly16Week(params);
	}
	@Override
	public List<EgovMap> selectMonthlyStartEnd(Map<String, Object> params) {
		return	scmReportMapper.selectMonthlyStartEnd(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyMonthlyDetail(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyMonthlyDetail(params);
	}
	@Override
	public List<EgovMap> selectSalesPlanAccuracyMaster(Map<String, Object> params) {
		return	scmReportMapper.selectSalesPlanAccuracyMaster(params);
	}
	@Override
	public int saveSalesPlanAccuracyMaster(List<Map<String, Object>> updList, SessionVO sessionVO) {

		LOGGER.debug("saveSalesPlanAccuracyMaster : {}", updList);

		int thisWeekTh	= 0;
		int saveCnt	= 0;
		int weeklyVal	= 0;

		Map<String, Object> delParam	= new HashMap<>();
		Map<String, Object> insParam	= new HashMap<>();

		try {
			for ( Map<String, Object> list : updList ) {
				//	Master 그리드의 row
				//	delete
				delParam.put("year", list.get("year"));
				delParam.put("gbn", list.get("gbn"));
				LOGGER.debug("saveSalesPlanAccuracyMaster delete : {}", delParam);
				scmReportMapper.deleteSalesPlanAccuracyMaster(delParam);

				//	insert
				for ( int i = 1 ; i < 17 ; i++ ) {
					//	Master 그리드의 column
					weeklyVal	= Integer.parseInt(list.get("w" + i).toString());
					if ( 0 != weeklyVal ) {
						insParam.put("year", list.get("year"));
						insParam.put("gbn", list.get("gbn"));
						insParam.put("week", weeklyVal);
						LOGGER.debug("saveSalesPlanAccuracyMaster insert : {}", insParam);
						scmReportMapper.insertSalesPlanAccuracyMaster(insParam);
					}
				}

				//	마스터 변경한 연도의 판매계획 정확도 재실행
				scmReportMapper.executeSalesPlanAccuracy(delParam);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return	saveCnt;
	}

	//	Ontime Delivery Report
	@Override
	public List<EgovMap> selectOntimeDeliverySummary(Map<String, Object> params) {
		return	scmReportMapper.selectOntimeDeliverySummary(params);
	}
	@Override
	public List<EgovMap> selectOntimeDeliveryDetail(Map<String, Object> params) {
		return	scmReportMapper.selectOntimeDeliveryDetail(params);
	}
	@Override
	public List<EgovMap> selectOntimeDeliveryPopup(Map<String, Object> params) {
		return	scmReportMapper.selectOntimeDeliveryPopup(params);
	}

	//	Inventory Report
	@Override
	public List<EgovMap> selectInventoryReportTotalHeader(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportTotalHeader(params);
	}
	@Override
	public List<EgovMap> selectInventoryReportDetailHeader(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportDetailHeader(params);
	}
	@Override
	public List<EgovMap> selectInventoryReportTotal(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportTotal(params);
	}
	@Override
	public List<EgovMap> selectInventoryReportDetail(Map<String, Object> params) {
		return	scmReportMapper.selectInventoryReportDetail(params);
	}
	@Override
	public List<EgovMap> selectScmCurrency(Map<String, Object> params) {
		return	scmReportMapper.selectScmCurrency(params);
	}
	@Override
	public void updateScmCurrency(Map<String, Object> params) {
		scmReportMapper.updateScmCurrency(params);
	}
	@Override
	public void executeScmInventory(Map<String, Object> params) {
		try {
			scmReportMapper.executeScmInventory(params);

			if ( 0 < Integer.parseInt(params.get("staValue").toString()) ) {
				LOGGER.debug("executeScmInventory.staValue : " + Integer.parseInt(params.get("staValue").toString()));
				scmReportMapper.executeScmDaysInInventory(params);
				if ( 0 < Integer.parseInt(params.get("staValue").toString()) ) {
					LOGGER.debug("executeScmDaysInInventory.staValue : " + Integer.parseInt(params.get("staValue").toString()));
				} else {
					LOGGER.debug("executeScmDaysInInventory occurs error");
				}
			} else {
				LOGGER.debug("executeScmInventory occurs error");
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}

	//	Aging Report
	@Override
	public List<EgovMap> selectAgingInventoryHeader(Map<String, Object> params) {
		return	scmReportMapper.selectAgingInventoryHeader(params);
	}
	@Override
	public List<EgovMap> selectAgingInventory(Map<String, Object> params) {
		return	scmReportMapper.selectAgingInventory(params);
	}
}