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
	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params) {
		return paymentListMapper.selectPaymentListByGroupSeq(params);
	}
	
	 /**
	 * Payment List - Request DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public EgovMap requestDCF(Map<String, Object> params) {
		
		EgovMap returnMap = new EgovMap();
		
		//DCF Request 등록
		paymentListMapper.requestDCF(params);
		
		//Group Payment 정보 수정
		params.put("revStusId", "1");
		paymentListMapper.updateGroupPaymentRevStatus(params);
		
		returnMap.put("returnKey", params.get("dcfReqId"));
		
		return returnMap;
		
		
	}
	
	/**
	 * Payment List - Request DCF 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */		
	@Override
	public List<EgovMap> selectRequestDCFList(Map<String, Object> params) {
		return paymentListMapper.selectRequestDCFList(params);
	}
	
	
	/**
	 * Payment List - Reject DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public void rejectDCF(Map<String, Object> params) {
		
		//DCF Reject 처리
		params.put("dcfStusId", "6");
		paymentListMapper.updateStatusDCF(params);
		
		//Group Payment 정보 수정
		params.put("revStusId", "6");
		paymentListMapper.updateGroupPaymentRevStatus(params);
		
	}
	
	/**
	 * Payment List - Approval DCF 처리 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public void approvalDCF(Map<String, Object> params) {
		//Approval DCF 처리 프로시저 호출
		paymentListMapper.approvalDCF(params);
	}
	
	
}
