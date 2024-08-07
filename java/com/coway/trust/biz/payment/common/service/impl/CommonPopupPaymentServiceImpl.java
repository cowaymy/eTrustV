package com.coway.trust.biz.payment.common.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.billinggroup.service.BillingGroupService;
import com.coway.trust.biz.payment.common.service.CommonPopupPaymentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("commonPopupPaymentService")
public class CommonPopupPaymentServiceImpl extends EgovAbstractServiceImpl implements CommonPopupPaymentService {

	private static final Logger logger = LoggerFactory.getLogger(CommonPopupPaymentServiceImpl.class);

	@Resource(name = "commonPopupPaymentMapper")
	private CommonPopupPaymentMapper commonPopupPaymentMapper;	
	
	/**
	 * Payment - Invoice Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap>  selectCommonSearchInvoicePop(Map<String, Object> params) {
		return commonPopupPaymentMapper.selectCommonSearchInvoicePop(params);
	}
	
	/**
	 * Payment - Rental Membership Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap> selectCommonContractSearchPop(Map<String, Object> params) {
		return commonPopupPaymentMapper.selectCommonContractSearchPop(params);
	}
	
	 /**
	 * Payment - Outright Membership Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public List<EgovMap>  selectCommonQuotationSearchPop(Map<String, Object> params) {
		return commonPopupPaymentMapper.selectCommonQuotationSearchPop(params);
	}
	
	/**
	 * Payment - Outright Membership Search Pop-up 리스트 카운트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public int countCommonQuotationSearchPop(Map<String, Object> params) {
		return commonPopupPaymentMapper.countCommonQuotationSearchPop(params);
	}
	
	
}
