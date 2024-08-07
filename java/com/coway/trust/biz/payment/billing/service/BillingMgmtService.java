package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface BillingMgmtService{
    
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
	 * Billing Detail 전체 건수 조회
	 * @param params
	 * @return
	 */
	int selectBillingDetailCount(Map<String, Object> params);
	
	/**
	 * createEaryBill 수행
	 * @param params
	 * @return
	 */
	void callEaryBillProcedure(Map<String, Object> params);
	
	/**
	 * createBill 수행
	 * @param params
	 * @return
	 */
	void callBillProcedure(Map<String, Object> params);
    
	/**
	 * Bill이 존재하는지 확인
	 * @param
	 * @return
	 */
	int getExistBill(Map<String, Object> params);
	
	/**
	 * Complete Early Bill
	 * @param
	 * @return
	 */
	void confirmEarlyBills(Map<String, Object> params);
	
	/**
	 * Complete Bill
	 * @param
	 * @return
	 */
	void confirmBills(Map<String, Object> params);
	
	/**
	 * 
	 * @param params
	 * @return
	 */
    int countMonthlyRawData(Map<String, Object> params);
}
