package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.DiscountEntryVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("proFormaInvoiceMapper")
public interface ProFormaInvoiceMapper {

	List<EgovMap> searchProFormaInvoiceList(Map<String, Object> params);

	List<EgovMap> chkCustType(Map<String, Object> params);

	String selectDocNo(int docNoId);

	int selectPFGroupID();

    void saveNewProForma(Map<String, Object> params);

    void farCheckConvertFn(Map<String, Object> params);

    List<EgovMap> chkProForma(Map<String, Object> params);

    List<EgovMap> selectInvoiceBillGroupListProForma(Map<String, Object> params);

	List<EgovMap> getDiscPeriod(Map<String, Object> params);

	EgovMap getStatus(Map<String, Object> params);

	void insertDiscountEntry(Map<String, Object> params);

	int getTaskIdSeq();

	EgovMap selectSalesOrderMs(Map<String, Object> params);

	void insTaskLogOrder(Map<String, Object> params);

	void insBillTaskLog(Map<String, Object> params);

	void confirmTaxesAdvanceBill(Map<String, Object> params);

	EgovMap chkEligible(Map<String, Object> params);

}
