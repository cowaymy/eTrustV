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

import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByOrganizationVO;


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

    List<EgovMap> selectOrderList_OrNo(Map<String, Object> params);

    List<EgovMap> selectOrderList_aNoOrNo(Map<String, Object> params);


	/**
	 * SearchPayment Order List(Master Grid) 전체 건수
	 * @param params
	 * @return
	 */
	int selectOrderListCount(Map<String, Object> params);

	/**
	 * SearchPayment Payment List(Slave Grid) 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPaymentList(Map<String, Object> params);

	String selectPayItmAmt(Map<String, Object> params);


	List<EgovMap> selectPayIdFromPayItemId(Map<String, Object> params);
	List<EgovMap> selectPayId(Map<String, Object> params);

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
     * RentalCollectionByBS 조회
     * @param params
     * @return
     */
    List<RentalCollectionByBSSearchVO> searchRentalCollectionByBSNewList(RentalCollectionByBSSearchVO searchVO);

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
	List<EgovMap> selectPaymentDetailView(Map<String, Object> params);


	/**
	 * PaymentDetailSlaveList   조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPaymentDetailSlaveList(Map<String, Object> params);

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
	List<EgovMap> selectPayDs(Map<String, Object> params);

	/**
	 * selectGlRoute   조회
	 * @param params
	 * @return
	 */
	EgovMap selectGlRoute(String param);

	/**
	 * PaymentItem 조회
	 * @param payItemId
	 * @return
	 */
	List<EgovMap> selectPaymentItem(Map<String, Object> params);

	/**
	 * PaymentDetail 조회
	 * @param payItemId
	 * @return
	 */
	List<EgovMap> selectPaymentDetail(int payItemId);


	/**
	 *  CheckAORType 조회
	 * @param payItemId
	 * @return
	 */
	String checkORNoIsAORType(String payItmId);

	/**
	 *  PayHistory에 저장
	 * @param payItemId
	 * @return
	 */
	void insertPayDHistory(PayDHistoryVO vo);

	/**
	 *  paymentDetail업데이트
	 * @param Map
	 * @return
	 */
	void updatePayDetail(Map map);

	/**
	 *  DocRelated 검색
	 * @param String
	 * @return EgovMap
	 */
	List<EgovMap> selectPaymentDocRelated(int payItemId);

	/**
	 *  DocDetail 검색
	 * @param int
	 * @return EgovMap
	 */
	List<EgovMap> selectPaymentDocDetail(int payItemId);

	/**
	 *  payDocDetail업데이트
	 * @param Map
	 * @return
	 */
	void updatePayDocDetail(Map map);

	/**
	 * selectPaymentItemIsPassRecon 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPaymentItemIsPassRecon(Map<String, Object> params);

	/**
	 * RentalCollectionByBSAgingMonth 조회
	 * @param params
	 * @return
	 */
	List<RentalCollectionByBSSearchVO> searchRCByBSAgingMonthList(RentalCollectionByBSSearchVO searchVO);

	/**
     * RentalCollectionByBSAgingMonthNew 조회
     * @param params
     * @return
     */
    List<EgovMap> searchRCByBSAgingMonthNewList(Map<String, Object> params);

	List<RentalCollectionByOrganizationVO> searchRCByOrganizationList(RentalCollectionByOrganizationVO orgVO);

	List<EgovMap> getPayIdByType(Map<String, Object> params);

}
