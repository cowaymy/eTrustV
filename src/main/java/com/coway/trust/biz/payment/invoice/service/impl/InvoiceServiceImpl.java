package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.impl.SrvMembershipBillingMapper;
import com.coway.trust.biz.payment.invoice.service.InvoiceService;
import com.coway.trust.config.datasource.DataSource;
import com.coway.trust.config.datasource.DataSourceType;

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

@Service("invoiceService")
public class InvoiceServiceImpl extends EgovAbstractServiceImpl implements InvoiceService {

	@Resource(name = "invoiceMapper")
	private InvoiceMapper invoiceMapper;

	@Resource(name = "srvMembershipBillingMapper")
	private SrvMembershipBillingMapper membershipMapper;

	@Override
	public List<EgovMap> selectInvoiceList(Map<String, Object> params) {
		return invoiceMapper.selectInvoiceList(params);
	}

	@Override
	public List<EgovMap> selectInvoiceMaster(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectInvoiceMaster(params);
	}

	@Override
	public List<EgovMap> selectInvoiceDetail(Map<String, Object> params) {
		return invoiceMapper.selectInvoiceDetail(params);
	}

	@Override
	public int selectInvoiceDetailCount(Map<String, Object> params) {
		return invoiceMapper.selectInvoiceDetailCount(params);
	}

	@Override
	@DataSource(value = DataSourceType.LONG_TIME)
	public void createTaxInvoice(Map<String, Object> params) {
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		if(checkList.size() > 0){
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				Map<String, Object> param = new HashMap<String, Object>();
				param = (Map<String, Object>) tmpMap.get("item");
				param.put("userId", params.get("userId"));
				membershipMapper.createTaxInvoice(param);
				params.put("p1",param.get("p1"));
			}
		}
	}

	@Override
	public List<EgovMap> selecteStatementRawList(Map<String, Object> params) {
		return invoiceMapper.selecteStatementRawList(params);
	}

	@Override
	public EgovMap getUploadSeq() {
		return invoiceMapper.getUploadSeq();
	}

	@Override
	public void insertBulkInvc(Map<String, Object> params) {
		invoiceMapper.insertBulkInvc(params);
	}

	@Override
    public List<EgovMap> selectUploadResultList( Map<String, Object> params) {
        return invoiceMapper.selectUploadResultList(params);
    }

	@Override
	public List<EgovMap> selecteStatementRawListbyBatch(Map<String, Object> params) {
		return invoiceMapper.selecteStatementRawListbyBatch(params);
	}

}
