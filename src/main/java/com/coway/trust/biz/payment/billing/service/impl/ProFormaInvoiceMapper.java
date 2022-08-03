package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("proFormaInvoiceMapper")
public interface ProFormaInvoiceMapper {

	List<EgovMap> searchProFormaInvoiceList(Map<String, Object> params);

	List<EgovMap> chkCustType(Map<String, Object> params);

	String selectDocNo(int docNoId);

    void saveNewProForma(Map<String, Object> params);

    void farCheckConvertFn(Map<String, Object> params);
}
