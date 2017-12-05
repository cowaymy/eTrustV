package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.otherpayment.service.PaymentListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("paymentListService")
public class PaymentListServiceImpl extends EgovAbstractServiceImpl implements PaymentListService {

	@Resource(name = "paymentListMapper")
	private PaymentListMapper paymentListMapper;
	
	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectPaymentList(Map<String, Object> params) {
		return paymentListMapper.selectPaymentList(params);
	}
	
	
	
}
