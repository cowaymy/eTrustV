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

@Mapper("hcDeliveryGrMapper")
public interface HcDeliveryGrMapper {

	// main 조회
	public int selectDeliveryGrMainCnt(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectDeliveryGrMain(Map<String, Object> obj) throws Exception;

	public EgovMap selectGrHeaderInfo(Map<String, Object> obj) throws Exception;

	// 팝업내용 조회
	public List<EgovMap> selectDeliveryConfirm(Map<String, Object> obj) throws Exception;

	// GR정보 insert
	public void insertDeliveryGrHeader(Map<String, Object> obj) throws Exception;
	public void insertDeliveryGrDetailList(Map<String, Object> obj) throws Exception;

	// 완료안된 GR인지 확인.
	public int selectGrHeaderCnt(Map<String, Object> obj) throws Exception;

	public void deleteDeliveryGrDetail(Map<String, Object> obj) throws Exception;
	public void insertDeliveryGrDetail(Map<String, Object> obj) throws Exception;
	public void updateDeliveryGrState(Map<String, Object> obj) throws Exception;

	// 스캔가능여부
	public EgovMap selectItemSerialChk(Map<String, Object> obj) throws Exception;
	public String selectLocationSerialChk(Map<String, Object> obj) throws Exception;


	// srial Count check.
	public int selectSerialGrCnt(Map<String, Object> obj) throws Exception;

	// GR complete.
	public int selectGrDifferenceCnt(Map<String, Object> obj) throws Exception;
	public void updateDeliveryComplete(Map<String, Object> obj) throws Exception;

	public Map<String, Object> callGrProcedure(Map<String, Object> param) throws Exception;

	// Main GR 처리를 위핸 내역 조회
	public List<EgovMap> selectGrDetailList(Map<String, Object> obj) throws Exception;

	public void deleteDeliveryGrDetailRow(Map<String, Object> obj) throws Exception;
	public void updateDeliveryGrDetailRow(Map<String, Object> obj) throws Exception;

	public void updateDeliveryGrDetail(Map<String, Object> obj) throws Exception;
	public void updateDeliveryGrMain(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectDeliveryGrHist(Map<String, Object> obj) throws Exception;
	public void updateDeliveryGrHist(Map<String, Object> obj) throws Exception;

}
