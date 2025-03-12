package com.coway.trust.web.services.orderCall;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.logistics.organization.impl.LocationMapper;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.orderCall.OrderCallListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 31/01/2019    ONGHC      1.0.1       - Restructure File
 * 05/03/2019    ONGHC      1.0.2       - To Show Error Code for SP
 * 03/04/2019    ONGHC      1.0.3       - Amend selectCallResultPop to retrieve Call Log Date Time
 * 10/10/2019    ONGHC      1.0.4       - Amend insertCallResult_2 to Check Available Stock
 * 11/10/2019    ONGHC      1.0.5       - Amend insertCallResult_2 to Check Available Stock By Status
 * 04/11/2019    ONGHC      1.0.6       - Amend insertCallResult_2
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/callCenter")
public class OrderCallListController {
  private static final Logger logger = LoggerFactory.getLogger(OrderCallListController.class);

  @Resource(name = "orderCallListService")
  private OrderCallListService orderCallListService;
  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name="locMapper")
  private LocationMapper locationMapper;

  /**
   * Call Center - Order Call
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/orderCallList.do")
  public String orderCallList(@RequestParam Map<String, Object> params, ModelMap model) {
    // FeedBack Code
    List<EgovMap> callStatus = orderCallListService.selectCallStatus();
    List<EgovMap> productList = orderCallListService.selectProductList();
    List<EgovMap> callLogTyp = orderCallListService.selectCallLogTyp();
    List<EgovMap> callLogSta = orderCallListService.selectCallLogSta();
    List<EgovMap> callLogSrt = orderCallListService.selectCallLogSrt();
    List<EgovMap> promotionList = orderCallListService.selectPromotionList();

    model.addAttribute("callStatus", callStatus);
    model.addAttribute("productList", productList);
    model.addAttribute("callLogTyp", callLogTyp);
    model.addAttribute("callLogSta", callLogSta);
    model.addAttribute("callLogSrt", callLogSrt);
    model.addAttribute("promotionList", promotionList);

    // 호출될 화면
    return "services/orderCall/orderCallList";
  }

  @RequestMapping(value = "/getstateList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getstateList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> stateList = orderCallListService.getstateList();
    return ResponseEntity.ok(stateList);
  }

  @RequestMapping(value = "/getAreaList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAreaList(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    List<EgovMap> areaList = orderCallListService.getAreaList(params);
    return ResponseEntity.ok(areaList);
  }

  /**
   * Call Center - order Call List SEARCH
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/searchOrderCallList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOrderCallListSearch(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    String[] appTypeList = request.getParameterValues("appType");
    String[] callLogTypeList = request.getParameterValues("callLogType");
    String[] callLogStatusList = request.getParameterValues("callLogStatus");
    String[] DSCCodeList = request.getParameterValues("DSCCode");
    String[] productListSp = request.getParameterValues("product");
    String[] promotionListSp = request.getParameterValues("promotion");
    String[] DSCCode = request.getParameterValues("DSCCode");
    String[] searchFeedBackCode = request.getParameterValues("searchFeedBackCode");
    String[] waStusCodeId = request.getParameterValues("waStusCodeId");

    params.put("appTypeList", appTypeList);
    params.put("callLogTypeList", callLogTypeList);
    params.put("callLogStatusList", callLogStatusList);
    params.put("DSCCodeList", DSCCodeList);
    params.put("productListSp", productListSp);
    params.put("promotionListSp", promotionListSp);
    params.put("DSCCode",DSCCode);
    params.put("searchFeedBackCode",searchFeedBackCode);
    params.put("waStusCodeId",waStusCodeId);

    logger.debug("searchOrderCallList - params : {}", params);

    List<EgovMap> orderCallList = null;
    orderCallList = orderCallListService.selectOrderCall(params);

    return ResponseEntity.ok(orderCallList);
  }

  /**
   * Call Center - order Call List - Add Call Log Result
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/addCallResultPop.do")
  public String insertCallResultPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    logger.debug("=========================/addCallResultPop.do================================");
    logger.debug("params : " + params);
    logger.debug("=========================/addCallResultPop.do================================");

    EgovMap orderCall = orderCallListService.getOrderCall(params);

    // Added for Special Delivery CT enhancement by Hui Ding, 31-03-2020
 	EgovMap superCtInd = commonMapper.selectSuperCtInd();
 	EgovMap superCtCode = commonMapper.selectSuperCtCode();
 	EgovMap superCtOrderCall = null;

 	if (orderCall != null && superCtInd != null && superCtCode !=null) {

 		model.addAttribute("superCtInd", superCtInd.get("code").toString());
 		model.addAttribute("superCtCode", superCtCode.get("code").toString());

 		superCtOrderCall = new EgovMap();
 		superCtOrderCall.put("superCtInd", superCtInd.get("code").toString());
 		superCtOrderCall.put("productCode", orderCall.get("productCode"));

 		EgovMap superCtCdMap = commonMapper.selectSuperCtCode();
 		EgovMap branchMap = null;

 		if (superCtCdMap != null){
 			logger.info("###superCtCdMap: " + superCtCdMap);
 			String superCtCd = superCtCdMap.get("code").toString();
 			if (superCtCd != null){
 				logger.info("###Super CT Code: " + superCtCd);
 				Map<String, Object> tempMap = new HashMap<String, Object>();
 				tempMap.put("whLocCd", superCtCd);
 				branchMap = locationMapper.selectBranchByWhLocId(tempMap);
 				logger.info("###branchMap: " + branchMap.get("branchId").toString());

 				superCtOrderCall.put("dscBrnchId", branchMap.get("branchId"));
 			}
 		}
 	}

 	EgovMap rdcincdcSuperCt = null;
 	if (superCtOrderCall != null) {
 		rdcincdcSuperCt = orderCallListService.getRdcInCdc(superCtOrderCall);
 	}
    EgovMap rdcincdc = orderCallListService.getRdcInCdc(orderCall);
    List<EgovMap> callStatus = orderCallListService.selectCallStatus();
    List<EgovMap> callLogSta = orderCallListService.selectCallLogSta();
    String productCode = orderCall.get("productCode").toString();
    params.put("productCode", productCode);
    EgovMap cdcAvaiableStock = orderCallListService.selectCdcAvaiableStock(params);
    EgovMap rdcStock = orderCallListService.selectRdcStock(params);

    // Order Detail Tab
    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.addAttribute("callStusCode", params.get("callStusCode"));
    model.addAttribute("callStusId", params.get("callStusId"));
    model.addAttribute("salesOrdId", params.get("salesOrdId"));
    model.addAttribute("callEntryId", params.get("callEntryId"));
    model.addAttribute("salesOrdNo", params.get("salesOrdNo"));
    model.addAttribute("rcdTms", params.get("rcdTms"));
    model.addAttribute("cdcAvaiableStock", cdcAvaiableStock);
    model.addAttribute("rdcStock", rdcStock);
    model.addAttribute("orderCall", orderCall);
    model.addAttribute("callStatus", callStatus);
    model.addAttribute("callLogSta", callLogSta);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("orderRdcInCdc", rdcincdc);
    model.addAttribute("rdcincdcSuperCt", rdcincdcSuperCt);

    return "services/orderCall/addCallLogResultPop";
  }

  /**
   * Call Center - order Call List - Save Call Log Result
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/addCallLogResult.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertCallResult(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();
    boolean success = false;
    logger.debug("params : {}", params);
    String installationNo = "";
    Map<String, Object> resultValue = new HashMap<String, Object>();
    resultValue = orderCallListService.insertCallResult(params, sessionVO);

    if (null != resultValue) {

      int state = CommonUtils.intNvl(params.get("callStatus"));
      if (state == 20) {

        HashMap spMap = (HashMap) resultValue.get("spMap");
        // logger.debug("spMap :"+ spMap.toString());
        if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
          resultValue.put("logerr", "Y");

          message.setMessage("Error in Logistics Transaction");
          message.setCode("99");

        } else {
          message.setMessage("success Installation No : " + resultValue.get("installationNo") + "</br>SELES ORDER NO : "
              + resultValue.get("salesOrdNo"));
          message.setCode("1");
        }
        servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
      }

    }

    return ResponseEntity.ok(message);
  }

  /**
   * Call Center - order Call List - Save Call Log Result [ENHANCE OLD insertCallResult]
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */

  @RequestMapping(value = "/addCallLogResult_2.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertCallResult_2(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/insertCallResult_2.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/insertCallResult_2.do=======================");

    Map<String, Object> resultValue = new HashMap<String, Object>();
//    Map<String, Object> smsResultValue = new HashMap<String, Object>();
    int noRcd = orderCallListService.chkRcdTms(params);

    if (noRcd == 1) { // RECORD ABLE TO UPDATE

      EgovMap orderCall = orderCallListService.getOrderCall(params);
      String productCode = orderCall.get("productCode").toString();
      String telM = orderCall.get("installTelM").toString();
      String appType = orderCall.get("appTypeName").toString();
      params.put("productCode", productCode);
      params.put("telM", telM);
      params.put("appType", appType);

      EgovMap rdcStock = orderCallListService.selectRdcStock(params);

      logger.debug("rdcStock : {}", rdcStock);
      //if (rdcStock != null) {
        if (CommonUtils.intNvl(params.get("callStatus")) == 20) {
          logger.debug("CHECK QUANTITY~~");
          if (rdcStock != null) {
            if ((Integer.parseInt(rdcStock.get("availQty").toString()) > 0) || (Integer.parseInt(rdcStock.get("availQty").toString()) <= 0 && params.get("hiddenATP").equals("Y"))) {
            	resultValue = orderCallListService.insertCallResult_2(params, sessionVO);

              if (null != resultValue) {
                if (CommonUtils.intNvl(params.get("callStatus")) == 20) {
                  if ("1".equals(resultValue.get("logStat"))) {
                    message.setMessage("Error Encounter. Please Contact Administrator. Error Code(CL): " + resultValue.get("logStat").toString());
                    message.setCode("99");
                  } else {
                	  params.put("logStat", resultValue.get("logStat"));
                	  String msg = "Record created successfully.</br> Installation No : " + resultValue.get("installationNo") + "</br>Seles Order No : " + resultValue.get("salesOrdNo");

/*                	  try{
                		  smsResultValue = orderCallListService.callLogSendSMS(params, sessionVO);
                	  }catch (Exception e){
                		  logger.info("===smsResultValue===" + smsResultValue.toString());
                	  }
                	  if(smsResultValue.isEmpty()){
                		  msg += "</br> Failed to send SMS to " + params.get("custMobileNo").toString();
                	  }
                	  */
                	  message.setMessage(msg);
                      message.setCode("1");
                  }
                } else {
                  message.setMessage("Record updated successfully.</br> ");
                  message.setCode("1");
                }
              }
            }
            else {
              message.setMessage("Fail to update due to RDC out of stock. ");
              message.setCode("99");
            }
          }else {
        	if(params.get("hiddenATP").equals("Y")){
        		resultValue = orderCallListService.insertCallResult_2(params, sessionVO);

                if (null != resultValue) {
                  if (CommonUtils.intNvl(params.get("callStatus")) == 20) {
                    if ("1".equals(resultValue.get("logStat"))) {
                      message.setMessage("Error Encounter. Please Contact Administrator. Error Code(CL): " + resultValue.get("logStat").toString());
                      message.setCode("99");
                    } else {
                  	  params.put("logStat", resultValue.get("logStat"));
                  	  String msg = "Record created successfully.</br> Installation No : " + resultValue.get("installationNo") + "</br>Seles Order No : " + resultValue.get("salesOrdNo");

                  	 /* try{
                  		  smsResultValue = orderCallListService.callLogSendSMS(params, sessionVO);
                  	  }catch (Exception e){
                  		  logger.info("===smsResultValue===" + smsResultValue.toString());
                  	  }
                  	  if(smsResultValue.isEmpty()){
                  		  msg += "</br> Failed to send SMS to " + params.get("custMobileNo").toString();
                  	  }*/
                  	  message.setMessage(msg);
                        message.setCode("1");
                    }
                  } else {
                    message.setMessage("Record updated successfully.</br> ");
                    message.setCode("1");
                  }
                }
        	}else{
        		message.setMessage("Fail to update due to RDC out of stock. ");
                message.setCode("99");
        	}
          }
        } else {
          logger.debug("BY PASS CHECK QUANTITY~~");
          resultValue = orderCallListService.insertCallResult_2(params, sessionVO);

          if (null != resultValue) {
            if (CommonUtils.intNvl(params.get("callStatus")) == 20) {
              if ("1".equals(resultValue.get("logStat"))) {
                message.setMessage("Error Encounter. Please Contact Administrator. Error Code(CL): " + resultValue.get("logStat").toString());
                message.setCode("99");
              } else {
                message.setMessage("Record created successfully.</br> Installation No : " + resultValue.get("installationNo") + "</br>Seles Order No : " + resultValue.get("salesOrdNo"));
                message.setCode("1");
              }
            } else {
              message.setMessage("Record updated successfully.</br> ");
              message.setCode("1");
            }
          }
        }

        /*if (Integer.parseInt(rdcStock.get("availQty").toString()) > 0) {
          resultValue = orderCallListService.insertCallResult_2(params, sessionVO);

          if (null != resultValue) {
            if (CommonUtils.intNvl(params.get("callStatus")) == 20) {
              if ("1".equals(resultValue.get("logStat"))) {
                message.setMessage("Error Encounter. Please Contact Administrator. Error Code(CL): " + resultValue.get("logStat").toString());
                message.setCode("99");
              } else {
                message.setMessage("Record created successfully.</br> Installation No : " + resultValue.get("installationNo") + "</br>Seles Order No : " + resultValue.get("salesOrdNo"));
                message.setCode("1");
              }
            } else {
              message.setMessage("Record updated successfully.</br> ");
              message.setCode("1");
            }
          }
        } else {
          message.setMessage("Fail to update due to RDC out of stock. ");
          message.setCode("99");
        }*/
      //} else {
        //message.setMessage("Fail to update due to RDC out of stock. ");
        //message.setCode("99");
      //}
    } else {
      message.setMessage("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }

    return ResponseEntity.ok(message);
  }

  /**
   * Call Center - order Call List - Save Call Log Result
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/getCallLogTransaction.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCallLogTransaction(@RequestParam Map<String, Object> params,
      ModelMap model, SessionVO sessionVO) {
    // logger.debug("params : {}", params);
    // Call Log Transation
    List<EgovMap> callLogTran = orderCallListService.selectCallLogTransaction(params);

    // logger.debug("callLogTran : {}", callLogTran);
    return ResponseEntity.ok(callLogTran);
  }

  /**
   * Call Center - order Call List - Add Call Log Result
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/viewCallResultPop.do")
  public String selectCallResultPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    EgovMap orderCall = orderCallListService.getOrderCall(params);
    List<EgovMap> callStatus = orderCallListService.selectCallStatus();
    EgovMap rdcincdc = orderCallListService.getRdcInCdc(orderCall);

    params.put("viewSort", "2");
    List<EgovMap> firstCallLog = orderDetailService.selectCallLogList(params);

    // Order Detail Tab
    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    //Get Oldest Call Log

    // logger.debug("orderCall : {}", orderCall);
    model.addAttribute("callStusCode", params.get("callStusCode"));
    model.addAttribute("callStusId", params.get("callStusId"));
    model.addAttribute("salesOrdId", params.get("salesOrdId"));
    model.addAttribute("callEntryId", params.get("callEntryId"));
    model.addAttribute("salesOrdNo", params.get("salesOrdNo"));
    model.addAttribute("orderCall", orderCall);
    model.addAttribute("callStatus", callStatus);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("orderRdcInCdc", rdcincdc);
    model.addAttribute("firstCallLog", firstCallLog);
    return "services/orderCall/viewCallLogResultPop";
  }

  @RequestMapping(value = "/changeStock.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> changeStockAction(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {
    EgovMap rtnMap = new EgovMap();
    logger.debug("params : {}", params);

    EgovMap orderCall = orderCallListService.getOrderCall(params);
    orderCall.put("stock", params.get("stock"));
    logger.debug("orderCall : {}", orderCall);
    EgovMap rdcincdc = orderCallListService.getRdcInCdc(orderCall);
    String productCode = orderCall.get("productCode").toString();
    params.put("productCode", productCode);

    EgovMap cdcAvaiableStock = orderCallListService.selectCdcAvaiableStock(params);
    EgovMap rdcStock = orderCallListService.selectRdcStock(params);

    rtnMap.put("cdcAvaiableStock", cdcAvaiableStock);
    rtnMap.put("rdcStock", rdcStock);
    rtnMap.put("rdcincdc", rdcincdc);

    logger.debug("###rtnMap : {}", rtnMap);

    return ResponseEntity.ok(rtnMap);
  }

  @RequestMapping(value = "/selRcdTms.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> selRcdTms(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/selRcdTms.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/selRcdTms.do=======================");

    int noRcd = orderCallListService.selRcdTms(params);

    if (noRcd == 1) {
      message.setMessage("OK");
      message.setCode("1");
    } else {
      message.setMessage("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectProductList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProductList(@RequestParam Map<String, Object> params) {

      List<EgovMap> codeList = orderCallListService.selectProductList();
      return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectPromotionList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromotionList(@RequestParam Map<String, Object> params) {

      List<EgovMap> codeList = orderCallListService.selectPromotionList();
      return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/callLogAppointmentManualBlastPop.do")
  public String callLogAppointmentManualBlastPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "services/orderCall/callLogAppointmentManualBlastPop";
  }

  @RequestMapping(value = "/getCallLogAppointmentList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCallLogAppointmentList(@RequestParam Map<String, Object> params,HttpServletRequest request) {

		 String[] statusIdList = request.getParameterValues("status");
		 params.put("statusIdList",statusIdList);
      List<EgovMap> result = orderCallListService.getCallLogAppointmentList(params);
      return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/confirmBlastCallLogAppointment.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> confirmBlastCallLogAppointment(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    String[] idValue = params.get("ids").toString().split(",");

    params.put("idValue", idValue);

    message = orderCallListService.blastCallLogAppointmentList(params);

    return ResponseEntity.ok(message);
  }
}
