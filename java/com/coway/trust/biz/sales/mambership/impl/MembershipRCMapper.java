/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
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
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;


import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * sample에 관한 데이터처리 매퍼 클래스
 *
 * @author 표준프레임워크센터
 * @since 2014.01.24
 * @version 1.0
 * @see
 * 
 *      <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2014.01.24        표준프레임워크센터          최초 생성
 *
 *      </pre>
 */
@Mapper("membershipRCMapper")
public interface MembershipRCMapper {

	List<EgovMap> selectCancellationList(Map<String, Object> params);
	List<EgovMap> selectReasonList(Map<String, Object> params);
	List<EgovMap> selectBranchList(Map<String, Object> params);
	EgovMap selectCancellationInfo(Map<String, Object> params);
	List<EgovMap> selectCodeList(Map<String, Object> params);
	List<EgovMap> selectCancellReqInfo(Map<String, Object> params);
	EgovMap selectCancellMemInfo(Map<String, Object> params);
	int selectBillInfo(Map<String, Object> params);
	EgovMap selectContractSchedules(Map<String, Object> params);
	float selectContractLedger(Map<String, Object> params);
	EgovMap selectOrdInfo(Map<String, Object> params);
	EgovMap selectSrvMemConfigInfo(Map<String, Object> params);
	EgovMap selectMemAddrInfo(Map<String, Object> params);
	EgovMap selectCustInfo(Map<String, Object> params);
	EgovMap selectCustContactInfo(Map<String, Object> params);
	
	String getDocNo(Map<String, Object> params);
	void insert_SAL0086D(Map<String, Object> params);
	
	EgovMap selectServiceContracts(Map<String, Object> params);
	void update_SAL0077D(Map<String, Object> params);
	
	EgovMap selectSrvConfigPeriods(Map<String, Object> params);
	void update_SAL0088D(Map<String, Object> params);
	
	EgovMap selectServiceContractDetail(Map<String, Object> params);
	void update_SAL0078D(Map<String, Object> params);
	void saveCanclPnaltyBill(Map<String, Object> params);


}
