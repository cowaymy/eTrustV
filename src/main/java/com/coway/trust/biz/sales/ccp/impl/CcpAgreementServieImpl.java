package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.coway.trust.biz.sales.ccp.CcpAgreementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpAgreementService")
public class CcpAgreementServieImpl extends EgovAbstractServiceImpl implements CcpAgreementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpAgreementServieImpl.class);
	
	@Resource(name = "ccpAgreementMapper")
	private CcpAgreementMapper ccpAgreementMapper;
	
	@Override
	public List<EgovMap> selectContactAgreementList(Map<String, Object> params) throws Exception {
		
		if("" != params.get("salesOrdNo") && null != params.get("salesOrdNo")){
			
			List<String> tempList = null;
			
			tempList = ccpAgreementMapper.selectItemBatchNofromSalesOrdNo(params);
			
			if(tempList != null){
					
				params.put("exist", "1");
				params.put("getBatchNoList", tempList);
				
			}else{
				
				params.put("exist", "0");
			}
			
		}
		
		return ccpAgreementMapper.selectContactAgreementList(params);
	}

	
	@Override
	public EgovMap getOrderId(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.getOrderId(params);
	}

	@Override
	public List<EgovMap> selectAfterServiceJsonList(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectAfterServiceJsonList(params);
	}


	@Override
	public List<EgovMap> selectBeforeServiceJsonList(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectBeforeServiceJsonList(params);
	}


	@Override
	public List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectSearchOrderNo(params);
	}


	@Override
	public List<EgovMap> selectSearchMemberCode(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectSearchMemberCode(params);
	}


	@Override
	public EgovMap getMemCodeConfirm(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.getMemCodeConfirm(params);
	}
	
}
