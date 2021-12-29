package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.billinggroup.service.BillingInvoiceService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("billingInvoiceService")
public class BillingInvoiceServiceImpl extends EgovAbstractServiceImpl implements BillingInvoiceService{

	@Resource(name = "billingInvoiceMapper")
	private BillingInvoiceMapper invoiceMapper;

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

	@Override
	public List<EgovMap> selectCompanyStatementList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectCompanyStatementList(params);
	}

	@Override
	public List<EgovMap> selectProformaInvoiceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectProformaInvoiceList(params);
	}

	@Override
	public List<EgovMap> selectAdvancedRentalInvoiceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectAdvancedRentalInvoiceList(params);
	}

	@Override
	public List<EgovMap> selectProductUsageMonth(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectProductUsageMonth(params);
	}

	@Override
	public List<EgovMap> selectProductBasicInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectProductBasicInfo(params);
	}

	@Override
	public List<EgovMap> selectPenaltyBillDate(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectPenaltyBillDate(params);
	}

	@Override
	public int selectOutrightInvoiceListCount(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectOutrightInvoiceListCount(params);
	}

	@Override
	public  List<EgovMap> searchSummaryInvoiceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.searchSummaryInvoiceList(params);
	}

	@Override
	public  List<EgovMap> searchSummaryAccountList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.searchSummaryAccountList(params);
	}
}
