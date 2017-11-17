package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentService;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("advPaymentService")
public class AdvPaymentServiceImpl extends EgovAbstractServiceImpl implements AdvPaymentService {

	@Resource(name = "advPaymentMapper")
	private AdvPaymentMapper advPaymentMapper;
	
	
}
