package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.otherpayment.service.PaymentListService;
import com.coway.trust.web.payment.otherpayment.controller.PaymentListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("paymentListService")
public class PaymentListServiceImpl extends EgovAbstractServiceImpl implements PaymentListService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentListServiceImpl.class);

	@Resource(name = "paymentListMapper")
	private PaymentListMapper paymentListMapper;
	
	@Resource(name = "commonPaymentMapper")
	private CommonPaymentMapper commonPaymentMapper;	
	
	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectGroupPaymentList(Map<String, Object> params) {
		return paymentListMapper.selectGroupPaymentList(params);
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
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectRequestDCFByGroupSeq(Map<String, Object> params) {
		return paymentListMapper.selectRequestDCFByGroupSeq(params);
	}
	
	/**
	 * Payment List - Request DCF 정보 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public EgovMap selectReqDcfInfo(Map<String, Object> params) {
		return paymentListMapper.selectReqDcfInfo(params);
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
		paymentListMapper.rejectGroupPaymentRevStatus(params);
		
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
	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectFTOldData(Map<String, Object> params) {
		return paymentListMapper.selectFTOldData(params);
	}
	
	/**
	 * Request Fund Transfer
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
    public EgovMap requestFT(Map<String, Object> paramMap, List<Object> paramList ) {
    	
    	LOGGER.debug("params : {} ", paramMap);
    	
    	//Payment 임시테이블(PAY0240T) 시퀀스 조회
    	Integer seq = commonPaymentMapper.getPayTempSEQ();
    	
    	//payment 임시정보 등록
    	paramMap.put("seq", seq);
    	commonPaymentMapper.insertTmpPaymentInfoFT(paramMap);
		
		//billing 임시정보 등록
    	if (paramList.size() > 0) {    		
    		Map<String, Object> hm = null;    		
    		for (Object map : paramList) {
    			hm = (HashMap<String, Object>) map;  
    			hm.put("seq", seq);
    			commonPaymentMapper.insertTmpBillingInfo(hm);    			
    		}
    	}
    	
    	//Request F/T 정보 등록
    	paymentListMapper.requestFT(paramMap);
    	
    	//Group Payment 정보 수정
    	paramMap.put("ftStusId", "1");
    	paymentListMapper.updateGroupPaymentFTStatus(paramMap);
    			
    	
    	//WOR 번호 조회
    	EgovMap returnMap = new EgovMap();
    	returnMap.put("returnKey", paramMap.get("ftReqId"));
		
		return returnMap;
    	
    }
    
    /**
	 * Payment List - Request FT 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */		
	@Override
	public List<EgovMap> selectRequestFTList(Map<String, Object> params) {
		return paymentListMapper.selectRequestFTList(params);
	}
	
	/**
	 * Payment List - Request FT 상세정보 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
	public EgovMap selectReqFTInfo(Map<String, Object> params) {
		return paymentListMapper.selectReqFTInfo(params);
	}
	
	
	/**
	 * Payment List - Reject FT
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public void rejectFT(Map<String, Object> params) {
		
		//DCF Reject 처리
		params.put("ftStusId", "6");
		paymentListMapper.updateStatusFT(params);
		
		//Group Payment 정보 수정		
    	paymentListMapper.updateGroupPaymentFTStatus(params);
		
	}
	
	/**
	 * Payment List - Approval FT 처리 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public void approvalFT(Map<String, Object> params) {
		//Approval DCF 처리 프로시저 호출
		paymentListMapper.approvalFT(params);
	}
	
	
}
