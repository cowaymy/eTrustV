package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.invoice.service.BillingVoidService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("billingVoidService")
public class BillingVoidServiceImpl extends EgovAbstractServiceImpl implements BillingVoidService{

	@Resource(name = "billingVoidMapper")
	private BillingVoidMapper billingVoidMapper ;

	@Override
	public EgovMap selectStatementView(Map<String, Object> params) {
		return billingVoidMapper.selectStatementView(params);
	}

	@Override
	public List<EgovMap> selectInvoiceDetailList(Map<String, Object> params) {
		return billingVoidMapper.selectInvoiceDetailList(params);
	}

	@Override
	public void saveInvoiceVoidResult(Map<String, Object> params) {
		billingVoidMapper.saveInvoiceVoidResult(params);
	}
	
	
}
