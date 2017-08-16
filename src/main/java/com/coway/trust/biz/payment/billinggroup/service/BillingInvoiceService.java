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
  	 * StatementCompany List 조회
  	 * @param params
  	 * @return 
  	 */
  	List<EgovMap> selectStatementCompanyList(Map<String, Object> params);
}
