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
package com.coway.trust.biz.payment.document.service.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("financeMgmtMapper")
public interface FinanceMgmtMapper {
	/**
	 * ReceiveList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectReceiveList(Map<String, Object> params);
	
	/**
	 * CreditCardList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCreditCardList(Map<String, Object> params);
	
	/**
	 * paymentItemList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDocItemPaymentItem(Map<String, Object> params);
	
	/**
	 * PaymentItem에 대한 Log 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectLogItemPaymentItem(Map<String, Object> params);
	
	/**
	 * BatchId에 의한 PayDoc조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPayDocBatchById(Map<String, Object> params);
	
	/**
	 * paymentItem2List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDocItemPaymentItem2(Map<String, Object> params);

	/**
	 * PayDocList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPayDocumentDetail(Map<String, Object> params);
	
	/**
	 * PayDocDetail 업데이트
	 * @param params
	 * @return
	 */
	void updatePayDocDetail(Map<String, Object> params);
	
	/**
	 * Log에 저장
	 * @param params
	 * @return
	 */
	void insertPaymentDocLog(Map<String, Object> params);
	
	/**
	 * PayDoc 타입별 누적 갯수 조회
	 * @param params
	 * @return
	 */
	int countPayDocDetail(Map<String, Object> params);
	
	/**
	 *  PayDocMaster 업데이트
	 * @param params
	 * @return
	 */
	void updatePayDocMaster(Map<String, Object> params);
}
