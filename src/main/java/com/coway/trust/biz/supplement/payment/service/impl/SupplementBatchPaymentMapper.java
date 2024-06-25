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
package com.coway.trust.biz.supplement.payment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementBatchPaymentMapper")
public interface SupplementBatchPaymentMapper {
	/**
	 * selectBatchList(Master Grid)
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBatchList(Map<String, Object> params);

	/**
	 * selectBatchPaymentView
	 * @param params
	 * @return
	 */
	EgovMap selectBatchPaymentView(Map<String, Object> params);

	/**
	 * selectBatchPaymentDetList
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBatchPaymentDetList(Map<String, Object> params);

	/**
	 * selectTotalValidAmt
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
	 * selectBatchPaymentMs
	 * @param params
	 * @return
	 */
	EgovMap selectBatchPaymentMs(Map<String, Object> params);

	/**
	 * selectBatchPaymentDs
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
	 * getPAY0360MSEQ
	 * @param params
	 * @return
	 */
	int getPAY0360MSEQ();

	/**
	 * getPAY0359DSEQ
	 * @param params
	 * @return
	 */
	int getPAY0359DSEQ();

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
	int callCnvrSupBatchPay(Map<String, Object> params);

	/**
	 * callBatchPayVerifyDet
	 * @param params
	 * @return
	 */
	int callSupBatchPayVerifyDet(Map<String, Object> params);

	String selectBatchPayCardModeId(String cardModeCode);

  int checkIfIsEGHLRecord(Map<String, Object> params);

	int removeEGHLBatchOrderRecord(Map<String, Object> params);

	List<EgovMap> selectSupBatchPaymentDtl(Map<String, Object> params);

	void updSupplementOrdStage(Map<String, Object> params);

}
