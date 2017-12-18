package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentMatchService;
import com.coway.trust.biz.payment.otherpayment.service.ConfirmBankChargeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("confirmBankChargeService")
public class ConfirmBankChargeServiceImpl extends EgovAbstractServiceImpl implements ConfirmBankChargeService {

	@Resource(name = "confirmBankChargeMapper")
	private ConfirmBankChargeMapper confirmBankChargeMapper;
	
	
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ConfirmBankChargeServiceImpl.class);
	
	@Override
	public List<EgovMap> selectNorKeyInList(Map<String, Object> params) {
		return confirmBankChargeMapper.selectNorKeyInList(params);
	}
	
	@Override
	public List<EgovMap> selectBankStateMatchList(Map<String, Object> params) {
		return confirmBankChargeMapper.selectBankStateMatchList(params);
	}
	
	/**
	 * Advance Payment Matching - Mapping 처리 
	 * @param params
	 * @param model
	 * @return
	 */		
	@Override
	public void saveBankChgMapping(Map<String, Object> params) {
		
		//Group Payment Mapping처리
		confirmBankChargeMapper.mappingBankChgGroupPayment(params);
		
		//Bank Statement Mapping 처리
		confirmBankChargeMapper.mappingBankStatementBankChg(params);
		
		
		//Interface 테이블 처리 - Bank Statement Bank Charge 
		
		
	}
	
	
}
