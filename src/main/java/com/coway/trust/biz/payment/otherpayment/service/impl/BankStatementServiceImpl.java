package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("bankStatementService")
public class BankStatementServiceImpl extends EgovAbstractServiceImpl implements BankStatementService {

	@Resource(name = "bankStatementMapper")
	private BankStatementMapper bankStatementMapper;
	
	
	/**
	 * Bank Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectBankStatementMasterList(Map<String, Object> params) {
		return bankStatementMapper.selectBankStatementMasterList(params);
	}
	
	/**
	 * Bank Statement Detail List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectBankStatementDetailList(Map<String, Object> params) {
		return bankStatementMapper.selectBankStatementDetailList(params);
	}
	
	/**
	 * Bank Statement Upload
	 * @param params
	 * @return
	 */
	@Override
	public void uploadBankStatement(Map<String, Object> masterParamMap, List<Object> detailParamList){
		
		//Master Data 등록
		bankStatementMapper.insertBankStatementMaster(masterParamMap);		
		
		//Detail Data 등록
    	if (detailParamList.size() > 0) {    		
    		HashMap<String, Object> hm = null;    		
    		for (Object map : detailParamList) {
    			hm = (HashMap<String, Object>) map;      			
    			hm.put("fBankJrnlId", masterParamMap.get("fBankJrnlId"));	//Master 정보 등록시 생성된 key값    			
    			bankStatementMapper.insertBankStatementDetail(hm);    			
    		}
    	}    	
	}
	
}
