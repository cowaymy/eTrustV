package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.billinggroup.service.BillingTaxInvoiceService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("billingTaxInvoiceService")
public class BillingTaxInvoiceServiceImpl extends EgovAbstractServiceImpl implements BillingTaxInvoiceService {

	@Resource(name = "billingTaxInvoiceMapper")
	private BillingTaxInvoiceMapper billingTaxInvoiceMapper;
	
	
	/**
	 * Billing Group - Tax Invoice Rental 그리드 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectTaxInvoiceRentalList(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectTaxInvoiceRentalList(params);
	}
	
	@Override
	public List<EgovMap> selectTaxInvoiceRentalListCody(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectTaxInvoiceRentalListCody(params);
	}
	/**
	 * Billing Group - Tax Invoice Outright 그리드 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectTaxInvoiceOutrightList(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectTaxInvoiceOutrightList(params);
	}
	
	@Override
	public List<EgovMap> selectTaxInvoiceOutrightListCody(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectTaxInvoiceOutrightListCody(params);
	}
	
	/**
	 * Billing Group - Tax Invoice Membership 그리드 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectTaxInvoiceMembershipList(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectTaxInvoiceMembershipList(params);
	}
	
	/**
	 * Billing Group - Tax Invoice Rental Membership 그리드 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectTaxInvoiceRenMembershipList(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectTaxInvoiceRenMembershipList(params);
	}
	
	/**
	 * Billing Group - Tax Invoice Miscellaneous 그리드 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectTaxInvoiceMiscellaneousList(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectTaxInvoiceMiscellaneousList(params);
	}
	
	/**
	 * Billing Group - Statement Company Rental 그리드 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectStatementCompanyRental(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectStatementCompanyRental(params);
	}
	
	@Override
	public List<EgovMap> selectStatementCompanyRentalCody(Map<String, Object> params) {
		return billingTaxInvoiceMapper.selectStatementCompanyRentalCody(params);
	}
	
	
}
