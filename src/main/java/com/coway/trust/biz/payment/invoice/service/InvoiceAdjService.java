package com.coway.trust.biz.payment.invoice.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InvoiceAdjService {
	 /**
  	 * InvoiceAdjustment List 조회
  	 * @param params
  	 * @return
  	 */
      List<EgovMap> selectInvoiceAdj(Map<String, Object> params);
}
