package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.cardpayment.service.CrcReconCRCStateService;
import com.coway.trust.biz.payment.reconciliation.service.impl.AccountReconciliationServiceImpl;
import com.coway.trust.biz.payment.reconciliation.service.impl.CRCStatementMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("crcReconCRCStateService")
public class CrcReconCRCStateServiceImpl extends EgovAbstractServiceImpl implements CrcReconCRCStateService {

	@Resource(name = "crcReconCRCStateMapper")
	private CrcReconCRCStateMapper crcReconCRCStateMapper ;
	private static final Logger logger = LoggerFactory.getLogger(AccountReconciliationServiceImpl.class);

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
		boolean isSucess = false;

    	if (paramList.size() > 0) {
    		Map<String, Object> hm = null;
    		Map<String, Object> orNoMap = null;
    		for (Object map : paramList) {
    			hm = (HashMap<String, Object>) map;
    			hm.put("userId", userId);

    			List<EgovMap> orNoList = crcReconCRCStateMapper.selectCrcKeyInOrNoList(hm);
    			for(int i = 0 ; i < orNoList.size() ; i++){
					orNoMap = (Map<String, Object>)orNoList.get(i);
					hm.put("bankSeq", i+1);
        			hm.put("ordNo", orNoMap.get("ordNo"));
        			hm.put("orNo", orNoMap.get("orNo"));
        			hm.put("amount", orNoMap.get("payAmt"));
        			crcReconCRCStateMapper.insertCrcStatementITF(hm);
    			}
    			crcReconCRCStateMapper.updCrcKeyIn(hm);
    			crcReconCRCStateMapper.updCrcStatement(hm);

    		}
    		isSucess = true;
    	}
    	return isSucess;

	}

	@Override
	public void updIncomeCrcStatement(Map<String, Object> params) {
		crcReconCRCStateMapper.updCrcStatement(params);

		if("INC".equals(params.get("action"))) {
		    crcReconCRCStateMapper.updIncomeCrcStatementIF(params);
		}
	}
}
