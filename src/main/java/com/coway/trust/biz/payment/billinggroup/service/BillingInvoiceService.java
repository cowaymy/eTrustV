package com.coway.trust.biz.payment.billinggroup.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BillingInvoiceService {
	 /**
  	 * CompanyInvoice List 조회
  	 * @param params
  	 * @return
  	 */
      List<EgovMap> selectCompanyInvoice(Map<String, Object> params);

      /**
    	 * RentalStatement List 조회
    	 * @param params
    	 * @return
    	 */
      List<EgovMap>selectRentalStatementList(Map<String, Object> params);

      /**
    	 * membershipInvoice List 조회
    	 * @param params
    	 * @return
    	 */
      List<EgovMap> selectMembershipInvoiceList(Map<String, Object> params);

      /**
  	 * OutrightInvoice List 조회
  	 * @param params
  	 * @return
  	 */
      List<EgovMap> selectOutrightInvoiceList(Map<String, Object> params);

      /**
  	 * CompanyStatement List 조회
  	 * @param params
  	 * @return
  	 */
  	List<EgovMap> selectCompanyStatementList(Map<String, Object> params);

  	/**
	 * ProformaInvoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectProformaInvoiceList(Map<String, Object> params);
	
	List<EgovMap> selectProformaInvoiceListCody(Map<String, Object> params);

 	/**
	 * Advanced Rental Invoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectAdvancedRentalInvoiceList(Map<String, Object> params);
	
	List<EgovMap> selectAdvancedRentalInvoiceListCody(Map<String, Object> params);

	List<EgovMap> selectProductUsageMonth(Map<String, Object> params);

	List<EgovMap> selectProductBasicInfo(Map<String, Object> params);

	/**
	 * Penalty Invoice Bill Date 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPenaltyBillDate(Map<String, Object> params);

	/**
	 * Outright List Count 조회
	 * @param params
	 * @return
	 */
	int selectOutrightInvoiceListCount(Map<String, Object> params);

	/**
	 * Summary Invoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> searchSummaryInvoiceList(Map<String, Object> params);

	/**
	 * Summary Account List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> searchSummaryAccountList(Map<String, Object> params);

}
