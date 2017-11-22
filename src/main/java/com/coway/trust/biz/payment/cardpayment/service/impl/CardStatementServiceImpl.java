package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.cardpayment.service.CardStatementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("cardStatementService")
public class CardStatementServiceImpl extends EgovAbstractServiceImpl implements CardStatementService {

	@Resource(name = "cardStatementMapper")
	private CardStatementMapper cardStatementMapper;
	
	
	/**
	 * Credit Card Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectCardStatementMasterList(Map<String, Object> params) {
		return cardStatementMapper.selectCardStatementMasterList(params);
	}
	
	/**
	 * Credit Card Statement Detail List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectCardStatementDetailList(Map<String, Object> params) {
		return cardStatementMapper.selectCardStatementDetailList(params);
	}
	
	/**
	 * Credit Card Statement Upload
	 * @param params
	 * @return
	 */
	@Override
	public void uploadCardStatement(Map<String, Object> masterParamMap, List<Object> detailParamList){
		
		//Running No 세팅하기		
		masterParamMap.put("crcRunningNo", cardStatementMapper.getCRCStatementRunningNo(masterParamMap));
		
		//Master Data 등록
		cardStatementMapper.insertCardStatementMaster(masterParamMap);		
		
		//Detail Data 등록
    	if (detailParamList.size() > 0) {    		
    		HashMap<String, Object> hm = null;    		
    		for (Object map : detailParamList) {
    			hm = (HashMap<String, Object>) map;      			
    			hm.put("crcStateId", masterParamMap.get("crcStateId"));	//Master 정보 등록시 생성된 key값    			
    			cardStatementMapper.insertCardStatementDetail(hm);
    			
    		}
    	}    	
	}
	
	/**
	 * Credit Statement Confirm Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@Override
	public List<EgovMap> selectCRCConfirmMasterList(Map<String, Object> params) {
		return cardStatementMapper.selectCRCConfirmMasterList(params);
	}
	
	 /**
	 * Credit Card Statement Master Posting 처리
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@Override
    public void postCardStatement(Map<String, Object> param){
		cardStatementMapper.postCardStatement(param);
		
		//Interface Table Insert
		cardStatementMapper.insertCrcStatementITF(param);
	}
	
}
