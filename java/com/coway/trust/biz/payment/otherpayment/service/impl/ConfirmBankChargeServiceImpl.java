package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentMatchService;
import com.coway.trust.biz.payment.otherpayment.service.ConfirmBankChargeService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("confirmBankChargeService")
public class ConfirmBankChargeServiceImpl extends EgovAbstractServiceImpl implements ConfirmBankChargeService {

	@Resource(name = "confirmBankChargeMapper")
	private ConfirmBankChargeMapper confirmBankChargeMapper;
	
	@Resource(name = "advPaymentMatchMapper")
	private AdvPaymentMatchMapper advPaymentMatchMapper;
	
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
	 * Advance Payment Matching - Confrim 처리 
	 * @param params
	 * @param model
	 * @return
	 */		
	@Override
	public void saveBankChgConfirm(List<Object> paramList, SessionVO sessionVO) {
		
		//Interface 테이블 처리 - Bank Statement Bank Charge 
		//List<EgovMap> returnList = advPaymentMatchMapper.selectMappedData(params);
		int seq = 0;
		
		if(paramList != null && paramList.size() > 0){
			for(int i = 0 ; i < paramList.size(); i++){
				
				Map<String, Object> ifMap = (Map<String, Object>)paramList.get(i);
				ifMap.put("userId", sessionVO.getUserId());
				
				LOGGER.debug("ifMap============================" + ifMap);
				//Group Payment Mapping처리
				//confirmBankChargeMapper.mappingBankChgGroupPayment(ifMap);
				
				//Bank Statement Mapping 처리
				confirmBankChargeMapper.mappingBankStatementBankChg(ifMap);
				
				//variance
				//ifMap.put("variance", params.get("variance"));
				ifMap.put("bankSeq", seq+1);
				confirmBankChargeMapper.insertConfBankChargeIF(ifMap);
				seq++;
			}
		}
	}
	
}
