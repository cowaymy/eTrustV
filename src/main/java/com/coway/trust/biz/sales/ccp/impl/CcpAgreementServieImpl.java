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

	private static final Logger logger = LoggerFactory.getLogger(CcpAgreementServieImpl.class);
	
	@Resource(name = "ccpAgreementMapper")
	private CcpAgreementMapper ccpAgreementMapper;
	
	@Override
	public List<EgovMap> selectContactAgreementList(Map<String, Object> params) {
		
		if("" != params.get("salesOrdNo") && null != params.get("salesOrdNo")){
			
			List<String> tempList = null;
			
			tempList = ccpAgreementMapper.selectItemBatchNofromSalesOrdNo(params);
			
			if(tempList != null){
					
				params.put("exist", "1");
				params.put("getBatchNoList", tempList);
				
			}else{
				logger.info(" ############## 임플 결과 없음 exist 0 처리 ###############");
				params.put("exist", "0");
			}
			
		}
		
		return ccpAgreementMapper.selectContactAgreementList(params);
	}
	
}
