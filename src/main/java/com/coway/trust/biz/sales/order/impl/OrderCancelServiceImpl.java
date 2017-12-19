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
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.web.sales.SalesConstants;

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
		
		Map<String, Object> salesReqCancelParam = new HashMap<String, Object>();
		
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
		saveParam.put("salesOrdId", params.get("paramOrdId"));
		
		
		int status = Integer.parseInt((String)params.get("addStatus"));	// recall, calcel, reversal cancel
		int reqStageId = 0;	// before , after install
		String reqStageIdValue = "";	// RET, CAN
		
		if((String)params.get("reqStageId") != null && !"".equals((String)params.get("reqStageId")) ){
			reqStageId = Integer.parseInt((String)params.get("reqStageId"));
		}
		saveParam.put("reqStageId", reqStageId);
		
		if(status == 19){	// status : Recall
			logger.info("####################### Recall save Start!! #####################");
			
			saveParam.put("callDt", params.get("addCallRecallDt"));
			saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			orderSuspensionMapper.insertCCR0007DSuspend(saveParam);
			
			EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam);
			saveParam.put("resultId", getResultId.get("resultId"));
			orderCancelMapper.updateCancelCCR0006D(saveParam);
			
			saveParam.put("soReqId", params.get("paramReqId"));
			orderCancelMapper.updateCancelSAL0020D(saveParam);
			
			logger.info("####################### Recall save End!! #####################");
		} else if(status == 32){	// Confirm To Cancel
			logger.info("####################### Confirm To Cancel save Start!! #####################");
			saveParam.put("userId", params.get("userId"));
			EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam);		// CallEntry
			saveParam.put("resultId", getResultId.get("resultId"));
			
			saveParam.put("callDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			orderSuspensionMapper.insertCCR0007DSuspend(saveParam);									// CallResult
			orderCancelMapper.updateCancelCCR0006D(saveParam);											// CallEntry
				
			saveParam.put("soReqId", params.get("paramReqId"));
			orderCancelMapper.updateCancelSAL0020D(saveParam);											// SalesReqCancel
			
			EgovMap salesReqCancel = orderCancelMapper.newSearchCancelSAL0020D(saveParam);
			
			if(reqStageId == 25){
				salesReqCancelParam.put("callEntryId", salesReqCancel.get("soReqPrevCallEntryId"));
				EgovMap installEntry = orderCancelMapper.newSearchCancelSAL0046D(salesReqCancelParam);
				String getMovId = orderCancelMapper.crtSeqLOG0031D();
				String getStkRetnId = orderCancelMapper.crtSeqLOG0038D();
				saveParam.put("installEntryId", installEntry.get("installEntryId"));
				saveParam.put("movId", getMovId);
				saveParam.put("movFromLocId", 0);
				saveParam.put("movToLocId", 0);
				saveParam.put("movTypeId", 265);
				saveParam.put("movStusId", 1);
				saveParam.put("movCnfm", 0);
				saveParam.put("stkCrdPost", 0);
				saveParam.put("stkCrdPostDt", SalesConstants.DEFAULT_DATE);
				saveParam.put("stkCrdPostToWebOnTm", 0);
				orderCancelMapper.insertCancelLOG0013D(saveParam);
				
				saveParam.put("docNoId", 30);
				String getDocId = orderInvestMapper.getDocNo(saveParam);
				
				saveParam.put("stusCodeId", 1);
				saveParam.put("typeId", 296);
				
				saveParam.put("movId", getMovId);
				saveParam.put("refId", params.get("paramReqId"));
				saveParam.put("stockId", params.get("paramStockId"));
				
				saveParam.put("isSynch", 0);
				saveParam.put("retnNo", getDocId);
				saveParam.put("appDt", params.get("addAppRetnDt"));
				saveParam.put("ctId", params.get("cmbAssignCt"));
				saveParam.put("ctGrp", params.get("cmbCtGroup"));
				String stkRetnIdSeq = orderCancelMapper.crtSeqLOG0038D();
				saveParam.put("stkRetnId", stkRetnIdSeq);
				orderCancelMapper.insertCancelLOG0038D(saveParam);
			}else{
				EgovMap searchSAL0001D = orderCancelMapper.newSearchCancelSAL0001D(saveParam);	// SalesOrderM
				orderCancelMapper.updateCancelSAL0001D(saveParam);											// SalesOrderM
				
				EgovMap getRenSchId = orderInvestMapper.saveCallResultSearchFourth(saveParam);	// RentalScheme
				saveParam.put("renSchId", getRenSchId.get("renSchId"));
				if(reqStageId == 25){	// after installation
					reqStageIdValue = "RET";
				}else{
					reqStageIdValue = "CAN";
				}
				saveParam.put("rentalSchemeStusId", reqStageIdValue);
				orderCancelMapper.updateCancelSAL0071D(saveParam);											// RentalScheme
			}
			
			if(reqStageId == 25){
				saveParam.put("prgrsId", 12);
				saveParam.put("isLok", 1);
			}else{
				saveParam.put("prgrsId", 13);
				saveParam.put("isLok", 0);
			}
			saveParam.put("refId", 0);
			
			orderInvestMapper.insertSalesOrdLog(saveParam);													// SalesOrderLog
			logger.info("####################### Confirm To Cancel save END!! #####################");
			
			
		}else if(status == 31){	// Reversal Of Cancellation 
			logger.info("####################### Reversal Of Cancellation save Start!! #####################");
			//해야함
			if(reqStageId == 24){
				saveParam.put("callDt", params.get("addCallRecallDt"));
				saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			}
			
			orderSuspensionMapper.insertCCR0007DSuspend(saveParam);
			
			EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam);
			saveParam.put("resultId", getResultId.get("resultId"));
			
			orderCancelMapper.updateCancelCCR0006D(saveParam);
			
			saveParam.put("soReqId", params.get("paramReqId"));
			orderCancelMapper.updReservalCancelSAL0020D(saveParam);
			
			if(reqStageId == 24){
			
    			int getCallEntryIdMaxSeq = orderExchangeMapper.getCallEntryIdMaxSeq();
    			saveParam.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
    			saveParam.put("salesOrdId", params.get("paramOrdId"));
    			EgovMap getSOReqPrevCallEntryID = orderCancelMapper.newSearchCancelSAL0020D(saveParam);
    			logger.info("#####--------------------- callEntryId ###############" +getSOReqPrevCallEntryID.get("soReqPrevCallEntryId"));
    			saveParam.put("callEntryId", getSOReqPrevCallEntryID.get("soReqPrevCallEntryId"));
    			EgovMap getTypeId = orderSuspensionMapper.newSuspendSearch2(saveParam);
    			saveParam.put("typeId", getTypeId.get("typeId"));
    			saveParam.put("stusCodeId", 1);
    			saveParam.put("resultId", 0);
    			saveParam.put("docId", params.get("paramOrdId"));
    			saveParam.put("isWaitForCancl", 0);
    			saveParam.put("hapyCallerId", 0);
    			orderCancelMapper.insertCancelCCR0006D(saveParam);
    			
    			saveParam.put("soExchgNwCallEntryId", getCallEntryIdMaxSeq);
    			int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
    			saveParam.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
    			saveParam.put("callStusId", 1);
    			saveParam.put("callCtId", 0);
    			orderExchangeMapper.insertCCR0007D(saveParam);
			
    			saveParam.put("resultId", getCallResultIdMaxSeq);
    			orderExchangeMapper.updateResultIdCCR0006D(saveParam);
    			
    			
    			EgovMap getRenSchId = orderInvestMapper.saveCallResultSearchFourth(saveParam);
    			saveParam.put("renSchId", getRenSchId.get("renSchId"));
    			if(reqStageId == 24){
    				saveParam.put("rentalSchemeStusId", "ACT");
    			}else{
    				saveParam.put("rentalSchemeStusId", "REG");
    			}
    			
    			orderCancelMapper.updateCancelSAL0071D(saveParam);
    			logger.info("##### reqStageId ###############" +(String)params.get("reqStageId"));
			}

			saveParam.put("salesOrderId", params.get("paramOrdId"));
			EgovMap getRefId = orderExchangeMapper.firstSearchForCancel(saveParam);
			if(reqStageId == 25){
				saveParam.put("prgrsId", 5);
				saveParam.put("isLok", 0);
				saveParam.put("refId", 0);
			}else{
				saveParam.put("prgrsId", 2);
				saveParam.put("isLok", 1);
				saveParam.put("refId", getRefId.get("refId"));
			}
			saveParam.put("userId", params.get("userId"));
			
			orderInvestMapper.insertSalesOrdLog(saveParam);
		}

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
	
	
	@Override
	public void saveCtAssignment(Map<String, Object> params) {
		
//		Map<String, Object> saveParam = new HashMap<String, Object>();
		
		String crtSeqLOG0037D = orderCancelMapper.crtSeqLOG0037D();
		params.put("crtSeqLOG0037D", crtSeqLOG0037D);
		orderCancelMapper.insertCancelLOG0037D(params);
		
		orderCancelMapper.cancelCtLOG0038D(params);
		
		orderCancelMapper.updateCancelLOG0038D(params);
		
	}
	
	
	public List<EgovMap> ctAssignBulkList(Map<String, Object> params) {
		return orderCancelMapper.ctAssignBulkList(params);
	}
	
	@Override
	@Transactional
	public int saveCancelBulk(Map<String, Object> params){
		
//		GridDataSet<OrderCancelCtBulkMVO> bulkDataSetList = ctbulkvo.getBulkDataSetList();
		
//		List<OrderCancelCtBulkMVO> updateList = bulkDataSetList.getRemove();
		List<Object> updList = (List<Object>)params.get("saveList");
		int dataCnt = 0;
		
		// insert & update data
		for(int i=0; i<updList.size(); i++){
			Map<String, Object> addMap = (Map<String, Object>)updList.get(i);
			// insert data
			addMap.put("userId", params.get("userId"));
			orderCancelMapper.insertBulkLOG0037D(addMap);
			// update data
			orderCancelMapper.updateBulkLOG0038D(addMap);
			
			dataCnt++;
		}
		
		return dataCnt;
	}
	
}
