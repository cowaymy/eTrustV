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

@Mapper("productLostMapper")
public interface ProductLostBillingMapper {
	/**
	 * RentalProductLostPenalty 정보 조회
	 * @param
	 * @return
	 */
	List<EgovMap> selectRentalProductLostPenalty(String param);
	
	/**
	 * ZRLocationId 가져오기
	 * @param
	 * @return
	 */
	String getZRLocationId(String param);
	
	/**
	 * RSCertificationId 가져오기
	 * @param
	 * @return
	 */
	String getRSCertificateId(String param);
	
	/**
	 * DocNumber얻어옴
	 * @param
	 * @return
	 */
	String getDocNumberForProductLost(String param);
	
	/**
	 * ledger저장
	 * @param
	 * @return
	 */
	void insertLedger(Map<String, Object> ledger); 
	
	/**
	 * orderBill저장
	 * @param
	 * @return
	 */
	void insertOrderBill(Map<String, Object> orderbill); 
	
	/**
	 * invoice Master저장
	 * @param
	 * @return
	 */
	void insertInvoiceM(Map<String, Object> invoiceM); 
	
	/**
	 * invoice Detail 저장
	 * @param
	 * @return
	 */
	void insertInvoiceD(Map<String, Object> invoiceD); 
}
