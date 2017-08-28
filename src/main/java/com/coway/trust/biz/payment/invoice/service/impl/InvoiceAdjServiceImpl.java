package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.invoice.service.InvoiceAdjService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("invoiceAdjService")
public class InvoiceAdjServiceImpl extends EgovAbstractServiceImpl implements InvoiceAdjService{

	@Resource(name = "invoiceAdjMapper")
	private InvoiceAdjMapper invoiceMapper;

	@Override
	public List<EgovMap> selectInvoiceAdj(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectInvoiceAdjList(params);
	}
	

}
