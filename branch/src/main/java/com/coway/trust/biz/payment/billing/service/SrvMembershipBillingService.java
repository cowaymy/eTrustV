package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SrvMembershipBillingService{
	
	/**
	 * Manual Billing - Membership save 처리 
	 * @param params
	 * @param model
	 * @return
	 */
    int saveSrvMembershipBilling(Map<String, Object> formData, List<Object> taskBillList, SessionVO sessionVO);
    
}