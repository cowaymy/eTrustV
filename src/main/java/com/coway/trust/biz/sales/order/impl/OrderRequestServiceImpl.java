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
import com.coway.trust.biz.sales.order.vo.InvStkMovementVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvConfigVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvFilterVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvPeriodVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvSettingVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;
import com.coway.trust.biz.sales.order.vo.StkReturnEntryVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
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
	public List<EgovMap> selectResnCodeList(Map<String, Object> params) {
		return orderRequestMapper.selectResnCodeList(params);
	}

	@Override
	public EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params) {
		return orderRequestMapper.selectOrderLastRentalBillLedger1(params);
	}
	
	private void preprocSalesOrderExchange(SalesOrderExchangeVO salesOrderExchangeVO, Map<String, Object> params, SessionVO sessionVO) {
		
		salesOrderExchangeVO.setSoExchgId(0);
		salesOrderExchangeVO.setSoId(CommonUtils.intNvl((String)params.get("salesOrdId")));
		salesOrderExchangeVO.setSoExchgTypeId(283);
		salesOrderExchangeVO.setSoExchgStusId(SalesConstants.STATUS_ACTIVE);
		salesOrderExchangeVO.setSoExchgResnId(CommonUtils.intNvl((String)params.get("cmbReason")));
		salesOrderExchangeVO.setSoCurStusId((int)params.get("stusCodeId") == 4 ? 25 :24);
		salesOrderExchangeVO.setInstallEntryId(0);
		salesOrderExchangeVO.setSoExchgOldAppTypeId((int)params.get("appTypeId"));
		salesOrderExchangeVO.setSoExchgNwAppTypeId((int)params.get("appTypeId"));
		salesOrderExchangeVO.setSoExchgOldStkId(CommonUtils.intNvl((String)params.get("hiddenCurrentProductID")));
		salesOrderExchangeVO.setSoExchgNwStkId(CommonUtils.intNvl((String)params.get("cmbOrderProduct")));
		salesOrderExchangeVO.setSoExchgOldPrcId(0);
		salesOrderExchangeVO.setSoExchgNwPrcId(CommonUtils.intNvl((String)params.get("hiddenPriceID")));
		salesOrderExchangeVO.setSoExchgOldPrc(BigDecimal.ZERO);
		salesOrderExchangeVO.setSoExchgNwPrc(new BigDecimal((String)params.get("ordPrice")));
		salesOrderExchangeVO.setSoExchgOldPv(BigDecimal.ZERO);
		salesOrderExchangeVO.setSoExchgNwPv(new BigDecimal((String)params.get("ordPv")));
		salesOrderExchangeVO.setSoExchgOldRentAmt(BigDecimal.ZERO);
		salesOrderExchangeVO.setSoExchgNwRentAmt(new BigDecimal((String)params.get("ordRentalFees")));
		salesOrderExchangeVO.setSoExchgOldPromoId(CommonUtils.intNvl((String)params.get("hiddenCurrentPromotionID")));
		salesOrderExchangeVO.setSoExchgNwPromoId("1".equals((String)params.get("btnCurrentPromo")) ? CommonUtils.intNvl((String)params.get("hiddenCurrentPromotionID"))
				                                                                                   : CommonUtils.intNvl((String)params.get("cmbPromotion")));
		salesOrderExchangeVO.setSoExchgCrtUserId(sessionVO.getUserId());
		salesOrderExchangeVO.setSoExchgUpdUserId(sessionVO.getUserId());
		salesOrderExchangeVO.setSoExchgOldSrvConfigId(0);
		salesOrderExchangeVO.setSoExchgNwSrvConfigId(0);
		salesOrderExchangeVO.setSoExchgOldCallEntryId(0);
		salesOrderExchangeVO.setSoExchgNwCallEntryId(0);
		salesOrderExchangeVO.setSoExchgStkRetMovId(0);
		salesOrderExchangeVO.setSoExchgRem((String)params.get("txtRemark"));
		salesOrderExchangeVO.setSoExchgOldDefRentAmt(BigDecimal.ZERO);
		salesOrderExchangeVO.setSoExchgNwDefRentAmt(new BigDecimal((String)params.get("ordRentalFees")));
		salesOrderExchangeVO.setSoExchgUnderFreeAsId(CommonUtils.intNvl((String)params.get("hiddenFreeASID")));
		salesOrderExchangeVO.setSoExchgOldCustId(0);
		salesOrderExchangeVO.setSoExchgNwCustId(0);
	}
	
    private void preprocStkMovementMaster(InvStkMovementVO invStkMovementVO, Map<String, Object> params, SessionVO sessionVO) {
    	
    	invStkMovementVO.setMovId(0);
    	invStkMovementVO.setInstallEntryId(0);
    	invStkMovementVO.setMovFromLocId(0);
    	invStkMovementVO.setMovToLocId(0);
    	invStkMovementVO.setMovTypeId(264);
    	invStkMovementVO.setMovStusId(SalesConstants.STATUS_ACTIVE);
    	invStkMovementVO.setMovCnfm(0);
    	invStkMovementVO.setMovCrtUserId(sessionVO.getUserId());
    	invStkMovementVO.setMovUpdUserId(sessionVO.getUserId());
    	invStkMovementVO.setStkCrdPost(SalesConstants.IS_FALSE);
    	invStkMovementVO.setStkCrdPostDt(SalesConstants.DEFAULT_DATE);
    	invStkMovementVO.setStkCrdPostToWebOnTm(SalesConstants.IS_FALSE);
    }

    private void preprocStkReturnMaster(StkReturnEntryVO stkReturnEntryVO, Map<String, Object> params, SessionVO sessionVO) {

    	stkReturnEntryVO.setStkRetnId(0);
    	stkReturnEntryVO.setRetnNo("");
    	stkReturnEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    	stkReturnEntryVO.setTypeId(297);
    	stkReturnEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    	stkReturnEntryVO.setMovId(0);
    	stkReturnEntryVO.setCrtUserId(sessionVO.getUserId());
    	stkReturnEntryVO.setUpdUserId(sessionVO.getUserId());
    	stkReturnEntryVO.setRefId(0);
    	stkReturnEntryVO.setStockId(0);
    	stkReturnEntryVO.setIsSynch(SalesConstants.IS_FALSE);
    	stkReturnEntryVO.setAppDt(SalesConstants.DEFAULT_DATE);
    	stkReturnEntryVO.setCtId(0);
    	stkReturnEntryVO.setCtGrp("");;
    	stkReturnEntryVO.setCallEntryId(0);
    }
    
    private void preprocSalesOrderM(SalesOrderMVO salesOrderMVO, Map<String, Object> params, SessionVO sessionVO) {
    	
        salesOrderMVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
        salesOrderMVO.setTotAmt(new BigDecimal((String)params.get("ordPrice")));
        salesOrderMVO.setTotPv(new BigDecimal((String)params.get("ordPv")));
        salesOrderMVO.setMthRentAmt(new BigDecimal((String)params.get("ordRentalFees")));
        salesOrderMVO.setDefRentAmt(new BigDecimal((String)params.get("ordRentalFees")));
        salesOrderMVO.setPromoId("1".equals((String)params.get("btnCurrentPromo")) ? CommonUtils.intNvl((String)params.get("hiddenCurrentPromotionID"))
                																   : CommonUtils.intNvl((String)params.get("cmbPromotion")));
        salesOrderMVO.setUpdUserId(sessionVO.getUserId());
        salesOrderMVO.setPromoDiscPeriodTp(CommonUtils.intNvl((String)params.get("promoDiscPeriodTp")));
        salesOrderMVO.setPromoDiscPeriod(CommonUtils.intNvl((String)params.get("promoDiscPeriod")));
        salesOrderMVO.setNorAmt(new BigDecimal((String)params.get("orgOrdPrice")));
        salesOrderMVO.setNorRntFee(new BigDecimal((String)params.get("orgOrdRentalFees")));
        salesOrderMVO.setDiscRntFee(new BigDecimal((String)params.get("ordRentalFees")));
/*
        SalesOrderM.TotalAmt = double.Parse(txtPrice.Text.Trim());
        SalesOrderM.TotalPV = double.Parse(txtPV.Text.Trim());
        SalesOrderM.MthRentAmt = double.Parse(txtOrderRentalFees.Text.Trim());
        SalesOrderM.DefRentAmt = double.Parse(txtOrderRentalFees.Text.Trim());
        SalesOrderM.PromoID = btnCurrentPromo.Checked ? int.Parse(hiddenCurrentPromotionID.Value) : int.Parse(cmbPromotion.SelectedValue);
*/
    }
    
    private void preprocSalesOrderD(SalesOrderDVO salesOrderDVO, Map<String, Object> params, SessionVO sessionVO) {
    	
    	salesOrderDVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    	salesOrderDVO.setItmStkId(CommonUtils.intNvl((String)params.get("cmbOrderProduct")));
    	salesOrderDVO.setItmPrcId(CommonUtils.intNvl((String)params.get("hiddenPriceID")));
    	salesOrderDVO.setItmPrc(new BigDecimal((String)params.get("ordPrice")));
    	salesOrderDVO.setItmPv(new BigDecimal((String)params.get("ordPv")));
    	salesOrderDVO.setUpdUserId(sessionVO.getUserId());
/*
        OrderID = Request["OrderID"] != null ? Request["OrderID"].ToString() : string.Empty;
        SalesOrderD.SalesOrderID = int.Parse(OrderID);
        SalesOrderD.ItemStkID = int.Parse(cmbOrderProduct.SelectedValue);
        SalesOrderD.ItemPriceID = int.Parse(hiddenPriceID.Value);
        SalesOrderD.ItemPrice = int.Parse(hiddenPriceID.Value);
        SalesOrderD.ItemPV = double.Parse(txtPV.Text.Trim());
        SalesOrderD.Updator = li.UserID;
        SalesOrderD.Updated = DateTime.Now;
*/
    }
    
	@Override
	public ReturnMessage requestProductExchange(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);
		EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
		
		int stusCodeId = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("stusCodeId")));
		int appTypeId  = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("appTypeId")));
		
		params.put("stusCodeId", stusCodeId);
		params.put("appTypeId",  appTypeId);
		
		//ORDER EXCHANGE
		SalesOrderExchangeVO orderExchangeMasterVO = new SalesOrderExchangeVO();		
		this.preprocSalesOrderExchange(orderExchangeMasterVO, params, sessionVO);
		
		//CALL ENTRY
		CallEntryVO callEntryMasterVO = new CallEntryVO();
		this.preprocCallEntryMaster(callEntryMasterVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
		
		//CANCEL CALL ENTRY/RESULT | STOCK MOVEMENT | STOCK RETURN | SALESORDERM | SALESORDERED
		CallEntryVO cancCallEntryMasterVO = new CallEntryVO();
		CallResultVO cancCallResultDetailsVO = new CallResultVO();
		InvStkMovementVO stkMovementMasterVO = new InvStkMovementVO();
		StkReturnEntryVO stkReturnMasterVO = new StkReturnEntryVO();
		SalesOrderMVO salesOrderMVO = new SalesOrderMVO();
		SalesOrderDVO salesOrderDVO = new SalesOrderDVO();
		
		if(SalesConstants.STATUS_ACTIVE == stusCodeId) { //Active
			this.preprocCancelCallEntryMaster(cancCallEntryMasterVO, params, sessionVO);
			this.preprocCancelCallResultDetails(cancCallResultDetailsVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
			
			this.preprocSalesOrderM(salesOrderMVO, params, sessionVO);
			this.preprocSalesOrderD(salesOrderDVO, params, sessionVO);
		}
		else { //Completed
			this.preprocStkMovementMaster(stkMovementMasterVO, params, sessionVO);
			this.preprocStkReturnMaster(stkReturnMasterVO, params, sessionVO);
		}
		
		//ORDER LOG LIST
        SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();        
        this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_PEXC);
		
        //SALES ORDER EXCHANGE
        orderExchangeMasterVO.setSoExchgOldPrcId(CommonUtils.intNvl(String.valueOf((BigDecimal)sodMap.get("itmPrcId"))));
        orderExchangeMasterVO.setSoExchgOldPrc((BigDecimal)somMap.get("totAmt"));
        orderExchangeMasterVO.setSoExchgOldPv((BigDecimal)somMap.get("totPv"));
        orderExchangeMasterVO.setSoExchgOldRentAmt((BigDecimal)somMap.get("mthRentAmt"));
        orderExchangeMasterVO.setSoExchgOldDefRentAmt((BigDecimal)somMap.get("defRentAmt"));
        orderExchangeMasterVO.setSoExchgOldCustId(CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("custId"))));
        orderExchangeMasterVO.setSoExchgNwCustId(CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("custId"))));

        if(orderExchangeMasterVO.getSoCurStusId() == 24) { //BEFORE INSTALL
        	params.put("opt", "2");
        	EgovMap callEntryMap2 = orderRequestMapper.selectCallEntry(params);        	
        	orderExchangeMasterVO.setSoExchgOldCallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)callEntryMap2.get("callEntryId"))));
        }
        else { //AFTER INSTALL
        	EgovMap lastInstallMap = orderRequestMapper.selecLastInstall(params);
        	
        	params.put("opt", "3");
        	EgovMap callEntryMap3 = orderRequestMapper.selectCallEntry(params);
        	
        	EgovMap srvConfingMap = orderRequestMapper.selectSrvConfiguration(params);
        	
        	orderExchangeMasterVO.setSoExchgOldCallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)callEntryMap3.get("callEntryId"))));
        	orderExchangeMasterVO.setSoExchgOldSrvConfigId(CommonUtils.intNvl(String.valueOf((BigDecimal)srvConfingMap.get("srvConfigId"))));
        	orderExchangeMasterVO.setSoExchgNwSrvConfigId(CommonUtils.intNvl(String.valueOf((BigDecimal)srvConfingMap.get("srvConfigId"))));
        	orderExchangeMasterVO.setInstallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)lastInstallMap.get("installEntryId"))));
        }
        
        orderRequestMapper.insertSalesOrderExchange(orderExchangeMasterVO);
        
        if(orderExchangeMasterVO.getSoCurStusId() == 24) {
        	//BEFORE INSTALL CASE
        	params.put("callEntryId", orderExchangeMasterVO.getSoExchgOldCallEntryId());
        	
			EgovMap ccleMap = orderRequestMapper.selectCallEntryByEntryId(params);
			
			cancCallResultDetailsVO.setCallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)ccleMap.get("callEntryId"))));
			
			orderRegisterMapper.insertCallResult(cancCallResultDetailsVO);
			
			ccleMap.put("stusCodeId", cancCallEntryMasterVO.getStusCodeId());
			ccleMap.put("resultId",   cancCallResultDetailsVO.getCallResultId());
			ccleMap.put("updUserId",  cancCallEntryMasterVO.getUpdUserId());
			
			orderRequestMapper.updateCallEntry2(ccleMap);
			
			//modified by chia // 19-10-2015
			orderRequestMapper.updateSalesOrderM(salesOrderMVO);
			
			orderRequestMapper.updateSalesOrderD(salesOrderDVO);
        }
        else {
        	//AFTER INSTALL CASE
        	stkMovementMasterVO.setInstallEntryId(orderExchangeMasterVO.getInstallEntryId());        	
        	orderRequestMapper.insertInvStkMovement(stkMovementMasterVO);
        	
        	orderExchangeMasterVO.setSoExchgStkRetMovId(stkMovementMasterVO.getMovId());
        	orderRequestMapper.updateSoExchgStkRetMovId(orderExchangeMasterVO);
        	
            //GET REQUEST NUMBER
            String retNo = orderRegisterMapper.selectDocNo(DocTypeConstants.RET_NO);
            
            logger.info("!@#### GET NEW RET_NO  :"+retNo);
            
            stkReturnMasterVO.setRetnNo(retNo);
            stkReturnMasterVO.setMovId(stkMovementMasterVO.getMovId());
            stkReturnMasterVO.setRefId(orderExchangeMasterVO.getSoExchgId());
            stkReturnMasterVO.setStockId(orderExchangeMasterVO.getSoExchgOldStkId());
            
            orderRequestMapper.insertStkReturnEntry(stkReturnMasterVO);
            
            EgovMap buConfigMap = orderRequestMapper.selectSrvConfiguration(params);
            
            if(buConfigMap != null) {
            	List<EgovMap> buPeriodMap  = orderRequestMapper.selectSrvConfigPeriod(buConfigMap);
            	List<EgovMap> buSettingMap = orderRequestMapper.selectSrvConfigSetting(buConfigMap);
            	List<EgovMap> buFilterMap  = orderRequestMapper.selectSrvConfigFilter(buConfigMap);
            	
            	SalesOrderExchangeBUSrvConfigVO salesOrderExchangeBUSrvConfigVO = new SalesOrderExchangeBUSrvConfigVO();
            	
            	salesOrderExchangeBUSrvConfigVO.setBuSrvConfigId(0);
            	salesOrderExchangeBUSrvConfigVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            	salesOrderExchangeBUSrvConfigVO.setSrvConfigId(CommonUtils.intNvl(String.valueOf((BigDecimal)buConfigMap.get("srvConfigId"))));
            	
            	orderRequestMapper.insertSalesOrderExchangeBUSrvConfig(salesOrderExchangeBUSrvConfigVO);
            	
            	if(buPeriodMap != null && buPeriodMap.size() > 0) {
            		
            		SalesOrderExchangeBUSrvPeriodVO salesOrderExchangeBUSrvPeriodVO = null;
            		
            		for(EgovMap eMap : buPeriodMap) {
            			salesOrderExchangeBUSrvPeriodVO = new SalesOrderExchangeBUSrvPeriodVO();
            			salesOrderExchangeBUSrvPeriodVO.setBuSrvPriodId(0);
            			salesOrderExchangeBUSrvPeriodVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            			salesOrderExchangeBUSrvPeriodVO.setSrvPrdId(CommonUtils.intNvl(String.valueOf((BigDecimal)eMap.get("srvPrdId"))));
            			
            			orderRequestMapper.insertSalesOrderExchangeBUSrvPeriod(salesOrderExchangeBUSrvPeriodVO);
            		}
            	}
            	
            	if(buSettingMap != null && buSettingMap.size() > 0) {
            		
            		SalesOrderExchangeBUSrvSettingVO salesOrderExchangeBUSrvSettingVO = null;
            		
            		for(EgovMap eMap : buSettingMap) {
            			salesOrderExchangeBUSrvSettingVO = new SalesOrderExchangeBUSrvSettingVO();
            			salesOrderExchangeBUSrvSettingVO.setBuSrvSetngId(0);
            			salesOrderExchangeBUSrvSettingVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            			salesOrderExchangeBUSrvSettingVO.setSrvSettId(CommonUtils.intNvl(String.valueOf((BigDecimal)eMap.get("srvSettId"))));
            			
            			orderRequestMapper.insertSalesOrderExchangeBUSrvSetting(salesOrderExchangeBUSrvSettingVO);
            		}
            	}
            	
            	if(buFilterMap != null && buFilterMap.size() > 0) {
            		
            		SalesOrderExchangeBUSrvFilterVO salesOrderExchangeBUSrvFilterVO = null;
            		
            		for(EgovMap eMap:buFilterMap) {
            			salesOrderExchangeBUSrvFilterVO = new SalesOrderExchangeBUSrvFilterVO();
            			salesOrderExchangeBUSrvFilterVO.setBuSrvFilterId(0);
            			salesOrderExchangeBUSrvFilterVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
            			salesOrderExchangeBUSrvFilterVO.setSrvFilterId(CommonUtils.intNvl(String.valueOf((BigDecimal)eMap.get("srvFilterId"))));
            			
            			orderRequestMapper.insertSalesOrderExchangeBUSrvFilter(salesOrderExchangeBUSrvFilterVO);
            		}
            	}
            }
        }
        
        callEntryMasterVO.setDocId(orderExchangeMasterVO.getSoExchgId());
        orderRegisterMapper.insertCallEntry(callEntryMasterVO);
        
        orderExchangeMasterVO.setSoExchgNwCallEntryId(callEntryMasterVO.getCallEntryId());
        
        //INSERT ORDER LOG >> OWNERSHIP TRANSFER REQUEST
        salesOrderLogVO.setRefId(callEntryMasterVO.getCallEntryId());
        
        orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
        
        String msg = "Order Number : " + (String)somMap.get("salesOrdNo") + "<br/>Product exchange request successfully saved.";

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        //message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        message.setMessage(msg);
        
        return message;
	}
	
	@Override
	public ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		//logger.info("!@###### OrderModifyServiceImpl.updateNric");
		
		EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params);
		EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params);
		
		int stusCodeId = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("stusCodeId")));
		int appTypeId  = CommonUtils.intNvl(String.valueOf((BigDecimal)somMap.get("appTypeId")));
		
        //GET REQUEST NUMBER
        String reqNo = orderRegisterMapper.selectDocNo(DocTypeConstants.CANCEL_REQUEST);
        
        logger.info("!@#### GET NEW REQ_NO  :"+reqNo);
        
        int LatestOrderCallEntryID = 0;
        
        if(SalesConstants.STATUS_ACTIVE == stusCodeId) {
        	//Active
        	params.put("opt", "1");
        	EgovMap callEntryMap1 = orderRequestMapper.selectCallEntry(params);
        	
        	LatestOrderCallEntryID = (int)callEntryMap1.get("callEntryId");
        }
        else {
        	//Complete
        	EgovMap ineMap = orderRequestMapper.selectInstallEntry(params);
        	
        	LatestOrderCallEntryID = CommonUtils.intNvl(String.valueOf((BigDecimal)ineMap.get("callEntryId")));
        }
        
		SalesReqCancelVO salesReqCancelVO = new SalesReqCancelVO();
		CallEntryVO callEntryMasterVO = new CallEntryVO();
		CallResultVO callResultVO = new CallResultVO();
		CallResultVO cancCallResultVO = new CallResultVO();
		
		params.put("stusCodeId", stusCodeId);
		params.put("appTypeId",  appTypeId);
		params.put("callEntryId",  LatestOrderCallEntryID);		
		params.put("tempOrdId",  params.get("salesOrdId"));		
		
		this.preprocSalesReqCancel(salesReqCancelVO, params, sessionVO);
		this.preprocCallEntryMaster(callEntryMasterVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
		this.preprocCallResultDetails(callResultVO, params, sessionVO);
		this.preprocCancelCallResultDetails(cancCallResultVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
		
		salesReqCancelVO.setSoReqPrevCallEntryId(LatestOrderCallEntryID);
		salesReqCancelVO.setSoReqCurStkId(CommonUtils.intNvl(String.valueOf((BigDecimal)sodMap.get("itmStkId"))));
		salesReqCancelVO.setSoReqCurAmt((BigDecimal)somMap.get("totAmt"));
		salesReqCancelVO.setSoReqCurPv((BigDecimal)somMap.get("totPv"));
		salesReqCancelVO.setSoReqCurrAmt((BigDecimal)somMap.get("mthRentAmt"));
		salesReqCancelVO.setSoReqNo(reqNo);
		
		orderRequestMapper.insertSalesReqCancel(salesReqCancelVO);
		
		//PREVIOUS CALL LOG
		if(stusCodeId == SalesConstants.STATUS_ACTIVE) {
			EgovMap ccleMap = orderRequestMapper.selectCallEntryByEntryId(params);
			
			cancCallResultVO.setCallEntryId(CommonUtils.intNvl(String.valueOf((BigDecimal)ccleMap.get("callEntryId"))));
			
			orderRegisterMapper.insertCallResult(cancCallResultVO);
			
			ccleMap.put("stusCodeId", cancCallResultVO.getCallStusId());
			ccleMap.put("resultId",   cancCallResultVO.getCallResultId());
			ccleMap.put("updUserId",  cancCallResultVO.getCallCrtUserId());
			
			orderRequestMapper.updateCallEntry2(ccleMap);
		}
		
		//CANCELLATION CALL LOG
		callEntryMasterVO.setDocId(salesReqCancelVO.getSoReqId());
		
		orderRegisterMapper.insertCallEntry(callEntryMasterVO);
		
		callResultVO.setCallEntryId(callEntryMasterVO.getCallEntryId());
		
		orderRegisterMapper.insertCallResult(callResultVO);
		
		callEntryMasterVO.setResultId(callResultVO.getCallResultId());
		
		orderRequestMapper.updateCallEntry(callEntryMasterVO);
		
        //RENTAL SCHEME
        if(appTypeId == 66) {
        	EgovMap stsMap = ccpCalculateMapper.rentalSchemeStatusByOrdId(params);
        	
        	stsMap.put("stusCodeId", "RET");
        	stsMap.put("isSync", SalesConstants.IS_FALSE);
        	
        	orderRequestMapper.updateRentalScheme(stsMap);
        }
        
        //INSERT ORDER LOG >> CANCELLATION CALL LOG
        SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();
        
        this.preprocSalesOrderLog(salesOrderLogVO, params, sessionVO, SalesConstants.ORDER_REQ_TYPE_CD_CANC);
        
        salesOrderLogVO.setRefId(callEntryMasterVO.getCallEntryId());
        
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
	
	private void preprocSalesOrderLog(SalesOrderLogVO salesOrderLogVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) {
		
		if(SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
    		salesOrderLogVO.setLogId(0);
    		salesOrderLogVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    		salesOrderLogVO.setPrgrsId(11);
    		salesOrderLogVO.setRefId(0);
    		salesOrderLogVO.setIsLok(SalesConstants.IS_TRUE);
    		salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
    		salesOrderLogVO.setLogId(0);
    		salesOrderLogVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    		salesOrderLogVO.setPrgrsId(3);
    		salesOrderLogVO.setRefId(0);
    		salesOrderLogVO.setIsLok(SalesConstants.IS_TRUE);
    		salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());
		}
	}
	
	private void preprocCancelCallResultDetails(CallResultVO callResultVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) {
		
		if(SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
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
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
    		callResultVO.setCallResultId(0);
    		callResultVO.setCallEntryId(0);
    		callResultVO.setCallStusId(SalesConstants.STATUS_CANCELLED);
    		callResultVO.setCallDt(SalesConstants.DEFAULT_DATE);
    		callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
    		callResultVO.setCallFdbckId(0);
    		callResultVO.setCallCtId(0);
    		callResultVO.setCallRem("Call-log cancelled - Product Exchange Requested.");
    		callResultVO.setCallCrtUserId(sessionVO.getUserId());
    		callResultVO.setCallCrtUserIdDept(0);
    		callResultVO.setCallHcId(0);
    		callResultVO.setCallRosAmt(BigDecimal.ZERO);
    		callResultVO.setCallSms(SalesConstants.IS_FALSE);
    		callResultVO.setCallSmsRem("");
		}
	}
	
	private void preprocCallResultDetails(CallResultVO callResultVO, Map<String, Object> params, SessionVO sessionVO) {
		
		callResultVO.setCallResultId(0);
		callResultVO.setCallEntryId(0);
		callResultVO.setCallStusId(SalesConstants.STATUS_ACTIVE);
		callResultVO.setCallDt((String)params.get("dpCallLogDate"));
		callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE);
		callResultVO.setCallFdbckId(CommonUtils.intNvl((String)params.get("cmbReason")));
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
	
	private void preprocCancelCallEntryMaster(CallEntryVO callEntryVO, Map<String, Object> params, SessionVO sessionVO)
    {
		callEntryVO.setCallEntryId(0);
		callEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
		callEntryVO.setTypeId(257);
		callEntryVO.setStusCodeId(SalesConstants.STATUS_CANCELLED);
		callEntryVO.setResultId(0);
		callEntryVO.setDocId(0);
		callEntryVO.setCrtUserId(sessionVO.getUserId());
		callEntryVO.setCallDt(SalesConstants.DEFAULT_DATE);
		callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
		callEntryVO.setHapyCallerId(0);
		callEntryVO.setUpdUserId(sessionVO.getUserId());
		callEntryVO.setOriCallDt(SalesConstants.DEFAULT_DATE);
    }
	
	private void preprocCallEntryMaster(CallEntryVO callEntryVO, Map<String, Object> params, SessionVO sessionVO, String ordReqType) {
		
		if(SalesConstants.ORDER_REQ_TYPE_CD_CANC.equals(ordReqType)) {
    		callEntryVO.setCallEntryId(0);
    		callEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    		callEntryVO.setTypeId(CommonUtils.intNvl(SalesConstants.CALL_ENTRY_TYPE_ID));
    		callEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    		callEntryVO.setResultId(0);
    		callEntryVO.setDocId(0);
    		callEntryVO.setCrtUserId(sessionVO.getUserId());
    		callEntryVO.setCallDt((String)params.get("dpCallLogDate"));
    		callEntryVO.setIsWaitForCancl(SalesConstants.IS_TRUE);
    		callEntryVO.setHapyCallerId(0);
    		callEntryVO.setUpdUserId(sessionVO.getUserId());
    		callEntryVO.setOriCallDt((String)params.get("dpCallLogDate"));
		}
		else if(SalesConstants.ORDER_REQ_TYPE_CD_PEXC.equals(ordReqType)) {
    		callEntryVO.setCallEntryId(0);
    		callEntryVO.setSalesOrdId(CommonUtils.intNvl((String)params.get("salesOrdId")));
    		callEntryVO.setTypeId(258);
    		callEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
    		callEntryVO.setResultId(0);
    		callEntryVO.setDocId(0);
    		callEntryVO.setCrtUserId(sessionVO.getUserId());
    		callEntryVO.setCallDt((String)params.get("dpCallLogDate"));
    		callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
    		callEntryVO.setHapyCallerId(0);
    		callEntryVO.setUpdUserId(sessionVO.getUserId());
    		callEntryVO.setOriCallDt((String)params.get("dpCallLogDate"));
		}
	}
	
	private void preprocSalesReqCancel(SalesReqCancelVO salesReqCancelVO, Map<String, Object> params, SessionVO sessionVO) {

		salesReqCancelVO.setSoReqId(0);
		salesReqCancelVO.setSoReqSoId(CommonUtils.intNvl((String)params.get("salesOrdId")));
		salesReqCancelVO.setSoReqStusId(SalesConstants.STATUS_ACTIVE);
		salesReqCancelVO.setSoReqCurStusId((int)params.get("stusCodeId") == 1 ? 24 :25);
		salesReqCancelVO.setSoReqResnId(CommonUtils.intNvl((String)params.get("cmbReason")));
		salesReqCancelVO.setSoReqPrevCallEntryId(0);
		salesReqCancelVO.setSoReqCurCallEntryId(0);		
		salesReqCancelVO.setSoReqCrtUserId(sessionVO.getUserId());
		salesReqCancelVO.setSoReqUpdUserId(sessionVO.getUserId());
		salesReqCancelVO.setSoReqCurStkId(0);
		salesReqCancelVO.setSoReqCurAppTypeId((int)params.get("appTypeId"));
		salesReqCancelVO.setSoReqCurAmt(BigDecimal.ZERO);
		salesReqCancelVO.setSoReqCurPv(BigDecimal.ZERO);
		salesReqCancelVO.setSoReqCurrAmt(BigDecimal.ZERO);
		salesReqCancelVO.setSoReqActualCanclDt(SalesConstants.DEFAULT_DATE);
		salesReqCancelVO.setSoReqCanclTotOtstnd(new BigDecimal((String)params.get("txtTotalAmount")));
		salesReqCancelVO.setSoReqCanclPnaltyAmt(new BigDecimal((String)params.get("txtPenaltyCharge")));
		salesReqCancelVO.setSoReqCanclObPriod(CommonUtils.intNvl((String)params.get("txtObPeriod")));
		salesReqCancelVO.setSoReqCanclUnderCoolPriod(SalesConstants.IS_FALSE);
		salesReqCancelVO.setSoReqCanclRentalOtstnd(new BigDecimal((String)params.get("txtCurrentOutstanding")));
		salesReqCancelVO.setSoReqCanclTotUsedPriod(CommonUtils.intNvl((String)params.get("txtTotalUseMth")));
		salesReqCancelVO.setSoReqNo("");
		salesReqCancelVO.setSoReqCanclAdjAmt(new BigDecimal((String)params.get("txtPenaltyAdj")));
		salesReqCancelVO.setSoReqster(CommonUtils.intNvl((String)params.get("cmbRequestor")));
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
	
	@Override
	public EgovMap selectCompleteASIDByOrderIDSolutionReason(Map<String, Object> params) {
		return orderRequestMapper.selectCompleteASIDByOrderIDSolutionReason(params);
	}
	
}
