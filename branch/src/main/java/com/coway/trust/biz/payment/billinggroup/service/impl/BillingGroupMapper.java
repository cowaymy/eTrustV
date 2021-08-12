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
package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("billingGroupMapper")
public interface BillingGroupMapper {

	
	/**
	 * selectCustBillId 조회
	 * @param params
	 * @return
	 */
	String selectCustBillId(Map<String, Object> params);
	
	/**
	 * selectBasicInfo 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBasicInfo(Map<String, Object> params);
	
	/**
	 * selectMaillingInfo 조회
	 * @param params
	 * @return
	 */
	EgovMap selectMaillingInfo(Map<String, Object> params);
	
	/**
	 * selectContractInfo 조회
	 * @param params
	 * @return
	 */
	EgovMap selectContractInfo(Map<String, Object> params);
	
	/**
	 * selectOrderGroupList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectOrderGroupList(Map<String, Object> params);
	
	/**
	 * selectEstmReqHistory 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectEstmReqHistory(Map<String, Object> params);
	
	/**
	 * selectBillGrpHistory 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillGrpHistory(Map<String, Object> params);
	
	/**
	 * selectBillGrpOrder 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBillGrpOrder(Map<String, Object> params);
	
	/**
	 * selectBillGroupOrderView 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillGroupOrderView(Map<String, Object> params);
	
	/**
	 * updCustMaster 업데이트
	 * @param params
	 * @return
	 */
	void updCustMaster(Map<String, Object> params);
	
	/**
	 * updSalesOrderMaster 업데이트
	 * @param params
	 * @return
	 */
	void updSalesOrderMaster(Map<String, Object> params);
	
	/**
	 * insHistory
	 * @param params
	 * @return
	 */
	int insHistory(Map<String, Object> params);
	
	/**
	 * selectDetailHistoryView 조회
	 * @param params
	 * @return
	 */
	EgovMap selectDetailHistoryView(Map<String, Object> params);
	
	/**
	 * selectMailAddrHistorty 조회
	 * @param param
	 * @return
	 */
	EgovMap selectMailAddrHistorty(String param);
	
	/**
	 * selectMailAddrHistorty 조회
	 * @param param
	 * @return
	 */
	EgovMap selectContPersonHistorty(String param);
	
	/**
	 * selectCustMailAddrList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCustMailAddrList(Map<String, Object> params);
	
	/**
	 * selectSalesOrderM 조회
	 * @param param
	 * @return
	 */
	List<EgovMap> selectSalesOrderM(Map<String, Object> params);
	
	/**
	 * selectContPersonList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectContPersonList(Map<String, Object> params);
	
	/**
	 * selectCustBillMaster 조회
	 * @param param
	 * @return
	 */
	EgovMap selectCustBillMaster(Map<String, Object> param);
	
	/**
	 * selectReqMaster 조회
	 * @param param
	 * @return
	 */
	List<EgovMap> selectReqMaster(Map<String, Object> param);
	
	List<EgovMap> selectBeforeReqIDs(Map<String, Object> param);
	
	/**
	 * updReqEstm
	 * @param params
	 * @return
	 */
	void updReqEstm(Map<String, Object> params);
	
	/**
	 * selectDocNo 조회
	 * @param param
	 * @return
	 */
	EgovMap selectDocNo(Map<String, Object> param);
	
	/**
	 * updReqEstm
	 * @param params
	 * @return
	 */
	void updDocNo(Map<String, Object> params);
	
	/**
	 * insEstmReq
	 * @param params
	 * @return
	 */
	void insEstmReq(Map<String, Object> params);
	
	/**
	 * selectEstmReqHisView 조회
	 * @param param
	 * @return
	 */
	EgovMap selectEstmReqHisView(Map<String, Object> param);
	
	/**
	 * selectEStatementReqs 조회
	 * @param param
	 * @return
	 */
	EgovMap selectEStatementReqs(Map<String, Object> param);
	
	/**
	 * selectBillGrpOrdView 조회
	 * @param param
	 * @return
	 */
	EgovMap selectBillGrpOrdView(Map<String, Object> param);
	
	/**
	 * selectSalesOrderMs 조회
	 * @param param
	 * @return
	 */
	EgovMap selectSalesOrderMs(Map<String, Object> param);
	
	/**
	 * selectReplaceOrder 조회
	 * @param param
	 * @return
	 */
	EgovMap selectReplaceOrder(Map<String, Object> param);
	
	/**
	 * selectAddOrdList 조회
	 * @param param
	 * @return
	 */
	List<EgovMap> selectAddOrdList(Map<String, Object> param);
	
	/**
	 * selectMainOrderHistory 조회
	 * @param param
	 * @return
	 */
	EgovMap selectMainOrderHistory(Map<String, Object> param);
	
	/**
	 * insBillGrpMaster 인서트
	 * @param params
	 * @return
	 */
	void insBillGrpMaster(Map<String, Object> params);
	
	/**
	 * "selectGetOrder" 조회
	 * @param param
	 * @return
	 */
	EgovMap selectGetOrder(Map<String, Object> param);
	
	/**
	 * getSAL0024DSEQ 조회
	 * @param params
	 * @return
	 */
	int getSAL0024DSEQ();
	
	/**
	 * docNoCreateSeq 조회
	 * @param params
	 * @return
	 */
	String selectDocNo24Seq();
	
	/**
	 * updCustBillMaster
	 * @param params
	 * @return
	 */
    void updCustBillMaster(Map<String, Object> params);
    
    /**
	 * selectEstmLatelyHistory 조회
	 * @param param
	 * @return
	 */
	EgovMap selectEstmLatelyHistory(Map<String, Object> param);
}
