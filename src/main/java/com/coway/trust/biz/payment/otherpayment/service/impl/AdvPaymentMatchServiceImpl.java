package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentMatchService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("advPaymentMatchService")
public class AdvPaymentMatchServiceImpl extends EgovAbstractServiceImpl implements AdvPaymentMatchService {

	@Resource(name = "advPaymentMatchMapper")
	private AdvPaymentMatchMapper advPaymentMatchMapper;
	
	@Resource(name = "paymentListMapper")
	private PaymentListMapper paymentListMapper;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdvPaymentMatchServiceImpl.class);
	
	@Override
	public List<EgovMap> selectAdvKeyInList(Map<String, Object> params) {
		return advPaymentMatchMapper.selectAdvKeyInList(params);
	}
	
	@Override
	public List<EgovMap> selectBankStateMatchList(Map<String, Object> params) {
		return advPaymentMatchMapper.selectBankStateMatchList(params);
	}
	
	/**
	 * Advance Payment Matching - Mapping 처리 
	 * @param params
	 * @param model
	 * @return
	 */		
	@Override
	public void saveAdvPaymentMapping(Map<String, Object> params) {
		
		//Group Payment Mapping처리
		advPaymentMatchMapper.mappingAdvGroupPayment(params);
		
		//Bank Statement Mapping 처리
		advPaymentMatchMapper.mappingBankStatementAdv(params);
		
		//Interface 테이블 처리 - Bank Statement 
		
		//Interface 테이블 처리 - Bank Statement Bank Charge 
		
		
	}
	
	 /**
	 * Advance Payment Matching - Reverse 처리 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public EgovMap requestDCFWithAppv(Map<String, Object> params) {
		
		EgovMap returnMap = new EgovMap();
		
		//DCF Request 등록
		paymentListMapper.requestDCF(params);
		
		//Group Payment 정보 수정
		params.put("revStusId", "1");
		paymentListMapper.updateGroupPaymentRevStatus(params);
		
		
		//Approval DCF 처리 프로시저 호출
		params.put("reqNo", params.get("dcfReqId"));
		paymentListMapper.approvalDCF(params);
		
		returnMap.put("returnKey", params.get("dcfReqId"));
		
		return returnMap;
		
		
	}
	
}
