package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.cardpayment.service.CrcReconCRCStateService;
import com.coway.trust.biz.payment.reconciliation.service.impl.CRCStatementMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("crcReconCRCStateService")
public class CrcReconCRCStateServiceImpl extends EgovAbstractServiceImpl implements CrcReconCRCStateService {

	@Resource(name = "crcReconCRCStateMapper")
	private CrcReconCRCStateMapper crcReconCRCStateMapper ;
	
	
	/**
	 * selectCrcStatementMappingList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectCrcStatementMappingList(Map<String, Object> params) {
		return crcReconCRCStateMapper.selectCrcStatementMappingList(params);
	}

	/**
	 * selectCrcKeyInList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectCrcKeyInList(Map<String, Object> params) {
		return crcReconCRCStateMapper.selectCrcKeyInList(params);
	}

	/**
	 * selectCrcStateList
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectCrcStateList(Map<String, Object> params) {
		return crcReconCRCStateMapper.selectCrcStateList(params);
	}

	@Override
	public boolean updCrcReconState(int userId , List<Object> paramList) {
		
    	if (paramList.size() > 0) {    		
    		Map<String, Object> hm = null;
    		//int index = 0;
    		for (Object map : paramList) {
    			hm = (HashMap<String, Object>) map;  
    			hm.put("userId", userId);
    			//hm.put("bankSeq", index+1);
    			crcReconCRCStateMapper.updCrcKeyIn(hm);
    			crcReconCRCStateMapper.updCrcStatement(hm);
    			//crcReconCRCStateMapper.insertCrcStatementITF(hm);
    			//index++;
    		}
    	}
    	
    	return true;
	}
	
}
