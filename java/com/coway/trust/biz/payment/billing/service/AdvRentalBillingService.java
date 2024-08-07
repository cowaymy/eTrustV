package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface AdvRentalBillingService{

    
    /**
	 * selectCustBillOrderList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCustBillOrderList(Map<String, Object> params);
    
    
    /**
	 * selectRentalBillingSchedule 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectRentalBillingSchedule(Map<String, Object> params);
	
	/**
	 * createTaxesBills 
	 * @param params
	 * @return
	 */
	int createTaxesBills(List<Object> formList, List<Object> taskBillList, SessionVO sessionVO);

}
