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
	private SalesPlanMngementMapper salesPlanMngementMapper;
	
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
	
	//
	@Override
	public int updatePoApprovalDetail(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			LOGGER.debug(">>>>> updatePoApprovalDetail paramList : {}", addList.toString() );
			
			saveCnt++;
			
			poMngementMapper.updatePoApprovalDetail((Map<String, Object>) obj);
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
		
		LOGGER.debug(" updatePOIssuItem_IMPLE {} ", addList.toString() );
		
		String preCdc = "";
		String preYear = "";
		
		if(addList != null && addList.size() > 0)
		{
		  preCdc =  (String) addList.get(0).get("preCdc");
		  preYear = (String) addList.get(0).get("preYear");
		}
		
		if(StringUtils.isEmpty(preCdc) || StringUtils.isEmpty(preYear)){
			throw new ApplicationException(AppConstants.FAIL, "필수값 오류 입니다.");
		}
		
		Map<String, Object> params = new HashMap<>();
		params.put("preCdc", preCdc);
		params.put("preYear", preYear);
		EgovMap newPonoMap =  selectPOIssueNewPoNo( params );
		String selectNewPoNo = (String)newPonoMap.get("newPono");
		
		for (Map<String, Object> obj : addList) 
		{
			poItemNo++;
			
			obj.put("crtUserId", crtUserId);
			obj.put("updUserId", crtUserId);
			obj.put("poItemNo", poItemNo);
			obj.put("newPono", selectNewPoNo);
			
			saveCnt++;
			
			LOGGER.debug(" >>>>> PO_Issue_Input_Params {} ", obj);
			
			//update SCMPrePOItem 
			poMngementMapper.updatePOIssuItem(obj);
			// Insert SCMPODetail
			poMngementMapper.insertPOIssueDetail(obj);
		}
		
		return saveCnt;
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
