package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ProFormaInvoiceService{

	List<EgovMap> searchProFormaInvoiceList(Map<String, Object> params) ;

	List<EgovMap> chkCustType(Map<String, Object> params);

	void saveNewProForma(Map<String, Object> params);

	void farCheckConvertFn(Map<String, Object> params);

	List<EgovMap> chkProForma(Map<String, Object> params);

}