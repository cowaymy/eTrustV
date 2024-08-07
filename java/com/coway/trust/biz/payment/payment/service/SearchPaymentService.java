package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SearchPaymentService
{


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
	 * Sales List(Slave Grid) 조회
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
	 * PaymentDetailView   조회
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
	 * PaymentItem 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPaymentItem(Map<String, Object> params);

	/**
	 * PaymentDetail 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPaymentDetail(int payItemId);

	/**
	 * PaymentBankCode 조회
	 * @param params
	 * @return
	 */
	String selectBankCode(String payItemIssuedBankID);

	/**
	 * PaymentCodeDetail 조회
	 * @param params
	 * @return
	 */
	String selectCodeDetail(int payItmCcTypeId);

	/**
	 * selectPayMaster   조회
	 * @param params
	 * @return
	 */
	EgovMap selectPayMaster(Map<String, Object> params);

	/**
	 * saveChanges 저장
	 * @param params
	 * @return
	 */
	void saveChanges (Map<String, Object> params);

	/**
	 * updChanges
	 * @param params
	 * @return
	 */
	void updChanges (Map<String, Object> params);

	/**
	 * selectMemCode   조회
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
	 * CheckAORType 조회
	 * @param String
	 * @return
	 */
	String checkORNoIsAORType(String payItem);

	/**
	 * PaymentDetails 저장 및 업데이트
	 * @param PayDVO
	 * @return boolean
	 */
	boolean doEditPaymentDetails(PayDVO payDet);

	/**
	 * updGlReceiptBranchId (업데이트)
	 * @param params
	 * @return
	 */
	void updGlReceiptBranchId (Map<String, Object> params);

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
     * RentalCollectionByBSAgingMonth 조회
     * @param params
     * @return
     */
    List<EgovMap> searchRCByBSAgingMonthNewList(Map<String, Object> params);

    /**
	 * RentalCollectionByOrganization 조회
	 * @param params
	 * @return
	 */
    List<RentalCollectionByOrganizationVO> searchRCByOrganizationList(RentalCollectionByOrganizationVO searchVO);


}
