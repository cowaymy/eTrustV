package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface RentalUnbillBillingService{

	/**
	 * selectCustBillOrderNoList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCustBillOrderList_U(Map<String, Object> params);
    
    /**
	 * selectUnbilledRentalBillingSchedule 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectUnbilledRentalBillingSchedule(Map<String, Object> params);
	
	/**
	 * createTaxesBills 
	 * @param params
	 * @return
	 */
	int createTaxesManualBills(List<Object> formList, List<Object> taskBillList, SessionVO sessionVO);


}
