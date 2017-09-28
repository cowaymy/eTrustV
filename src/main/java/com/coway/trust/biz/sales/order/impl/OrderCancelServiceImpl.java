package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderCancelService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderCancelService")
public class OrderCancelServiceImpl  extends EgovAbstractServiceImpl implements OrderCancelService{

	private static final Logger logger = LoggerFactory.getLogger(OrderCancelServiceImpl.class);
	
	@Resource(name = "orderCancelMapper")
	private OrderCancelMapper orderCancelMapper;
	
	@Resource(name = "orderSuspensionMapper")
	private OrderSuspensionMapper orderSuspensionMapper;
	
	@Resource(name = "orderInvestMapper")
	private OrderInvestMapper orderInvestMapper;
	
	@Resource(name = "orderExchangeMapper")
	private OrderExchangeMapper orderExchangeMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderCancelVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderCancellationList(Map<String, Object> params) {
		return orderCancelMapper.orderCancellationList(params);
	}
	
	
	/**
	 * DSC BRANCH
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	public List<EgovMap> dscBranch(Map<String, Object> params) {
		return orderCancelMapper.dscBranch(params);
	}
	
	
	@Override
	public EgovMap cancelReqInfo(Map<String, Object> params) {
		
		return orderCancelMapper.cancelReqInfo(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderCancelVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> cancelLogTransctionList(Map<String, Object> params) {
		return orderCancelMapper.cancelLogTransctionList(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderCancelVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> productReturnTransctionList(Map<String, Object> params) {
		return orderCancelMapper.productReturnTransctionList(params);
	}
	
	
	@Override
	public void saveCancel(Map<String, Object> params) {
		
		Map<String, Object> saveParam = new HashMap<String, Object>();
		
		saveParam.put("callEntryId", params.get("paramCallEntryId"));
		saveParam.put("callStusId", params.get("addStatus"));
		saveParam.put("callFdbckId", params.get("cmbFeedbackCd"));
		saveParam.put("callCtId", 0);
		saveParam.put("callRem", params.get("addRem"));
		saveParam.put("callCrtUserId", params.get("userId"));
		saveParam.put("callCrtUserIdDept", 0);
		saveParam.put("callHcId", 0);
		saveParam.put("callRosAmt", 0);
		saveParam.put("callSms", 0);
		saveParam.put("callSmsRem", "");
		
		orderSuspensionMapper.insertCCR0007DSuspend(saveParam);
		
		EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam);
		saveParam.put("resultId", getResultId.get("resultId"));
		
		orderCancelMapper.updateCancelCCR0006D(saveParam);
		
		saveParam.put("soReqId", params.get("paramReqId"));
		orderCancelMapper.updateCancelSAL0020D(saveParam);
		
		saveParam.put("salesOrdId", params.get("paramOrdId"));
		EgovMap getRenSchId = orderInvestMapper.saveCallResultSearchFourth(saveParam);
		saveParam.put("renSchId", getRenSchId.get("renSchId"));
		saveParam.put("rentalSchemeStusId", params.get("addStatus"));
		saveParam.put("rentalSchemeStusId", "REG");
		
//		int success = orderInvestMapper.updateSAL0071D(saveParam);
		orderCancelMapper.updateCancelSAL0071D(saveParam);
//		logger.info("##### reqStageId ###############" +(int)params.get("reqStageId"));
		logger.info("##### reqStageId ###############" +(String)params.get("reqStageId"));
		if((String)params.get("reqStageId") != null && !"".equals((String)params.get("reqStageId")) ){
			int reqStageId = Integer.parseInt((String)params.get("reqStageId"));

			if(reqStageId == 25){
				saveParam.put("prgrsId", 5);
				saveParam.put("isLok", 0);
			}else{
				saveParam.put("prgrsId", 2);
				saveParam.put("isLok", 1);
			}
		}else{
			saveParam.put("prgrsId", 2);
			saveParam.put("isLok", 1);
		}
		
//			EgovMap getRefId = orderExchangeMapper.firstSearchForCancel(saveParam);
//			saveParam.put("refId", getRefId.get("refId"));
			saveParam.put("refId", 0);
			saveParam.put("userId", params.get("userId"));
			
			orderInvestMapper.insertSalesOrdLog(saveParam);
//		 }else{
			 
//		 }
		
		
	}
	
	
	@Override
	public EgovMap ctAssignmentInfo(Map<String, Object> params) {
		
		return orderCancelMapper.ctAssignmentInfo(params);
	}
	
	
	/**
	 * Assign CT  - New Cancellation Log Result
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	public List<EgovMap> selectAssignCT(Map<String, Object> params) {
		return orderCancelMapper.selectAssignCT(params);
	}
	
	
	/**
	 * Assign CT  - New Cancellation Log Result
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	public List<EgovMap> selectFeedback(Map<String, Object> params) {
		return orderCancelMapper.selectFeedback(params);
	}


	@Override
	public void updateCancelSAL0071D(Map<String, Object> params) {
		// TODO Auto-generated method stub
		
	}
}
