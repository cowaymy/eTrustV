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

@Mapper("earlyTerminationMapper")
public interface EarlyTerminationBillingMapper {
	/**
	 * Billing Mgnt 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillingMgnt(Map<String, Object> params);
	
	/**
	 * Cancel 정보가 있는지 조회
	 * @param
	 * @return
	 */
	int selectExistOrderCancellationList(String param);
	
	/**
	 * PenaltyBill 정보가 있는지 조회
	 * @param
	 * @return
	 */
	int selectCheckExistPenaltyBill(String param);
	
	/**
	 * ProductEarlyTerminationPenalty 정보 조회
	 * @param
	 * @return
	 */
	List<EgovMap> selectRentalProductEarlyTerminationPenalty(String param);
	
	/**
	 * DocNumber얻어옴
	 * @param
	 * @return
	 */
	String getDocNumber(String param);
	
	/**
	 * ledger 저장
	 * @param
	 * @return
	 */
	void insertAccRentLedger(Map<String, Object> params);
	
	/**
	 * orderbill 저장
	 * @param
	 * @return
	 */
	void insertAccOrderBill(Map<String, Object> params);
	
	/**
	 * taxInvoice 저장
	 * @param
	 * @return
	 */
	void insertAccTaxInvoiceMiscellaneous(Map<String, Object> params);
	
	/**
	 * taxInvoiceSub 저장
	 * @param
	 * @return
	 */
	void insertAccTaxInvoiceMiscellaneousSub(Map<String, Object> params);
}
