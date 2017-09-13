package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface BillingRentalService{
    
    /**
	 * Billing Mgnt 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillingMgnt(Map<String, Object> params);
	
	/**
	 * Billing Master 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBillingMaster(Map<String, Object> params);
	
	/**
	 * Billing Detail 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillingDetail(Map<String, Object> params);
	
	/**
	 * createEaryBill 수행
	 * @param params
	 * @return
	 */
	int callEaryBillProcedure(Map<String, Object> params);
	
	/**
	 * createBill 수행
	 * @param params
	 * @return
	 */
	int callBillProcedure(Map<String, Object> params);
    
}
