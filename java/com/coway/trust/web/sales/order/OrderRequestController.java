/**
 *
 */
package com.coway.trust.web.sales.order;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.order.OrderReqApplication;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */

/******************************************************************
 * DATE              PIC            VERSION        COMMENT
 *--------------------------------------------------------------------------------------------
 * 23/04/2020    ONGHC          1.0.1           - Add checkDefectByReason
 ******************************************************************/

@Controller
@RequestMapping(value = "/sales/order")
public class OrderRequestController {

  private static Logger logger = LoggerFactory.getLogger(OrderRequestController.class);

  @Resource(name = "orderRequestService")
  private OrderRequestService orderRequestService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "orderLedgerService")
  private OrderLedgerService orderLedgerService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Autowired
  private OrderReqApplication orderReqApplication;



  @RequestMapping(value = "/orderRequestPop.do")
  public String orderRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    String callCenterYn = "N";

    if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
      callCenterYn = "Y";
    }

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);// APP_TYPE_ID
                                                                                     // CUST_ID

    model.put("orderDetail", orderDetail);
    model.put("ordReqType", params.get("ordReqType"));
    model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("toDay", toDay);
    model.put("callCenterYn", callCenterYn);
    model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));

    return "sales/order/orderRequestPop";
  }

  @RequestMapping(value = "/selectResnCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectResnCodeList(@RequestParam Map<String, Object> params) {
    List<EgovMap> rsltList = orderRequestService.selectResnCodeList(params);
    return ResponseEntity.ok(rsltList);
  }

  @RequestMapping(value = "/selectOrderLastRentalBillLedger1.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderLastRentalBillLedger1(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectOrderLastRentalBillLedger1(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/requestCancelOrder.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> requestCancelOrder(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    ReturnMessage message = orderRequestService.requestCancelOrder(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/cboPckReqCanOrd.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> cboPckReqCanOrd(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    ReturnMessage message = orderRequestService.cboPckReqCanOrd(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/requestProdExch.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> requestProdExch(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    ReturnMessage message = orderRequestService.requestProductExchange(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/requestSchmConv.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> requestSchmConv(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    ReturnMessage message = orderRequestService.requestSchmConv(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/requestAppExch.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> requestAppExch(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    ReturnMessage message = orderRequestService.requestApplicationExchange(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/requestOwnershipTransfer.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> requestOwnershipTransfer(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    ReturnMessage message = orderRequestService.requestOwnershipTransfer(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectCompleteASIDByOrderIDSolutionReason.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCompleteASIDByOrderIDSolutionReason(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectCompleteASIDByOrderIDSolutionReason(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/loginUserId.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> loginUserId(SessionVO sessionVO) throws Exception {

    EgovMap map = new EgovMap();

    map.put("userId", sessionVO.getUserId());

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/selectSalesOrderSchemeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectSalesOrderSchemeList(@RequestParam Map<String, Object> params) {
    List<EgovMap> rsltList = orderRequestService.selectSalesOrderSchemeList(params);
    return ResponseEntity.ok(rsltList);
  }

  @RequestMapping(value = "/selectSchemePriceSettingByPromoCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectSchemePriceSettingByPromoCode(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectSchemePriceSettingByPromoCode(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/selectSchemePartSettingBySchemeIDList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectSchemePartSettingBySchemeIDList(@RequestParam Map<String, Object> params) {
    List<EgovMap> rsltList = orderRequestService.selectSchemePartSettingBySchemeIDList(params);
    return ResponseEntity.ok(rsltList);
  }

  @RequestMapping(value = "/schemConvPop.do")
  public String schemConvPop() {
    return "sales/order/schemConvPop";
  }

  @RequestMapping(value = "/selectValidateInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectValidateInfo(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectValidateInfo(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/selectValidateInfoSimul.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectValidateInfoSimul(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectValidateInfoSimul(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/selectOrderSimulatorViewByOrderNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderSimulatorViewByOrderNo(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectOrderSimulatorViewByOrderNo(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/selectOderOutsInfo.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectOderOutsInfo(@RequestParam Map<String, Object> params) {
    List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);
    return ResponseEntity.ok(ordOutInfoList);
  }

  @RequestMapping(value = "/selectObligtPriod.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectObligtPriod(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectObligtPriod(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/selectPenaltyAmt.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectPenaltyAmt(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.selectPenaltyAmt(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/checkeAutoDebitDeduction.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkeAutoDebitDeduction(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.checkeAutoDebitDeduction(params);
    return ResponseEntity.ok(rslt);
  }

  // BY KV order installation no yet complete (CallLog Type - 257, CCR0001D -
  // 20, SAL00046 - Active )
  @RequestMapping(value = "/validOCRStus.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> validOCRStus(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.validOCRStus(params);
    return ResponseEntity.ok(rslt);
  }

  /* Valid OCR Status - (CallLog Type - 257, Stus - 1, SAL00046 - NO RECORD ) */
  @RequestMapping(value = "/validOCRStus2.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> validOCRStus2(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.validOCRStus2(params);
    return ResponseEntity.ok(rslt);
  }

  // BY KV -order cancellation no yet complete sal0020d)
  @RequestMapping(value = "/validOCRStus3.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> validOCRStus3(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.validOCRStus3(params);
    return ResponseEntity.ok(rslt);
  }

  // By KV - order cancellation complete sal0020d ; log0038d active
  @RequestMapping(value = "/validOCRStus4.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> validOCRStus4(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderRequestService.validOCRStus4(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {
    logger.debug("==============================selectCodeList====================================");
    logger.debug("= PARAMS = " + params.toString());
    logger.debug("==============================selectCodeList====================================");
    List<EgovMap> rsltList = orderRequestService.selectCodeList(params);
    return ResponseEntity.ok(rsltList);
  }

  @RequestMapping(value = "/chkCboSal.do", method = RequestMethod.GET)
  public ResponseEntity<Integer> chkCboSal(@RequestParam Map<String, Object> params) {
    logger.debug("=============================chkCboSal=====================================");
    logger.debug("= PARAMS = " + params.toString());
    logger.debug("=============================chkCboSal=====================================");
    Integer stat = orderRequestService.chkCboSal(params);
    return ResponseEntity.ok(stat);
  }

  @RequestMapping(value = "/chkSalStat.do", method = RequestMethod.GET)
  public ResponseEntity<Integer> chkSalStat(@RequestParam Map<String, Object> params) {
    logger.debug("=============================chkSalStat=====================================");
    logger.debug("= PARAMS = " + params.toString());
    logger.debug("=============================chkSalStat=====================================");
    Integer stat = orderRequestService.chkSalStat(params);
    return ResponseEntity.ok(stat);
  }

  @RequestMapping(value = "/checkDefectByReason.do", method = RequestMethod.GET)
  public ResponseEntity<Integer> checkDefectByReason(@RequestParam Map<String, Object> params) {
    logger.debug("=============================checkDefectByReason=====================================");
    logger.debug("= PARAMS = " + params.toString());
    logger.debug("=============================checkDefectByReason=====================================");
    Integer stat = orderRequestService.checkDefectByReason(params);
    return ResponseEntity.ok(stat);
  }


  @RequestMapping(value = "/attachmentFileUpload.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

      String err = "";
      String code = "";
      List<String> seqs = new ArrayList<>();

      try{
           Set set = request.getFileMap().entrySet();
           Iterator i = set.iterator();

           while(i.hasNext()) {
               Map.Entry me = (Map.Entry)i.next();
               String key = (String)me.getKey();
               seqs.add(key);
           }

      List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "sales" + File.separator + "Attachment", AppConstants.UPLOAD_MIN_FILE_SIZE, true);

      logger.debug("list.size : {}", list.size());

      params.put(CommonConstants.USER_ID, sessionVO.getUserId());

      orderReqApplication.insertOrderCancelAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

      params.put("attachFiles", list);
      code = AppConstants.SUCCESS;
      }catch(ApplicationException e){
          err = e.getMessage();
          code = AppConstants.FAIL;
      }

      ReturnMessage message = new ReturnMessage();
      message.setCode(code);
      message.setData(params);
      message.setMessage(err);

      return ResponseEntity.ok(message);
  }
}
