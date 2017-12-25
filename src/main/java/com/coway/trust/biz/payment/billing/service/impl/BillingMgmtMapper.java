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

@Mapper("billingRentalMapper")
public interface BillingMgmtMapper {
	/**
	 * Billing Mgnt 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillingMgnt(Map<String, Object> params);
	
	/**
	 * Billing Master 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBillingMaster(Map<String, Object> params);
	
	/**
	 * Billing Detail 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillingDetail(Map<String, Object> params);
	
	/**
	 * Billing Detail 전체 건수 조회
	 * @param params
	 * @return
	 */
	int selectBillingDetailCount(Map<String, Object> params);
	
	/**
	 * createEaryBill 수행
	 * @param params
	 * @return
	 */
	void callEaryBillProcedure(Map<String, Object> params);
	
	/**
	 * createBill 수행
	 * @param params
	 * @return
	 */
	void callBillProcedure(Map<String, Object> params);
	
	/**
	 * Bill이 존재하는지 확인
	 * @param
	 * @return
	 */
	int getExistBill(Map<String, Object> params);
	
	/**
	 * Complete Early Bill
	 * @param
	 * @return
	 */
	void confirmEarlyBills(Map<String, Object> params);
	
	/**
	 * Complete Bill
	 * @param
	 * @return
	 */
	void confirmBills(Map<String, Object> params);
	
	/**
   	 * 
   	 * @param params
   	 * @return
   	 */
   	int countMonthlyRawData(Map<String, Object> params);
   	
   	/**
   	 * 
   	 * @param params
   	 * @return
   	 */
   	List<EgovMap> selectMonthlyRawData(Map<String, Object> params);
}
