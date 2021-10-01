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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
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

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  // @Autowired
  // private MessageSourceAccessor messageSourceAccessor;

  @Override
  public List<EgovMap> selectOrderList(Map<String, Object> params) {
    return orderListMapper.selectOrderList(params);
  }

  @Override
  public List<EgovMap> selectOrderListVRescue(Map<String, Object> params) {
    return orderListMapper.selectOrderListVRescue(params);
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

    EgovMap rMp = new EgovMap();

    logger.debug("insert_LOG0039D==>" + params.toString());
    int log39cnt = orderListMapper.insert_LOG0039D(params);
    logger.debug("log39cnt==>" + log39cnt);

    if (log39cnt > 0) {
      logger.debug("updateState_LOG0038D / updateState_SAL0001D / insert_SAL0009D ==>" + params.toString());
      int log38cnt = orderListMapper.updateState_LOG0038D(params);
      logger.debug("log38cnt==>" + log38cnt);

      int sal9dcnt = orderListMapper.insert_SAL0009D(params);
      logger.debug("sal9dcnt==>" + sal9dcnt);
      int sal20dcnt = orderListMapper.updateState_SAL0020D(params);
      logger.debug("sal20dcnt==>" + sal20dcnt);
      int sal71dcnt = orderListMapper.updateState_SAL0071D(params);
      logger.debug("sal71dcnt==>" + sal71dcnt);

      if(params.get("stkRetnResnId").toString() != "1993"){
        int sal299dcnt = orderListMapper.insert_SAL0299D(params);
        logger.debug("sal299dcnt==>" + sal299dcnt);
      }
    }

    params.put("P_SALES_ORD_NO", params.get("salesOrderNo"));
    params.put("P_USER_ID", params.get("stkRetnCrtUserId"));
    params.put("P_RETN_NO", params.get("serviceNo"));
    orderListMapper.SP_RETURN_BILLING_EARLY_TERMI(params);

    int sal1dcnt = orderListMapper.updateState_SAL0001D(params);
    logger.debug("sal1dcnt==>" + sal1dcnt);

    // 물류 호출 add by hgham
    Map<String, Object> logPram = null;
    ///////////////////////// 물류 호출/////////////////////////
    logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", params.get("serviceNo"));
    logPram.put("RETYPE", "SVO");
    logPram.put("P_TYPE", "OD91");
    logPram.put("P_PRGNM", "LOG39");
    logPram.put("USERID", params.get("stkRetnCrtUserId"));

    logger.debug("productReturnResult 물류  PRAM ===>" + logPram.toString());
    servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
    logger.debug("productReturnResult 물류  결과 ===>" + logPram.toString());
    logPram.put("P_RESULT_TYPE", "PR");
    logPram.put("P_RESULT_MSG", logPram.get("p1"));
    ///////////////////////// 물류 호출 END //////////////////////

    rMp.put("SP_MAP", logPram);

    logger.info("= PARAM = " + params.toString());
    EgovMap searchSAL0001D = orderListMapper.newSearchCancelSAL0001D(params);

    logger.info("====================== PROMOTION COMBO CHECKING - START - ==========================");
    logger.info("= PARAM = " + searchSAL0001D.toString());

    // CHECK ORDER PROMOTION IS IT FALL ON COMBO PACKAGE PROMOTION
    // 1ST CHECK PCKAGE_BINDING_NO (SUB)
    int count = orderListMapper.chkSubPromo(searchSAL0001D);
    logger.info("= CHECK PCKAGE_BINDING_NO (SUB) = " + count);

    if (count > 0) {
      // CANCELLATION IS SUB COMBO PACKAGE.
      // TODO REVERT MAIN PRODUCT PROMO. CODE
      logger.info("====================== CANCELLATION IS SUB COMBO PACKAGE ==========================");

      EgovMap revCboPckage = orderListMapper.revSubCboPckage(searchSAL0001D);
      revCboPckage.put("reqStageId", "25");

      logger.info("= PARAM 2 = " + revCboPckage.toString());
      orderListMapper.insertSAL0254D(revCboPckage);

    } else {
      // 2ND CHECK PACKAGE (MAIN)
      count = orderListMapper.chkMainPromo(searchSAL0001D);

      if (count > 0) {
        // CANCELLATION IS MAIN COMBO PACKAGE.
        // TODO REVERT SUB PRODUCT PROMO. CODE AND RENTAL PRICE

        logger.info("====================== CANCELLATION IS MAIN COMBO PACKAGE ==========================");

        EgovMap revCboPckage = orderListMapper.revMainCboPckage(searchSAL0001D);
        revCboPckage.put("reqStageId", "25");

        logger.info("= PARAM 2 = " + revCboPckage.toString());
        orderListMapper.insertSAL0254D(revCboPckage);
      } else {
        // DO NOTHING (IS NOT A COMBO PACKAGE)
      }
    }
    logger.info("====================== PROMOTION COMBO CHECKING - END - ==========================");

    return rMp;
  }

  @Override
  public void setPRFailJobRequest(Map<String, Object> params) {
    // TODO Auto-generated method stub

    logger.debug("setPRFailJobRequest==>" + params.toString());
    String callEntryID = orderListMapper.select_SeqCCR0006D(params);

    params.put("callEntryID", callEntryID);

    String callResultID = orderListMapper.select_SeqCCR0007D(params);

    params.put("callResultID", callResultID);
    logger.debug("setPRFailJobRequest==>" + params.toString());
    orderListMapper.insert_CCR0006D(params);
    orderListMapper.insert_CCR0007D(params);

    int log38cnt = orderListMapper.updateFailed_LOG0038D(params);
    int log39cnt = orderListMapper.insertFailed_LOG0039D(params);
    orderListMapper.updateFailed_SAL0020D(params);

    logger.debug("log39cnt==>" + log39cnt);

  }

  @Override
  public EgovMap getPrCTInfo(Map<String, Object> params) {

    return orderListMapper.getPrCTInfo(params);
  }

  @Override
  public int chkRcdTms(Map<String, Object> params) {
    return orderListMapper.chkRcdTms(params);
  }

	// KR HAN
//  @SuppressWarnings("unchecked")
//  @Override
//	public Map<String, Object> saveSerialNoModify(Map<String, Object> params) {
//
//	logger.info("++++ saveSerialNoModify params ::" + params );
//
//	params.put("pItmCode", params.get("pStkCode") );
//	params.put("pRefDocNo", params.get("pRetnNo") );
//	params.put("pCallGbn", "RETURN" );
//	params.put("pMobileYn", "Y" );
//
//	params.put("pUserId", CommonUtils.intNvl(params.get("userId"))  );
//
//	orderListMapper.updateBarcodeChange(params);
//
//	logger.info("++++ saveSerialNoModify return params ::" + params );
//
//  	  return params;
//	}

  // KR_HAN : ADD
  @Override
  public EgovMap insertProductReturnResultSerial(Map<String, Object> params) {

	  // 결과 리턴
    EgovMap rMp = new EgovMap();

	logger.debug("insertProductReturnResultSerial params : {}", params);

	EgovMap   pReturnParam = this.getPReturnParam(params);
	if(String.valueOf(params.get("returnStatus")).equals("4") ) { //성공시
		Map<String, Object>    cvMp = new HashMap<String, Object>();

	     int noRcd = this.chkRcdTms(params);


    	cvMp.put("stkRetnStusId",  			"4");
    	cvMp.put("stkRetnStkIsRet",  			"1");
    	cvMp.put("stkRetnRem",  			    String.valueOf(params.get("remark")));
    	cvMp.put("stkRetnResnId", 		    pReturnParam.get("soReqResnId"));   //?
    	cvMp.put("stkRetnCcId",  		     	"1781"); //?
    	cvMp.put("stkRetnCrtUserId",         params.get("userId"));
    	cvMp.put("stkRetnUpdUserId",        params.get("userId"));
    	cvMp.put("stkRetnResultIsSynch",   "0");
    	cvMp.put("stkRetnAllowComm",  	"1");
    	cvMp.put("stkRetnCtMemId",  		params.get("CTID"));
    	cvMp.put("checkinDt",  					String.valueOf( params.get("returnDate") ) );
    	cvMp.put("checkinTm",  				"");
    	cvMp.put("checkinGps",  				"");
    	cvMp.put("signData",  					"");
    	cvMp.put("signRegDt",  			    String.valueOf( params.get("returnDate") ) );
    	cvMp.put("signRegTm",  				"");
    	cvMp.put("ownerCode",                String.valueOf(params.get("custRelationship")));
    	cvMp.put("resultCustName",  		String.valueOf(params.get("hidCustomerName")));
    	cvMp.put("resultIcmobileNo",  		String.valueOf(params.get("hidCustomerContact")));
    	cvMp.put("resultRptEmailNo",  		"");
    	cvMp.put("resultAceptName",  		String.valueOf(params.get("custName")));
    	cvMp.put("salesOrderNo",  String.valueOf(params.get("hidTaxInvDSalesOrderNo")));
    	cvMp.put("userId",  params.get("userId"));
    	cvMp.put("serviceNo",  String.valueOf(pReturnParam.get("retnNo")));
    	//cvMp.put("transactionId",  String.valueOf(paramsTran.get("transactionId")));

      // Data Preparation for 3 Month Cooling Off Block List
      cvMp.put("salesOrderId",  params.get("hidSalesOrderId"));
      cvMp.put("appTypeId",  params.get("hidAppTypeId"));
      cvMp.put("custId",  params.get("hidCustomerId"));
      cvMp.put("productId",  params.get("hidProductId"));
      cvMp.put("categoryId",  params.get("hidCategoryId"));
      cvMp.put("brnchId",  params.get("brnchId"));
    	logger.debug("cvMp : {}", cvMp);

    		// KR_HAN : Serial 변경
    		EgovMap  rtnValue = this.productReturnResultSerial(cvMp);

    		// DELVRY_NO 조회
    		Map<String, Object> schDelvryNoMap = new HashMap();
    		schDelvryNoMap.put("refDocNo", params.get("hidRefDocNo") );
    		Map<String, Object> dlvryNoMap = orderListMapper.selectDelvryNo(schDelvryNoMap);

		if( null !=rtnValue){
			HashMap   spMap =(HashMap)rtnValue.get("spMap");
			logger.debug("spMap :"+ spMap.toString());
			if(!"000".equals(spMap.get("P_RESULT_MSG"))){
				rtnValue.put("logerr","Y");
			}
//			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

			String errCodeSvc = (String)spMap.get("pErrcode");
      	  	String errMsgSvc = (String)spMap.get("pErrmsg");

      	    logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCodeSvc);
      	    logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsgSvc);

         	// pErrcode : 000  = Success, others = Fail
         	if(!"000".equals(errCodeSvc)){
         		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCodeSvc + ":" + errMsgSvc);
         	}

    		// KR-HAN Barcode Save Start
    		Map<String, Object> setmap = new HashMap();
    		setmap.put("serialNo", params.get("serialNo"));
    		setmap.put("beforeSerialNo", "");
    		setmap.put("salesOrdId", params.get("hidSalesOrderId"));
    		setmap.put("reqstNo", params.get("hidRefDocNo"));
    		setmap.put("delvryNo", dlvryNoMap.get("delvryNo"));
    		setmap.put("callGbn", "RETURN");
    		setmap.put("mobileYn", "N");
    		setmap.put("userId", params.get("userId"));

    		servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmap);

    		String errCode = (String)setmap.get("pErrcode");
    		String errMsg = (String)setmap.get("pErrmsg");

    		logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE ERROR CODE : " + errCode);
    		logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE ERROR MSG: " + errMsg);

    		// pErrcode : 000  = Success, others = Fail
    		if(!"000".equals(errCode)){
    			throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
    		}
    		// KR-HAN Barcode Save Start
		}
//		message.setMessage("Success : Product Return is Complete");
		rMp.put("message", "Success : Product Return is Complete");
		rMp.put("rtnCode", AppConstants.SUCCESS);

	}

	else{ // 실패시
		Map<String, Object> failParam = params;

		failParam.put("userId", params.get("userId") );
		failParam.put("salesOrderNo",  params.get("hidTaxInvDSalesOrderNo") );
		failParam.put("serviceNo",  pReturnParam.get("retnNo") );
		failParam.put("failReasonCode",  params.get("failReason") );


		this.setPRFailJobRequest(params);
		//message.setMessage("Success : Product Return is Fail");
		rMp.put("message", "FAIL : Product Return is Fail");
		rMp.put("rtnCode", AppConstants.FAIL);
	}

    return rMp;
  }

  // KR_HAN : Serial 추가
  @Override
  public EgovMap productReturnResultSerial(Map<String, Object> params) {

    EgovMap rMp = new EgovMap();

    logger.debug("insert_LOG0039D==>" + params.toString());
    int log39cnt = orderListMapper.insert_LOG0039D(params);
    logger.debug("log39cnt==>" + log39cnt);

    if (log39cnt > 0) {
      logger.debug("updateState_LOG0038D / updateState_SAL0001D / insert_SAL0009D ==>" + params.toString());
      int log38cnt = orderListMapper.updateState_LOG0038D(params);
      logger.debug("log38cnt==>" + log38cnt);

      int sal9dcnt = orderListMapper.insert_SAL0009D(params);
      logger.debug("sal9dcnt==>" + sal9dcnt);
      int sal20dcnt = orderListMapper.updateState_SAL0020D(params);
      logger.debug("sal20dcnt==>" + sal20dcnt);
      int sal71dcnt = orderListMapper.updateState_SAL0071D(params);
      logger.debug("sal71dcnt==>" + sal71dcnt);

      if(params.get("stkRetnResnId").toString() != "1993"){
        int sal299dcnt = orderListMapper.insert_SAL0299D(params);
        logger.debug("sal299dcnt==>" + sal299dcnt);
      }
    }


    params.put("P_SALES_ORD_NO", params.get("salesOrderNo"));
    params.put("P_USER_ID", params.get("stkRetnCrtUserId"));
    params.put("P_RETN_NO", params.get("serviceNo"));
    // KR_HAN : ADD
    orderListMapper.SP_RETURN_BILLING_EARLY_TERMI_SERIAL(params);

    int sal1dcnt = orderListMapper.updateState_SAL0001D(params);
    logger.debug("sal1dcnt==>" + sal1dcnt);

    // 물류 호출 add by hgham
    Map<String, Object> logPram = null;
    ///////////////////////// 물류 호출/////////////////////////
    logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", params.get("serviceNo"));
    logPram.put("RETYPE", "SVO");
    logPram.put("P_TYPE", "OD91");
    logPram.put("P_PRGNM", "LOG39");
    logPram.put("USERID", params.get("stkRetnCrtUserId"));

    // KR_HAN : SP_LOGISTIC_REQUEST_SERIAL 변경
    logger.debug("productReturnResult 물류  PRAM ===>" + logPram.toString());
    servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
    logger.debug("productReturnResult 물류  결과 ===>" + logPram.toString());

    if(!"000".equals(logPram.get("p1"))) {
		  throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1")+ ":" + "RETURN Result Error");
	  }

    logPram.put("P_RESULT_TYPE", "PR");
    logPram.put("P_RESULT_MSG", logPram.get("p1"));
    ///////////////////////// 물류 호출 END //////////////////////

    rMp.put("SP_MAP", logPram);

    logger.info("= PARAM = " + params.toString());
    EgovMap searchSAL0001D = orderListMapper.newSearchCancelSAL0001D(params);

    logger.info("====================== PROMOTION COMBO CHECKING - START - ==========================");
    logger.info("= PARAM = " + searchSAL0001D.toString());

    // CHECK ORDER PROMOTION IS IT FALL ON COMBO PACKAGE PROMOTION
    // 1ST CHECK PCKAGE_BINDING_NO (SUB)
    int count = orderListMapper.chkSubPromo(searchSAL0001D);
    logger.info("= CHECK PCKAGE_BINDING_NO (SUB) = " + count);

    if (count > 0) {
      // CANCELLATION IS SUB COMBO PACKAGE.
      // TODO REVERT MAIN PRODUCT PROMO. CODE
      logger.info("====================== CANCELLATION IS SUB COMBO PACKAGE ==========================");

      EgovMap revCboPckage = orderListMapper.revSubCboPckage(searchSAL0001D);
      revCboPckage.put("reqStageId", "25");

      logger.info("= PARAM 2 = " + revCboPckage.toString());
      orderListMapper.insertSAL0254D(revCboPckage);

    } else {
      // 2ND CHECK PACKAGE (MAIN)
      count = orderListMapper.chkMainPromo(searchSAL0001D);

      if (count > 0) {
        // CANCELLATION IS MAIN COMBO PACKAGE.
        // TODO REVERT SUB PRODUCT PROMO. CODE AND RENTAL PRICE

        logger.info("====================== CANCELLATION IS MAIN COMBO PACKAGE ==========================");

        EgovMap revCboPckage = orderListMapper.revMainCboPckage(searchSAL0001D);
        revCboPckage.put("reqStageId", "25");

        logger.info("= PARAM 2 = " + revCboPckage.toString());
        orderListMapper.insertSAL0254D(revCboPckage);
      } else {
        // DO NOTHING (IS NOT A COMBO PACKAGE)
      }
    }
    logger.info("====================== PROMOTION COMBO CHECKING - END - ==========================");

    return rMp;
  }

  @Override
  public EgovMap selectOrderSerial(Map<String, Object> params) {
    return orderListMapper.selectOrderSerial(params);
  }

  @Override
  public List<EgovMap> selectCboPckLinkOrdSub(Map<String, Object> params) {
    return orderListMapper.selectCboPckLinkOrdSub(params);
  }

  @Override
  public List<EgovMap> selectCboPckLinkOrdSub2(Map<String, Object> params) {
    return orderListMapper.selectCboPckLinkOrdSub2(params);
  }



  @Override
  public List<EgovMap> getCustIdOfOrderList(Map<String, Object> params) {
    return orderListMapper.getCustIdOfOrderList(params);
  }

  @Override
  public List<EgovMap> selectOrderListCody(Map<String, Object> params) {
    return orderListMapper.selectOrderListCody(params);
  }

  @Override
  public int getSirimOrdID(Map<String, Object> params) {
      return orderListMapper.getSirimOrdID(params);
  }

  @Override
  public int getMemberID(Map<String, Object> params) {
      return orderListMapper.getMemberID(params);
  }
}
