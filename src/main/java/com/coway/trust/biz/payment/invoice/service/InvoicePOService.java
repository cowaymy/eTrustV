package com.coway.trust.biz.payment.invoice.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface InvoicePOService{

	/**
	 * InvoicePO Master 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectOrderBasicInfoByOrderId(Map<String, Object> params);

	List<EgovMap> selectHTOrderBasicInfoByOrderId(Map<String, Object> params);


	/**
	 * InvoicePO Data 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectOrderDataByOrderId(Map<String, Object> params);

	/**
	 * update Invoice Statement
	 * @param params
	 * @return
	 */
	int updateInvoiceStatement(Map<String, Object> params);

	/**
	 * InvoiceStatement 조회
	 * @param params
	 * @return
	 */
	List<EgovMap>selectInvoiceStatementByOrdId(Map<String, Object> params);

	/**
	 * InvoiceStatement 저장
	 * @param params
	 * @return
	 */
	void insertInvoicStatement(Map<String, Object> params);

	List<EgovMap>selectInvoiceStatementStart(Map<String, Object> params);

	List<EgovMap>selectInvoiceStatementEnd(Map<String, Object> params);

	List<EgovMap> selectInvoiceBillGroupList(Map<String, Object> params);

	String selectCustBillId(Map<String, Object> params);

}
