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
    
    /**
	 * SearchPayment Payment List(Slave Grid) 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectPaymentList(Map<String, Object> params);
    
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
	EgovMap selectPaymentDetailView(Map<String, Object> params);
	
	/**
	 * PaymentDetailSlaveList   조회
	 * @param params
	 * @return
	 */
	EgovMap selectPaymentDetailSlaveList(Map<String, Object> params);
}
