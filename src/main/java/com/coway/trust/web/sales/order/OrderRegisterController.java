package com.coway.trust.web.sales.order;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.FileDto;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.OrderRequestService;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderRegisterController {

  private static Logger logger = LoggerFactory.getLogger(OrderRegisterController.class);

  @Resource(name = "orderRegisterService")
  private OrderRegisterService orderRegisterService;

  @Resource(name = "orderRequestService")
  private OrderRequestService orderRequestService;

  @Resource(name = "customerService")
  private CustomerService customerService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "webInvoiceService")
  private WebInvoiceService webInvoiceService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private FileApplication fileApplication;

  @Value("${com.file.upload.path}")
  private String uploadDir;

  @RequestMapping(value = "/orderRegisterPop.do")
  public String main(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
    String nextDay = CommonUtils.changeFormat(CommonUtils.getCalDate(1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
    model.put("nextDay", nextDay);

    return "sales/order/orderRegisterPop";
  }

  @RequestMapping(value = "/copyChangeOrder.do")
  public String copyChangeOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

    EgovMap result = orderDetailService.selectOrderBasicInfo(params, sessionVO);

    model.put("orderInfo", result);
    model.put("COPY_CHANGE_YN", "Y");
    model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

    return "sales/order/orderRegisterPop";
  }

  @RequestMapping(value = "/bulkOrderPop.do")
  public String convertToOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

    model.put("BULK_ORDER_YN", "Y");
    model.put("preOrdId", params.get("preOrdId"));
    model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

    return "sales/order/orderRegisterPop";
  }

  @RequestMapping(value = "/oldOrderPop.do")
  public String oldOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "sales/order/oldOrderPop";
  }

  @RequestMapping(value = "/orderApprovalPop.do")
  public String orderApprovalPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "sales/order/orderApprovalPop";
  }

  @RequestMapping(value = "/cnfmOrderDetailPop.do")
  public String cnfmOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "sales/order/cnfmOrderDetailPop";
  }

  @RequestMapping(value = "/orderSearchPop.do")
  public String orderSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
    model.put("callPrgm", params.get("callPrgm"));
    model.put("indicator", params.get("indicator"));
    return "sales/order/orderSearchPop";
  }

  @RequestMapping(value = "/selectCustAddJsonInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCustAddInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### custAddId : " + params.get("custAddId"));
    logger.debug("!@##############################################################################");

    // EgovMap custAddInfo = orderRegisterService.selectCustAddInfo(params);
    EgovMap custAddInfo = customerService.selectCustomerViewMainAddress(params);
    /*
     * if(custAddInfo != null) {
     * if(CommonUtils.isNotEmpty(custAddInfo.get("postcode"))) {
     * params.put("postCode", custAddInfo.get("postcode"));
     *
     * EgovMap brnchInfo = commonService.selectBrnchIdByPostCode(params);
     *
     * custAddInfo.put("brnchId", brnchInfo.get("brnchId")); } }
     */
    // 데이터 리턴.
    return ResponseEntity.ok(custAddInfo);
  }

  @RequestMapping(value = "/checkOldOrderId.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {
    logger.info("extrade :: " + params.get("exTrade"));
    EgovMap RESULT;
    if (params.get("exTrade").equals("2")) {
      RESULT = orderRegisterService.checkOldOrderIdICare(params);
    } else {
      RESULT = orderRegisterService.checkOldOrderId(params);
    }

    // 데이터 리턴.
    return ResponseEntity.ok(RESULT);
  }

  /*
   * @RequestMapping(value = "/selectOldOrderId.do", method = RequestMethod.GET)
   * public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String,
   * Object>params, ModelMap model) throws Exception {
   *
   * EgovMap ordInfo = orderRegisterService.selectOldOrderId(params);
   *
   * // 데이터 리턴. return ResponseEntity.ok(ordInfo); }
   *
   * @RequestMapping(value = "/selectSvcExpire.do", method = RequestMethod.GET)
   * public ResponseEntity<EgovMap> selectSvcExpire(@RequestParam Map<String,
   * Object>params, ModelMap model) throws Exception {
   *
   * EgovMap ordInfo = orderRegisterService.selectSvcExpire(params);
   *
   * // 데이터 리턴. return ResponseEntity.ok(ordInfo); }
   *
   * @RequestMapping(value = "/selectVerifyOldSalesOrderNoValidity.do", method =
   * RequestMethod.GET) public ResponseEntity<EgovMap>
   * selectVerifyOldSalesOrderNoValidity(@RequestParam Map<String,
   * Object>params, ModelMap model) throws Exception {
   *
   * EgovMap ordInfo =
   * orderRegisterService.selectVerifyOldSalesOrderNoValidity(params);
   *
   * // 데이터 리턴. return ResponseEntity.ok(ordInfo); }
   */

  @RequestMapping(value = "/selectCustCntcJsonInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCustCntcInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### custAddId : " + params.get("custAddId"));
    logger.debug("!@##############################################################################");

    EgovMap custAddInfo = customerService.selectCustomerViewMainContact(params);

    // 데이터 리턴.
    return ResponseEntity.ok(custAddInfo);
  }

  @RequestMapping(value = "/selectSrvCntcJsonInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectSrvCntcInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : " + params.get("custCareCntId"));
    logger.debug("!@##############################################################################");

    EgovMap custAddInfo = orderRegisterService.selectSrvCntcInfo(params);

    // 데이터 리턴.
    return ResponseEntity.ok(custAddInfo);
  }

  @RequestMapping(value = "/selectStockPriceJsonInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectStockPrice(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : " + params.get("custCareCntId"));
    logger.debug("!@##############################################################################");

    EgovMap priceInfo = orderRegisterService.selectStockPrice(params);

    // 데이터 리턴.
    return ResponseEntity.ok(priceInfo);
  }

  @RequestMapping(value = "/selectDocSubmissionList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDocSubmissionList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectDocSubmissionList(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectPromotionByAppTypeStock.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectPromotionByAppTypeStock(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectPromotionByAppTypeStock2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock2(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectPromotionByAppTypeStock2(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectPromotionByAppTypeStockESales.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStockESales(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectPromotionByAppTypeStockESales(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectProductPromotionPriceByPromoStockID.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectProductPromotionPriceByPromoStockID(@RequestParam Map<String, Object> params) {
    EgovMap priceInfo = orderRegisterService.selectProductPromotionPriceByPromoStockID(params);
    return ResponseEntity.ok(priceInfo);
  }

  @RequestMapping(value = "/selectTrialNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectTrialNo(@RequestParam Map<String, Object> params) {
    EgovMap result = orderRegisterService.selectTrialNo(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/selectMemberByMemberIDCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectMemberByMemberIDCode(@RequestParam Map<String, Object> params) {
    EgovMap result = orderRegisterService.selectMemberByMemberIDCode(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/checkRC.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkRC(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

      if(!params.containsKey("memCode")) {
          String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
          params.put("memCode", memCode);
      }
    EgovMap result = orderRegisterService.checkRC(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/selectMemberList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMemberList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectMemberList(params);
    return ResponseEntity.ok(codeList);
  }

  /**
   * 공통 파일 테이블 사용 Upload를 처리한다.
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/gstEurCertUpload.do", method = RequestMethod.POST)
  public ResponseEntity<FileDto> sampleUploadCommon(MultipartHttpServletRequest request,
      @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
        SalesConstants.SALES_GSTEURCERET_SUBPATH, AppConstants.UPLOAD_MAX_FILE_SIZE);

    String param01 = (String) params.get("param01");

    params.put(CommonConstants.USER_ID, sessionVO.getUserId());

    // serivce 에서 파일정보를 가지고, DB 처리.
    int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList(list), params);
    FileDto fileDto = FileDto.create(list, fileGroupKey);

    return ResponseEntity.ok(fileDto);
  }

  @RequestMapping(value = "/copyOrderBulkPop.do")
  public String copyOrderBulkPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

      EgovMap result = null;
      result = orderRegisterService.checkRC(params);
      if(result != null) {
          model.addAttribute("rcPrct", result.get("rcPrct"));
          model.addAttribute("cnt", result.get("cnt"));
          model.addAttribute("memRc", "1");
      } else {
          model.addAttribute("memRc", "0");
      }


      model.addAttribute("memCode", params.get("memCode"));
      model.addAttribute("salesmanName", params.get("name"));

    return "sales/order/copyOrderBulkPop";
  }

  @RequestMapping(value = "/registerOrder.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> registerOrder(@RequestBody OrderVO orderVO, HttpServletRequest request,
      Model model, SessionVO sessionVO) throws Exception {

    // MultipartHttpServletRequest multipartRequest =
    // (MultipartHttpServletRequest)request;
    /*
     * String sEurcRefNo = orderVO.getgSTEURCertificateVO().getEurcRefNo();
     * FileDto fileDto = null;
     *
     * if(CommonUtils.isNotEmpty(sEurcRefNo)) { //if(request.get)
     * List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request,
     * uploadDir, SalesConstants.SALES_GSTEURCERET_SUBPATH,
     * AppConstants.UPLOAD_MAX_FILE_SIZE);
     *
     * Map<String, Object> params = new HashMap<String, Object>();
     *
     * int fileGroupKey = fileApplication.commonAttach(FileType.WEB,
     * FileVO.createList(list), params);
     *
     * logger.info("fileGroupKey :"+fileGroupKey);
     *
     * fileDto = FileDto.create(list, fileGroupKey); }
     * orderRegisterService.registerOrder(orderVO, sessionVO, fileDto);
     */
    orderRegisterService.registerOrder(orderVO, sessionVO);

    logger.info("orderVO : {}" + orderVO.getASEntryVO());

    // Ex-Trade : 1
    if (orderVO.getSalesOrderMVO().getExTrade() == 1
        && CommonUtils.isNotEmpty(orderVO.getSalesOrderMVO().getSalesOrdIdOld())) {
      logger.debug("@#### Order Cancel START");
      logger.debug("######### " + orderVO.getSalesOrderMVO().getSalesOrdIdOld());
      logger.debug("######### " + orderVO.getSalesOrderMVO().getExTrade());
      String nowDate = "";

      Date date = new Date();
      SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault(Locale.Category.FORMAT));
      nowDate = df.format(date);

      logger.debug("@#### nowDate:" + nowDate);

      Map<String, Object> cParam = new HashMap<String, Object>();

      //cParam.put("salesOrdNo", orderVO.getSalesOrderMVO().getBindingNo());
      cParam.put("salesOrdId",String.valueOf(orderVO.getSalesOrderMVO().getSalesOrdIdOld()));

      EgovMap rMap = orderRegisterService.selectOldOrderId(cParam);

      cParam.put("salesOrdId", String.valueOf(rMap.get("salesOrdId")));
      cParam.put("cmbRequestor", "527");
      cParam.put("dpCallLogDate", nowDate);
      cParam.put("cmbReason", "1993");
      cParam.put("txtRemark", "Auto Cancellation for Ex-Trade");
      cParam.put("txtTotalAmount", "0");
      cParam.put("txtPenaltyCharge", "0");
      cParam.put("txtObPeriod", "0");
      cParam.put("txtCurrentOutstanding", "0");
      cParam.put("txtTotalUseMth", "0");
      cParam.put("txtPenaltyAdj", "0");

      orderRequestService.requestCancelOrder(cParam, sessionVO);
    }

    String msg = "", appTypeName = "";

    switch (orderVO.getSalesOrderMVO().getAppTypeId()) {
      case SalesConstants.APP_TYPE_CODE_ID_RENTAL:
        appTypeName = SalesConstants.APP_TYPE_CODE_RENTAL_FULL;
        break;
      case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT:
        appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHT_FULL;
        break;
      case SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT:
        appTypeName = SalesConstants.APP_TYPE_CODE_INSTALLMENT_FULL;
        break;
      case SalesConstants.APP_TYPE_CODE_ID_SPONSOR:
        appTypeName = SalesConstants.APP_TYPE_CODE_SPONSOR_FULL;
        break;
      case SalesConstants.APP_TYPE_CODE_ID_SERVICE:
        appTypeName = SalesConstants.APP_TYPE_CODE_SERVICE_FULL;
        break;
      case SalesConstants.APP_TYPE_CODE_ID_EDUCATION:
        appTypeName = SalesConstants.APP_TYPE_CODE_EDUCATION_FULL;
        break;
      case SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL:
        appTypeName = SalesConstants.APP_TYPE_CODE_FREE_TRIAL_FULL;
        break;
      case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS:
        appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS_FULL;
        break;
      default:
        break;
    }

    msg += "Order successfully saved.<br />";

    if ("Y".equals(orderVO.getCopyOrderBulkYN())) {
      msg += "Order Number : " + orderVO.getSalesOrdNoFirst() + " ~ " + orderVO.getSalesOrderMVO().getSalesOrdNo()
          + "<br />";

    } else {
      msg += "Order Number : " + orderVO.getSalesOrderMVO().getSalesOrdNo() + "<br />";
    }

    if (orderVO.getSalesOrderDVO().getItmCompId() == 2 || orderVO.getSalesOrderDVO().getItmCompId() == 3
        || orderVO.getSalesOrderDVO().getItmCompId() == 4) {
      msg += "AS Number : " + orderVO.getASEntryVO().getAsNo() + "<br />";
    }

    msg += "Application Type : " + appTypeName + "<br />";

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage(msg);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectLoginInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectLoginInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap result = orderRegisterService.selectLoginInfo(params);

    // 데이터 리턴.
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/selectCheckAccessRight.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCheckAccessRight(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    EgovMap result = orderRegisterService.selectCheckAccessRight(params, sessionVO);

    // 데이터 리턴.
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/selectProductCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectProductCodeList(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectServicePackageList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectServicePackageList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectServicePackageList(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectServicePackageList2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectServicePackageList2(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectServicePackageList2(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/prevOrderNoPop.do")
  public String prevOrderNoPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("custId", params.get("custId"));

    return "sales/order/prevOrderNoPop";
  }

  @RequestMapping(value = "/selectPrevOrderNoList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPrevOrderNoList(@RequestParam Map<String, Object> params) {
    List<EgovMap> result = orderRegisterService.selectPrevOrderNoList(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/selectProductComponent.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectProductComponent(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectProductComponent(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectProductComponentDefaultKey.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectProductComponentDefaultKey(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {
    EgovMap defaultKey = orderRegisterService.selectProductComponentDefaultKey(params);
    // 데이터 리턴.
    return ResponseEntity.ok(defaultKey);
  }

  @RequestMapping(value = "/selectPromoBsdCpnt.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromoBsdCpnt(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectPromoBsdCpnt(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectPromoBsdCpntESales.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromoBsdCpntESales(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = orderRegisterService.selectPromoBsdCpntESales(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectEKeyinSofCheck.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectEKeyinSofCheck(@RequestParam Map<String, Object> params) {
    EgovMap sofNo = orderRegisterService.selectEKeyinSofCheck(params);
    return ResponseEntity.ok(sofNo);
  }

  @RequestMapping(value = "/instAddrViewHistoryPop.do")
  public String instAddrViewHistoryPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("=============================instAddrViewHistoryPop.do================================");
    logger.debug("= PARAM :: " + params);
    logger.debug("=============================instAddrViewHistoryPop.do================================");
    model.put("prm", params.get("prm"));
    model.put("ind", params.get("ind"));
    return "sales/order/orderModifyInstAddrViewHistoryPop";
  }

  @RequestMapping(value = "/mailAddrViewHistoryAjax", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> mailAddrViewHistoryAjax(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
    logger.debug("=============================mailAddrViewHistoryAjax================================");
    logger.debug("= PARAM :: " + params);
    logger.debug("=============================mailAddrViewHistoryAjax================================");
    List<EgovMap> list = orderRegisterService.mailAddrViewHistoryAjax(params);
    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/instAddrViewHistoryAjax", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> instAddrViewHistoryAjax(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
    logger.debug("=============================instAddrViewHistoryAjax================================");
    logger.debug("= PARAM :: " + params);
    logger.debug("=============================instAddrViewHistoryAjax================================");
    List<EgovMap> list = orderRegisterService.instAddrViewHistoryAjax(params);
    return ResponseEntity.ok(list);
  }
/*
  @RequestMapping(value = "/chkPromoCboMst.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkPromoCboMst(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/chkPromoCboMst.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/chkPromoCboMst.do=======================");

    int statCode = orderRegisterService.chkPromoCboMst(params);

    if (statCode == 1) {
      message.setMessage("NORMAL PROMOTION[NOT COMBO]");
    } else if (statCode == 2) {
      message.setMessage("IS MASTER COMBO PACKAGE");
    } else if (statCode == 3) {
      message.setMessage("HAVE MASTER COMBO ORDER TO MAP");
    } else if (statCode == 4) {
      message.setMessage("PLEASE CREATE A MASTER COMBP TO MAP");
    }

    message.setCode(Integer.toString(statCode));
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/chkCboBindOrdNo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkCboBindOrdNo(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/chkCboBindOrdNo.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/chkCboBindOrdNo.do=======================");

    int statCode = orderRegisterService.chkCboBindOrdNo(params);

    if (statCode > 0) {
      message.setCode("99");
      message.setMessage("SELECTED BINDING NO FOR THIS PROMOTION ALREADY EXIST.");
    } else {
      message.setCode("1");
      message.setMessage("OK.");
    }

    // message.setCode(Integer.toString(statCode));
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/orderComboSearchPop.do")
  public String orderComboSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
    model.put("promoNo", params.get("promoNo"));
    model.put("prod", params.get("prod"));
    model.put("custId", params.get("custId"));
    return "sales/order/orderComboSearchPop";
  }

  @RequestMapping(value = "/selectComboOrderJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectComboOrderJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    String[] arrAppType = request.getParameterValues("appType");
    String[] arrOrdStusId = request.getParameterValues("ordStusId");
    String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId");
    String[] arrDscBrnchId = request.getParameterValues("dscBrnchId");
    String[] arrRentStus = request.getParameterValues("rentStus");

    if (StringUtils.isEmpty(params.get("ordStartDt")))
      params.put("ordStartDt", "01/01/1900");

    if (StringUtils.isEmpty(params.get("ordEndDt")))
      params.put("ordEndDt", "31/12/9999");

    params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

    if (arrAppType != null && !CommonUtils.containsEmpty(arrAppType))
      params.put("arrAppType", arrAppType);

    if (arrOrdStusId != null && !CommonUtils.containsEmpty(arrOrdStusId))
      params.put("arrOrdStusId", arrOrdStusId);

    if (arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId))
      params.put("arrKeyinBrnchId", arrKeyinBrnchId);

    if (arrDscBrnchId != null && !CommonUtils.containsEmpty(arrDscBrnchId))
      params.put("arrDscBrnchId", arrDscBrnchId);

    if (arrRentStus != null && !CommonUtils.containsEmpty(arrRentStus))
      params.put("arrRentStus", arrRentStus);

    if (params.get("custIc") == null) {
    }

    if ("".equals(params.get("custIc"))) {
    }

    logger.debug("!@##############################################################################");
    logger.debug("!@###### ordNo : " + params.get("ordNo"));
    logger.debug("!@###### ordStartDt : " + params.get("ordStartDt"));
    logger.debug("!@###### ordEndDt : " + params.get("ordEndDt"));
    logger.debug("!@###### ordDt : " + params.get("ordDt"));
    logger.debug("!@###### custIc : " + params.get("custIc"));
    logger.debug("!@##############################################################################");

    List<EgovMap> orderList = orderRegisterService.selectComboOrderJsonList(params);

    return ResponseEntity.ok(orderList);
  }
*/

}
