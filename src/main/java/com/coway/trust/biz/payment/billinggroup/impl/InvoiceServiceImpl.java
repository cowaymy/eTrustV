package com.coway.trust.biz.payment.billinggroup.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.billinggroup.InvoiceService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("invoiceService")
public class InvoiceServiceImpl implements InvoiceService{

	@Resource(name = "invoiceMapper")
	private InvoiceMapper invoiceMapper;
	
	@Override
	public List<EgovMap> selectCompanyInvoice(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectCompanyInvoiceList(params);
	}

	@Override
	public List<EgovMap> selectMembershipInvoiceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectMembershipInvoiceList(params);
	}

	@Override
	public List<EgovMap> selectRentalStatementList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectRentalStatementList(params);
	}
	
	@Override
	public List<EgovMap> selectOutrightInvoiceList(Map<String, Object> params){
		return invoiceMapper.selectOutrightInvoiceList(params);
	}
}
