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
package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("batchPaymentMapper")
public interface BatchPaymentMapper {


	/**
	 * selectBatchList(Master Grid) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBatchList(Map<String, Object> params);

	/**
	 * selectBatchPaymentView 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBatchPaymentView(Map<String, Object> params);

	/**
	 * selectBatchPaymentDetList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBatchPaymentDetList(Map<String, Object> params);

	/**
	 * selectTotalValidAmt 조회
	 * @param params
	 * @return
	 */
	EgovMap selectTotalValidAmt(Map<String, Object> params);


	/**
	 * updRemoveItem
	 * @param params
	 * @return
	 */
	int updRemoveItem(Map<String, Object> params);

	/**
	 * saveConfirmBatch
	 * @param params
	 * @return
	 */
	int saveConfirmBatch(Map<String, Object> params);


	/**
	 * selectBatchPaymentMs 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBatchPaymentMs(Map<String, Object> params);

	/**
	 * selectBatchPaymentDs 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBatchPaymentDs(Map<String, Object> params);

	/**
	 * saveDeactivateBatch
	 * @param params
	 * @return
	 */
	int saveDeactivateBatch(Map<String, Object> params);

	/**
	 * getPAY0044DSEQ
	 * @param params
	 * @return
	 */
	int getPAY0044DSEQ();

	/**
	 * getPAY0043DSEQ
	 * @param params
	 * @return
	 */
	int getPAY0043DSEQ();

	/**
	 * saveBatchPayMaster
	 * @param params
	 * @return
	 */
	int saveBatchPayMaster(Map<String, Object> params);

	/**
	 * saveBatchPayDetailList
	 * @param params
	 * @return
	 */
	int saveBatchPayDetailList(Map<String, Object> params);

	/**
	 * callCnvrBatchPay
	 * @param params
	 * @return
	 */
	void callCnvrBatchPay(Map<String, Object> params);

	/**
	 * callBatchPayVerifyDet
	 * @param params
	 * @return
	 */
	int callBatchPayVerifyDet(Map<String, Object> params);

	String selectBatchPayCardModeId(String cardModeCode);
	
    void callCnvrAdvBatchPay(Map<String, Object> params);

	int checkIfIsEGHLRecord(Map<String, Object> params);
	int removeEGHLBatchOrderRecord(Map<String, Object> params);

}
