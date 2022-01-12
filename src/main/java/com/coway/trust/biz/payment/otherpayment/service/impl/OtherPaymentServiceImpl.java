package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;
import com.coway.trust.biz.payment.otherpayment.service.OtherPaymentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("otherPaymentService")
public class OtherPaymentServiceImpl extends EgovAbstractServiceImpl implements OtherPaymentService {

	@Resource(name = "otherPaymentMapper")
	private OtherPaymentMapper otherPaymentMapper;

	@Override
	public List<EgovMap> selectBankStatementList(Map<String, Object> params) {
		return otherPaymentMapper.selectBankStatementList(params);
	}

	@Override
	public EgovMap getMemVaNo(Map<String, Object> params) {

		return otherPaymentMapper.getMemVaNo(params);
	}

}
