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
import com.coway.trust.biz.scm.ScmInterfaceManagementService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ScmInterfaceManagementService")
public class ScmInterfaceManagementServiceImpl implements ScmInterfaceManagementService {
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmInterfaceManagementServiceImpl.class);

	@Autowired
	private ScmInterfaceManagementMapper	scmInterfaceManagementMapper;

	/*
	 * SCM Interface
	 */
	//	Search & etc
	@Override
	public List<EgovMap> selectInterfaceList(Map<String, Object> params) {
		String startDate	= "";
		String endDate		= "";
		
		startDate	= params.get("startDate").toString();
		endDate		= params.get("endDate").toString();
		
		startDate	= startDate.replace("/", "");	startDate	= startDate.replace(".", "");	startDate	= startDate.replace("-", "");
		endDate		= endDate.replace("/", "");		endDate		= endDate.replace(".", "");		endDate		= endDate.replace("-", "");
		
		startDate	= startDate.substring(4, 8) + startDate.substring(2, 4) + startDate.substring(0, 2);
		endDate		= endDate.substring(4, 8) + endDate.substring(2, 4) + endDate.substring(0, 2);
		
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		LOGGER.debug("startDate : " + startDate + ", endDate : " + endDate);
		
		return	scmInterfaceManagementMapper.selectInterfaceList(params);
	}
	@Override
	public int scmIf155(List<Map<String, Object>> chkList, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		int crtUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();
		
		try {
			for ( Map<String, Object> list : chkList ) {
				LOGGER.debug("chkList : ", list);
				params.put("crtUserId", crtUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemNo", list.get("poItemNo"));
				scmInterfaceManagementMapper.scmIf155(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	@Override
	public int insertSCM0039M(List<Map<String, Object>> chkList, SessionVO sessionVO) {
		
		int saveCnt	= 0;
		int crtUserId	= sessionVO.getUserId();
		Map<String, Object> params = new HashMap<>();
		
		try {
			for ( Map<String, Object> list : chkList ) {
				LOGGER.debug("chkList : ", list);
				params.put("crtUserId", crtUserId);
				params.put("poNo", list.get("poNo"));
				params.put("poItemNo", list.get("poItemNo"));
				params.put("stockCode", list.get("stockCode"));
				params.put("poQty", list.get("poQty"));
				params.put("poItemStusId", 5);	//	5 : Approvaed
				scmInterfaceManagementMapper.insertSCM0039M(params);
				saveCnt++;
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return	saveCnt;
	}
	
	//	log
	@Override
	public void insertLog(Map<String, Object> params) {
		LOGGER.debug("insertLog : {}", params);
		scmInterfaceManagementMapper.insertLog(params);
	}
	
	//	Procedure Batch
	@Override
	public void executeProcedureBatch(Map<String, Object> params) {
		String ifType	= "";
		params.put("status", 0);
		params.put("result", "");
		
		try {
			//	do anything
			ifType	= params.get("ifType").toString();
			
			if ( "151".equals(ifType) ) {
				//	OTD SO 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "152".equals(ifType) ) {
				//	OTD GI 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "153".equals(ifType) ) {
				//	OTD PP 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "156".equals(ifType) ) {
				//	SAP 생성 PO번호 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0156(params);
			} else if ( "160".equals(ifType) ) {
				//	GR/AP 정보
				scmInterfaceManagementMapper.executeSP_SCM_0039M_ITF0160(params);
			} else if ( "161".equals(ifType) ) {
				//	주문정보
				scmInterfaceManagementMapper.executeSP_SCM_0050S_INSERT(params);
			} else if ( "162".equals(ifType) ) {
				//	출고정보
				scmInterfaceManagementMapper.executeSP_SCM_0051S_INSERT(params);
				scmInterfaceManagementMapper.executeSP_SCM_0051S_INSERT_CALL(params);
			} else if ( "163".equals(ifType) ) {
				//	오버듀정보
				scmInterfaceManagementMapper.executeSP_SCM_0052S_INSERT(params);
			} else if ( "164".equals(ifType) ) {
				//	재고정보
				scmInterfaceManagementMapper.executeSP_SCM_0053S_INSERT(params);
			} else if ( "165".equals(ifType) ) {
				//	월별재고예측정보
				scmInterfaceManagementMapper.executeSP_MTH_SCM_FILTER_FRCST(params);
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	//	FTP Supply Plan RTP Batch
	@Override
	public List<EgovMap> selectTodayWeekTh(Map<String, Object> params) {
		return	scmInterfaceManagementMapper.selectTodayWeekTh(params);
	}
	@Override
	public List<EgovMap> selectScmIfSeq(Map<String, Object> params) {
		return	scmInterfaceManagementMapper.selectScmIfSeq(params);
	}
	@Override
	public void mergeSupplyPlanRtp(Map<String, Object> params) {
		scmInterfaceManagementMapper.mergeSupplyPlanRtp(params);
	}
	@Override
	public void updateSupplyPlanRtp(Map<String, Object> params) {
		scmInterfaceManagementMapper.updateSupplyPlanRtp(params);
	}
	
	//	FTP OTD SO Batch
	@Override
	public void updateOtdSo(Map<String, Object> params) {
		LOGGER.debug("updateOtdSo : {}", params);
		scmInterfaceManagementMapper.updateOtdSo(params);
	}
	
	//	FTP OTD PP Batch
	@Override
	public void deleteOtdPp(Map<String, Object> params) {
		LOGGER.debug("deleteOtdPp : {}", params);
		scmInterfaceManagementMapper.deleteOtdPp(params);
	}
	@Override
	public void mergeOtdPp(Map<String, Object> params) {
		LOGGER.debug("mergeOtdPp : {}", params);
		scmInterfaceManagementMapper.mergeOtdPp(params);
	}
	
	//	FTP OTD GI Batch
	@Override
	public void mergeOtdGi(Map<String, Object> params) {
		LOGGER.debug("mergeOtdGi : {}", params);
		scmInterfaceManagementMapper.mergeOtdGi(params);
	}
}