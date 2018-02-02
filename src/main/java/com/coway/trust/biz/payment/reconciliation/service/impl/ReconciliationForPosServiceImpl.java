package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.reconciliation.service.ReconciliationForPosService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ReconciliationForPosService")
public class ReconciliationForPosServiceImpl extends EgovAbstractServiceImpl implements ReconciliationForPosService{

	@Resource(name="ReconciliationForPosMapper")
	private ReconciliationForPosMapper rMapper;
	  
	

	@Override
	public List<EgovMap> selectPosKeyInList(Map<String, Object> params) {
		return rMapper.selectPosKeyInList(params);
	}
	
	@Override
	public List<EgovMap> selectBankStateMatchList(Map<String, Object> params) {
		return rMapper.selectBankStateMatchList(params);
	}
	
	
	/**
	 * savePosKeyPaymentMapping  - Mapping 처리 
	 * @param params
	 * @param model
	 * @return
	 */		
	@Override
	@Transactional
	public void savePosKeyPaymentMapping(Map<String, Object> params) {
//		
//		//Group Payment Mapping처리
		rMapper.mappingGroupPayment(params);
		
//		//Bank Statement Mapping 처리
		rMapper.mappingBankStatement(params);
		
		
		//금액이 상일 할경우만 처리 
		if(((String)params.get("isAmtSame")).equals("false")){
			rMapper.insertPosPaymentMatchIF(params);
		}
		
		
	}
	
	
}
