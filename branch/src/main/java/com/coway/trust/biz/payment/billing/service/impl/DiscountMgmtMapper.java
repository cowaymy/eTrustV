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
package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("discountMgmtMapper")
public interface DiscountMgmtMapper {

	
	/**
	 * selectBasicInfo 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBasicInfo(Map<String, Object> params);
	
	/**
	 * selectSalesOrderMById 조회
	 * @param params
	 * @return
	 */
	EgovMap selectSalesOrderMById(Map<String, Object> params);
	
	/**
	 * selectDiscountList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDiscountList(Map<String, Object> params);
	
	/**
	 * selectContractServiceId 조회
	 * @param params
	 * @return
	 */
	String selectContractServiceId(Map<String, Object> params);
	
	/**
	 * saveAddDiscount 조회
	 * @param params
	 * @return
	 */
	int saveAddDiscount(Map<String, Object> params);
	
	/**
	 * selectDiscountEntries 조회
	 * @param params
	 * @return
	 */
	EgovMap selectDiscountEntries(Map<String, Object> params);
	
	/**
	 * updDiscountEntry 업데이트
	 * @param params
	 * @return
	 */
	void updDiscountEntry(Map<String, Object> params);
	
}
