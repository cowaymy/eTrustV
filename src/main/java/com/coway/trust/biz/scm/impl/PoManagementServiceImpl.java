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
import com.coway.trust.biz.scm.PoManagementService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("PoManagementService")
public class PoManagementServiceImpl implements PoManagementService {
	private static final Logger LOGGER = LoggerFactory.getLogger(PoManagementServiceImpl.class);
	
	@Autowired
	private PoManagementMapper	poManagementMapper;

	@Autowired
	private ScmInterfaceManagementMapper	scmInterfaceManagementMapper;

	//	PO Issue
	@Override
	public List<EgovMap> selectPoStatus(Map<String, Object> params) {
		return	poManagementMapper.selectPoStatus(params);
	}
	@Override
	public List<EgovMap> selectLeadTm(Map<String, Object> params) {
		return	poManagementMapper.selectLeadTm(params);
	}
	@Override
	public List<EgovMap> selectLastWeekTh(Map<String, Object> params) {
		return	poManagementMapper.selectLastWeekTh(params);
	}
	@Override
	public List<EgovMap> selectSplitCnt(Map<String, Object> params) {
		return	poManagementMapper.selectSplitCnt(params);
	}
	/*@Override
	public List<EgovMap> selectSplitCnt1(Map<String, Object> params) {
		return	poManagementMapper.selectSplitCnt1(params);
	}
	@Override
	public List<EgovMap> selectSplitCnt2(Map<String, Object> params) {
		return	poManagementMapper.selectSplitCnt2(params);
	}*/
	@Override
	public List<EgovMap> selectLastWeekSplitYn(Map<String, Object> params) {
		return	poManagementMapper.selectLastWeekSplitYn(params);
	}
	/*@Override
	public List<EgovMap> selectLastWeekSplitYn1(Map<String, Object> params) {
		return	poManagementMapper.selectLastWeekSplitYn1(params);
	}
	@Override
	public List<EgovMap> selectLastWeekSplitYn2(Map<String, Object> params) {
		return	poManagementMapper.selectLastWeekSplitYn2(params);
	}*/
	@Override
	public List<EgovMap> selectPoCreatedList(Map<String, Object> params) {
		return	poManagementMapper.selectPoCreatedList(params);
	}
	@Override
	public List<EgovMap> selectPoTargetList(Map<String, Object> params) {
		return	poManagementMapper.selectPoTargetList(params);
	}
	@Override
	public List<EgovMap> selectPoInfo(Map<String, Object> params) {
		return	poManagementMapper.selectPoInfo(params);
	}
	@Override
	public int insertPoMaster(Map<String, Object> params, SessionVO sessionVO) {

		LOGGER.debug("insertPoMaster : {}", params);

		int saveCnt	= 0;
		params.put("crtUserId", sessionVO.getUserId());

		try {
			LOGGER.debug("params : {}", params);
			poManagementMapper.insertPoMaster(params);
			saveCnt++;
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return	saveCnt;
	}
	@Override
	public int insertPoDetail(List<Map<String, Object>> addList, SessionVO sessionVO) {

		LOGGER.debug("insertPoDetail : {}", addList);

		int saveCnt		= 0;
		int poItemNo	= 1;
		int crtUserId	= sessionVO.getUserId();
		int grYear		= 0;
		int grMonth		= 0;
		int grWeek		= 0;
		String poNo		= "";
		Map<String, Object> params	= new HashMap<>();
		Map<String, Object> grParam	= new HashMap<>();

		List<EgovMap> selectGetPoNo	= poManagementMapper.selectGetPoNo(addList.get(0));
		poNo	= selectGetPoNo.get(0).get("poNo").toString();

		grParam.put("poYear", addList.get(0).get("poYear"));
		grParam.put("poWeek", addList.get(0).get("poWeek"));

		try {
			for ( Map<String, Object> list : addList ) {
				params.put("poId", list.get("poId"));
				params.put("poNo", poNo);
				params.put("poItemNo", poItemNo);
				params.put("stockCode", list.get("stockCode"));
				params.put("poQty", list.get("poQty"));
				params.put("prcUnit", list.get("prcUnit"));
				params.put("purchPrc", list.get("purchPrc"));
				params.put("fobPrc", list.get("fobPrc"));
				params.put("fobAmt", list.get("fobAmt"));
				params.put("vendor", list.get("vendor"));
				params.put("vendorTxt", list.get("vendorTxt"));
				params.put("curr", list.get("curr"));
				params.put("crtUserId", crtUserId);
				LOGGER.debug("params : {}", params);
				
				poManagementMapper.insertPoDetail(params);
				saveCnt++;
				poItemNo++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return	saveCnt;
	}
	@Override
	public List<EgovMap> selectGetPoNo(Map<String, Object> params) {
		return	poManagementMapper.selectGetPoNo(params);
	}
	@Override
	public int updatePoMaster(Map<String, Object> params, SessionVO sessionVO) {

		int saveCnt	= 0;

		return	saveCnt;
	}
	@Override
	public int updatePoDetail(List<Map<String, Object>> updList, SessionVO sessionVO) {

		int saveCnt	= 0;
		int updUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();
		
		try {
			for ( Map<String, Object> list : updList ) {
				params.put("updUserId", updUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemNo", list.get("poItemNo"));
				params.put("stockCode", list.get("stockCode"));
				LOGGER.debug("params : {}", params);

				poManagementMapper.updatePoDetailDel(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return	saveCnt;
	}

	@Override
	public int updatePoDetailDel(List<Map<String, Object>> delList, SessionVO sessionVO) {

		int saveCnt	= 0;
		int updUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();

		try {
			for ( Map<String, Object> list : delList ) {
				params.put("updUserId", updUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemNo", list.get("poItemNo"));
				params.put("stockCode", list.get("stockCode"));
				params.put("poYear", list.get("poYear"));
				params.put("poMonth", list.get("poMonth"));
				params.put("poWeek", list.get("poWeek"));
				params.put("cdc", list.get("cdc"));

				poManagementMapper.updateSupplyPlan(params);
				poManagementMapper.updatePoDetailDel(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return	saveCnt;
	}

	//	PO Approval
	@Override
	public List<EgovMap> selectPoSummary(Map<String, Object> params) {
		return	poManagementMapper.selectPoSummary(params);
	}
	@Override
	public List<EgovMap> selectPoApprList(Map<String, Object> params) {
		return	poManagementMapper.selectPoApprList(params);
	}
	@Override
	public int updatePoApprove(List<Map<String, Object>> updList, SessionVO sessionVO) {

		int saveCnt	= 0;
		int updUserId	= sessionVO.getUserId();
		Map<String, Object> params		= new HashMap<>();
		//Map<String, Object> ifParams	= new HashMap<>();

		//	po approve
		try {
			for ( Map<String, Object> list : updList ) {
				params.put("updUserId", updUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemStusId", 5);
				LOGGER.debug("params : {}", params);

				poManagementMapper.updatePoApprove(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}

		return	saveCnt;
	}
}