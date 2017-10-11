package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("srvMembershipBillingMapper")
public interface SrvMembershipBillingMapper {
	
	/**
	 * confirm Service Membership Billing
	 * @param params
	 * @return
	 */
	void confirmSrvMembershipBilll(Map<String, Object> params);
	
	/**
	 * Create Tax Invoice
	 * @param params
	 * @return
	 */
	void createTaxInvoice(Map<String, Object> params);
}
