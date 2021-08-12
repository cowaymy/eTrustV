package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("bankStatementService")
public class BankStatementServiceImpl extends EgovAbstractServiceImpl implements BankStatementService {

	@Resource(name = "bankStatementMapper")
	private BankStatementMapper bankStatementMapper;
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;
	
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
	public Map<String, Object>  uploadBankStatement(Map<String, Object> masterParamMap, List<Object> detailParamList){
		
		//Master Data 등록
		bankStatementMapper.insertBankStatementMaster(masterParamMap);		
		
		//Detail Data 등록
    	if (detailParamList.size() > 0) {    		
    		HashMap<String, Object> hm = null;
    		EgovMap codeMap = null;
    		masterParamMap.put("accId", masterParamMap.get("uploadIssueBank"));
    		List<EgovMap> accountCodeList = commonMapper.getAccountCodeList(masterParamMap);//Account code 조회
    		codeMap = (EgovMap ) accountCodeList.get(0);
    		for (Object map : detailParamList) {
    			hm = (HashMap<String, Object>) map;      			
    			hm.put("fBankJrnlId", masterParamMap.get("fBankJrnlId"));	//Master 정보 등록시 생성된 key값    			
    			bankStatementMapper.insertBankStatementDetail(hm);   
    			
    			hm.put("uploadIssueBank", masterParamMap.get("uploadIssueBank"));	//Interface 정보 Bank Code
    			hm.put("uploadBankAccount", codeMap.get("accCode"));	//Interface 정보 Bank Account Code
    			
    			//Interface Table Insert
//    			bankStatementMapper.insertBankStatementITF(hm);
    			
    		}
    	}  
    	
    	return masterParamMap;
	}

	@Override
	public boolean deleteBankStatement(List<Object> paramList) {
		boolean result = false;
		
		if (paramList.size() > 0) {    		
    		Map<String, Object> hm = null;    		
    		for (Object map : paramList) {
    			hm = (HashMap<String, Object>) map;  
    			int mstResult = bankStatementMapper.deleteBankStateMaster(hm); 
    			
    			if(mstResult > 0){
    				int dtResult = bankStatementMapper.deleteBankStateDetail(hm);
    				if(dtResult > 0)
    					result = true;
    			}
    		}
    	}
		
		return result;
	}

	@Override
	public boolean updateBankStateDetail(List<Object> paramList) {
		boolean result = false;
		
		if (paramList.size() > 0) {
			Map<String, Object> hm = null;    		
    		for (Object map : paramList) {
    			hm = (HashMap<String, Object>) map;  
    			int updResult = bankStatementMapper.updateBankStateDetail(hm); 
    			result = true;
    		}
		}
		return result;
	}

	/**
	 * Bank Statement Download List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectBankStatementDownloadList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bankStatementMapper.selectBankStatementDownloadList(params);
	}
	
}
