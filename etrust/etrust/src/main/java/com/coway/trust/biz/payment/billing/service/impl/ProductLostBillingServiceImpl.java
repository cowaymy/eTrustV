package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.billing.service.BillingMgmtService;
import com.coway.trust.biz.payment.billing.service.EarlyTerminationBillingService;
import com.coway.trust.biz.payment.billing.service.ProductLostBillingService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("productLostService")
public class ProductLostBillingServiceImpl extends EgovAbstractServiceImpl implements ProductLostBillingService {

	private static final Logger logger = LoggerFactory.getLogger(EarlyTerminationBillingServiceImpl.class);

	@Resource(name = "productLostMapper")
	private ProductLostBillingMapper productLostMapper;

	@Override
	public List<EgovMap> selectRentalProductLostPenalty(String param) {
		return productLostMapper.selectRentalProductLostPenalty(param);
	}

	@Override
	public String getZRLocationId(String param) {
		return productLostMapper.getZRLocationId(param);
	}

	@Override
	public String getRSCertificateId(String param) {
		return productLostMapper.getRSCertificateId(param);
	}

	@Override
	@Transactional
	public String doSaveProductLostPenalty(Map<String, Object> ledger, Map<String, Object> orderbill,
			Map<String, Object> invoiceM, Map<String, Object> invoiceD) {
		String invoiceNo = "";
		boolean success = false;
		
		invoiceNo = this.getDocNumberForProductLost("126");
		System.out.println("#### invoiceNo : " + invoiceNo);
		
		ledger.put("rentDocNo", invoiceNo);
		this.insertLedger(ledger);
		
		orderbill.put("accBillRemark", invoiceNo);
		this.insertOrderBill(orderbill);
		
		invoiceM.put("taxInvoiceRefNo", invoiceNo);
		this.insertInvoiceM(invoiceM);
		
		invoiceD.put("taxInvoiceId", invoiceM.get("taxInvoiceId"));
		this.insertInvoiceD(invoiceD);
		
		success = true;
		
		if(!success) invoiceNo = "";
		
		return invoiceNo;
	}

	@Override
	public String getDocNumberForProductLost(String param) {
		// TODO Auto-generated method stub
		return productLostMapper.getDocNumberForProductLost(param);
	}

	@Override
	public void insertLedger(Map<String, Object> ledger) {
		productLostMapper.insertLedger(ledger);
	}

	@Override
	public void insertOrderBill(Map<String, Object> orderbill) {
		productLostMapper.insertOrderBill(orderbill);
	}

	@Override
	public void insertInvoiceM(Map<String, Object> invoiceM) {
		productLostMapper.insertInvoiceM(invoiceM);
	}

	@Override
	public void insertInvoiceD(Map<String, Object> invoiceD) {
		productLostMapper.insertInvoiceD(invoiceD);
	}                                  

}
