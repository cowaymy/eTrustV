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

import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("searchPaymentMapper")
public interface SearchPaymentMapper {

	
	/**
	 * SearchPayment Order List(Master Grid) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectOrderList(Map<String, Object> params);
	
	/**
	 * SearchPayment Payment List(Slave Grid) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPaymentList(Map<String, Object> params);
	
	/**
	 * RentalCollectionBySales(Slave Grid) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectSalesList(Map<String, Object> params);
	
	/**
	 * RentalCollectionByBS 조회
	 * @param params
	 * @return
	 */
	List<RentalCollectionByBSSearchVO> searchRentalCollectionByBSList(RentalCollectionByBSSearchVO searchVO);
	
	/**
	 * MasterHistory 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectViewHistoryList(int payId);

	/**
	 * DetailHistory 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDetailHistoryList(int payItemId);
	
	/**
	 * PaymentDetailViewer   조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentDetailViewer(Map<String, Object> params);
	
	/**
	 * 주문진행상태   조회
	 * @param params
	 * @return
	 */
	EgovMap selectOrderProgressStatus(Map<String, Object> params);
	
	/**
	 * paymentDetailView   조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentDetailView(Map<String, Object> params);
	
	
	/**
	 * PaymentDetailSlaveList   조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentDetailSlaveList(Map<String, Object> params);
	
	/**
	 * selectPayMaster   조회
	 * @param params
	 * @return
	 */
	EgovMap selectPayMaster(Map<String, Object> params);
	
	/**
	 * SaveChanges
	 * @param params
	 * @return
	 */
	void saveChanges(Map<String, Object> params);
	
	/**
	 * updChanges
	 * @param params
	 * @return
	 */
	void updChanges(Map<String, Object> params);
	
	/**
	 * selectPayMaster   조회
	 * @param params
	 * @return
	 */
	EgovMap selectMemCode(Map<String, Object> params);
	
	/**
	 * selectBranchCode   조회
	 * @param params
	 * @return
	 */
	EgovMap selectBranchCode(Map<String, Object> params);
	
	/**
	 * updGlReceiptBranchId
	 * @param params
	 * @return
	 */
	void updGlReceiptBranchId(Map<String, Object> params);
	
	/**
	 * selectPayDs   조회
	 * @param params
	 * @return
	 */
	EgovMap selectPayDs(Map<String, Object> params);
	
	/**
	 * selectGlRoute   조회
	 * @param params
	 * @return
	 */
	EgovMap selectGlRoute(Map<String, Object> params);

	/**
	 * PaymentItem 조회
	 * @param payItemId
	 * @return
	 */
	List<EgovMap> selectPaymentItem(int payItemId);
	
	/**
	 * PaymentDetail 조회
	 * @param payItemId
	 * @return
	 */
	List<EgovMap> selectPaymentDetail(int payItemId);
	
	/**
	 * BankCode 조회
	 * @param payItemId
	 * @return
	 */
	String selectBankCode(String payItmIssuBankId);
	
	/**
	 *  CodeDetail조회
	 * @param payItemId
	 * @return
	 */
	String selectCodeDetail(String payItmCcTypeId);
	
	/**
	 * selectPaymentItemIsPassRecon 조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentItemIsPassRecon(Map<String, Object> params);
}
