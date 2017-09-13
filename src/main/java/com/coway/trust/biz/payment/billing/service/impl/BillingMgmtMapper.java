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

@Mapper("billingRantalMapper")
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
	 * createEaryBill 수행
	 * @param params
	 * @return
	 */
	int callEaryBillProcedure(Map<String, Object> params);
	
	/**
	 * createBill 수행
	 * @param params
	 * @return
	 */
	int callBillProcedure(Map<String, Object> params);
}
