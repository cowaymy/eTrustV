package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.impl.CcpCalculateMapper;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterHistoryVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderRequestService")
public class OrderRequestServiceImpl implements OrderRequestService {

	private static Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "orderRequestMapper")
	private OrderRequestMapper orderRequestMapper;
	
	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;
	
	@Resource(name = "ccpCalculateMapper")
	private CcpCalculateMapper ccpCalculateMapper;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Override
	public List<EgovMap> selectResnCodeList() {
		return orderRequestMapper.selectResnCodeList();
	}

	@Override
	public EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params) {
		return orderRequestMapper.selectOrderLastRentalBillLedger1(params);
	}
	
	@Override
	public ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		//logger.info("!@###### OrderModifyServiceImpl.updateNric");
		
		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);
		EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
		
		int stusCodeId = Integer.parseInt(String.valueOf((BigDecimal)somMap.get("stusCodeId")));
		int appTypeId  = Integer.parseInt(String.valueOf((BigDecimal)somMap.get("appTypeId")));
		
        //GET REQUEST NUMBER
        String reqNo = orderRegisterMapper.selectDocNo(DocTypeConstants.CANCEL_REQUEST);
        
        logger.info("!@#### GET NEW REQ_NO  :"+reqNo);
        
        int LatestOrderCallEntryID = 0;
        
        if(SalesConstants.STATUS_ACTIVE == stusCodeId) {
        	//Active
        	EgovMap cleMap = orderRequestMapper.selectCallEntry(params);
        	
        	LatestOrderCallEntryID = (int)cleMap.get("callEntryId");
        }
        else {
        	//Complete
        	EgovMap ineMap = orderRequestMapper.selectInstallEntry(params);
        	
        	LatestOrderCallEntryID = Integer.parseInt(String.valueOf((BigDecimal)ineMap.get("callEntryId")));
        }
        
		SalesReqCancelVO salesReqCancelVO = new SalesReqCancelVO();
		CallEntryVO callEntryVO = new CallEntryVO();
		CallResultVO callResultVO = new CallResultVO();
		CallResultVO cancCallResultVO = new CallResultVO();
		
		params.put("stusCodeId", stusCodeId);
		params.put("appTypeId",  appTypeId);
		params.put("callEntryId",  LatestOrderCallEntryID);		
		params.put("tempOrdId",  params.get("salesOrdId"));		
		
		this.preprocSalesReqCancel(salesReqCancelVO, params, sessionVO);
		this.preprocCallEntryMaster(callEntryVO, params, sessionVO);
		this.preprocCallResultDetails(callResultVO, params, sessionVO);
		this.preprocCancCallResultDetails(cancCallResultVO, params, sessionVO);
		
		salesReqCancelVO.setSoReqPrevCallEntryId(LatestOrderCallEntryID);
		salesReqCancelVO.setSoReqCurStkId(Integer.parseInt(String.valueOf((BigDecimal)sodMap.get("itmStkId"))));
		salesReqCancelVO.setSoReqCurAmt(Integer.parseInt(String.valueOf((BigDecimal)somMap.get("totAmt"))));
		salesReqCancelVO.setSoReqCurPv(Integer.parseInt(String.valueOf((BigDecimal)somMap.get("totPv"))));
		salesReqCancelVO.setSoReqCurrAmt(Integer.parseInt(String.valueOf((BigDecimal)somMap.get("mthRentAmt"))));
		salesReqCancelVO.setSoReqNo(reqNo);
		
		orderRequestMapper.insertSalesReqCancel(salesReqCancelVO);
		
		//PREVIOUS CALL LOG
		if(stusCodeId == SalesConstants.STATUS_ACTIVE) {
			EgovMap ccleMap = orderRequestMapper.selectCallEntryByEntryId(params);
			
			cancCallResultVO.setCallEntryId(Integer.parseInt(String.valueOf((BigDecimal)ccleMap.get("callEntryId"))));
			
			orderRegisterMapper.insertCallResult(cancCallResultVO);
			
			ccleMap.put("stusCodeId", cancCallResultVO.getCallStusId());
			ccleMap.put("resultId",   cancCallResultVO.getCallResultId());
			ccleMap.put("updUserId",  cancCallResultVO.getCallCrtUserId());
			
			orderRequestMapper.updateCallEntry2(ccleMap);
		}
		
		//CANCELLATION CALL LOG
		callEntryVO.setDocId(salesReqCancelVO.getSoReqId());
		
		orderRegisterMapper.insertCallEntry(callEntryVO);
		
		callResultVO.setCallEntryId(callEntryVO.getCallEntryId());
		
		orderRegisterMapper.insertCallResult(callResultVO);
		
		callEntryVO.setResultId(callResultVO.getCallResultId());
		
		orderRequestMapper.updateCallEntry(callEntryVO);
		
        //RENTAL SCHEME
        if(appTypeId == 66) {
        	EgovMap stsMap = ccpCalculateMapper.rentalSchemeStatusByOrdId(params);
        	
        	stsMap.put("stusCodeId", "RET");
        	stsMap.put("isSync", SalesConstants.IS_FALSE);
        	
        	orderRequestMapper.updateRentalScheme(stsMap);
        }
        
        //INSERT ORDER LOG >> CANCELLATION CALL LOG
        SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();
        
        this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO);
        
        salesOrderLogVO.setRefId(callEntryVO.getCallEntryId());
        
        orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
        
        String msg = "Order Number : " + (String)somMap.get("salesOrdNo")
                   + "<br/>Order cancellation request successfully saved.<br/>" 
        		   + "Request Number : " + reqNo + "<br />";
        
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return message;
	}
	
	private void preprocSalesOrderLog(SalesOrderLogVO salesOrderLogVO, Map<String, Object> params, SessionVO sessionVO) {
		
		salesOrderLogVO.setLogId(0);
		salesOrderLogVO.setSalesOrdId(Integer.parseInt((String)params.get("salesOrdId")));
		salesOrderLogVO.setPrgrsId(11);
		salesOrderLogVO.setRefId(0);
		salesOrderLogVO.setIsLok(SalesConstants.IS_TRUE);
		salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());
/*
        OrderID = Request["OrderID"] != null ? Request["OrderID"].ToString() : string.Empty;

        Data.SalesOrderLog OrderLog_Exchange = new Data.SalesOrderLog();
        OrderLog_Exchange.LogID = 0;
        OrderLog_Exchange.SalesOrderID = int.Parse(OrderID);
        OrderLog_Exchange.ProgressID = 11;
        OrderLog_Exchange.LogDate = DateTime.Now;
        OrderLog_Exchange.RefID = 0; //NEED UPDATE
        OrderLog_Exchange.IsLock = true;
        OrderLog_Exchange.LogCreator = li.UserID;
        OrderLog_Exchange.LogCreated = DateTime.Now;
        OrderLogList.Add(OrderLog_Exchange);

        return OrderLogList;
 */
	}
	
	private void preprocCancCallResultDetails(CallResultVO callResultVO, Map<String, Object> params, SessionVO sessionVO) {
		
		callResultVO.setCallResultId(0);
		callResultVO.setCallEntryId(0);
		callResultVO.setCallStusId(SalesConstants.STATUS_CANCELLED);
		callResultVO.setCallDt(SalesConstants.DEFAULT_DATE);
		callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
		callResultVO.setCallFdbckId(0);
		callResultVO.setCallCtId(0);
		callResultVO.setCallRem("(Call-log cancelled - Order Cancellation Request) "+(String)params.get("txtRemark"));
		callResultVO.setCallCrtUserId(sessionVO.getUserId());
		callResultVO.setCallCrtUserIdDept(0);
		callResultVO.setCallHcId(0);
		callResultVO.setCallRosAmt(BigDecimal.ZERO);
		callResultVO.setCallSms(SalesConstants.IS_FALSE);
		callResultVO.setCallSmsRem("");
/*
        CallResultDetails.CallResultID = 0;
        CallResultDetails.CallEntryID = 0; //NEED UPDATE
        CallResultDetails.CallStatusID = 1;
        CallResultDetails.CallCallDate = dpCallLogDate.SelectedDate;
        CallResultDetails.CallActionDate = defaultDate;
        CallResultDetails.CallFeedBackID = int.Parse(cmbReason.SelectedValue);
        CallResultDetails.CallCTID = 0;
        CallResultDetails.CallRemark = txtRemark.Text.Trim();
        CallResultDetails.CallCreateBy = li.UserID;
        CallResultDetails.CallCreateAt = DateTime.Now;
        CallResultDetails.CallCreateByDept = 0;
        CallResultDetails.CallHCID = 0;
        CallResultDetails.CallROSAmt = 0;
        CallResultDetails.CallSMS = false;
        CallResultDetails.CallSMSRemark = "";
 */
	}
	
	private void preprocCallResultDetails(CallResultVO callResultVO, Map<String, Object> params, SessionVO sessionVO) {
		
		callResultVO.setCallResultId(0);
		callResultVO.setCallEntryId(0);
		callResultVO.setCallStusId(SalesConstants.STATUS_ACTIVE);
		callResultVO.setCallDt((String)params.get("dpCallLogDate"));
		callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
		callResultVO.setCallFdbckId(Integer.parseInt((String)params.get("cmbReason")));
		callResultVO.setCallCtId(0);
		callResultVO.setCallRem((String)params.get("txtRemark"));
		callResultVO.setCallCrtUserId(sessionVO.getUserId());
		callResultVO.setCallCrtUserIdDept(0);
		callResultVO.setCallHcId(0);
		callResultVO.setCallRosAmt(BigDecimal.ZERO);
		callResultVO.setCallSms(SalesConstants.IS_FALSE);
		callResultVO.setCallSmsRem("");
/*
        CallResultDetails.CallResultID = 0;
        CallResultDetails.CallEntryID = 0; //NEED UPDATE
        CallResultDetails.CallStatusID = 1;
        CallResultDetails.CallCallDate = dpCallLogDate.SelectedDate;
        CallResultDetails.CallActionDate = defaultDate;
        CallResultDetails.CallFeedBackID = int.Parse(cmbReason.SelectedValue);
        CallResultDetails.CallCTID = 0;
        CallResultDetails.CallRemark = txtRemark.Text.Trim();
        CallResultDetails.CallCreateBy = li.UserID;
        CallResultDetails.CallCreateAt = DateTime.Now;
        CallResultDetails.CallCreateByDept = 0;
        CallResultDetails.CallHCID = 0;
        CallResultDetails.CallROSAmt = 0;
        CallResultDetails.CallSMS = false;
        CallResultDetails.CallSMSRemark = "";
 */
	}
	
	private void preprocCallEntryMaster(CallEntryVO callEntryVO, Map<String, Object> params, SessionVO sessionVO) {
		
		callEntryVO.setCallEntryId(0);
		callEntryVO.setSalesOrdId(Integer.parseInt((String)params.get("salesOrdId")));
		callEntryVO.setTypeId(Integer.parseInt(SalesConstants.CALL_ENTRY_TYPE_ID));
		callEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
		callEntryVO.setResultId(0);
		callEntryVO.setDocId(0);
		callEntryVO.setCrtUserId(sessionVO.getUserId());
		callEntryVO.setCallDt((String)params.get("dpCallLogDate"));
		callEntryVO.setIsWaitForCancl(SalesConstants.IS_TRUE);
		callEntryVO.setHapyCallerId(0);
		callEntryVO.setUpdUserId(sessionVO.getUserId());
		callEntryVO.setOriCallDt((String)params.get("dpCallLogDate"));
/*
        CallEntryMaster.CallEntryID = 0;
        CallEntryMaster.SalesOrderID = int.Parse(OrderID);
        CallEntryMaster.TypeID = 259;
        CallEntryMaster.StatusCodeID = 1;
        CallEntryMaster.ResultID = 0; //NEED UPDATE
        CallEntryMaster.DocID = 0; //NEED UPDATE
        CallEntryMaster.Created = DateTime.Now;
        CallEntryMaster.Creator = li.UserID;
        CallEntryMaster.CallDate = dpCallLogDate.SelectedDate;
        CallEntryMaster.IsWaitForCancel = true;
        CallEntryMaster.HappyCallerID = 0;
        CallEntryMaster.Updated = DateTime.Now;
        CallEntryMaster.Updator = li.UserID;
        CallEntryMaster.OriCallDate = dpCallLogDate.SelectedDate;
 */
	}
	
	private void preprocSalesReqCancel(SalesReqCancelVO salesReqCancelVO, Map<String, Object> params, SessionVO sessionVO) {

		salesReqCancelVO.setSoReqId(0);
		salesReqCancelVO.setSoReqSoId(Integer.parseInt((String)params.get("salesOrdId")));
		salesReqCancelVO.setSoReqStusId(SalesConstants.STATUS_ACTIVE);
		salesReqCancelVO.setSoReqCurStusId((int)params.get("stusCodeId") == 1 ? 24 :25);
		salesReqCancelVO.setSoReqResnId(Integer.parseInt((String)params.get("cmbReason")));
		salesReqCancelVO.setSoReqPrevCallEntryId(0);
		salesReqCancelVO.setSoReqCurCallEntryId(0);		
		salesReqCancelVO.setSoReqCrtUserId(sessionVO.getUserId());
		salesReqCancelVO.setSoReqUpdUserId(sessionVO.getUserId());
		salesReqCancelVO.setSoReqCurStkId(0);
		salesReqCancelVO.setSoReqCurAppTypeId((int)params.get("appTypeId"));
		salesReqCancelVO.setSoReqCurAmt(0);
		salesReqCancelVO.setSoReqCurPv(0);
		salesReqCancelVO.setSoReqCurrAmt(0);
		salesReqCancelVO.setSoReqActualCanclDt(SalesConstants.DEFAULT_DATE);
		salesReqCancelVO.setSoReqCanclTotOtstnd(new BigDecimal((String)params.get("txtTotalAmount")));
		salesReqCancelVO.setSoReqCanclPnaltyAmt(new BigDecimal((String)params.get("txtPenaltyCharge")));
		salesReqCancelVO.setSoReqCanclObPriod(Integer.parseInt((String)params.get("txtObPeriod")));
		salesReqCancelVO.setSoReqCanclUnderCoolPriod(SalesConstants.IS_FALSE);
		salesReqCancelVO.setSoReqCanclRentalOtstnd(new BigDecimal((String)params.get("txtCurrentOutstanding")));
		salesReqCancelVO.setSoReqCanclTotUsedPriod(Integer.parseInt((String)params.get("txtTotalUseMth")));
		salesReqCancelVO.setSoReqNo("");
		salesReqCancelVO.setSoReqCanclAdjAmt(new BigDecimal((String)params.get("txtPenaltyAdj")));
		salesReqCancelVO.setSoReqster(Integer.parseInt((String)params.get("cmbRequestor")));
		salesReqCancelVO.setSoReqPreRetnDt((int)params.get("stusCodeId") == 4 ? (String)params.get("dpReturnDate") : SalesConstants.DEFAULT_DATE);
		salesReqCancelVO.setSoReqRem((String)params.get("txtRemark"));
/*		
        OrderReqCancelMaster.SOReqID = 0;
        OrderReqCancelMaster.SOReqSOID = int.Parse(OrderID);
        OrderReqCancelMaster.SOReqStatusID = 1;
        OrderReqCancelMaster.SOReqCurStatusID = int.Parse(hiddenOrderStatusID.Value) == 1 ? 24 : 25;
        OrderReqCancelMaster.SOReqReasonID = int.Parse(cmbReason.SelectedValue);
        OrderReqCancelMaster.SOReqPrevCallEntryID = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurCallEntryID = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCreateAt = DateTime.Now;
        OrderReqCancelMaster.SOReqCreateBy = li.UserID;
        OrderReqCancelMaster.SOReqUpdateAt = DateTime.Now;
        OrderReqCancelMaster.SOReqUpdateBy = li.UserID;
        OrderReqCancelMaster.SOReqCurStkID = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurAppTypeID = int.Parse(hiddenAppTypeID.Value);
        OrderReqCancelMaster.SOReqCurAmt = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurPV = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqCurRentAmt = 0; //NEED UPDATE
        OrderReqCancelMaster.SOReqActualCancelDate = defaultDate;
        OrderReqCancelMaster.SOReqCancelTotalOutstanding = double.Parse(txtTotalAmount.Text);
        OrderReqCancelMaster.SOReqCancelPenaltyAmt = double.Parse(txtPenaltyCharge.Text);
        OrderReqCancelMaster.SOReqCancelObPeriod = int.Parse(txtObPeriod.Text);
        OrderReqCancelMaster.SOReqCancelIsUnderCoolPeriod = false;
        OrderReqCancelMaster.SOReqCancelRentalOutstanding = double.Parse(txtCurrentOutstanding.Text);
        OrderReqCancelMaster.SOReqCancelTotalUsedPeriod = int.Parse(txtTotalUseMth.Text);
        OrderReqCancelMaster.SOReqNo = ""; //NEED UPDATE
        OrderReqCancelMaster.SOReqCancelAdjustmentAmt = double.Parse(txtPenaltyAdj.Text);
        OrderReqCancelMaster.SORequestor = int.Parse(cmbRequestor.SelectedValue);
        OrderReqCancelMaster.SOReqPreReturnDate = int.Parse(hiddenOrderStatusID.Value) == 4 ? dpReturnDate.SelectedDate : defaultDate;
        OrderReqCancelMaster.SOReqRemark = txtRemark.Text.Trim();
*/
	}
}
