package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.coway.trust.biz.payment.common.service.impl.CommonPaymentMapper;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("advPaymentService")
public class AdvPaymentServiceImpl extends EgovAbstractServiceImpl implements AdvPaymentService {

	@Resource(name = "advPaymentMapper")
	private AdvPaymentMapper advPaymentMapper;
	
	@Resource(name = "commonPaymentMapper")
	private CommonPaymentMapper commonPaymentMapper;	

	private static final Logger LOGGER = LoggerFactory.getLogger(AdvPaymentServiceImpl.class);
	
	@Transactional
	public List<EgovMap> saveAdvPayment(Map<String, Object> paramMap, List<Object> paramList) {
		//시퀀스 조회
    	Integer seq = commonPaymentMapper.getPayTempSEQ();
    	
    	//payment 임시정보 등록
    	paramMap.put("seq", seq);
    	
    	if("105".equals(String.valueOf(paramMap.get("keyInPayType"))) || "106".equals(String.valueOf(paramMap.get("keyInPayType")))){
    		advPaymentMapper.insertTmpPaymentInfo(paramMap);
    	}else if("108".equals(String.valueOf(paramMap.get("keyInPayType")))){
    		advPaymentMapper.insertTmpPaymentOnlineInfo(paramMap);
    	}
		
		//billing 임시정보 등록
    	if (paramList.size() > 0) {    		
    		Map<String, Object> hm = null;    		
    		for (Object map : paramList) {
    			hm = (HashMap<String, Object>) map;  
    			hm.put("seq", seq);
    			advPaymentMapper.insertTmpBillingInfo(hm);    			
    		}
    	}
    	
    	//payment 처리 프로시저 호출
    	commonPaymentMapper.processPayment(paramMap);
    	
    	//WOR 번호 조회
    	return commonPaymentMapper.selectProcessPaymentResult(paramMap);
	}
	
}
