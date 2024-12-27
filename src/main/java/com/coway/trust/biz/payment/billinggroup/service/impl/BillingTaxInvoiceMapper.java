package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("billingTaxInvoiceMapper")
public interface BillingTaxInvoiceMapper {

	
	/**
	 * Billing Group - Tax Invoice Rental 그리드 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectTaxInvoiceRentalList(Map<String, Object> params);
	
	List<EgovMap> selectTaxInvoiceRentalListCody(Map<String, Object> params);
	
	/**
	 * Billing Group - Tax Invoice Outright 그리드 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectTaxInvoiceOutrightList(Map<String, Object> params);
	
	List<EgovMap> selectTaxInvoiceOutrightListCody(Map<String, Object> params);
	
	/**
	 * Billing Group - Tax Invoice Membership 그리드 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectTaxInvoiceMembershipList(Map<String, Object> params);
	
	/**
	 * Billing Group - Tax Invoice Rental Membership 그리드 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectTaxInvoiceRenMembershipList(Map<String, Object> params);
	
	/**
	 * Billing Group - Tax Invoice Miscellaneous 그리드 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectTaxInvoiceMiscellaneousList(Map<String, Object> params);
	
	/**
	 * Billing Group - Statement Company Rental 그리드 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectStatementCompanyRental(Map<String, Object> params);
	
	List<EgovMap> selectStatementCompanyRentalCody(Map<String, Object> params);
}
