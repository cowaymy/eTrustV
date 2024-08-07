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

@Mapper("hcDeliveryPlanMapper")
public interface HcDeliveryPlanMapper {


	// main 조회
	public int selectHcDeliveryPlanMainListCnt(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectHcDeliveryPlanMainList(Map<String, Object> obj) throws Exception;

	// Detail List 조회
	public List<EgovMap> selectHcDeliveryPlanSubList(Map<String, Object> obj) throws Exception;

	// Plan
	public List<EgovMap> selectHcDeliveryPlanPlan(Map<String, Object> obj) throws Exception;
	// Plan cnt 조회
	public int selectHcDeliveryPlanPlanCnt(Map<String, Object> obj) throws Exception;

	// plan 삭제
	public int deleteHcPoPlan(Map<String, Object> params) throws Exception;

	// plan 저장
	public int insertHcPoPlan(Map<String, Object> params) throws Exception;

	// plan 갯수 검증
	public List<EgovMap> selectPlanCompare(Map<String, Object> params) throws Exception;


}