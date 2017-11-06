package com.coway.trust.biz.payment.common.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonPaymentService{
	
	/**
	 * Payment - Order Info 조회 : order No로 Order ID 조회하기 
	 * @param params
	 * @param model
	 * @return
	 * 
	 */	
    EgovMap selectOrdIdByNo(Map<String, Object> params);
	
	/**
	 * Payment - Order Info Rental 조회 
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetRentalOrders(int orderId, bool getBillingGroup)
	 */
    List<EgovMap> selectOrderInfoRental(Map<String, Object> params);
    
    /**
	 * Payment - Bill Info Rental 조회 
	 * @param params
	 * @param model
	 * @return
	 * BillingManager.cs : public List<BillView> GetRentalBillsByOrder(int orderId, bool excludeRPFBill)
	 */
    List<EgovMap> selectBillInfoRental(Map<String, Object> params);
    
    /**
	 * Payment - Order Info Non - Rental 조회 
	 * @param params
	 * @param model
	 * @return
	 * PaymentManager.cs : public List<RentalOrderView> GetOutInstOrders(int orderId)
	 */
    List<EgovMap> selectOrderInfoNonRental(Map<String, Object> params);
    
    /**
	 * Payment - Order Info Membership Service  조회 
	 * @param params
	 * @param model
	 * @return
	 * 
	 */
    Map<String, Object> selectOrderInfoSVM(Map<String, Object> params);
    
    /**
	 * Payment - Order Info Rental Membership 조회 
	 * @param params
	 * @param model
	 * @return
	 * 
	 */
    List<EgovMap> selectOrderInfoSrvc(Map<String, Object> params);
    

}
