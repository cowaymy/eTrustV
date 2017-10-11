package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EarlyTerminationBillingService{
	
	/**
	 * OrderCancelation 존재여부 확인
	 * @param params
	 * @return
	 */
	int selectExistOrderCancellationList(String param);
	
	/**
	 * PenaltyBill 존재여부 확인
	 * @param params
	 * @return
	 */
	int selectCheckExistPenaltyBill(String param);
	
	/**
	 * ProductEarlyTerminationPenalty 정보 조회
	 * @param
	 * @return
	 */
	List<EgovMap> selectRentalProductEarlyTerminationPenalty(String param);
	
	/**
	 * DocNumber얻어옴
	 * @param
	 * @return
	 */
	String getDocNumber(String param);
	
	/**
	 * bill 업데이트 및 저장
	 * @param
	 * @return
	 */
	public String doSaveProductEarlyTerminationPenalty(Map<String, Object> ledger, Map<String, Object> orderbill, Map<String, Object> invoiceM, Map<String, Object> invoiceD);

	/**
	 * ledger저장
	 * @param
	 * @return
	 */
	void insertAccRentLedger(Map<String, Object> params);
	
	/**
	 * orderbill저장
	 * @param
	 * @return
	 */
	void insertAccOrderBill(Map<String, Object> params);
	
	/**
	 * taxInvoice 저장
	 * @param
	 * @return
	 */
	void insertAccTaxInvoiceMiscellaneous(Map<String, Object> params);
	
	/**
	 * taxInvoiceSub 저장
	 * @param
	 * @return
	 */
	void insertAccTaxInvoiceMiscellaneousSub(Map<String, Object> params);
}
