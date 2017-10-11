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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("earlyTerminationService")
public class EarlyTerminationBillingServiceImpl extends EgovAbstractServiceImpl implements EarlyTerminationBillingService {

	private static final Logger logger = LoggerFactory.getLogger(EarlyTerminationBillingServiceImpl.class);

	@Resource(name = "earlyTerminationMapper")
	private EarlyTerminationBillingMapper earlyTerminationMapper;

	@Override
	public int selectExistOrderCancellationList(String param) {
		return earlyTerminationMapper.selectExistOrderCancellationList(param);
	}

	@Override
	public int selectCheckExistPenaltyBill(String param) {
		return earlyTerminationMapper.selectCheckExistPenaltyBill(param);
	}

	@Override
	public List<EgovMap> selectRentalProductEarlyTerminationPenalty(String param) {
		return earlyTerminationMapper.selectRentalProductEarlyTerminationPenalty(param);
	}

	@Override
	public String getDocNumber(String param) {
		return earlyTerminationMapper.getDocNumber(param);
	}
	
	@Override
	@Transactional
	public String doSaveProductEarlyTerminationPenalty(Map<String, Object> ledger, Map<String, Object> orderbill, Map<String, Object> invoiceM, Map<String, Object> invoiceD){
		
		String strInvoiceNo = "";
		strInvoiceNo = this.getDocNumber("122");
		
		ledger.put("rentDocNo", strInvoiceNo);
		this.insertAccRentLedger(ledger);
		
		orderbill.put("accBillRemark", strInvoiceNo);
		this.insertAccOrderBill(orderbill);
		
		invoiceM.put("taxInvoiceRefNo", strInvoiceNo);
		this.insertAccTaxInvoiceMiscellaneous(invoiceM);
		
		invoiceD.put("taxInvoiceId", invoiceM.get("taxInvoiceId"));
		this.insertAccTaxInvoiceMiscellaneousSub(invoiceD);
		
		return strInvoiceNo;
	}

	@Override
	public void insertAccRentLedger(Map<String, Object> params) {
		earlyTerminationMapper.insertAccRentLedger(params);
	}

	@Override
	public void insertAccOrderBill(Map<String, Object> params) {
		earlyTerminationMapper.insertAccOrderBill(params);
	}

	@Override
	public void insertAccTaxInvoiceMiscellaneous(Map<String, Object> params) {
		earlyTerminationMapper.insertAccTaxInvoiceMiscellaneous(params);
	}

	@Override
	public void insertAccTaxInvoiceMiscellaneousSub(Map<String, Object> params) {
		earlyTerminationMapper.insertAccTaxInvoiceMiscellaneousSub(params);
	}

}
