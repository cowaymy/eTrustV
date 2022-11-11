package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ProFormaInvoiceService{

	List<EgovMap> searchProFormaInvoiceList(Map<String, Object> params) ;

	List<EgovMap> chkCustType(Map<String, Object> params);

	String saveNewProForma(List<Object> taskBillList, SessionVO sessionVO);

	List<EgovMap> chkProForma(Map<String, Object> params);

	List<EgovMap> selectInvoiceBillGroupListProForma(Map<String, Object> params);

	List<EgovMap> getDiscPeriod(Map<String, Object> params) ;

	int createTaxesBills(Map<String, Object> params, List<Object> taskBillList, SessionVO sessionVO);

	Map<String, Object> updateProForma(Map<String, Object> params, SessionVO sessionVO);

	EgovMap chkEligible(Map<String, Object> params);
}