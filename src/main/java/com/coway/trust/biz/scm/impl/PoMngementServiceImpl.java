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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.PoMngementService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("POMngementService")
public class PoMngementServiceImpl implements PoMngementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PoMngementServiceImpl.class);
	
	@Autowired
	private PoMngementMapper poMngementMapper;
	
	/* OTD Status View */
	@Override
	public List<EgovMap> selectOtdStatusView(Map<String, Object> params) {
		return poMngementMapper.selectOtdStatusView(params);
	}
	@Override
	public List<EgovMap> selectOtdSOGIDetailPop(Map<String, Object> params) {
		return poMngementMapper.selectOtdSOGIDetailPop(params);
	}
	@Override
	public List<EgovMap> selectOtdSOPPDetailPop(Map<String, Object> params) {
		return poMngementMapper.selectOtdSOPPDetailPop(params);
	}
	@Override
	public List<EgovMap> selectPoRightMove(Map<String, Object> params) {
		return poMngementMapper.selectPoRightMove(params);
	}
	
	/* Interface */
	@Override
	public List<EgovMap> selectInterfaceList(Map<String, Object> params) {
		return poMngementMapper.selectInterfaceList(params);
	}
	
	@Override
	public List<EgovMap> selectInterfaceLastState(Map<String, Object> params) {
		return poMngementMapper.selectInterfaceLastState(params);
	}
	
	// PO Management - PO Approval
	@Override
	public List<EgovMap> selectPoApprovalSummary(Map<String, Object> params) {
		return poMngementMapper.selectPoApprovalSummary(params);
	}
	@Override
	public List<EgovMap> selectPoApprovalSummaryHidden(Map<String, Object> params) {
		return poMngementMapper.selectPoApprovalSummaryHidden(params);
	}
	@Override
	public List<EgovMap> selectPoApprovalMainList(Map<String, Object> params) {
		return poMngementMapper.selectPoApprovalMainList(params);
	}	
	
	//Interface Call..
	@Override
	public int updatePoApprovalDetail(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			poMngementMapper.updatePoApprovalDetail((Map<String, Object>) obj);
			
			LOGGER.debug(" poNo : {}", ((Map<String, Object>) obj).get("poNo"));
			
			((Map<String, Object>) obj).put("poNo", ((Map<String, Object>) obj).get("poNo") );
			((Map<String, Object>) obj).put("poItemNo", ((Map<String, Object>) obj).get("poItmNo") );
			((Map<String, Object>) obj).put("stockCode", ((Map<String, Object>) obj).get("stockCode") );
			((Map<String, Object>) obj).put("vender", "" );
			((Map<String, Object>) obj).put("failINFKey", "");
			
			poMngementMapper.callSpPoApprovalINF155((Map<String, Object>) obj);
			
			poMngementMapper.updatePoIssueStatus((Map<String, Object>) obj);
			
			saveCnt++;
			
			LOGGER.debug(" saveCnt : {} ", saveCnt);

		}
		
		return saveCnt;
	}
			
	// PO Management - PO Issue	
	@Override
	public List<EgovMap> selectScmPoView(Map<String, Object> params) {
		return poMngementMapper.selectScmPoView(params);
	}
	
	@Override
	public List<EgovMap> selectScmPrePoItemView(Map<String, Object> params) {
		return poMngementMapper.selectScmPrePoItemView(params);
	}
	
	@Override
	public List<EgovMap> selectScmPoStatusCnt(Map<String, Object> params) {
		return poMngementMapper.selectScmPoStatusCnt(params);
	}
	
	@Override
	public EgovMap selectPOIssueNewPoNo(Map<String, Object> params) {
		return poMngementMapper.selectPOIssueNewPoNo(params);
	}
	
	// update SCMPrePOItem && Insert SCMPODetail
	@Override
	public int updatePOIssuItem(List<Map<String, Object>> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		int poItemNo = 0;
		int scmMst9MCnt = 0;
		
		LOGGER.debug(" updatePOIssuItem_IMPLE {} ", addList.toString() );
		
		String preCdc = "";
		String preYear = "";
		String preWeekTh = "";
		String stockCode = "";
		
		Map<String, Object> params = new HashMap<>();
		
		if(addList != null && addList.size() > 0)
		{
		  preYear = (String) addList.get(0).get("preYear");
		  preWeekTh =  (String) addList.get(0).get("preWeekTh");
		  preCdc =  (String) addList.get(0).get("preCdc");
		  
		  params.put("preYear", preYear);
		  params.put("preCdc" , preCdc);
		}
			
		if(StringUtils.isEmpty(preYear)){
			throw new ApplicationException(AppConstants.FAIL, "필수값(YEAR) 오류 입니다.");
		}

		EgovMap newPonoMap =  selectPOIssueNewPoNo( params );
		String selectNewPoNo = (String)newPonoMap.get("newPono");
		
		for (Map<String, Object> obj : addList) 
		{
			
			stockCode = (String) addList.get(saveCnt).get("stockCode");
			
			poItemNo++;
			
			obj.put("crtUserId", crtUserId);
			obj.put("updUserId", crtUserId);
			obj.put("poItemNo", poItemNo);
			obj.put("newPono", selectNewPoNo);
			
			obj.put("preCdc", preCdc);
			obj.put("preYear", preYear);
			obj.put("preWeekTh", preWeekTh);
			obj.put("stockCode", stockCode);						
			
			LOGGER.debug(" >>>>> PO_Issue_Input_Params {} ", obj);
			
			//merge SCMPrePOItem SCM0011D
			poMngementMapper.updatePOIssuItem(obj);
			// Insert SCMPODetail SCM0010D
			poMngementMapper.insertPOIssueDetail(obj);
			
			// INSERT SCMPOMASTER SCM0009M Only 1
			if (scmMst9MCnt == 0)
			{
			  scmMst9MCnt = poMngementMapper.insertPOIssueMaster(obj);
			}
			else
			{
			  LOGGER.debug(" >>>>>scmMst9MCnt {} ", scmMst9MCnt);
			}
			
			saveCnt++;
		}
		

		
		return saveCnt;
	}
	
	// delete POMaster(SCM0009M) & PODetail(SCM0010D), Update SCM0011D.PO_QTY
	@Override
	public int deletePOMaster(List<Object> delList, Integer crtUserId) 
	{
    	int saveCnt = 0;
    	int delCnt = 0;
    	
    	for (Object obj : delList) 
    	{
    		LOGGER.debug(" delList : {} ", delList.toString() );
    		
    		poMngementMapper.deletePOMaster((Map<String, Object>) obj);
    		poMngementMapper.deletePODetail((Map<String, Object>) obj);
    		poMngementMapper.updatePOQtinty((Map<String, Object>) obj);
    		
    		saveCnt++;
    		
    		delCnt = delCnt + saveCnt;
    		
    		LOGGER.debug(" delCnt : {} ", delCnt);
    	}
    	
        return delCnt;
	}
	
	// Insert SCMPODetail
	@Override
	public int insertPOIssueDetail(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		int poItemNo = 0;
		
		for (Object obj : addList) 
		{
			LOGGER.debug(" >>>>> InsertPOIssueDetail ");

			poItemNo++;
			
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			((Map<String, Object>) obj).put("poItemNo", poItemNo);
			
			saveCnt++;
			
			poMngementMapper.insertPOIssueDetail((Map<String, Object>) obj);
		}
		
		return saveCnt;
	}
	

}
