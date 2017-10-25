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
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("adminMgmtMapper")
public interface AdminMgmtMapper {

	
	/**
	 * selectWaitingItemList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectWaitingItemList(Map<String, Object> params);
	
	/**
	 * selectReviewItemList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectReviewItemList(Map<String, Object> params);
	
	/**
	 * selectDocItemPayDetailList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDocItemPayDetailList(Map<String, Object> params);
	
	/**
	 * selectDocNo
	 * @param params
	 * @return
	 */
	String selectDocNo(String docNo);
	
	/**
	 * getPAY0170MSEQ
	 * @param params
	 * @return
	 */
	int getPAY0170MSEQ();
	
	/**
	 * getPAY0097DSEQ
	 * @param params
	 * @return
	 */
	int getPAY0097DSEQ();
	
	/**
	 * insertPayDocDetail
	 * @param params
	 * @return
	 */
	void insertPayDocDetail(Map<String, Object> params);
	
	/**
	 * insertPayDocMaster
	 * @param params
	 * @return
	 */
	void insertPayDocMaster(Map<String, Object> params);
	
	/**
	 * insertPayDocLogs
	 * @param params
	 * @return
	 */
	void insertPayDocLogs(Map<String, Object> params);
	
	/**
	 * selectDocPaymentItem 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDocPaymentItem(Map<String, Object> params);
	
	
	/**
	 * selectPaymentDs 조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentDs(String payItmId);
	
	/**
	 * updPayItemIsLock
	 * @param params
	 * @return
	 */
	void updPayItemIsLock(String payItmId);
	
	/**
	 * insertPayDocRelateds
	 * @param params
	 * @return
	 */
	void insertPayDocRelateds(Map<String, Object> params);
	
	/**
	 * selectDocItemPayReviewDetailList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDocItemPayReviewDetailList(Map<String, Object> params);
	
	/**
	 * selectLoadItemLog 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectLoadItemLog(Map<String, Object> params);
	
	/**
	 * selectPaymentDocDs 조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentDocDs(String param);
	
	/**
	 * updPayDocDetail
	 * @param params
	 * @return
	 */
	void updPayDocDetail(Map<String, Object> params);
	
	/**
	 * selectPaymentDocMs 조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentDocMs(Map<String, Object> params);
	
	/**
	 * selectPaymentDocDsTotalCount 조회
	 * @param params
	 * @return
	 */
	String selectPaymentDocDsTotalCount(Map<String, Object> params);
}
