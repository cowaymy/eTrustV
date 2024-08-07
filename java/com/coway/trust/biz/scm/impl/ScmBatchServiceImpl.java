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
import com.coway.trust.biz.scm.ScmBatchService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import antlr.StringUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("scmBatchService")
public class ScmBatchServiceImpl implements ScmBatchService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmBatchServiceImpl.class);

	@Autowired
	private ScmCommonMapper scmCommonMapper;
	@Autowired
	private ScmBatchMapper scmBatchMapper;
	


	



	/*
	@Override
	public int updateSupplyPlanRtp(Map<String, Object> params) {
		int cnt	= 0;
		int planYear	= 0;	int planWeek	= 0;
		String stockCode	= "";
		
		List<EgovMap> selectBatchTarget	= scmBatchMapper.selectBatchTarget(params);
		planYear	= Integer.parseInt(selectBatchTarget.get(0).get("planYear").toString());
		planWeek	= Integer.parseInt(selectBatchTarget.get(0).get("planWeek").toString());
		
		Map<String, Object> updateParams	= new HashMap<String, Object>();
		Map<String, Object> basParams	= new HashMap<String, Object>();
		basParams.put("scmYearCbBox", planYear);
		basParams.put("scmWeekCbBox", planWeek);
		
		List<EgovMap> selectScmTotalInfo	= scmCommonMapper.selectScmTotalInfo(basParams);
		int m0WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m0WeekCnt").toString());
		int m1WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m1WeekCnt").toString());
		int m2WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m2WeekCnt").toString());
		int m3WeekCnt	= Integer.parseInt(selectScmTotalInfo.get(0).get("m3WeekCnt").toString());
		
		int totCnt	= 0;
		int weekCnt	= 0;
		
		/*
		 * 공급가시성 데이터 흐름
		 * 1. 본사 -> FTP
		 * 2. FTP데이터 구성
		 * 본사기준
		 * 수립년(yyyy)||수립주차(ww) + 제품코드 + (ww+1)주, (ww+2)주, ... (ww+12)주
		 * ** 스플릿 주차인 경우는 1개의 데이터(data)
		 * ** 그 1개의 데이터(data)는 공급가시성화면에서 스플릿주차인 경우 -1주차에는 0, -2주차에는 데이터(data)
		 * 3. SCM0056S 에 12개 주차의 데이터를 w01 ~ w12까지 순차적으로 insert
		 
		
		for ( int i = 0 ; i < selectBatchTarget.size() ; i++ ) {
			String intToStrFieldCnt1	= "";	int iLoopDataFieldCnt1	= 1;
			int m0	= 0;	int m1	= 0;	int m2	= 0;	int m3	= 0;	int m4	= 0;	int wNn	= 0;
			planYear	= Integer.parseInt(selectBatchTarget.get(i).get("planYear").toString());
			planWeek	= Integer.parseInt(selectBatchTarget.get(i).get("planWeek").toString());
			stockCode	= selectBatchTarget.get(i).get("stockCode").toString();
			
			//	m0
			for ( int i0 = 1 ; i0 < m0WeekCnt ; i0++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				if ( 1 == intToStrFieldCnt1.length() ) {
					intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				}
				wNn	= Integer.parseInt(selectBatchTarget.get(i).get("w" + intToStrFieldCnt1).toString());
				m0	= m0 + wNn;
				iLoopDataFieldCnt1++;
				weekCnt++;
				LOGGER.debug("m0 : " + "w" + intToStrFieldCnt1 + " : " + wNn);
			}
			//	m1
			for ( int i1 = 1 ; i1 < m0WeekCnt ; i1++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				if ( 1 == intToStrFieldCnt1.length() ) {
					intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				}
				wNn	= Integer.parseInt(selectBatchTarget.get(i).get("w" + intToStrFieldCnt1).toString());
				m1	= m1 + wNn;
				iLoopDataFieldCnt1++;
				weekCnt++;
				LOGGER.debug("m1 : " + "w" + intToStrFieldCnt1 + " : " + wNn);
			}
			//	m2
			for ( int i2 = 1 ; i2 < m0WeekCnt ; i2++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				if ( 1 == intToStrFieldCnt1.length() ) {
					intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				}
				
				if ( 12 > weekCnt ) {
					wNn	= Integer.parseInt(selectBatchTarget.get(i).get("w" + intToStrFieldCnt1).toString());
					m2	= m2 + wNn;
				}
				iLoopDataFieldCnt1++;
				weekCnt++;
				LOGGER.debug("m2 : " + "w" + intToStrFieldCnt1 + " : " + wNn);
			}
			//	m3
			for ( int i3 = 1 ; i3 < m0WeekCnt ; i3++ ) {
				intToStrFieldCnt1	= String.valueOf(iLoopDataFieldCnt1);
				if ( 1 == intToStrFieldCnt1.length() ) {
					intToStrFieldCnt1	= "0" + intToStrFieldCnt1;
				}
				if ( 12 > weekCnt ) {
					wNn	= Integer.parseInt(selectBatchTarget.get(i).get("w" + intToStrFieldCnt1).toString());
					m3	= m3 + wNn;
				}
				iLoopDataFieldCnt1++;
				weekCnt++;
				LOGGER.debug("m3 : " + "w" + intToStrFieldCnt1 + " : " + wNn);
			}
			
			totCnt++;
			updateParams.put("m0", m0);
			updateParams.put("m1", m1);
			updateParams.put("m2", m2);
			updateParams.put("m3", m3);
			updateParams.put("m4", m4);
			updateParams.put("planYear", planYear);
			updateParams.put("planWeek", planWeek);
			updateParams.put("stockCode", stockCode);
			LOGGER.debug("updateParams : {} ", updateParams.toString());
			scmBatchMapper.updateSupplyPlanRpt(updateParams);
		}
		
		return	cnt;
	}
	*/

}