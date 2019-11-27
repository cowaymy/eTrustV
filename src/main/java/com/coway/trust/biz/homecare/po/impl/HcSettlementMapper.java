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
package com.coway.trust.biz.homecare.po.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hcSettlementMapper")
public interface HcSettlementMapper {

	// main 조회
	public int selectHcSettlementMainCnt(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectHcSettlementMain(Map<String, Object> obj) throws Exception;

	// sub 조회
	public List<EgovMap> selectHcSettlementSub(Map<String, Object> obj) throws Exception;

	// HMC0009M : PO_SETTL_STATUS : 10
	public void updateGrStateChange(Map<String, Object> obj) throws Exception;

	public List<EgovMap> selectSettlementDetailInfo(Map<String, Object> obj) throws Exception;

	// SAVE
	public void insertSettlementMain(Map<String, Object> obj) throws Exception;
	public void insertSettlementDetail(Map<String, Object> obj) throws Exception;

	// HMC0012M.SETTL_DT
	public void updateSettlementState(Map<String, Object> obj) throws Exception;


	public void updateSettlementStateRejectComplete(Map<String, Object> obj) throws Exception;
}
