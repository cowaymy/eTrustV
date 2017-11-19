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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.PoMngementService;

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
	/*
	 	@Override
	public void returnPartsUpdate(Map<String, Object> params,int loginId) {

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		for (int i = 0; i < checkList.size(); i++) {
			logger.debug("checkList    값 : {}", checkList.get(i));
		}

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
				insMap.put("userId", loginId);

				returnUsedPartsMapper.upReturnParts(insMap);
			}
		}

	} 
	 * */
	@Override
	public int updatePoApprovalDetail(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			//((Map<String, Object>) obj).put("crtUserId", crtUserId);
			//((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" >>>>> updatePoApprovalDetail ");
			LOGGER.debug(" paramList : {}", addList.toString() );
			
			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );
			
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
	
	//
	@Override
	public int updatePoManagement(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			LOGGER.debug(" >>>>> updateSCMPlanMaster ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			
			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );
			
			saveCnt++;
			
			//salesPlanMngementMapper.updateScmPlanMaster((Map<String, Object>) obj);
		}
		
		return saveCnt;
	}
	

}
