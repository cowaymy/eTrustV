package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.billing.service.impl.SrvMembershipBillingMapper;
import com.coway.trust.biz.payment.invoice.service.InvoicePOService;
import com.coway.trust.biz.payment.invoice.service.InvoiceService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("invoicePOService")
public class InvoicePOServiceImpl extends EgovAbstractServiceImpl implements InvoicePOService {

	@Resource(name = "invoicePOMapper")
	private InvoicePOMapper invoicePOMapper;

	@Override
	public List<EgovMap> selectOrderBasicInfoByOrderId(Map<String, Object> params) {
		return invoicePOMapper.selectOrderBasicInfoByOrderId(params);
	}

	@Override
	public List<EgovMap> selectHTOrderBasicInfoByOrderId(Map<String, Object> params) {
		return invoicePOMapper.selectHTOrderBasicInfoByOrderId(params);
	}

	@Override
	public List<EgovMap> selectOrderDataByOrderId(Map<String, Object> params) {
		return invoicePOMapper.selectOrderDataByOrderId(params);
	}

	@Override
	public int updateInvoiceStatement(Map<String, Object> params) {
		return invoicePOMapper.updateInvoiceStatement(params);
	}

	@Override
	public List<EgovMap> selectInvoiceStatementByOrdId(Map<String, Object> params) {
		return invoicePOMapper.selectInvoiceStatementByOrdId(params);
	}

	@Override
	public void insertInvoicStatement(Map<String, Object> params) {
		invoicePOMapper.insertInvoicStatement(params);
	}

	@Override
	public List<EgovMap> selectInvoiceStatementStart(Map<String, Object> params) {
	    return invoicePOMapper.selectInvoiceStatementStart(params);
	}

	@Override
	public List<EgovMap> selectInvoiceStatementEnd(Map<String, Object> params) {
	    return invoicePOMapper.selectInvoiceStatementEnd(params);
	}

	@Override
	public String selectCustBillId(Map<String, Object> params) {
		return invoicePOMapper.selectCustBillId(params);
	}

	@Override
	public List<EgovMap> selectInvoiceBillGroupList(Map<String, Object> params) {
		return invoicePOMapper.selectInvoiceBillGroupList(params);
	}

}
