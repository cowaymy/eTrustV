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

@Mapper("hcPurchasePriceMapper")
public interface HcPurchasePriceMapper {

	public List<EgovMap> selectComonCodeList(Map<String, String> params) throws Exception;
	public List<EgovMap> selectVendorList(Map<String, Object> params) throws Exception;

	// Purchase Price(HC) 메인 조회
	public int selectHcPurchasePriceListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectHcPurchasePriceList(Map<String, Object> params) throws Exception;

	public String selectHcPurchasePriceKey(Map<String, Object> obj) throws Exception;

	// UPDATE
	public void updateHcPurchasePrice(Map<String, Object> obj) throws Exception;

	// insert
	public void insertHcPurchasePrice(Map<String, Object> obj) throws Exception;

	// HISTORY insert
	public void insertHcPurchasePriceHist(Map<String, Object> obj) throws Exception;

	public List<EgovMap> selectHcPurchasePriceHstList(Map<String, Object> params) throws Exception;

	public int selectHcPurchaseDuflicateDate(Map<String, Object> obj) throws Exception;
}
