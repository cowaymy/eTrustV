package com.coway.trust.biz.payment.invoice.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface InvoiceService{

	/**
	 * Invoice List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectInvoiceList(Map<String, Object> params);

	/**
	 * Invoice Master 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectInvoiceMaster(Map<String, Object> params);

	/**
	 * Invoice Detail 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectInvoiceDetail(Map<String, Object> params);

	/**
	 * Invoice Detail 전체 건수 조회
	 * @param params
	 * @return
	 */
	int selectInvoiceDetailCount(Map<String, Object> params);

	/**
	 * Create Tax Invoice
	 * @param params
	 * @return
	 */
	void createTaxInvoice(Map<String, Object> params);

	List<EgovMap> selecteStatementRawList(Map<String, Object> params);

	EgovMap getUploadSeq();

	void insertBulkInvc(Map<String, Object> bulkMap) throws Exception;

	List<EgovMap> selectUploadResultList(Map<String, Object> params);

	List<EgovMap> selecteStatementRawListbyBatch(Map<String, Object> params);

}
