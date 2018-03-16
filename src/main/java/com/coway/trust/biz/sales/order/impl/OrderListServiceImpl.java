/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.web.sales.order.OrderListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("orderListService")
public class OrderListServiceImpl extends EgovAbstractServiceImpl implements OrderListService {


	private static Logger logger = LoggerFactory.getLogger(OrderListServiceImpl.class);
	
	@Resource(name = "orderListMapper")
	private OrderListMapper orderListMapper;
	
	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;
	
	
//	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return orderListMapper.selectOrderList(params);
	}

	@Override
	public List<EgovMap> getApplicationTypeList(Map<String, Object> params) {
		return orderListMapper.getApplicationTypeList(params);
	}

	@Override
	public List<EgovMap> getUserCodeList() {
		return orderListMapper.getUserCodeList();
	}

	@Override
	public List<EgovMap> getOrgCodeList(Map<String, Object> params) {
		return orderListMapper.getOrgCodeList(params);
	}

	@Override
	public List<EgovMap> getGrpCodeList(Map<String, Object> params) {
		return orderListMapper.getGrpCodeList(params);
	}

	@Override
	public EgovMap getMemberOrgInfo(Map<String, Object> params) {
		return orderListMapper.getMemberOrgInfo(params);
	}

	@Override
	public List<EgovMap> getBankCodeList(Map<String, Object> params) {
		return orderListMapper.getBankCodeList(params);
	}

	@Override
	public EgovMap selectInstallParam(Map<String, Object> params) {
		
		return orderListMapper.selectInstallParam(params);
	}

	@Override
	public List<EgovMap> selectProductReturnView(Map<String, Object> params) {
		
		return orderListMapper.selectProductReturnView(params);
	}

	@Override
	public EgovMap getPReturnParam(Map<String, Object> params) {
	
		return orderListMapper.selectPReturnParam(params);
	}

	@Override
	public EgovMap productReturnResult(Map<String, Object> params) {
		EgovMap  rMp = new EgovMap();
		
    	logger.debug("insert_LOG0039D==>" +params.toString());
    	int  log39cnt  = orderListMapper.insert_LOG0039D(params);
    	logger.debug("log39cnt==>" +log39cnt);
	
	if(log39cnt > 0){
			logger.debug("updateState_LOG0038D / updateState_SAL0001D / insert_SAL0009D ==>" +params.toString());
			int  log38cnt  = orderListMapper.updateState_LOG0038D(params);
			logger.debug("log38cnt==>" +log38cnt);
		
    		int  sal9dcnt  = orderListMapper.insert_SAL0009D(params);
    		logger.debug("sal9dcnt==>" +sal9dcnt);
    		int  sal20dcnt  = orderListMapper.updateState_SAL0020D(params);
    		logger.debug("sal20dcnt==>" +sal20dcnt);
    		int  sal71dcnt  = orderListMapper.updateState_SAL0071D(params);
    		logger.debug("sal71dcnt==>" +sal71dcnt);
		}
	
    	params.put("P_SALES_ORD_NO", params.get("salesOrderNo"));
    	params.put("P_USER_ID",   params.get("stkRetnCrtUserId")); 
    	params.put("P_RETN_NO",  params.get("serviceNo") );
    	orderListMapper.SP_RETURN_BILLING_EARLY_TERMI(params);
		
		int  sal1dcnt  = orderListMapper.updateState_SAL0001D(params);
		logger.debug("sal1dcnt==>" +sal1dcnt);
	
		   //물류 호출   add by hgham
        Map<String, Object>  logPram = null ;
		/////////////////////////물류 호출/////////////////////////
		logPram =new HashMap<String, Object>();
        logPram.put("ORD_ID",   params.get("serviceNo") );
        logPram.put("RETYPE",  "SVO");    
        logPram.put("P_TYPE",  "OD91");   
        logPram.put("P_PRGNM","LOG39");   
        logPram.put("USERID",params.get("stkRetnCrtUserId"));   
        
        logger.debug("productReturnResult 물류  PRAM ===>"+ logPram.toString());
		servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);  
		logger.debug("productReturnResult 물류  결과 ===>" +logPram.toString());
		logPram.put("P_RESULT_TYPE", "PR");
		logPram.put("P_RESULT_MSG", logPram.get("p1"));
        /////////////////////////물류 호출 END //////////////////////   	
		
		rMp.put("SP_MAP", logPram);
	

		return rMp;
	}

	@Override
	public void setPRFailJobRequest(Map<String, Object> params) {
		// TODO Auto-generated method stub
		
		
		logger.debug("setPRFailJobRequest==>" +params.toString());
    	String callEntryID= orderListMapper.select_SeqCCR0006D(params);
		
		params.put("callEntryID", callEntryID);
		
		String callResultID = orderListMapper.select_SeqCCR0007D(params);
		
		params.put("callResultID", callResultID);
		logger.debug("setPRFailJobRequest==>" +params.toString());
		orderListMapper.insert_CCR0006D(params);
		orderListMapper.insert_CCR0007D(params);
	
		int  log38cnt  = orderListMapper.updateFailed_LOG0038D(params);
		int  log39cnt  = orderListMapper.insertFailed_LOG0039D(params);  
		orderListMapper.updateFailed_SAL0020D(params);
		
		logger.debug("log39cnt==>" +log39cnt);
		
		
		
	}

	@Override
	public EgovMap getPrCTInfo(Map<String, Object> params) {

		return orderListMapper.getPrCTInfo(params);
	}
	
	
	
}
