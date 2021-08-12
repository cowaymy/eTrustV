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

@Mapper("hcCreateDeliveryMapper")
public interface HcCreateDeliveryMapper {

	// main 조회
	public int selectPoListCnt(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectPoList(Map<String, Object> obj) throws Exception;

	// Detail List 조회
	public List<EgovMap> selectPoDetailList(Map<String, Object> obj) throws Exception;

	// Delivery
	public List<EgovMap> selectDeliveryList(Map<String, Object> obj) throws Exception;

	// Delivery No
	public String selectHmcDelvryNo() throws Exception;
	// Delivery-1 저장
	public int insertHcCreateDeliveryMain(Map<String, Object> params) throws Exception;

	// Delivery-2 저장
	public int insertHcCreateDeliveryDetail(Map<String, Object> params) throws Exception;

	// delete
	public int selectIsDeleteSearch(Map<String, Object> params) throws Exception;
	public int deleteHcCreateDeliveryDetail(Map<String, Object> params) throws Exception;
	public int deleteHcCreateDeliveryMain(Map<String, Object> params) throws Exception;

	// delivery 처리
	public int updateDeliveryMain(Map<String, Object> params) throws Exception;

	// PO의 생산수량 select
	public List<EgovMap> selectProductionCompar(Map<String, Object> params) throws Exception;

	//
	public int selectGrCompleteCheck(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectCdcSerialChk(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectGrNoList(Map<String, Object> params) throws Exception;
	public int selectSerialCountCheck(Map<String, Object> params) throws Exception;

	public int deleteDeliveryGrDetail(Map<String, Object> params) throws Exception;
	public int deleteDeliveryGrMain(Map<String, Object> params) throws Exception;
	public int updateInitDelivery(Map<String, Object> params) throws Exception;
}