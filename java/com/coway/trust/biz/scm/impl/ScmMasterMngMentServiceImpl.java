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

import com.coway.trust.biz.scm.ScmMasterMngMentService;
import com.coway.trust.cmmn.model.SessionVO;
import com.crystaldecisions.reports.common.value.StringValue;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ScmMasterMngMentService")
public class ScmMasterMngMentServiceImpl implements ScmMasterMngMentService
{
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterMngMentServiceImpl.class);
	
	@Autowired
	private ScmMasterMngMentMapper scmMasterMngMentMapper;
	
	//	Master Management
	@Override
	public List<EgovMap> selectMasterMngmentSearch(Map<String, Object> params) {
		return scmMasterMngMentMapper.selectMasterMngmentSearch(params);
	}
	@Override
	public List<EgovMap> selectInvenCbBoxByStockType(Map<String, Object> params) {
		return scmMasterMngMentMapper.selectInvenCbBoxByStockType(params);
	}
	@Override
	public List<EgovMap> selectInvenCbBoxByCategory(Map<String, Object> params) {
		return scmMasterMngMentMapper.selectInvenCbBoxByCategory(params);
	}
	
	@Override
	public int updateMasterMngment(List<Object> updList, Integer crtUserId) {
		int saveCnt	= 0;
		
		for ( Object obj : updList ) {
			LOGGER.debug(" >>>>> updateMasterMngment_imple: {} ", updList.toString() );
			LOGGER.debug(" startDt : {}", String.valueOf(((Map<String, Object>) obj).get("startDt")));
			LOGGER.debug(" endDt : {}", String.valueOf(((Map<String, Object>) obj).get("endDt")));
			LOGGER.debug( " klTarget : {}",  String.valueOf(((Map<String, Object>) obj).get("klTarget")) );
			
			((Map<String, Object>) obj).put("cdcCode", "KL");
			((Map<String, Object>) obj).put("cdcIsTarget", ((Map<String, Object>) obj).get("klTarget"));
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("klMoq"));
			scmMasterMngMentMapper.updateMasterMngSupplyPlanTgtMoq((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "KK");
			((Map<String, Object>) obj).put("cdcIsTarget", ((Map<String, Object>) obj).get("kkTarget"));
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kkMoq"));
			scmMasterMngMentMapper.updateMasterMngSupplyPlanTgtMoq((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "JB");
			((Map<String, Object>) obj).put("cdcIsTarget", ((Map<String, Object>) obj).get("jbTarget"));
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("jbMoq"));
			scmMasterMngMentMapper.updateMasterMngSupplyPlanTgtMoq((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "PN");
			((Map<String, Object>) obj).put("cdcIsTarget", ((Map<String, Object>) obj).get("pnTarget"));
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("pnMoq"));
			scmMasterMngMentMapper.updateMasterMngSupplyPlanTgtMoq((Map<String, Object>) obj);
			
			((Map<String, Object>) obj).put("cdcCode", "KC");
			((Map<String, Object>) obj).put("cdcIsTarget", ((Map<String, Object>) obj).get("kcTarget"));
			((Map<String, Object>) obj).put("moq", ((Map<String, Object>) obj).get("kcMoq"));
			scmMasterMngMentMapper.updateMasterMngSupplyPlanTgtMoq((Map<String, Object>) obj);
			
			saveCnt++;
			
			if ( String.valueOf(((Map<String, Object>) obj).get("startDt")).length() == 8 ) {
			  String strYear	= String.valueOf(((Map<String, Object>) obj).get("startDt")).substring(0, 4);
			  String strMonth	= String.valueOf(((Map<String, Object>) obj).get("startDt")).substring(4, 6);
			  String strday	= String.valueOf(((Map<String, Object>) obj).get("startDt")).substring(6, 8);
			  
			  ((Map<String, Object>) obj).put("startDt", strMonth+"-"+ strday+"-"+strYear);
			}
			
			if ( String.valueOf(((Map<String, Object>) obj).get("endDt")).length() == 8 ) {
				String strYear	= String.valueOf(((Map<String, Object>) obj).get("endDt")).substring(0, 4);
				String strMonth	= String.valueOf(((Map<String, Object>) obj).get("endDt")).substring(4, 6);
				String strday	= String.valueOf(((Map<String, Object>) obj).get("endDt")).substring(6, 8);
				
				((Map<String, Object>) obj).put("endDt", strMonth+"-"+ strday+"-"+strYear);
			}
			
			scmMasterMngMentMapper.updateMasterMngment((Map<String, Object>) obj);
		}
		
		return	saveCnt;
	}
	
	@Override
	public int updateMasterMngSupplyPlanTgtMoq(List<Object> updList, Integer crtUserId) {
		int saveCnt	= 0;
		
		for ( Object obj : updList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" >>>>> updateMasterMngmentCDC_impl ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			
			scmMasterMngMentMapper.updateMasterMngSupplyPlanTgtMoq((Map<String, Object>) obj);
		}
		
		return	saveCnt;
	}
	
	@Override
	public int insertMstMngMasterCDC(Map<String, Object> params, SessionVO sessionVO) {
		int saveCnt	= 0;
		int looCnt	= 0;
		
		LOGGER.debug(" insertMstMngMasterCDC_Imple_params : {}", params);
		
		//	SCM0017M
		if ( "1".equals(String.valueOf(params.get("klChkbox"))) ) {
			params.put("cdcIsTarget", 1);
		} else {
			params.put("cdcIsTarget", 0);
		}
		((Map<String, Object>) params).put("cdcCode", "KL");
		looCnt	= scmMasterMngMentMapper.insertMstMngMasterCDC(params);
		saveCnt	= saveCnt+looCnt;
		
		if ( "1".equals(String.valueOf(params.get("kkChkbox"))) ) {
			params.put("cdcIsTarget", 1);
		} else {
			params.put("cdcIsTarget", 0);
		}
		((Map<String, Object>) params).put("cdcCode", "KK");
		looCnt	= scmMasterMngMentMapper.insertMstMngMasterCDC(params);
		saveCnt	= saveCnt+looCnt;
		
		if ( "1".equals(String.valueOf(params.get("jbChkbox"))) ) {
			params.put("cdcIsTarget", 1);
		} else {
			params.put("cdcIsTarget", 0);
		}
		((Map<String, Object>) params).put("cdcCode", "JB");
		looCnt	= scmMasterMngMentMapper.insertMstMngMasterCDC(params);
		saveCnt	= saveCnt+looCnt;
		
		if ( "1".equals(String.valueOf(params.get("pnChkbox"))) ) {
			params.put("cdcIsTarget", 1);
		} else {
			params.put("cdcIsTarget", 0);
		}
		((Map<String, Object>) params).put("cdcCode", "PN");
		looCnt	= scmMasterMngMentMapper.insertMstMngMasterCDC(params);
		saveCnt	= saveCnt+looCnt;
		
		if ( "1".equals(String.valueOf(params.get("kcChkbox"))) ) {
			params.put("cdcIsTarget", 1);
		} else {
			params.put("cdcIsTarget", 0);
		}
		((Map<String, Object>) params).put("cdcCode", "KC");
		looCnt	= scmMasterMngMentMapper.insertMstMngMasterCDC(params);
		saveCnt	= saveCnt+looCnt;
		
		//	header  (SCM0008M)
		if ( "1".equals(String.valueOf(params.get("targetYNRadio"))) ) {
			params.put("headerIsTrget", 1);
		} else {
			params.put("headerIsTrget", 0);
		}
		looCnt = scmMasterMngMentMapper.insertMstMngMasterHeader(params);
		saveCnt = saveCnt+looCnt;
		
		return	looCnt;
	}
	
	@Override
	public int insertMstMngMasterHeader(Map<String, Object> params, SessionVO sessionVO) {
		int saveCnt	= 0;
		
		LOGGER.debug(" insertMstMngMasterHeader_Imple_params : {}", params.toString());
		
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());
		
		saveCnt	= scmMasterMngMentMapper.insertMstMngMasterHeader(params);
		
		return	saveCnt;
	}
	
	/*
	 * CDC Warehouse Mapping
	 */
	//	CDC Master
	@Override
	public List<EgovMap> selectCdcMst(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectCdcMst(params);
	}
	//	insert cdc mst
	@Override
	public int insertCdcMst(List<Object> insList, Integer crtUserId) {
		int insCnt	= 0;
		
		for ( Object obj : insList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug("insertCdcMst CDC_CODE : {}", ((Map<String, Object>) obj).get("cdcCode"));
			
			insCnt++;
			
			scmMasterMngMentMapper.insertCdcMst((Map<String, Object>) obj);
		}
		
		return	insCnt;
	}
	//	update cdc mst
	@Override
	public int updateCdcMst(List<Object> updList, Integer crtUserId) {
		int updCnt	= 0;
		
		for ( Object obj : updList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug("updateCdcMst CDC_CODE : {}", ((Map<String, Object>) obj).get("cdcCode"));
			
			updCnt++;
			
			scmMasterMngMentMapper.updateCdcMst((Map<String, Object>) obj);
		}
		
		return	updCnt;
	}
	//	delete cdc mst
	@Override
	public int deleteCdcMst(List<Object> delList, Integer crtUserId) {
		int delCnt	= 0;
		
		for ( Object obj : delList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug("deleteCdcMst CDC_CODE : {}", ((Map<String, Object>) obj).get("cdcCode"));
			
			delCnt++;
			
			scmMasterMngMentMapper.deleteCdcMst((Map<String, Object>) obj);
		}
		
		return	delCnt;
	}
	
	//	CDC WareHouse Mapping
	@Override
	public List<EgovMap> selectCdcWareMapping(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectCdcWareMapping(params);
	}

	@Override
	public List<EgovMap> selectWhLocationMapping(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectWhLocationMapping(params);
	}
	
	@Override
	public int insertCdcWhMapping(List<Object> insList, Integer crtUserId) {
		int saveCnt	= 0;
		
		for ( Object obj : insList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" insertCdcWhMapping_Whid : {}", ((Map<String, Object>) obj).get("whId"));
			
			saveCnt++;
			
			scmMasterMngMentMapper.insertCdcWhMapping((Map<String, Object>) obj);
		}
		
		return	saveCnt;
	}
	
	@Override
	public int deleteCdcWhMapping(List<Object> delList, Integer crtUserId) {
		int saveCnt	= 0;
		
		for ( Object obj : delList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" deleteCdcWhMapping_Whid : {}", ((Map<String, Object>) obj).get("whId"));
			
			saveCnt++;
			
			scmMasterMngMentMapper.deleteCdcWhMapping((Map<String, Object>) obj);
		}
		
		return	saveCnt;
	}
	
	//	Business Plan Manager
	@Override
	public List<EgovMap> selectVersionCbList(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectVersionCbList(params);
	}
	@Override
	public List<EgovMap> selectBizPlanManager(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectBizPlanManager(params);
	}
	@Override
	public List<EgovMap> selectBizPlanStock(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectBizPlanStock(params);
	}
	
	@Override
	public int updatePlanStock(List<Object> addList, Integer crtUserId) {
		int saveCnt	= 0;
		
		for ( Object obj : addList ) {
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" updatePlanStock_PlanId : {}", ((Map<String, Object>) obj).get("planId"));
			
			saveCnt++;
			
			scmMasterMngMentMapper.updatePlanStock((Map<String, Object>) obj);
		}
		
		return	saveCnt;
	}
	
	@Override
	public int insertBizPlanMaster(Map<String, Object> params, SessionVO sessionVO) {
		int saveCnt	= 0;
		
		LOGGER.debug(" insertBizPlanMaster_USER_ID : {}", sessionVO.getUserId());
		
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());
		
		saveCnt	= scmMasterMngMentMapper.insertBizPlanMaster(params);
		
		return	saveCnt;
	}
	
	@Override
	public int saveLoadExcel(Map<String, Object> masterMap, List<Map<String, Object>> detailList) {
		int iLoopCnt	= 0;
		int mResult	= scmMasterMngMentMapper.insertMasterExcel(masterMap);  // excel_Insert
		
		if ( mResult > 0 && detailList.size() > 0 ) {
			//	search seq & setting
			int bizPlanMasterSeq	= (int)masterMap.get("bizPlanMasterSeq");
			int detailSeqGet	= scmMasterMngMentMapper.getSeqNowSCM0003M();
			
			LOGGER.debug("bizPlanMasterSeq: " + bizPlanMasterSeq + " /detailSeqGet: " + detailSeqGet);
			
			for ( int i = 0 ; i < detailList.size() ; i++ ) {
			  detailList.get(i).put("planDetailIdSeq", detailSeqGet);
			  
			  iLoopCnt	= iLoopCnt +1;
			  
			  scmMasterMngMentMapper.insertDetailExcel(detailList.get(i));
			}
		}
		
		return	iLoopCnt;
	}
	
	//	Plan and Sales Dashboard
	@Override
	public List<EgovMap> selectChartDataList(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectChartDataList(params);
	}
	@Override
	public List<EgovMap> selectQuarterRate(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectQuarterRate(params);
	}
	@Override
	public List<EgovMap> selectPSDashList(Map<String, Object> params) {
		return	scmMasterMngMentMapper.selectPSDashList(params);
	}
}