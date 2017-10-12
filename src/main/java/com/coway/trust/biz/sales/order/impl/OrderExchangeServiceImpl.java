package com.coway.trust.biz.sales.order.impl;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderExchangeService;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderExchangeService")
public class OrderExchangeServiceImpl extends EgovAbstractServiceImpl implements OrderExchangeService {
	
	private static final Logger logger = LoggerFactory.getLogger(OrderExchangeServiceImpl.class);
	
	@Resource(name = "orderExchangeMapper")
	private OrderExchangeMapper orderExchangeMapper;
	
	@Resource(name = "orderSuspensionMapper")
	private OrderSuspensionMapper orderSuspensionMapper;
	
	@Resource(name = "orderCancelMapper")
	private OrderCancelMapper orderCancelMapper;
	
	@Resource(name = "orderInvestMapper")
	private OrderInvestMapper orderInvestMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
		
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderExchangeList(Map<String, Object> params) {
		return orderExchangeMapper.orderExchangeList(params); 
	}
	
	
	/**
	 * Exchange Information. - Product Exchange Type
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoProduct(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoProduct(params);
	}


	/**
	 * Exchange Information. - Product Exchange Type
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoOwnershipFr(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoOwnershipFr(params);
	}
	
	
	/**
	 * Exchange Information. - Product Exchange Type
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoOwnershipTo(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoOwnershipTo(params);
	}
	
	
	@Override
	public void saveCancelReq(Map<String, Object> params) {
		
		java.util.Calendar cal = Calendar.getInstance();
		String day = "";
		int yyyy = cal.get(cal.YEAR);
		int month = cal.get(cal.MONTH)+1;
		int date = cal.get(cal.DAY_OF_MONTH);
		day = date +"/"+month+"/"+yyyy;
		
		EgovMap firstSearchForCancel = orderExchangeMapper.firstSearchForCancel(params);
		EgovMap secondSearchForCancel = orderExchangeMapper.secondSearchForCancel(params);
		
		
		logger.info("##### save soExchgId #####" +params.get("soExchgIdDetail"));
		logger.info("##### save soExchgRem #####" +params.get("soExchgRem"));
		logger.info("##### save salesOrderId #####" +params.get("salesOrderId"));
		logger.info("##### save soExchgNwCallEntryId #####" +secondSearchForCancel.get("soExchgNwCallEntryId"));//SO_EXCHG_NW_CALL_ENTRY_ID
		
		int reqStageId = 0;	// before , after install
		if((String)params.get("exchgCurStusId") != null && !"".equals((String)params.get("exchgCurStusId")) ){
			reqStageId = Integer.parseInt((String)params.get("exchgCurStusId"));
		}
		int soExchgTypeId = 0;	// product , ownership, application exchange
		if((String)params.get("initType") != null && !"".equals((String)params.get("initType")) ){
			soExchgTypeId = Integer.parseInt((String)params.get("initType"));
		}
		logger.info("##### save reqStageId #####" +reqStageId);
		
		Map<String, Object> drdExchgMt = new HashMap<String, Object>();
		Map<String, Object> prodParam = new HashMap<String, Object>();
		
		drdExchgMt.put("soExchgUpdUserId", params.get("userId"));
		drdExchgMt.put("callCrtUserId", params.get("userId"));
		drdExchgMt.put("userId", params.get("userId"));
		
		if(soExchgTypeId == 283){	// product
			drdExchgMt.put("soExchgStusId", 10);
			drdExchgMt.put("soExchgRem", "(Product Exchange Request Cancelled) "+params.get("soExchgRem"));
			drdExchgMt.put("soExchgIdDetail", params.get("soExchgIdDetail"));
			orderExchangeMapper.updateStusSAL0004D(drdExchgMt);
			
			drdExchgMt.put("soExchgNwCallEntryId", secondSearchForCancel.get("soExchgNwCallEntryId"));
			int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
			drdExchgMt.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
			drdExchgMt.put("callStusId", 10);
			drdExchgMt.put("callDt", SalesConstants.DEFAULT_DATE);
			drdExchgMt.put("callActnDt", SalesConstants.DEFAULT_DATE);
			drdExchgMt.put("callFdbckId", 0);
			drdExchgMt.put("callCtId", 0);
			drdExchgMt.put("callRem", "(Product Exchange Request Cancelled) "+params.get("soExchgRem"));
			drdExchgMt.put("callCrtUserId", params.get("userId"));
			drdExchgMt.put("callCrtUserIdDept", 0);
			drdExchgMt.put("callHcId", 0);
			drdExchgMt.put("callRosAmt", 0);
			drdExchgMt.put("callSms", 0);
			drdExchgMt.put("callSmsRem", "");
			orderExchangeMapper.insertCCR0007D(drdExchgMt);
			
			if(reqStageId == 25){
				
				EgovMap thirdSearchForCancel = orderExchangeMapper.thirdSearchForCancel(drdExchgMt);	// new
				drdExchgMt.put("resultId", thirdSearchForCancel.get("resultId"));
				drdExchgMt.put("stusCodeId", 10);
				drdExchgMt.put("callEntryId", secondSearchForCancel.get("soExchgNwCallEntryId"));
				orderSuspensionMapper.updateCCR0006DSuspend(drdExchgMt);
				
				drdExchgMt.put("movId", secondSearchForCancel.get("soExchgStkRetMovId"));
				EgovMap invStkMovLOG0013D = orderExchangeMapper.invStkMovLOG0013D(drdExchgMt);
				drdExchgMt.put("movStusId", 10);
				
				orderExchangeMapper.updateExchgLOG0013D(drdExchgMt);
				
				drdExchgMt.put("refId", params.get("soExchgIdDetail"));
				drdExchgMt.put("salesOrderId", params.get("salesOrderId"));
				EgovMap exchangeLOG0038D = orderExchangeMapper.exchangeLOG0038D(drdExchgMt);
				drdExchgMt.put("stkRetnId", exchangeLOG0038D.get("stkRetnId"));
				drdExchgMt.put("stusCodeId", 8);
				orderExchangeMapper.updateExchangeLOG0038D(drdExchgMt);
				
				drdExchgMt.put("salesOrdId", params.get("salesOrderId"));
				drdExchgMt.put("prgrsId", 5);
				drdExchgMt.put("isLok", 0);
				drdExchgMt.put("refId", 0);
				orderInvestMapper.insertSalesOrdLog(drdExchgMt);
			}else{
				
				EgovMap thirdSearchForCancel = orderExchangeMapper.thirdSearchForCancel(drdExchgMt);	// new
				drdExchgMt.put("resultId", thirdSearchForCancel.get("resultId"));
				drdExchgMt.put("soExchgNwCallEntryId", secondSearchForCancel.get("soExchgNwCallEntryId"));
				orderExchangeMapper.updateCCR0006D(drdExchgMt);
				
				drdExchgMt.put("soExchgOldCallEntryId", secondSearchForCancel.get("soExchgOldCallEntryId"));
				EgovMap fourthSearchForCancel = orderExchangeMapper.fourthSearchForCancel(drdExchgMt);	// old
				int getCallEntryIdMaxSeq = orderExchangeMapper.getCallEntryIdMaxSeq();
				drdExchgMt.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
				drdExchgMt.put("salesOrdId", params.get("salesOrderId"));
				drdExchgMt.put("typeId", fourthSearchForCancel.get("typeId"));
				drdExchgMt.put("stusCodeId", 1);
				drdExchgMt.put("resultId", 0);
				drdExchgMt.put("docId", fourthSearchForCancel.get("docId"));
				drdExchgMt.put("isWaitForCancl", 0);
				drdExchgMt.put("hapyCallerId", 0);
				orderExchangeMapper.insertCCR0006D(drdExchgMt);
				
				int getCallResultIdMaxSeq2 = orderExchangeMapper.getCallResultIdMaxSeq();
				drdExchgMt.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq2);
				drdExchgMt.put("soExchgNwCallEntryId", getCallEntryIdMaxSeq);
				drdExchgMt.put("callStusId", 1);
				drdExchgMt.put("callDt", day);
				drdExchgMt.put("callActnDt", SalesConstants.DEFAULT_DATE);
				drdExchgMt.put("callFdbckId", 0);
				drdExchgMt.put("callCtId", 0);
				drdExchgMt.put("callRem", "(Reversal From Product Exchange Request Cancellation) "+params.get("soExchgRem"));
				drdExchgMt.put("callCrtUserId", params.get("userId"));
				drdExchgMt.put("callCrtUserIdDept", 0);
				drdExchgMt.put("callHcId", 0);
				drdExchgMt.put("callRosAmt", 0);
				drdExchgMt.put("callSms", 0);
				drdExchgMt.put("callSmsRem", "");
				orderExchangeMapper.insertCCR0007D(drdExchgMt);
				
				prodParam.put("resultId", getCallResultIdMaxSeq2);
				prodParam.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
				orderExchangeMapper.updateResultIdCCR0006D(prodParam);
				
				drdExchgMt.put("salesOrdId", params.get("salesOrderId"));
				drdExchgMt.put("prgrsId", 2);
				drdExchgMt.put("isLok", 1);
				drdExchgMt.put("refId", getCallEntryIdMaxSeq);
				orderInvestMapper.insertSalesOrdLog(drdExchgMt);
				
			}
			
		}
		
	}
		
}
