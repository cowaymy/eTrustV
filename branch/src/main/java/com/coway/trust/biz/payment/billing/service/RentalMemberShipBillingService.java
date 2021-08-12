package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface RentalMemberShipBillingService{

	/**
	 * selectCustBillOrderNoList_M 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCustBillOrderList_M(Map<String, Object> params);
    
    /**
	 * selectRentalMembershipBillingSchedule 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectRentalMembershipBillingSchedule(Map<String, Object> params);
	
	/**
	 * confirmTaxesManualBillRentalMbrsh 
	 * @param params
	 * @return
	 */
	int confirmTaxesManualBillRentalMbrsh(List<Object> formList, List<Object> taskBillList, SessionVO sessionVO);


}
