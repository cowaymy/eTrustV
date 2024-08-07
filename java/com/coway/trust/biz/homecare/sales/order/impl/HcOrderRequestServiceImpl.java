package com.coway.trust.biz.homecare.sales.order.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderRequestService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.impl.OrderRequestMapper;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.InvStkMovementVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvConfigVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvFilterVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvPeriodVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvSettingVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.StkReturnEntryVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderRequestServiceImpl.java
 * @Description : Homecare Order Request ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
@Service("hcOrderRequestService")
public class HcOrderRequestServiceImpl extends EgovAbstractServiceImpl implements HcOrderRequestService {

	@Resource(name = "orderRequestService")
	private OrderRequestService orderRequestService;

	@Resource(name = "orderRequestMapper")
	private OrderRequestMapper orderRequestMapper;

	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "hcOrderRegisterMapper")
	private HcOrderRegisterMapper hcOrderRegisterMapper;

	@Resource(name = "voucherMapper")
	private VoucherMapper voucherMapper;

	/**
	 * Request Cancel Order
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRequestService#hcRequestCancelOrder(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage hcRequestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		// 대상주문을 취소요청 한다.

	  params.put("cmbFollowUp", 0); // Follow Up only available for HA at the moment

		ReturnMessage rtnMsg = orderRequestService.requestCancelOrder(params, sessionVO);

		// 같이 주문된 주문 건이 있는경우 취소한다.
		String salesAnoOrdId = CommonUtils.nvl(params.get("salesAnoOrdId"));
		String salesOrdCtgryCd = CommonUtils.nvl(params.get("salesOrdCtgryCd"));

		// Mattress 주문이면서 같이 주문된 주문이 있는 경우.
		if(("MAT".equals(salesOrdCtgryCd) || "ACI".equals(salesOrdCtgryCd)) && CommonUtils.isNotEmpty(salesAnoOrdId)) {
			// 유효성 체크
			params.put("salesOrdId", salesAnoOrdId);
			params.put("appTypeId", SalesConstants.APP_TYPE_CODE_ID_AUX);
			ReturnMessage rtnVaild = validOCRStus(params);

			if(CommonUtils.nvl(rtnVaild.getCode()).equals(AppConstants.SUCCESS)) {
				String rtnMessage = CommonUtils.nvl(rtnMsg.getMessage());
				// 같이 주문된 주문 취소요청한다.
				orderRequestService.requestCancelOrder(params, sessionVO);

				rtnMessage = rtnMessage.replaceFirst("<br/>", ", "+ CommonUtils.nvl(params.get("rtnOrderNo") +"<br/>"));
				rtnMessage = CommonUtils.replaceLast(rtnMessage, "<br/>", ", "+ CommonUtils.nvl(params.get("rtnReqNo") +"<br/>"));
				rtnMsg.setMessage(rtnMessage);
			} else {
				throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnVaild.getMessage()));
			}
		}

		return rtnMsg;
	}


	/**
	 * Request Check Validation
	 * @Author KR-SH
	 * @Date 2019. 12. 4.
	 * @param params
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRequestService#validOCRStus(java.util.Map)
	 */
	@Override
	public ReturnMessage validOCRStus(Map<String, Object> params) throws Exception {
		ReturnMessage message = new ReturnMessage();
		int callLogResult = 0;
		String strMsg = "This order [$3] is<br />under progress [$1].<br />OCR is not allowed due to $2 Status still [ACTIVE].<br/>";
		String salesOrdNo = CommonUtils.nvl(params.get("salesOrdNo"));

	    callLogResult = orderRequestMapper.validOCRStus(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	      	message.setMessage(strMsg.replace("$1", "Call for Install").replace("$2", "Installation").replace("$3", salesOrdNo));

	      	return message;
	    }

	    callLogResult = orderRequestMapper.validOCRStus2(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	    	message.setMessage(strMsg.replace("$1", "Call for Install").replace("$2", "Order").replace("$3", salesOrdNo));

	    	return message;
	    }

	    callLogResult = orderRequestMapper.validOCRStus3(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	    	message.setMessage(strMsg.replace("$1", "Call for Cancel").replace("$2", "Cancellation").replace("$3", salesOrdNo));

	    	return message;
	    }

	    callLogResult = orderRequestMapper.validOCRStus4(params);
	    if (callLogResult > 0) {
	    	message.setCode(AppConstants.FAIL);
	    	message.setMessage(strMsg.replace("$1", "Confirm To Cancel").replace("$2", "Cancellation").replace("$3", salesOrdNo));

	    	return message;
	    }

	    message.setCode(AppConstants.SUCCESS);
		return message;
	}


	/**
	 * Homecare Order Request - Transfer Ownership
	 * @Author KR-SH
	 * @Date 2020. 1. 13.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRequestService#hcReqOwnershipTransfer(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage hcReqOwnershipTransfer(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		String rtnMsg = "Order Number : " + CommonUtils.nvl(params.get("salesOrdNo"));

		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);
		String fraOrdId = CommonUtils.nvl(hcOrder.get("anoOrdId"));  // get - Frame Order Id

		// update - Mattress Transfer Ownership
		orderRequestService.requestOwnershipTransfer(params, sessionVO);

		// has Frame Order
		if(!"".equals(fraOrdId)) {
			params.put("salesOrdId", fraOrdId);  // set - Frame Order Id
			params.put("hiddenAppTypeID", SalesConstants.APP_TYPE_CODE_ID_AUX);  // set - Frame App Type Id

		    // update - Frame Transfer Ownership
			orderRequestService.requestOwnershipTransfer(params, sessionVO);
			rtnMsg += ", " + CommonUtils.nvl(hcOrder.get("fraOrdNo"));
		}

		// update HMC0011d
		HcOrderVO hcVO = new HcOrderVO();
		hcVO.setUpdUserId(sessionVO.getUserId());
		hcVO.setCustId(CommonUtils.intNvl(params.get("txtHiddenCustID")));
		hcVO.setOrdSeqNo(CommonUtils.intNvl(hcOrder.get("ordSeqNo")));

		int rtnCnt = hcOrderRegisterMapper.updateHcPreOrder(hcVO);
		if(rtnCnt <= 0) { // not insert
			throw new ApplicationException(AppConstants.FAIL, "Order Status updated Failed.");
		}

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(rtnMsg + "<br/>Ownership successfully transferred.");

		return message;
	}

	/**
	 * Homecare Order Request - Product Exchange
	 * @Author KR-SH
	 * @Date 2020. 1. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRequestService#hcRequestProdExch(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage hcRequestProdExch(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		String rtnMsg = "Order Number : " + CommonUtils.nvl(params.get("salesOrdNo"));

		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);
		int fraOrdId = CommonUtils.intNvl(hcOrder.get("anoOrdId"));  // get - Frame Order Id

		if(params.get("isComToPEX").toString().equals("Y")){
			fraOrdId = 0;
		}
		BigDecimal norAmt1 =  new BigDecimal(CommonUtils.nvl(params.get("orgOrdPrice1")));
		BigDecimal mrhRenAmt1 = new BigDecimal(CommonUtils.nvl(params.get("ordRentalFees1")));
		BigDecimal defRentAmt1 = new BigDecimal(CommonUtils.nvl(params.get("ordRentalFees1")));

		BigDecimal norAmt2 = BigDecimal.ZERO;
		BigDecimal discRntFee2 = BigDecimal.ZERO;

		// has order frame
		if(fraOrdId > 0) {
			discRntFee2 = new BigDecimal(CommonUtils.nvl(params.get("ordRentalFees2")));  // frame rental fee
			norAmt2 = new BigDecimal(CommonUtils.nvl(params.get("orgOrdPrice2")));

			norAmt1 = norAmt1 == null ? BigDecimal.ZERO : norAmt1;

			norAmt2 = new BigDecimal(CommonUtils.nvl(params.get("orgOrdPrice2"))); // frame NOR_AMT
			norAmt2 = norAmt2 == null ? BigDecimal.ZERO : norAmt2;
		}

		// update - Product Exchange
		params.put("cmbOrderProduct", CommonUtils.nvl(params.get("ordProduct1")));      // Product ID
		params.put("ordPriceId", CommonUtils.nvl(params.get("ordPriceId1")));
		params.put("ordPrice", CommonUtils.nvl(params.get("ordPrice1")));
		params.put("ordPv", CommonUtils.nvl(params.get("ordPv1")));
		params.put("ordRentalFees", CommonUtils.nvl(params.get("ordRentalFees1")));
		params.put("cmbPromotion", CommonUtils.nvl(params.get("ordPromo1")));           // Promotion ID
		params.put("promoDiscPeriodTp", CommonUtils.nvl(params.get("promoDiscPeriodTp1")));
		params.put("promoDiscPeriod", CommonUtils.nvl(params.get("promoDiscPeriod1")));
		params.put("orgOrdPrice", CommonUtils.nvl(params.get("orgOrdPrice1")));
		params.put("orgOrdRentalFees", CommonUtils.nvl(params.get("orgOrdRentalFees1")));
		// mattress order (mth_rent_amt, def_rent_amt) + frame order(disc_rnt_fee)
		params.put("mthRentAmt", mrhRenAmt1.add(discRntFee2));
		params.put("defRentAmt", defRentAmt1.add(discRntFee2));
		// mattress order NOR_AMT + frame order NOR_AMT
		params.put("norAmt", norAmt1.add(norAmt2));

		this.saveHcRequestProdExch(params, sessionVO);

		// has Frame Order
		if(fraOrdId > 0) {
			params.put("salesOrdId", fraOrdId);  // set - Frame Order Id
			params.put("appTypeId", SalesConstants.APP_TYPE_CODE_ID_AUX);

			params.put("cmbOrderProduct", CommonUtils.nvl(params.get("ordProduct2")));      // Product ID
			params.put("ordPriceId", CommonUtils.nvl(params.get("ordPriceId2")));
			params.put("ordPrice", CommonUtils.nvl(params.get("ordPrice2")));
			params.put("ordPv", CommonUtils.nvl(params.get("ordPv2")));
			params.put("ordRentalFees", CommonUtils.nvl(params.get("ordRentalFees2")));
			params.put("cmbPromotion", CommonUtils.nvl(params.get("ordPromo2")));           // Promotion ID
			params.put("promoDiscPeriodTp", CommonUtils.nvl(params.get("promoDiscPeriodTp2")));
			params.put("promoDiscPeriod", CommonUtils.nvl(params.get("promoDiscPeriod2")));
			params.put("orgOrdPrice", CommonUtils.nvl(params.get("orgOrdPrice2")));
			params.put("orgOrdRentalFees", CommonUtils.nvl(params.get("orgOrdRentalFees2")));
			// frame order (mth_rent_amt, def_rent_amt) = 0
			params.put("mthRentAmt", BigDecimal.ZERO);
			params.put("defRentAmt", BigDecimal.ZERO);
			// frame order NOR_AMT = 0
			params.put("norAmt", BigDecimal.ZERO);

		    // update - Product Exchange
			this.saveHcRequestProdExch(params, sessionVO);
			rtnMsg += ", " + CommonUtils.nvl(hcOrder.get("fraOrdNo"));
		}

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(rtnMsg + "<br/>Product successfully Exchanged.");

		return message;
	}

	/**
	 * Homecare Order Request Save - Product Exchange
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderRequestService#saveHcRequestProdExch(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public ReturnMessage saveHcRequestProdExch(Map<String, Object> params, SessionVO sessionVO) throws Exception {
	    EgovMap somMap = orderRegisterMapper.selectSalesOrderM(params); // GET SALES ORDER MASTER TABLE DETAILS
	    EgovMap sodMap = orderRequestMapper.selectSalesOrderD(params); // GET SALES ORDER SUB TABLE DETAILS

	    int stusCodeId = CommonUtils.intNvl(somMap.get("stusCodeId")); // GET ORDER STATUS CODE
	    int appTypeId = CommonUtils.intNvl(somMap.get("appTypeId")); // GET ORDER'S APPLICATION TYPE
	    int salesOrdId = CommonUtils.intNvl(params.get("salesOrdId")); // Get sales order id
	    int logUsrId = CommonUtils.intNvl(sessionVO.getUserId()); // Get login User ID
	    String dpCallLogDate = CommonUtils.nvl(params.get("dpCallLogDate"));

	    params.put("stusCodeId", stusCodeId);
	    params.put("appTypeId", appTypeId);
	    params.put("logUsrId", logUsrId);

	    //Voucher Exchange If Any
	  	String existingVoucherCode = CommonUtils.nvl(somMap.get("voucherCode"));
	  	String currentVoucherCode = CommonUtils.nvl(params.get("voucherCode"));
	  	this.voucherExchangeUpdate(existingVoucherCode, currentVoucherCode, somMap.get("salesOrdNo").toString(),sessionVO.getUserId());

	    // ORDER EXCHANGE
	    SalesOrderExchangeVO orderExchangeMasterVO = new SalesOrderExchangeVO();
	    this.preprocSalesOrderExchange(orderExchangeMasterVO, params, somMap, sodMap); // PRE SET DATA

	    // CALL ENTRY
	    CallEntryVO callEntryMasterVO = new CallEntryVO();
	    callEntryMasterVO.setSalesOrdId(salesOrdId);
        callEntryMasterVO.setTypeId(258); // CALL LOG PRODUCT EXCHANGE CODE
        callEntryMasterVO.setStusCodeId(SalesConstants.STATUS_ACTIVE); // 1 - ACTIVE
        callEntryMasterVO.setCrtUserId(logUsrId); // CREATE USER ID
        callEntryMasterVO.setCallDt(dpCallLogDate); // CALL DATE FROM USER
        callEntryMasterVO.setHapyCallerId(0);
        callEntryMasterVO.setUpdUserId(logUsrId); // UPDATE USER ID
        callEntryMasterVO.setOriCallDt(dpCallLogDate); // CALL DATE FROM USER

        CallEntryVO cancCallEntryMasterVO = new CallEntryVO(); // CALL ENTRY
	    CallResultVO cancCallResultDetailsVO = new CallResultVO(); // CALL RESULT
	    InvStkMovementVO stkMovementMasterVO = new InvStkMovementVO(); // STOCK MOVEMENT
	    StkReturnEntryVO stkReturnMasterVO = new StkReturnEntryVO(); // STOCK RETURN
	    SalesOrderMVO salesOrderMVO = new SalesOrderMVO(); // SALES ORDER MASTER
	    SalesOrderDVO salesOrderDVO = new SalesOrderDVO(); // SALES ORDER SUB

	    if (SalesConstants.STATUS_ACTIVE == stusCodeId) { // ACTIVE
	    	  this.preprocCancelCallEntryMaster(cancCallEntryMasterVO, params); // NEW INSTALLATION CALLOG WITH CANCEL STATUS
    	      this.preprocCancelCallResultDetails(cancCallResultDetailsVO, params); // NEW INSTALLATION CALLOG DETIALS WITH CANCEL STATUS

    	      this.preprocSalesOrderM(salesOrderMVO, params); // SALES ORD MASTER
    	      this.preprocSalesOrderD(salesOrderDVO, params); // SALES ORD SUB
	    } else { // COMPLETED
    	      this.preprocStkMovementMaster(stkMovementMasterVO, params); // STOCK MOVEMENT MASTER
    	      this.preprocStkReturnMaster(stkReturnMasterVO, params); // STOCK MOVEMENT SUB
	    }

	    // ORDER LOG LIST
	    SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();
	    this.preprocSalesOrderLog(salesOrderLogVO, params);

	    int callEntryId = 0;
	    int srvConfigId = 0;

	    if (orderExchangeMasterVO.getSoCurStusId() == 24) { // BEFORE INSTALL
    	      params.put("opt", "1"); // TYPE ID - 257 (NEW INSTALLATION) & 258 (PRODUCT EXCHANGE) STATUS - 1(ACTIVE), 19(RECALL), 30(WAITING FOR CANCEL)
    	      EgovMap callEntryMap2 = orderRequestMapper.selectCallEntry(params); // GET LATEST CALLLOG FOR THIS ORDER NUMBER

    	      if (callEntryMap2 != null) {
    	    	  callEntryId = CommonUtils.intNvl(callEntryMap2.get("callEntryId")); // STORE CALL ENTRY ID IF RECORD EXIST
    	      }
	    } else { // AFTER INSTALL
    	      EgovMap lastInstallMap = orderRequestMapper.selecLastInstall(params); // GET LAST INSTALL INFO (COMPLETE)
    	      params.put("opt", "3"); // TYPE ID - 257 (NEW INSTALLATION) & 258 (PRODUCT EXCHANGE) STATUS - 20 (READAY TO INSTALL)
    	      EgovMap callEntryMap3 = orderRequestMapper.selectCallEntry(params); // GET LATEST CALLLOG FOR THIS ORDER NUMBER
    	      EgovMap srvConfingMap = orderRequestMapper.selectSrvConfiguration(params); // GET CONFIG ID OF THIS ORDER NUMBER (MEMBERSHIP)

    	      if(callEntryMap3 != null) {
    	    	  callEntryId = CommonUtils.intNvl(callEntryMap3.get("callEntryId")); // STORE CALL ENTRY ID IF RECORD EXIST
    	      }
    	      if(srvConfingMap != null) {
    	    	  srvConfigId = CommonUtils.intNvl(srvConfingMap.get("srvConfigId"));
    	      }

    	      orderExchangeMasterVO.setSoExchgOldSrvConfigId(srvConfigId); // SET OLD CONFIG ID FROM CURRENT CONFIG ID IF EXIST
    	      orderExchangeMasterVO.setSoExchgNwSrvConfigId(srvConfigId); // SET OLD CONFIG ID TO NEW CONFIG ID FROM CURRENT CONFIG ID IF EXIST
    	      orderExchangeMasterVO.setInstallEntryId(CommonUtils.intNvl(lastInstallMap.get("installEntryId"))); // SET LAST INSTALLATION ENTRY ID
	    }

	    orderExchangeMasterVO.setSoExchgOldCallEntryId(CommonUtils.intNvl(callEntryId)); // SET LATEST CALL ENTRY ID
	    // START INSERT SELAS ORDER EXCHANGE RECORD
	    orderRequestMapper.insertSalesOrderExchange(orderExchangeMasterVO);

	    if (orderExchangeMasterVO.getSoCurStusId() == 24) { // BEFORE INSTALLATION
    	      params.put("callEntryId", orderExchangeMasterVO.getSoExchgOldCallEntryId()); // SET OLD CALL ENTRY ID

    	      EgovMap ccleMap = orderRequestMapper.selectCallEntryByEntryId(params); // GET OLD CALL ENTRY INFO
    	      cancCallResultDetailsVO.setCallEntryId(CommonUtils.intNvl(ccleMap.get("callEntryId")));

    	      orderRegisterMapper.insertCallResult(cancCallResultDetailsVO); // INSERT CALL LOG RESULT

    	      ccleMap.put("stusCodeId", SalesConstants.STATUS_CANCELLED);
    	      ccleMap.put("resultId", cancCallResultDetailsVO.getCallResultId());
    	      ccleMap.put("updUserId", logUsrId);

    	      orderRequestMapper.updateCallEntry2(ccleMap); // UPDATE CALL LOG MASTER'S STATUS AND RESULT ID

    	      // [19/10/2015] MODIFIED BY CHIA
              orderRequestMapper.updateSalesOrderM(salesOrderMVO); // UPDATE SALES ORDER MASTER DATA
              orderRequestMapper.updateSalesOrderD(salesOrderDVO); // UPDATE SALES ORDER DETAILS

	    } else { // AFTER INSTALL CASE
    	      stkMovementMasterVO.setInstallEntryId(orderExchangeMasterVO.getInstallEntryId());
    	      orderRequestMapper.insertInvStkMovement(stkMovementMasterVO); // PRE-INSERT STOCK MOVEMENT RECORD

    	      orderExchangeMasterVO.setSoExchgStkRetMovId(stkMovementMasterVO.getMovId());
    	      orderRequestMapper.updateSoExchgStkRetMovId(orderExchangeMasterVO); // UPDATE PRODUCT EXCHANGE TABLE'S MOVEMENT IS VIA SO_EXCHG_ID(0)**

    	      // GET REQUEST NUMBER
    	      String retNo = orderRegisterMapper.selectDocNo(DocTypeConstants.RET_NO);

    	      stkReturnMasterVO.setRetnNo(retNo);
    	      stkReturnMasterVO.setMovId(stkMovementMasterVO.getMovId()); // 0
    	      stkReturnMasterVO.setRefId(orderExchangeMasterVO.getSoExchgId()); // 0
    	      stkReturnMasterVO.setStockId(orderExchangeMasterVO.getSoExchgOldStkId()); // SET OLD STOCK CODE

    	      // PRE INSERT RECORD TO [LOG0038D - STOCK RETURN MST TBL. ] WITH STATUS 1 ACTIVE
    	      orderRequestMapper.insertStkReturnEntry(stkReturnMasterVO);
    	      // SELECT SERVICE MEMBERSHIP WITH STATUS 1 ACTIVE FROM [SAL0090D - SALES ORDER CONFIGURATION SETTING]
    	      EgovMap buConfigMap = orderRequestMapper.selectSrvConfiguration(params);

    	      // INSERTING LOG HISTORY
    	      if (buConfigMap != null) {
    	    	  	// GET SERV. PERIOD ID FROM [SAL0088D - SALES ORDER WARRANTY PERIOD]
        	        List<EgovMap> buPeriodMap = orderRequestMapper.selectSrvConfigPeriod(buConfigMap);
        	        List<EgovMap> buSettingMap = orderRequestMapper.selectSrvConfigSetting(buConfigMap); // GET SERV. SETTING ID FROM [SAL0089D - SALES ORDER DETAILS SETTING AS HAPPY CALL SETTING]
        	        List<EgovMap> buFilterMap = orderRequestMapper.selectSrvConfigFilter(buConfigMap); // SET ACTIVE FILTER FROM [SAL0087D - SALES ORDER FILTER SETTING]

        	        SalesOrderExchangeBUSrvConfigVO salesOrderExchangeBUSrvConfigVO = new SalesOrderExchangeBUSrvConfigVO();

        	        salesOrderExchangeBUSrvConfigVO.setBuSrvConfigId(0);
        	        salesOrderExchangeBUSrvConfigVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
        	        salesOrderExchangeBUSrvConfigVO.setSrvConfigId(CommonUtils.intNvl(buConfigMap.get("srvConfigId")));

        	        orderRequestMapper.insertSalesOrderExchangeBUSrvConfig(salesOrderExchangeBUSrvConfigVO); // INSERT SALES ORDER EXCHANGE HISTORY LOGS

        	        // INSERT SAL0007D - SALES ORDER WARRANTY PERIOD HISTORY LOG
        	        if (buPeriodMap != null && buPeriodMap.size() > 0) {
        	        	SalesOrderExchangeBUSrvPeriodVO salesOrderExchangeBUSrvPeriodVO = null;

        	        	for (EgovMap eMap : buPeriodMap) {
        	        		salesOrderExchangeBUSrvPeriodVO = new SalesOrderExchangeBUSrvPeriodVO();
        	        		salesOrderExchangeBUSrvPeriodVO.setBuSrvPriodId(0);
        	        		salesOrderExchangeBUSrvPeriodVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
        	        		salesOrderExchangeBUSrvPeriodVO.setSrvPrdId(CommonUtils.intNvl(eMap.get("srvPrdId")));

        	        		orderRequestMapper.insertSalesOrderExchangeBUSrvPeriod(salesOrderExchangeBUSrvPeriodVO);
        	        	}
    	        }

    	        // INSERT SAL0008D - SALES ORDER DETAILS SETTING HISTORY LOG
    	        if (buSettingMap != null && buSettingMap.size() > 0) {
    	        	SalesOrderExchangeBUSrvSettingVO salesOrderExchangeBUSrvSettingVO = null;

    	        	for (EgovMap eMap : buSettingMap) {
    	        		salesOrderExchangeBUSrvSettingVO = new SalesOrderExchangeBUSrvSettingVO();
        	            salesOrderExchangeBUSrvSettingVO.setBuSrvSetngId(0);
        	            salesOrderExchangeBUSrvSettingVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
        	            salesOrderExchangeBUSrvSettingVO.setSrvSettId(CommonUtils.intNvl(eMap.get("srvSettId")));

        	            orderRequestMapper.insertSalesOrderExchangeBUSrvSetting(salesOrderExchangeBUSrvSettingVO);
    	        	}
    	        }

    	        // INSERT SAL0006D - SALES ORDER FILTER HISTORY LOG
    	        if (buFilterMap != null && buFilterMap.size() > 0) {
    	        	SalesOrderExchangeBUSrvFilterVO salesOrderExchangeBUSrvFilterVO = null;

    	          	for (EgovMap eMap : buFilterMap) {
        	            salesOrderExchangeBUSrvFilterVO = new SalesOrderExchangeBUSrvFilterVO();
        	            salesOrderExchangeBUSrvFilterVO.setBuSrvFilterId(0);
        	            salesOrderExchangeBUSrvFilterVO.setSoExchgId(orderExchangeMasterVO.getSoExchgId());
        	            salesOrderExchangeBUSrvFilterVO.setSrvFilterId(CommonUtils.intNvl(eMap.get("srvFilterId")));

        	            orderRequestMapper.insertSalesOrderExchangeBUSrvFilter(salesOrderExchangeBUSrvFilterVO);
    	            }
    	        }
    	    }
	    }

	    callEntryMasterVO.setDocId(orderExchangeMasterVO.getSoExchgId()); // 0
	    orderRegisterMapper.insertCallEntry(callEntryMasterVO); // INSERT NEW RECORD FOR CALL LOG TO [CCR0006D - CALLLOG MASTER TABLE]
	    orderExchangeMasterVO.setSoExchgNwCallEntryId(callEntryMasterVO.getCallEntryId());

	    orderRequestMapper.updateSalesOrderExchangeNwCall(orderExchangeMasterVO); // UPDATE NEW CALL ENTRY ID

	    // INSERT ORDER LOG >> OWNERSHIP TRANSFER REQUEST
	    salesOrderLogVO.setRefId(callEntryMasterVO.getCallEntryId());
	    orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);

	    return message;
	}

	private void preprocSalesOrderExchange(SalesOrderExchangeVO salesOrderExchangeVO, Map<String, Object> params, EgovMap somMap, EgovMap sodMap) {
		int stusCodeId = CommonUtils.intNvl(params.get("stusCodeId"));

		salesOrderExchangeVO.setSoExchgId(0);
	    salesOrderExchangeVO.setSoId(CommonUtils.intNvl(params.get("salesOrdId")));

        salesOrderExchangeVO.setSoExchgTypeId(283); // 283 - PRODUCT EXCHANGE
        salesOrderExchangeVO.setSoExchgStusId(stusCodeId == 4 ? SalesConstants.STATUS_ACTIVE : SalesConstants.STATUS_COMPLETED); // 1 - ACTIVE
        salesOrderExchangeVO.setSoExchgResnId(CommonUtils.intNvl(params.get("cmbReason"))); // USER SELECTED REASON
        salesOrderExchangeVO.setSoCurStusId(stusCodeId == 4 ? 25 : 24); // 24 - BEFORE INSTALL 25 - AFTER INSTALL
        salesOrderExchangeVO.setInstallEntryId(0);
        salesOrderExchangeVO.setSoExchgCrtUserId(CommonUtils.intNvl(params.get("logUsrId"))); // CREATE USER ID
        salesOrderExchangeVO.setSoExchgUpdUserId(CommonUtils.intNvl(params.get("logUsrId"))); // UPDATE USER ID
        salesOrderExchangeVO.setSoExchgStkRetMovId(0);
        salesOrderExchangeVO.setSoExchgRem(CommonUtils.nvl(params.get("txtRemark"))); // REMARK
        salesOrderExchangeVO.setSoExchgUnderFreeAsId(CommonUtils.intNvl(params.get("hiddenFreeASID")));

        int appTypeId = CommonUtils.intNvl(somMap.get("appTypeId"));

        // DATA FOR OLD PRODUCT
        salesOrderExchangeVO.setSoExchgOldAppTypeId(appTypeId); // OLD APPLICATION TYPE - SAME AS PREVIOUS
        salesOrderExchangeVO.setSoExchgOldStkId(CommonUtils.intNvl(sodMap.get("itmStkId"))); // OLD PRODUCT CODE
        salesOrderExchangeVO.setSoExchgOldPromoId(CommonUtils.intNvl(somMap.get("promoId"))); // OLD PROMOTION ID
        salesOrderExchangeVO.setSoExchgOldCallEntryId(0);

        // DATA FOR NEW EXCHANGE PRODUCT
        salesOrderExchangeVO.setSoExchgNwAppTypeId(appTypeId); // NEW APPLICATION TYPE - SAME AS PREVIOUS
        salesOrderExchangeVO.setSoExchgNwStkId(CommonUtils.intNvl(params.get("cmbOrderProduct"))); // NEW SELECTED PRODUCT
        salesOrderExchangeVO.setSoExchgNwPromoId(CommonUtils.intNvl(params.get("cmbPromotion")));
        salesOrderExchangeVO.setSoExchgNwCallEntryId(0);

        int custId = CommonUtils.intNvl(somMap.get("custId"));

        // SALES ORDER EXCHANGE - OLD
        salesOrderExchangeVO.setSoExchgOldPrcId(CommonUtils.intNvl(sodMap.get("itmPrcId")));
        salesOrderExchangeVO.setSoExchgOldPrc(new BigDecimal(CommonUtils.nvl(somMap.get("totAmt"))));
        salesOrderExchangeVO.setSoExchgOldPv(new BigDecimal(CommonUtils.nvl(somMap.get("totPv"))));
	    salesOrderExchangeVO.setSoExchgOldRentAmt(new BigDecimal(CommonUtils.nvl(somMap.get("mthRentAmt"))));
	    salesOrderExchangeVO.setSoExchgOldDefRentAmt(new BigDecimal(CommonUtils.nvl(somMap.get("defRentAmt"))));
	    salesOrderExchangeVO.setSoExchgOldCustId(custId);

	    // SALES ORDER EXCHANGE - NEW
	    salesOrderExchangeVO.setSoExchgNwPrcId(CommonUtils.intNvl(params.get("ordPriceId"))); // NEW PRICE ID
        salesOrderExchangeVO.setSoExchgNwPrc(new BigDecimal(CommonUtils.nvl(params.get("ordPrice")))); // NEW PRICE
        salesOrderExchangeVO.setSoExchgNwPv(new BigDecimal(CommonUtils.nvl(params.get("ordPv")))); // NEW PV
        salesOrderExchangeVO.setSoExchgNwRentAmt(new BigDecimal(CommonUtils.nvl(params.get("mthRentAmt")))); // NEW RENTAL AMOUNT
        salesOrderExchangeVO.setSoExchgNwDefRentAmt(new BigDecimal(CommonUtils.nvl(params.get("defRentAmt"))));
        salesOrderExchangeVO.setSoExchgNwCustId(custId);
	}


	private void preprocSalesOrderLog(SalesOrderLogVO salesOrderLogVO, Map<String, Object> params) {
        salesOrderLogVO.setLogId(0);
        salesOrderLogVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
        salesOrderLogVO.setPrgrsId(11);
        salesOrderLogVO.setRefId(0);
        salesOrderLogVO.setIsLok(SalesConstants.IS_TRUE);
        salesOrderLogVO.setLogCrtUserId(CommonUtils.intNvl(params.get("logUsrId")));
        salesOrderLogVO.setPrgrsId(3);
	}

	private void preprocCancelCallResultDetails(CallResultVO callResultVO, Map<String, Object> params) {
        callResultVO.setCallStusId(SalesConstants.STATUS_CANCELLED); // 10 - CANCEL
        callResultVO.setCallDt(SalesConstants.DEFAULT_DATE); // 01/01/1900
        callResultVO.setCallActnDt(SalesConstants.DEFAULT_DATE); // 01/01/1900
        callResultVO.setCallFdbckId(0);
        callResultVO.setCallCtId(0);
        callResultVO.setCallRem("Call-log cancelled - Product Exchange Requested."); // REMARK
        callResultVO.setCallCrtUserId(CommonUtils.intNvl(params.get("logUsrId")));
        callResultVO.setCallCrtUserIdDept(0);
        callResultVO.setCallHcId(0);
        callResultVO.setCallRosAmt(BigDecimal.ZERO);
        callResultVO.setCallSms(SalesConstants.IS_FALSE);
        callResultVO.setCallSmsRem("");
	}

	private void preprocStkMovementMaster(InvStkMovementVO invStkMovementVO, Map<String, Object> params) {
        invStkMovementVO.setMovId(0);
        invStkMovementVO.setInstallEntryId(0);
        invStkMovementVO.setMovFromLocId(0);
        invStkMovementVO.setMovToLocId(0);
        invStkMovementVO.setMovTypeId(264);
        invStkMovementVO.setMovStusId(SalesConstants.STATUS_ACTIVE);
        invStkMovementVO.setMovCnfm(0);
        invStkMovementVO.setMovCrtUserId(CommonUtils.intNvl(params.get("logUsrId")));
        invStkMovementVO.setMovUpdUserId(CommonUtils.intNvl(params.get("logUsrId")));
        invStkMovementVO.setStkCrdPost(SalesConstants.IS_FALSE);
        invStkMovementVO.setStkCrdPostDt(SalesConstants.DEFAULT_DATE);
        invStkMovementVO.setStkCrdPostToWebOnTm(SalesConstants.IS_FALSE);
	}

	private void preprocStkReturnMaster(StkReturnEntryVO stkReturnEntryVO, Map<String, Object> params) {
        stkReturnEntryVO.setStkRetnId(0);
        stkReturnEntryVO.setRetnNo("");
        stkReturnEntryVO.setStusCodeId(SalesConstants.STATUS_ACTIVE);
        stkReturnEntryVO.setTypeId(297);
        stkReturnEntryVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
        stkReturnEntryVO.setMovId(0);
        stkReturnEntryVO.setCrtUserId(CommonUtils.intNvl(params.get("logUsrId")));
        stkReturnEntryVO.setUpdUserId(CommonUtils.intNvl(params.get("logUsrId")));
        stkReturnEntryVO.setRefId(0);
        stkReturnEntryVO.setStockId(0);
        stkReturnEntryVO.setIsSynch(SalesConstants.IS_FALSE);
        stkReturnEntryVO.setAppDt(SalesConstants.DEFAULT_DATE);
        stkReturnEntryVO.setCtId(0);
        stkReturnEntryVO.setCtGrp("");
        stkReturnEntryVO.setCallEntryId(0);
	}

	private void preprocCancelCallEntryMaster(CallEntryVO callEntryVO, Map<String, Object> params) {
		callEntryVO.setCallEntryId(0);
	    callEntryVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
        callEntryVO.setTypeId(257); // NEW INSTALLATION ORDER
        callEntryVO.setStusCodeId(SalesConstants.STATUS_CANCELLED); // 10 - CANCEL
        callEntryVO.setResultId(0);
        callEntryVO.setDocId(0);
        callEntryVO.setCrtUserId(CommonUtils.intNvl(params.get("logUsrId"))); // CREATE USER ID
        callEntryVO.setCallDt(SalesConstants.DEFAULT_DATE); // 01/01/1900
        callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE); // 0
        callEntryVO.setHapyCallerId(0);
        callEntryVO.setUpdUserId(CommonUtils.intNvl(params.get("logUsrId"))); // UPDATE USER ID
        callEntryVO.setOriCallDt(SalesConstants.DEFAULT_DATE); // 01/01/1900
	}

	private void preprocSalesOrderM(SalesOrderMVO salesOrderMVO, Map<String, Object> params) {
		salesOrderMVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
		salesOrderMVO.setTotAmt(new BigDecimal(CommonUtils.nvl(params.get("ordPrice")))); // NEW PRICE
		salesOrderMVO.setTotPv(new BigDecimal(CommonUtils.nvl(params.get("ordPv")))); // NEW PV
		salesOrderMVO.setMthRentAmt(new BigDecimal(CommonUtils.nvl(params.get("mthRentAmt")))); // NEW MONTHLY RENTAL AMOUNT
		salesOrderMVO.setDefRentAmt(new BigDecimal(CommonUtils.nvl(params.get("defRentAmt"))));
		salesOrderMVO.setPromoId(CommonUtils.intNvl(params.get("cmbPromotion"))); // IF CHECKED, OLD PROMOTION CODE APPLY ELSE NEW PROMOTION USED
		salesOrderMVO.setUpdUserId(CommonUtils.intNvl(params.get("logUsrId")));  // UPDATE USER ID
		salesOrderMVO.setPromoDiscPeriodTp(CommonUtils.intNvl(params.get("promoDiscPeriodTp")));
		salesOrderMVO.setPromoDiscPeriod(CommonUtils.intNvl(params.get("promoDiscPeriod")));
		salesOrderMVO.setNorAmt(new BigDecimal(CommonUtils.nvl(params.get("norAmt"))));
		salesOrderMVO.setNorRntFee(new BigDecimal(CommonUtils.nvl(params.get("orgOrdRentalFees"))));
		salesOrderMVO.setDiscRntFee(new BigDecimal(CommonUtils.nvl(params.get("ordRentalFees"))));
		salesOrderMVO.setVoucherCode(CommonUtils.nvl(params.get("voucherCode")));
	}

	private void preprocSalesOrderD(SalesOrderDVO salesOrderDVO, Map<String, Object> params) {
        salesOrderDVO.setSalesOrdId(CommonUtils.intNvl(params.get("salesOrdId")));
        salesOrderDVO.setItmStkId(CommonUtils.intNvl(params.get("cmbOrderProduct")));
        salesOrderDVO.setItmPrcId(CommonUtils.intNvl(params.get("hiddenPriceID")));
        salesOrderDVO.setItmPrc(new BigDecimal(CommonUtils.nvl(params.get("ordPrice"))));
        salesOrderDVO.setItmPv(new BigDecimal(CommonUtils.nvl(params.get("ordPv"))));
        salesOrderDVO.setUpdUserId(CommonUtils.intNvl(params.get("logUsrId")));
	}

  private void voucherExchangeUpdate(String existingVoucherCode,String currentVoucherCode, String salesOrdNo, int userId){
		if(existingVoucherCode.isEmpty() == false){
			if(existingVoucherCode.equals(currentVoucherCode) == false){
				//UPDATE EXISTING VOUCHER CODE USE TO 0(NOT USED STATE)
				this.updateVoucherUseStatus(existingVoucherCode, 0, salesOrdNo,userId);
			}
		}

		if(currentVoucherCode.isEmpty() == false){
			//UPDATE CURRENT VOUCHER USED TO 1(USED STATE)
			this.updateVoucherUseStatus(currentVoucherCode, 1, salesOrdNo,userId);
		}
  }

    private boolean updateVoucherUseStatus(String voucherCode, int isUsed, String salesOrdNo,int userId){
    Map<String, Object> params = new HashMap<String, Object>();
    params.put("voucherCode", voucherCode);
    params.put("isUsed", isUsed);
    params.put("updBy", userId);
    if(isUsed == 1){
        params.put("salesOrdNo", salesOrdNo);
    }

    voucherMapper.updateVoucherCodeUseStatus(params);
    return true;
    }
}
