package com.coway.trust.web.services.installation;

import java.io.File;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.vo.InstallResultVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.InstallationApplication;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.orderCall.OrderCallListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT ----------------------------------------------------------------------------- 31/01/2019 ONGHC 1.0.1 - Restructure File 05/03/2019 ONGHC 1.0.2 - To Show Error Code for SP 06/03/2019 ONGHC 1.0.3 - Create getSalStat 18/03/2019 ONGHC 1.0.4 - Remove runInstSp 3rd Part 22/03/2019 ONGHC 1.0.5 - Add Checking on SP_LOGISTIC_REQUEST's Data 09/04/2019 ONGHC 1.0.6 - Amend installationNotePop to add param 24/04/2019 ONGHC 1.0.7 - Amend insertInstallationResult_2 to accept 741 code 22/07/2019 ONGHC 1.0.8 - Amend insertInstallationResult_2 add installation stock checking 14/02/2020 ONGHC 1.0.9 - Amend editInstallationPopup 17/02/2020 THUNPY 1.0.10 - Add installationCallLogRawPop 01/07/2020 ONGHC 1.0.11 - Amend assignCtOrderListSaveSerial and assignCtOrderListSave
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services")
public class InstallationResultListController {
  private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

  @Resource(name = "installationResultListService")
  private InstallationResultListService installationResultListService;
  @Resource(name = "commonService")
  private CommonService commonService;
  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "orderCallListService")
  private OrderCallListService orderCallListService;

  @Resource(name = "preOrderService")
	private PreOrderService preOrderService; //  attachmentm

/*  @Autowired
	private PreOrderApplication preOrderApplication;*/

  @Autowired
	private InstallationApplication installationApplication; //attachmentm

  @Resource(name = "ASManagementListService")
  private ASManagementListService ASManagementListService;

  @Value("${web.resource.upload.file}") // attachmentm
	private String uploadDir;

  /**
   * organization transfer page
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationResultList.do")
  public String installationResultList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    List<EgovMap> instTypeList = installationResultListService.selectInstallationType();
    List<EgovMap> appTypeList = installationResultListService.selectApplicationType();
    List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
    List<EgovMap> dscCodeList = installationResultListService.selectDscCode();

    logger.debug("===========================installationResultList.do=====================================");
    logger.debug(" INSTALLATION TYPE : {}", instTypeList);
    logger.debug(" APPLICATION TYPE : {}", appTypeList);
    logger.debug(" INSTALLATION STATUS : {}", installStatus);
    logger.debug(" DCS CODE LIST : {}", dscCodeList);
    logger.debug("===========================installationResultList.do=====================================");

    model.addAttribute("instTypeList", instTypeList);
    model.addAttribute("appTypeList", appTypeList);
    model.addAttribute("installStatus", installStatus);
    model.addAttribute("dscCodeList", dscCodeList);

    return "services/installation/installationResultList";
  }

  /**
   * Installation Result DetailPopup
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationResultPop.do")
  public String installationResultPop(@RequestParam Map<String, Object> params, ModelMap model) {

    EgovMap resultInfo = installationResultListService.getInstallationResultInfo(params);
    model.addAttribute("resultInfo", resultInfo);
    logger.debug("viewInstallation : {}", resultInfo);

    List<EgovMap> installAcc = installationResultListService.selectInstallAccWithInstallEntryId(params);

    List<String> installAccValues = new ArrayList<>();

    for (EgovMap map : installAcc) {
        Object value = map.get("insAccPartId");
        if (value != null) {
            installAccValues.add(value.toString());
        }
    }

    model.put("installAccValues", installAccValues);

    // 호출될 화면
    return "services/installation/installationResultPop";
  }

  @RequestMapping(value = "/viewInstallationResult.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> viewInstallationResult(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("params : {}", params);
    List<EgovMap> viewInstallation = installationResultListService.viewInstallationResult(params);
    logger.debug("viewInstallation : {}", viewInstallation);
    return ResponseEntity.ok(viewInstallation);
  }

  /**
   * Search rule book management list
   *
   * @param request
   * @param model
   * @return
   * @throws ParseException
   * @throws Exception
   */
  @RequestMapping(value = "/installationListSearch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectInstallationListSearch(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws ParseException {

    SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
    Date mthapril = null;
    //logger.debug("-------------10 salesdate---------------" + salesdate);
    mthapril =  format.parse("01-04-2015");
    logger.debug("-------------11 mthapril new---------------" + mthapril);
    //dadu hati
    String[] installStatusList = request.getParameterValues("installStatus");
    String[] typeList = request.getParameterValues("type");
    String[] appTypeList = request.getParameterValues("appType");
    String[] stkAllctList = request.getParameterValues("stkAllct");
    /* KV- DSC Code */
    String[] dscCodeList = request.getParameterValues("dscCode"); /* dscCode- kv testing */

    String product = "";
    if (!"".equals(params.get("product"))) {
      product = params.get("product").toString();
      product = product.substring(0, product.indexOf(" - "));
    }

    params.put("product", product);
    params.put("installStatusList", installStatusList);
    params.put("typeList", typeList);
    params.put("appTypeList", appTypeList);
    params.put("stkAllctList", stkAllctList);
    /* KV- DSC Code */
    params.put("dscCodeList", dscCodeList);

    List<EgovMap> installationResultList = installationResultListService.installationResultList(params);
    logger.debug("installationResultList : {}", installationResultList);
    return ResponseEntity.ok(installationResultList);
  }

  /**
   * Installation Result DetailPopup
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationResultDetailPop.do")
  public String installationResultDetail(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)  throws Exception {
    EgovMap callType = installationResultListService.selectCallType(params);
    EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
    EgovMap orderInfo = null;
    logger.debug("params1111111 {}", params);

    if (params.get("codeId").toString().equals("258")) {
      orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
    } else {
      orderInfo = installationResultListService.getOrderInfo(params);
    }

    // EgovMap customerInfo =
    // installationResultListService.getcustomerInfo(orderInfo == null
    // ?installResult.get("custId") : orderInfo.get("custId"));

    EgovMap customerInfo = installationResultListService.getcustomerInfo(orderInfo);
    // EgovMap customerAddress =
    // installationResultListService.getCustomerAddressInfo(customerInfo);
    EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
    EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
    EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
    EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
    EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);
    logger.debug("installResult : {}", installResult);
    logger.debug("orderInfo : {}", orderInfo);
    logger.debug("customerInfo : {}", customerInfo);
    logger.debug("customerContractInfo : {}", customerContractInfo);
    logger.debug("installation : {}", installation);
    logger.debug("installationContract : {}", installationContract);
    logger.debug("salseOrder : {}", salseOrder);
    logger.debug("hpMember : {}", hpMember);
    logger.debug("callType : {}", callType);
    // logger.debug("customerAddress : {}", customerAddress);
    model.addAttribute("installResult", installResult);
    model.addAttribute("orderInfo", orderInfo);
    model.addAttribute("customerInfo", customerInfo);
    // model.addAttribute("customerAddress", customerAddress);
    model.addAttribute("customerContractInfo", customerContractInfo);
    model.addAttribute("installationContract", installationContract);
    model.addAttribute("salseOrder", salseOrder);
    model.addAttribute("hpMember", hpMember);
    model.addAttribute("callType", callType);

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.put("orderDetail", orderDetail);

    // 호출될 화면
    return "services/installation/installationResultDetailPop";
  }

  /**
   * InstallationResultDetailPop View Installation Result
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/viewInstallationSearch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectViewInstallationSearch(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("params : {}", params);
    List<EgovMap> viewInstallation = installationResultListService.selectViewInstallation(params);
    logger.debug("viewInstallation : {}", viewInstallation);
    return ResponseEntity.ok(viewInstallation);
  }

  /**
   * InstallationResult Add Installation Result Popup
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/addInstallationPopup.do")
  public String addInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    /*
     * INSTALL STATUS: 1 ACTIVE 4 COMPLETED 21 FAILED
     */

    logger.debug("=====================/addInstallationPopup.do=========================");
    logger.debug("params : {}", params);
    logger.debug("=====================/addInstallationPopup.do=========================");

    params.put("ststusCodeId", 1);
    params.put("reasonTypeId", 172);

    List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
    List<EgovMap> adapterUsed = installationResultListService.adapterUsed();
    List<EgovMap> boosterUsed = installationResultListService.boosterUsed();
    List<EgovMap> failParent = installationResultListService.failParent();
    List<EgovMap> failReason = installationResultListService.selectFailReason(params);
    List<EgovMap> waterSrcType = installationResultListService.selectWaterSrcType();
    EgovMap callType = installationResultListService.selectCallType(params); // CALL
                                                                             // LOG
                                                                             // INFORMATION
    EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params); // INSTALLATION
                                                                                                    // INFORMATION
    EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult); // STOCK
                                                                                                                    // INFORMATION
    EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult); // STOCK
                                                                                                 // LOCATION

    List<EgovMap> competitorBrand = installationResultListService.selectCompetitorBrand(); //COMPETITOR BRAND [CELESTE: 20240814 - JOMTUKAR ]

    List<EgovMap> dtPairList = installationResultListService.getInstallCtPairByCtCode(installResult);

    params.put("ststusCodeId", 1);
    params.put("reasonTypeId", 172);

    EgovMap orderInfo = null;
    if (params.get("codeId").toString().equals("258")) { // PRODUCT EXCHANGE
      orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
    } else { // NEW PRODUCT INSTALLATION
      orderInfo = installationResultListService.getOrderInfo(params);
    }

    if (null == orderInfo) {
      orderInfo = new EgovMap();
    }

    String promotionId = "";
    if (CommonUtils.nvl(params.get("codeId")).toString().equals("258")) {
      promotionId = CommonUtils.nvl(orderInfo.get("c8"));
    } else {
      promotionId = CommonUtils.nvl(orderInfo.get("c2"));
    }

    if (promotionId.equals("")) {
      promotionId = "0";
    }

    logger.debug("promotionId : {}", promotionId);

    EgovMap promotionView = new EgovMap();

    List<EgovMap> CheckCurrentPromo = installationResultListService
        .checkCurrentPromoIsSwapPromoIDByPromoID(Integer.parseInt(promotionId));
    if (CheckCurrentPromo.size() > 0) {
      promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(
          Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()), true);
    } else {
      if (promotionId != "0") {
        promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(
            Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()), false);
      } else {
        // if (null == promotionView) {
        // promotionView = new EgovMap();
        // }

        promotionView.put("promoId", "0");
        promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")).toString() == "258"
            ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
        promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")).toString() == "258"
            ? CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
        promotionView.put("swapPromoId", "0");
        promotionView.put("swapPromoPV", "0");
        promotionView.put("swapPormoPrice", "0");
      }
    }

    Object custId = (orderInfo == null ? installResult.get("custId") : orderInfo.get("custId"));
    Object salesOrdNo = (orderInfo == null ? installResult.get("salesOrdNo") : orderInfo.get("salesOrdNo"));
    params.put("custId", custId);
    params.put("salesOrdNo", salesOrdNo);
    EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
    // EgovMap customerAddress =
    // installationResultListService.getCustomerAddressInfo(customerInfo);
    EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
    EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
    EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
    EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
    EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

    logger.debug("========================/addInstallationPopup.do=============================");
    logger.debug("params : {}", params);
    logger.debug("installResult : {}", installResult);
    logger.debug("orderInfo : {}", orderInfo);
    logger.debug("customerInfo : {}", customerInfo);
    logger.debug("customerContractInfo : {}", customerContractInfo);
    logger.debug("installation : {}", installation);
    logger.debug("installationContract : {}", installationContract);
    logger.debug("salseOrder : {}", salseOrder);
    logger.debug("hpMember : {}", hpMember);
    logger.debug("callType : {}", callType);
    logger.debug("failReason : {}", failReason);
    logger.debug("failParent : {}", failParent);
    logger.debug("installStatus : {}", installStatus);
    logger.debug("adapterUsed : {}", adapterUsed);
    logger.debug("boosterUsed : {}", boosterUsed);
    logger.debug("stock : {}", stock);
    logger.debug("sirimLoc : {}", sirimLoc);
    logger.debug("promotionView : {}", promotionView);
    logger.debug("CheckCurrentPromo : {}", CheckCurrentPromo);
    logger.debug("=============================================================================");

    model.addAttribute("installResult", installResult);
    model.addAttribute("orderInfo", orderInfo);
    model.addAttribute("customerInfo", customerInfo);
    model.addAttribute("installation", installation);
    model.addAttribute("customerContractInfo", customerContractInfo);
    model.addAttribute("installationContract", installationContract);
    model.addAttribute("salseOrder", salseOrder);
    model.addAttribute("hpMember", hpMember);
    model.addAttribute("callType", callType);
    model.addAttribute("failReason", failReason);
    model.addAttribute("installStatus", installStatus);
    model.addAttribute("adapterUsed", adapterUsed);
    model.addAttribute("boosterUsed", boosterUsed);
    model.addAttribute("failParent", failParent);
    model.addAttribute("stock", stock);
    model.addAttribute("sirimLoc", sirimLoc);
    model.addAttribute("CheckCurrentPromo", CheckCurrentPromo);
    model.addAttribute("promotionView", promotionView);
    model.addAttribute("waterSrcType", waterSrcType);
    // model.addAttribute("customerAddress", customerAddress);
    model.addAttribute("competitorBrand", competitorBrand);
    model.addAttribute("dtPairList", dtPairList);

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//
    model.put("orderDetail", orderDetail);

    // Added Labour charge (like AS) by Hui Ding, 2021-03-11
    EgovMap sstInfo = commonService.getSstRelatedInfo();
    List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr(sstInfo);
    model.addAttribute("lbrFeeChr", lbrFeeChr);

  //List<EgovMap> fltPmtTyp = new ArrayList<EgovMap>();
    List<EgovMap> fltPmtTyp = ASManagementListService.selectFltPmtTyp();

    /*EgovMap pmtType = new EgovMap();
    pmtType.put("codeId", "FOC");
    pmtType.put("codeName", "Free of Charge");
    fltPmtTyp.add(pmtType);*/

    model.addAttribute("fltPmtTyp", fltPmtTyp);

    List<EgovMap> fltQty = ASManagementListService.selectFltQty();
    model.addAttribute("fltQty", fltQty);

    // 호출될 화면
    return "services/installation/addInstallationResultPop";
  }

  /**
   * Installation Result DetailPopup
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/addinstallationResultProductDetailPop.do")
  public String installationResultProductExchangeDetail(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVOl) throws Exception {

    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");
    logger.debug("params : {}", params);
    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");

    EgovMap viewDetail = installationResultListService.selectViewDetail(params);
    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVOl);
    model.addAttribute("viewDetail", viewDetail);
    model.addAttribute("orderDetail", orderDetail);

    List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
    List<EgovMap> adapterUsed = installationResultListService.adapterUsed();
    List<EgovMap> failParent = installationResultListService.failParent();
    List<EgovMap> failReason = installationResultListService.selectFailReason(params);
    List<EgovMap> waterSrcType = installationResultListService.selectWaterSrcType();
    params.put("ststusCodeId", 1);
    params.put("reasonTypeId", 172);
   // List<EgovMap> failReason = installationResultListService.selectFailReason(params);
    EgovMap callType = installationResultListService.selectCallType(params);
    EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
    EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
    EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);
    EgovMap orderInfo = null;
    List<EgovMap> dtPairList = installationResultListService.getInstallCtPairByCtCode(installResult);

    if (params.get("codeId").toString().equals("258")) {
      orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
    } else {
      orderInfo = installationResultListService.getOrderInfo(params);
    }

    if (null == orderInfo) {
      orderInfo = new EgovMap();
    }

    String promotionId = "";
    if (CommonUtils.nvl(params.get("codeId")).toString().equals("258")) {
      promotionId = CommonUtils.nvl(orderInfo.get("c8"));
    } else {
      promotionId = CommonUtils.nvl(orderInfo.get("c2"));
    }

    if (promotionId.equals("")) {
      promotionId = "0";
    }

    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");
    logger.debug("Promotion ID : {}", promotionId);
    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");

    EgovMap promotionView = new EgovMap();

    List<EgovMap> CheckCurrentPromo = installationResultListService
        .checkCurrentPromoIsSwapPromoIDByPromoID(Integer.parseInt(promotionId));
    if (CheckCurrentPromo.size() > 0) {
      promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(
          Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()), true);
    } else {
      if (promotionId != "0") {
        promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(
            Integer.parseInt(promotionId), Integer.parseInt(installResult.get("installStkId").toString()), false);

      } else {

        // if (null == promotionView) {
        // promotionView = new EgovMap();
        // }

        promotionView.put("promoId", "0");
        promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")).toString() == "258"
            ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
        promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")).toString() == "258"
            ? CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
        promotionView.put("swapPromoId", "0");
        promotionView.put("swapPromoPV", "0");
        promotionView.put("swapPormoPrice", "0");
      }
    }

    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");
    logger.debug("New Params {}", params);
    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");

    Object custId = (orderInfo == null ? installResult.get("custId") : orderInfo.get("custId"));
    params.put("custId", custId);
    EgovMap customerInfo = installationResultListService.getcustomerInfo(params);
    // EgovMap customerAddress =
    // installationResultListService.getCustomerAddressInfo(customerInfo);
    EgovMap customerContractInfo = installationResultListService.getCustomerContractInfo(customerInfo);
    EgovMap installation = installationResultListService.getInstallationBySalesOrderID(installResult);
    EgovMap installationContract = installationResultListService.getInstallContactByContactID(installation);
    EgovMap salseOrder = installationResultListService.getSalesOrderMBySalesOrderID(installResult);
    EgovMap hpMember = installationResultListService.getMemberFullDetailsByMemberIDCode(salseOrder);

    // if(params.get("codeId").toString().equals("258")){
    // }

    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");
    logger.debug("INSTALLATION RESULT : {}", installResult);
    logger.debug("ORDER INFO : {}", orderInfo);
    logger.debug("CUSTOMER INFO. : {}", customerInfo);
    logger.debug("CUSTOMER CONTACT NUMBER : {}", customerContractInfo);
    logger.debug("INSTALLATION : {}", installation);
    logger.debug("INSTALLATION CONTRACT : {}", installationContract);
    logger.debug("SALES ORDER : {}", salseOrder);
    logger.debug("HP MEMBER : {}", hpMember);
    logger.debug("CALL TYPE : {}", callType);
    logger.debug("FAIL REASON : {}", failReason);
    logger.debug("INSTALL STATUS : {}", installStatus);
    logger.debug("STOCK : {}", stock);
    logger.debug("SIRIM LOC. : {}", sirimLoc);
    logger.debug("PROMOTION VIEW : {}", promotionView);
    logger.debug("CURRENT PROMO : {}", CheckCurrentPromo);
    logger.debug("=====================/addinstallationResultProductDetailPop.do=========================");

    // logger.debug("customerAddress : {}", customerAddress);
    // model.addAttribute("customerAddress", customerAddress);
    // RETURN RESULT TO FRONTEND
    model.addAttribute("installResult", installResult);
    model.addAttribute("orderInfo", orderInfo);
    model.addAttribute("customerInfo", customerInfo);
    model.addAttribute("customerContractInfo", customerContractInfo);
    model.addAttribute("installation", installation);
    model.addAttribute("installationContract", installationContract);
    model.addAttribute("salseOrder", salseOrder);
    model.addAttribute("hpMember", hpMember);
    model.addAttribute("callType", callType);
    model.addAttribute("failReason", failReason);
    model.addAttribute("installStatus", installStatus);
    model.addAttribute("adapterUsed", adapterUsed);
    model.addAttribute("failParent", failParent);
    model.addAttribute("stock", stock);
    model.addAttribute("sirimLoc", sirimLoc);
    model.addAttribute("CheckCurrentPromo", CheckCurrentPromo);
    model.addAttribute("promotionView", promotionView);
    model.addAttribute("waterSrcType", waterSrcType);
    model.addAttribute("dtPairList", dtPairList);

    return "services/installation/addInstallationResultProductDetailPop";
  }

  /**
   * Search rule book management list
   *
   * @param request
   * @param model
   * @return
   * @throws ParseException
   * @throws Exception
   */
  @RequestMapping(value = "/saveInstallationProductExchange.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertInstallationProductExchange(@RequestBody Map<String, Object> params,
      SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params : {}", params);

    boolean success = false;

    success = installationResultListService.insertInstallationProductExchange(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  /**
   * Search rule book management list
   *
   * @param requestaddInstallation
   * @param model
   * @return
   * @throws ParseException
   * @throws Exception
   */
  @RequestMapping(value = "/addInstallation.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertInstallationResult(@RequestBody Map<String, Object> params,
      SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    Map<String, Object> resultValue = new HashMap<String, Object>();
    logger.debug("params : {}", params);

    boolean success = false;
    EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
    // EgovMap locInfo =
    // installationResultListService.getLocInfo(installResult);
    logger.debug("installResult : {}" + installResult);

    Map<String, Object> locInfoEntry = new HashMap<String, Object>();
    locInfoEntry.put("CT_CODE", installResult.get("ctMemCode"));
    locInfoEntry.put("STK_CODE", installResult.get("installStkId"));
    logger.debug("locInfoEntry : {}" + locInfoEntry);
    EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);
    logger.debug("locInfo : {}" + locInfo);

    EgovMap validMap = installationResultListService.validationInstallationResult(params);
    int resultCnt = ((BigDecimal) validMap.get("resultCnt")).intValue();

    // failed add by hgham
    if (CommonUtils.nvl(params.get("installStatus")).equals("21")) {

      if (resultCnt > 0) {
        message.setMessage("There is complete result exist already, 'ResultID : " + validMap.get("resultId")
            + ". Can't save the result again");
      } else {
        resultValue = installationResultListService.insertInstallationResult(params, sessionVO);
        if (null != resultValue) {
          HashMap<String, Object> spMap = (HashMap<String, Object>) resultValue.get("spMap");
          logger.debug("spMap :" + spMap.toString());
          if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
            resultValue.put("logerr", "Y");
            message.setMessage("Error in Logistics Transaction !");
          } else {
            message.setData("Y");
            message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));
          }
          servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
        }
      }

    } else {
      // if(locInfo==null){
      // message.setMessage("Can't complete the Installation without available
      // stock in the CT");
      // }else{
      // if(Integer.parseInt(locInfo.get("availQty").toString())<1){
      // message.setMessage("Can't complete the Installation without available
      // stock in the CT");
      // }else{

      if (resultCnt < 0) {
        message.setMessage("There is complete result exist already, 'ResultID : " + validMap.get("resultId")
            + ". Can't save the result again");
      } else {
        resultValue = installationResultListService.insertInstallationResult(params, sessionVO);

        if (null != resultValue) {
          HashMap<String, Object> spMap = (HashMap<String, Object>) resultValue.get("spMap");
          logger.debug("spMap :" + spMap.toString());
          if (!"000".equals(spMap.get("P_RESULT_MSG"))) {

            resultValue.put("logerr", "Y");
            message.setMessage("Error in Logistics Transaction !");

          } else {
            message.setData("Y");
            message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));

          }
          servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
        }
      }
      // }
      // }

    }

    return ResponseEntity.ok(message);
  }

  /**
   * Search rule book management list
   *
   * @param requestaddInstallation
   * @param model
   * @return
   * @throws ParseException
   * @throws Exception
   */
  @SuppressWarnings("unchecked")
@RequestMapping(value = "/addInstallation_2.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertInstallationResult_2(@RequestBody Map<String, Object> params,
      SessionVO sessionVO) throws ParseException {

	ASManagementListService.insertASResultLog(params.toString(), "/addInstallation_2.do", null, sessionVO.getUserId());

    ReturnMessage message = new ReturnMessage();
    Map<String, Object> resultValue = new HashMap<String, Object>();
    Map<String, Object> resultValuePexRtn = new HashMap<String, Object>();
//    Map<String, Object> smsResultValue = new HashMap<String, Object>();

    logger.debug("==========================/addInstallation_2.do=================================");
    logger.debug("params : {}", params);
    logger.debug("==========================/addInstallation_2.do=================================");

    List<EgovMap> add = (List<EgovMap>) params.get("add");
    Map<String, Object> param = (Map<String, Object>)params.get("installForm");

    List<Map<String, Object>> addList = (List<Map<String, Object>>) params.get("add");
    List<String> installAccList = (List<String>) params.get("installAccList");

    int noRcd = installationResultListService.chkRcdTms(param);

    if (noRcd == 1) {
      EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(param);

      logger.debug("INSTALLATION RESULT : {}" + installResult);

      param.put("EXC_CT_ID", installResult.get("ctId"));
      param.put("salesOrderNo", installResult.get("salesOrdNo")); //Added by keyi
      param.put("ctMemCode", installResult.get("ctMemCode")); //Added by keyi

      Map<String, Object> locInfoEntry = new HashMap<String, Object>();
      locInfoEntry.put("CT_CODE", installResult.get("ctMemCode"));
      locInfoEntry.put("STK_CODE", installResult.get("installStkId"));

      logger.debug("LOC. INFO. ENTRY : {}" + locInfoEntry);

      EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);

      logger.debug("LOC. INFO. : {}" + locInfo);

      if (locInfo == null) {
        message.setMessage("Fail to update result. [CT lack of stock]");
      } else {
        if (Integer.parseInt(locInfo.get("availQty").toString()) < 1) {
          message.setMessage("Fail to update result. [CT lack of stock]");
        } else {
          EgovMap validMap = installationResultListService.validationInstallationResult(param);
          int resultCnt = ((BigDecimal) validMap.get("resultCnt")).intValue();

          if (resultCnt > 0) {
            message.setMessage("Record already exist. Please refer ResultID : " + validMap.get("resultId") + ".");
          } else {
            // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
            resultValue = installationResultListService.runInstSp(param, sessionVO, "1");
          }

          if (null != resultValue && !resultValue.isEmpty()) {
            HashMap<String, Object> spMap = (HashMap<String, Object>) resultValue.get("spMap");
            logger.debug("spMap :" + spMap.toString());
            if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))
                && !"741".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
              resultValue.put("logerr", "Y");
              message.setMessage("Error Encounter. Please Contact Administrator. Error Code(INS1): "
                  + spMap.get("P_RESULT_MSG").toString());
            } else { // SUCCESS
              if ("000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) {
                servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
              }
              String ordStat = installationResultListService.getSalStat(param);

              if (!"1".equals(ordStat)) {
                if (param.get("hidCallType").equals("258")) {
                  int exgCode = installationResultListService.chkExgRsnCde(param);
                  // SKIP SOEXC009 - EXCHANGE (WITHOUT RETURN)
                  if (exgCode == 0) { // PEX EXCHANGE CODE NOT IN THE LIST
                    if (Integer.parseInt(param.get("installStatus").toString()) == 4) {
                      // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
                      resultValue = installationResultListService.runInstSp(param, sessionVO, "2");

                      if (null != resultValue) {
                        spMap = (HashMap<String, Object>) resultValue.get("spMap");
                        logger.debug("spMap :" + spMap.toString());
                        if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))
                            && !"".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
                          resultValue.put("logerr", "Y");
                          message.setMessage("Error Encounter. Please Contact Administrator. Error Code(INS2): "
                              + spMap.get("P_RESULT_MSG").toString());
                        } else {
                          servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);

                          // resultValue =
                          // installationResultListService.runInstSp(params,
                          // sessionVO, "3");

                          // if (null != resultValue) {
                          // spMap = (HashMap) resultValue.get("spMap");
                          // logger.debug("spMap :" + spMap.toString());
                          // if (!"000".equals(spMap.get("P_RESULT_MSG"))) { //
                          // FAIL
                          // resultValue.put("logerr", "Y");
                          // message.setMessage("Error Encounter. Please Contact
                          // Administrator. Error Code(INS3): " +
                          // spMap.get("P_RESULT_MSG").toString());
                          // } else {
                          // servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
                          // }
                          // }
                        }
                      }
                    }
                  }
                }
              }


              resultValue = installationResultListService.insertInstallationResult_2(param, sessionVO);

              // Added for inserting charge out filters and spare parts at AS. By Hui Ding, 06-04-2021
              if (resultValue.get("value") != null && resultValue.get("value").equals("Completed")){

            	  if (param.get("chkCrtAS") != null && (param.get("chkCrtAS").toString().equals("on") || param.get("chkCrtAS").toString().equals("Y"))){

            		  // change format from
            		  String appntDtFormatted = null;

            		  logger.info("### appointment date before: " + installResult.get("appntDt"));

            		  if (installResult.get("appntDt") != null){
            			  Date appntDtOri = new SimpleDateFormat("yyyy-MM-dd").parse(installResult.get("appntDt").toString());
            			  appntDtFormatted = CommonUtils.getFormattedString("dd/MM/yyyy", appntDtOri);
            			  installResult.put("appntDt", appntDtFormatted); // format date (in string) to dd/MM/yyyy format
            		  }

            		  logger.info("### appointment date after: " + installResult.get("appntDt"));

            		  installationResultListService.saveInsAsEntry(addList, param, installResult, sessionVO.getUserId());
            	  }

            	  if (param.get("chkInstallAcc") != null && (param.get("chkInstallAcc").toString().equals("on") || param.get("chkInstallAcc").toString().equals("Y"))){
                  try {
                    installationResultListService.insertInstallationAccessories(installAccList,installResult,sessionVO.getUserId());
                  } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                  }
                }

              }
              // End of inserting charge out filters and spare parts at AS

              message.setCode("1");
              message.setData("Y");
              String msg = "";
              if (Integer.parseInt(param.get("installStatus").toString()) == 21) {
                msg = "Installation No. (" + resultValue.get("installEntryNo") + ") successfully updated to "
                        + resultValue.get("value") + ". Please proceed to Calllog function.";
              } else {
            	  msg = "Installation No. (" + resultValue.get("installEntryNo")
                  + ") successfully updated to " + resultValue.get("value") + ".";

                message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));
              }

              /*String chksms = "";
              if (CommonUtils.nvl(param.get("chkSms")).equals("on")){
            	  chksms = "Y";
              }else{
            	  chksms = "N";
              }
              param.put("chkSms", chksms);
              param.put("ctCode", CommonUtils.nvl(installResult.get("ctMemCode")));
              param.put("salesOrderNo", CommonUtils.nvl(installResult.get("salesOrdNo")));
              param.put("creator", sessionVO.getUserId());
              String checkSend = "";
              if (CommonUtils.nvl(param.get("checkSend")).equals("on")){
            	  checkSend = "Y";
              }else{
            	  checkSend = "N";
              }
              param.put("checkSend", checkSend);


        	  try{
        		  smsResultValue = installationResultListService.installationSendSMS(CommonUtils.nvl(param.get("hidAppTypeId").toString()), param);
        	  }catch (Exception e){
        		  logger.info("===smsResultValue111===" + smsResultValue.toString());
        	  }
        	  if(CommonUtils.nvl(smsResultValue.get("smsLogStat")) == "3"){
        		  msg += "</br> Failed to send SMS to " + CommonUtils.nvl(param.get("custMobileNo")).toString();
        	  }
*/
        	  message.setMessage(msg);
            }
          }
        }
      }
    } else {
      message.setMessage(
          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/assignCTTransferPop.do")
  public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("=====================assignCTTransferPop=======================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("=====================assignCTTransferPop=======================");

    model.addAttribute("serialList", installationResultListService.selectCtSerialNoList(params));
    model.addAttribute("rcdTms", CommonUtils.nvl(params.get("rcdTms")));

    return "services/installation/assignCTTransferPop";
  }

  @RequestMapping(value = "/assignCtList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignCtList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("=====================assignCtList=======================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("=====================assignCtList=======================");

    // BRNCH_ID
    List<EgovMap> list = installationResultListService.assignCtList(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/parentList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> parentList(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {

    logger.debug("=====================assignCtList=======================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("=====================assignCtList=======================");
    List<EgovMap> failParent = installationResultListService.failParent();

    return ResponseEntity.ok(failParent);
  }

  @RequestMapping(value = "/adapterList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> adapterList(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {

    logger.debug("=====================assignCtList=======================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("=====================assignCtList=======================");
    List<EgovMap> adapterUsed = installationResultListService.adapterUsed();

    return ResponseEntity.ok(adapterUsed);
  }

  @RequestMapping(value = "/boosterList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> boosterList(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {

    logger.debug("=====================boosterList=======================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("=====================boosterList=======================");
    List<EgovMap> boosterUsed = installationResultListService.boosterUsed();

    return ResponseEntity.ok(boosterUsed);
  }

  @RequestMapping(value = "/instChkLst.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> instChkLst(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {

    List<EgovMap> instChkLst = installationResultListService.instChkLst();

    logger.debug("=====================instChkLst=======================");
    logger.debug(" instChkLst :: " + instChkLst);
    logger.debug("=====================instChkLst=======================");
    return ResponseEntity.ok(instChkLst);
  }

  @RequestMapping(value = "/assignCtOrderList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignCtOrderList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("=====================assignCtOrderList=======================");
    logger.debug(" PARAM :: ", params.toString());
    logger.debug("=====================assignCtOrderList=======================");

    String vAsNo = (String) params.get("installNo");
    String[] asNo = null;

    if (!StringUtils.isEmpty(vAsNo)) {
      asNo = ((String) params.get("installNo")).split(",");
      params.put("installNo", asNo);
    }

    List<EgovMap> list = installationResultListService.assignCtOrderList(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/assignCtOrderListSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> assignCtOrderListSave(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {

    logger.debug("==================assignCtOrderListSave==========================");
    logger.debug(" PARAM :: " + params.toString());

    params.put("updator", sessionVO.getUserId());
    List<EgovMap> update = (List<EgovMap>) params.get("update");

    logger.debug(" UPDATE RESULT :: " + update.toString());

    Map<String, Object> returnValue = new HashMap<String, Object>();
    returnValue = installationResultListService.updateAssignCT(params);

    logger.debug(" RETURN RESULT :: " + returnValue);

    String content = "";
    String successCon = "";
    String failCon = "";

    int successCnt = 0;
    int failCnt = 0;
    successCnt = Integer.parseInt(returnValue.get("successCnt").toString());
    failCnt = Integer.parseInt(returnValue.get("failCnt").toString());
    content = "[ Complete Count : " + successCnt + ", Fail Count : " + failCnt + " ]";

    List<String> successList = new ArrayList<String>();
    List<String> failList = new ArrayList<String>();
    successList = (List<String>) returnValue.get("successList");
    failList = (List<String>) returnValue.get("failList");

    if (successCnt > 0) {
      content += "<br/>Complete INS Number : ";
      for (int i = 0; i < successCnt; i++) {
        successCon += successList.get(i) + ", ";
      }
      successCon = successCon.substring(0, successCon.length() - 2);
      content += successCon;
    }

    if (failCnt > 0) {
      content += "<br/>Fail INS Number : ";
      for (int i = 0; i < failCnt; i++) {
        failCon += failList.get(i) + ", ";
      }
      failCon = failCon.substring(0, failCon.length() - 2);
      content += failCon;
      content += "<br/>Can't transfer CT to the Installation order. <br/>Please refer to job transfer failure report.";
    }

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(99);
    message.setMessage(content);

    /*
     * if (rtnValue == -1) { message.setCode(AppConstants.FAIL); message.setMessage("Can't transfer CT to the Installation order"); } else { message.setCode(AppConstants.SUCCESS); message.setData(99); message.setMessage(""); }
     */

    logger.debug("message : {}", message);
    logger.debug("==================assignCtOrderListSave==========================");

    return ResponseEntity.ok(message);

  }

  /**
   * organization transfer page
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationNotePop.do")
  public String installationNotePop(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> instTypeList = installationResultListService.selectInstallationType();
    List<EgovMap> installStatus = installationResultListService.selectInstallStatus();

    logger.debug("===========================installationNotePop.do=====================================");
    logger.debug(" INSTALLATION TYPE : {}", instTypeList);
    logger.debug(" INSTALLATION STATUS : {}", installStatus);
    logger.debug("===========================installationNotePop.do=====================================");

    model.addAttribute("instTypeList", instTypeList);
    model.addAttribute("installStatus", installStatus);
    return "services/installation/installationNotePop";
  }

  /**
   * Installation Report Do Active List
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/doActiveListPop.do")
  public String doActiveListPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/installation/doActiveListPop";
  }

  /**
   * Installation Report Do Active List
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/dailyDscReportPop.do")
  public String dailyDscReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/installation/dailyDscReportPop";
  }

  /**
   * Installation Report Installation Raw Data
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationRawDataPop.do")
  public String installationRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {

	  List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
	  List<EgovMap> dscCodeList = installationResultListService.selectDscCode();

	  model.addAttribute("installStatus", installStatus);
	  model.addAttribute("dscCodeList", dscCodeList);

    // 호출될 화면
    return "services/installation/installationRawDataPop";
  }

  /**
   * Installation Report Installation Log Book Listing
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationLogBookPop.do")
  public String installationLogBookPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/installation/installationLogBookListingPop";
  }

  /**
   * Installation Report Installation Note Listing
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationNoteListingPop.do")
  public String installationNoteListingPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "services/installation/installationNoteListingPop";
  }

  /**
   * Installation Report Installation Note Listing Search
   *
   * @param request
   * @param model
   * @return
   * @throws ParseException
   * @throws Exception
   */
  @RequestMapping(value = "/selectInstallationNoteListing.do")
  public ResponseEntity<List<EgovMap>> selectInstallationNoteListing(@RequestParam Map<String, Object> params,
      SessionVO sessionVO) throws ParseException {
    logger.debug("params : {}", params);
    installationResultListService.selectInstallationNoteListing(params);

    List<EgovMap> list = (List<EgovMap>) params.get("cv_1");
    logger.debug("list : {}", list);
    return ResponseEntity.ok(list);
  }

  /**
   * Installation Report Installation Free Gift List
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationFreeGiftListPop.do")
  public String installationFreeGiftListPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/installation/installationFreeGiftListPop";
  }

  /**
   * Installation Report Installation Free Gift List
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/installationDscReportPop.do")
  public String installationDscReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/installation/dscReportDataPop";
  }

  /**
   * InstallationResult edit Installation Result Popup
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/editInstallationPopup.do")
  public String editInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    logger.debug("params : {}", params);
    EgovMap installInfo = installationResultListService.selectInstallInfo(params);
    model.addAttribute("installInfo", installInfo);

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//
    model.put("orderDetail", orderDetail);
    model.put("codeId", params.get("codeId"));

    EgovMap orderInfo = null;

    if (params.get("codeId").toString().equals("258")) {
      orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
    } else {
      orderInfo = installationResultListService.getOrderInfo(params);
    }

    model.put("orderInfo", orderInfo);

    List<EgovMap> installAcc = installationResultListService.selectInstallAccWithInstallEntryId(params);

    List<String> installAccValues = new ArrayList<>();

    for (EgovMap map : installAcc) {
        Object value = map.get("insAccPartId");
        if (value != null) {
            installAccValues.add(value.toString());
        }
    }

    model.put("installAccValues", installAccValues);

    List<EgovMap> competitorBrand = installationResultListService.selectCompetitorBrand(); //COMPETITOR BRAND [CELESTE: 20240814 - JOMTUKAR ]
    model.put("competitorBrand", competitorBrand);

    // 호출될 화면
    return "services/installation/editInstallationResultPop";
  }

  /**
   * InstallationResult fail Installation Result Popup
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/ failInstallationPopup.do")
  public String failInstallationPopup(@RequestParam Map<String, Object> params, ModelMap model , SessionVO sessionVO) throws Exception {


	List<EgovMap> failParent = installationResultListService.failParent();

    EgovMap installInfo = installationResultListService.selectInstallInfo(params);
    model.addAttribute("installInfo", installInfo);

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//
    model.put("orderDetail", orderDetail);
    model.put("codeId", params.get("codeId"));

    EgovMap orderInfo = null;

    if (params.get("codeId").toString().equals("258")) {
      orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
    } else {
      orderInfo = installationResultListService.getOrderInfo(params);
    }

 //   model.addAttribute("adapterUsed", adapterUsed);
    model.addAttribute("failParent", failParent);

    model.put("orderInfo", orderInfo);

    // 호출될 화면
    return "services/installation/failInstallationResultPop";
  }

  @RequestMapping(value = "/editInstallation.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> editInstallationResult(@RequestBody Map<String, Object> params,  SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    int resultValue = 0;

    int userId = sessionVO.getUserId();
    params.put("user_id", userId);
    logger.debug("params : {}", params);

    resultValue = installationResultListService.editInstallationResult(params, sessionVO);
    if (resultValue > 0) {
      message.setMessage("Installation result successfully updated.");
    } else {
      message.setMessage("Failed to update installation result. Please try again later.");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/failInstallation.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> failInstallationResult(@RequestBody Map<String, Object> params,
      SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    int resultValue = 0;

    int userId = sessionVO.getUserId();
    params.put("user_id", userId);
    logger.debug("params : {}", params);

    resultValue = installationResultListService.failInstallationResult(params, sessionVO);
    if (resultValue > 0) {
      message.setMessage("Installation result successfully updated.");
    } else {
      message.setMessage("Failed to update installation result. Please try again later.");
    }

    return ResponseEntity.ok(message);
  }

	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
	 	logger.debug("params111 : {}", params);
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

    		//List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "Services" + File.separator + "installation", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
    		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, "service/web/installation", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
    		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

    		installationApplication.insertInstallationAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

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

	@RequestMapping(value = "/attachFileUploadEdit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUploadEdit(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
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

            List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, "service/web/installation", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
      	    params.put(CommonConstants.USER_ID, sessionVO.getUserId());

    		    installationApplication.insertInstallationAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

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


	@RequestMapping(value = "/attachFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
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

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "sales" + File.separator + "preOrder", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
      params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			installationApplication.updateInstallationAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

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


	@RequestMapping(value = "/registerPreOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerPreOrder(@RequestBody PreOrderVO preOrderVO, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		preOrderService.insertPreOrder(preOrderVO, sessionVO);

		String msg = "", appTypeName = "";

		switch(preOrderVO.getAppTypeId()) {
    		case SalesConstants.APP_TYPE_CODE_ID_RENTAL :
    			appTypeName = SalesConstants.APP_TYPE_CODE_RENTAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT :
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT :
    			appTypeName = SalesConstants.APP_TYPE_CODE_INSTALLMENT_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SPONSOR :
    			appTypeName = SalesConstants.APP_TYPE_CODE_SPONSOR_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_SERVICE :
    			appTypeName = SalesConstants.APP_TYPE_CODE_SERVICE_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_EDUCATION :
    			appTypeName = SalesConstants.APP_TYPE_CODE_EDUCATION_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL :
    			appTypeName = SalesConstants.APP_TYPE_CODE_FREE_TRIAL_FULL;
    			break;
    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS :
    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS_FULL;
    			break;
    		default :
    			break;
    	}

        msg += "Order successfully saved.<br />";
        msg += "SOF No : " + preOrderVO.getSofNo() + "<br />";
        msg += "Application Type : " + appTypeName + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/updateFileKey.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updateFileKey(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws ParseException {
	    ReturnMessage message = new ReturnMessage();
	    int resultValue = 0;

	    EgovMap fileID = new EgovMap();

	    Map<String, Object> locInfoEntry = new HashMap<String, Object>();
	    int userId = sessionVO.getUserId();
	    params.put("user_id", userId);
	    params.put("resultId", CommonUtils.nvl(params.get("resultId")));
	    params.put("StkId", CommonUtils.nvl(params.get("hidStkId")));
	    params.put("atchFileGrpId", CommonUtils.nvl(params.get("fileGroupKey")));
	    params.put("SalesOrderId", CommonUtils.nvl(params.get("SalesOrderId")));
	    params.put("installDt", CommonUtils.nvl(params.get("installdt")));
	    params.put("installEntryId", CommonUtils.nvl(params.get("installEntryId")));

	    locInfoEntry.put("userId", sessionVO.getUserId());

	    EgovMap locInfo = (EgovMap) installationResultListService.getFileID(locInfoEntry);
      params.put("atchFileGrpId", locInfo.get("atchFileGrpId"));

	    resultValue = installationResultListService.updateInstallFileKey(params, sessionVO);

	    return ResponseEntity.ok(message);
	  }



  @RequestMapping(value = "/checkMonth.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkMonthInstallation(@RequestParam Map<String, Object> params,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params : {}", params);

    EgovMap isPossibleMonth = installationResultListService.checkMonthInstallDate(params);

    if (isPossibleMonth != null) {
      message.setCode(AppConstants.SUCCESS);
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage("Please choose this month only");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getProductList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getProductList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = installationResultListService.getProductList(params);
    return ResponseEntity.ok(codeList);
  }

  /**
   * Get product with specific criteria
   *
   * @Date Apr 12, 2021
   * @Author HQIT-HUIDING
   * @param params
   * @return
   */
  @RequestMapping(value = "/getProductList2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getProductList2(@RequestParam Map<String, Object> params) {

	  String param = (String) params.get("prodCat");
		String[] prodCatList = param.split("∈");
		logger.debug("### product cat list: ", prodCatList.length);

		params.put("prodCat", prodCatList);

    List<EgovMap> codeList = installationResultListService.getProductList2(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selRcdTms.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkRcdTms(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/selRcdTms.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/selRcdTms.do=======================");

    int noRcd = installationResultListService.selRcdTms(params);

    if (noRcd == 1) {
      message.setMessage("OK");
      message.setCode("1");
    } else {
      message.setMessage(
          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }
    return ResponseEntity.ok(message);
  }

  // KR-OHK add serial add
  @RequestMapping(value = "/selectCtSerialNoList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCtSerialNoList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("==================/selectCtSerialNoList.do=======================");
    logger.debug("params : {}", params);
    logger.debug("==================/selectCtSerialNoList.do=======================");

    List<EgovMap> list = installationResultListService.selectCtSerialNoList(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/selectFailChild.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectFailChild(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("selectFailChild params : {}", params);
    List<EgovMap> selectFailChild = installationResultListService.selectFailChild(params);

    logger.debug("==========================/selectFailChild.do=================================");
    logger.debug("selectFailChild params : {}", selectFailChild);
    logger.debug("==========================/selectFailChild.do=================================");

    return ResponseEntity.ok(selectFailChild);
  }

  // KR-OHK add serial add
  @RequestMapping(value = "/addInstallationSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> addInstallationSerial(@RequestBody Map<String, Object> params,
      SessionVO sessionVO) throws ParseException {

    ReturnMessage message = new ReturnMessage();

	  ASManagementListService.insertASResultLog(params.toString(), "/addInstallationSerial.do", null, sessionVO.getUserId());

    logger.debug("==========================/addInstallationSerial.do=================================");
    logger.debug("params : {}", params);
    logger.debug("==========================/addInstallationSerial.do=================================");

    message = installationResultListService.insertInstallationResultSerial(params, sessionVO);

    return ResponseEntity.ok(message);
  }

  // KR-OHK add serial add
  @RequestMapping(value = "/editInstallationSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> editInstallationSerial(@RequestBody Map<String, Object> params,
      SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    int resultValue = 0;

    int userId = sessionVO.getUserId();
    params.put("user_id", userId);
    logger.debug("params : {}", params);

    resultValue = installationResultListService.editInstallationResultSerial(params, sessionVO);
    if (resultValue > 0) {
      message.setMessage("Installation result successfully updated.");
    } else {
      message.setMessage("Failed to update installation result. Please try again later.");
    }

    return ResponseEntity.ok(message);
  }

  // KR-OHK add serial add
  @RequestMapping(value = "/assignCtOrderListSaveSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> assignCtOrderListSaveSerial(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {

    logger.debug("==================assignCtOrderListSaveSerial==========================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("==================assignCtOrderListSaveSerial==========================");

    params.put("updator", sessionVO.getUserId());

    List<EgovMap> update = (List<EgovMap>) params.get("update");
    logger.debug(" RESULT :: " + update.toString());

    Map<String, Object> returnValue = new HashMap<String, Object>();
    returnValue = installationResultListService.updateAssignCTSerial(params);

    logger.debug(" SP RESULT :: " + returnValue);

    String content = "";
    String successCon = "";
    String failCon = "";

    int successCnt = 0;
    int failCnt = 0;

    successCnt = Integer.parseInt(returnValue.get("successCnt").toString());
    failCnt = Integer.parseInt(returnValue.get("failCnt").toString());
    content = "[ Total Complete CT's Job Transfer : " + successCnt + ", Total Fail CT's Job Transfer : " + failCnt
        + " ]";

    List<String> successList = new ArrayList<String>();
    List<String> failList = new ArrayList<String>();

    successList = (List<String>) returnValue.get("successList");
    failList = (List<String>) returnValue.get("failList");

    if (successCnt > 0) {
      content += "<br/>Complete INS Number : ";
      for (int i = 0; i < successCnt; i++) {
        successCon += successList.get(i) + ", ";
      }
      successCon = successCon.substring(0, successCon.length() - 2);
      content += successCon;
    }

    if (failCnt > 0) {
      content += "<br/>Fail INS Number : ";
      for (int i = 0; i < failCnt; i++) {
        failCon += failList.get(i) + ", ";
      }
      failCon = failCon.substring(0, failCon.length() - 2);
      content += failCon;
      content += "<br/>Can't transfer CT to the Installation order.<br/> Please refer to job transfer failure report.";
    }

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(99);
    message.setMessage(content);

    /*
     * if (rtnValue == -1) { message.setCode(AppConstants.FAIL); message.setMessage("Can't transfer CT to the Installation order"); } else { message.setCode(AppConstants.SUCCESS); message.setData(99); message.setMessage(""); }
     */

    logger.debug("message : {}", message);
    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/installationCallLogRawPop.do")
  public String installationCallLogRawPop(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> instcallLogTyp = orderCallListService.selectCallLogTyp();
    List<EgovMap> instcallLogSta = orderCallListService.selectCallLogSta();
    List<EgovMap> instcallLogStatus = installationResultListService.selectInstallStatus();

    model.addAttribute("instcallLogTyp", instcallLogTyp);
    model.addAttribute("instcallLogSta", instcallLogSta);
    model.addAttribute("instcallLogStatus", instcallLogStatus);
    return "services/installation/installationCallLogRawPop";
  }

  @RequestMapping(value = "/installationJobTransListPop.do")
  public String installationJobTransListPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "services/installation/installationJobTransListPop";
  }

  @RequestMapping(value = "/waterEnvironmentList.do")
  public String waterEnvironmentList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    List<EgovMap> appTypeList = installationResultListService.selectApplicationType();
    List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
    List<EgovMap> dscCodeList = installationResultListService.selectDscCode();
    List<EgovMap> failParent = installationResultListService.failParent();


    model.addAttribute("resultAppTypeList", appTypeList);
    model.addAttribute("resultStatus", installStatus);
    model.addAttribute("resultDscCodeList", dscCodeList);
    model.addAttribute("failParent", failParent);

    return "services/installation/waterEnvironmentList";
  }

  @RequestMapping(value = "/waterEnvironmentListSearch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> waterEnvironmentListSearch(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws ParseException {

    String[] resultTypeList = request.getParameterValues("resultType");
    String[] typeCodeList = request.getParameterValues("typeCode");
    String[] resultStatusList = request.getParameterValues("resultStatus");
    String[] resultAppTypeList = request.getParameterValues("resultAppType");
    String[] resultfailChildCodeList = request.getParameterValues("resultfailChildCode");
    String[] cmbProductList = request.getParameterValues("cmbProductList");
    String[] DSCCodeList = request.getParameterValues("DSCCodeList");
    String[] adptCodeList = request.getParameterValues("adptCode");
    String[] resultCityList = request.getParameterValues("resultCity");

    params.put("resultTypeList", resultTypeList);
    params.put("typeCodeList", typeCodeList);
    params.put("resultStatusList", resultStatusList);
    params.put("resultAppTypeList", resultAppTypeList);
    params.put("resultfailChildCodeList", resultfailChildCodeList);
    params.put("cmbProductList", cmbProductList);
    params.put("DSCCodeList", DSCCodeList);
    params.put("adptCodeList", adptCodeList);
    params.put("resultCityList", resultCityList);

    List<EgovMap> waterEnvironmentList = installationResultListService.waterEnvironmentList(params);
   /* logger.debug("waterEnvironmentList : {}", waterEnvironmentList);*/
    return ResponseEntity.ok(waterEnvironmentList);
  }

  @RequestMapping(value = "/getProductListwithCategory.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getProductListwithCategory(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = installationResultListService.getProductListwithCategory(params);
    return ResponseEntity.ok(codeList);
  }

  /**
   * to display installation charge out Filter/ spare part list
   *
   * @Date May 25, 2021
   * @Author HQIT-HUIDING
   * @param params
   * @return
   */
  @RequestMapping(value = "/getInsAsFilterSPList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getFilSparePartbyStockCode(@RequestParam Map<String, Object> params) {

    List<EgovMap> codeList = installationResultListService.selectFilterSparePartList(params);
    return ResponseEntity.ok(codeList);
  }

  /**
   * to get stock's category and type info
   *
   * @Date Jul 1, 2021
   * @Author HQIT-HUIDING
   * @param params
   * @return
   */
  @RequestMapping(value = "/getStockCatType.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getStkCatType (@RequestParam Map<String, Object> params) {
	  EgovMap stkCatType = installationResultListService.selectStkCatType(params);
	  return ResponseEntity.ok(stkCatType);
  }

  @RequestMapping(value = "/waterSrcTypeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> waterSrcTypeList(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {

    logger.debug("=====================waterSrcTypeList=======================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("=====================waterSrcTypeList=======================");
    List<EgovMap> waterSrcType = installationResultListService.selectWaterSrcType();

    return ResponseEntity.ok(waterSrcType);
  }

  @RequestMapping(value = "/insSendEmail.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insSendEmail(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) throws Exception{
    logger.debug("===========================/insSendEmail.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/insSendEmail.do===============================");

    ReturnMessage message = new ReturnMessage();
    message = installationResultListService.installationSendEmail(params);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/installationAccessoriesRawPop.do")
  public String installationAccessoriesRawPop(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> installStatus = installationResultListService.selectInstallStatus();
    List<EgovMap> dscCodeList = installationResultListService.selectDscCode();

    model.addAttribute("installStatus", installStatus);
    model.addAttribute("dscCodeList", dscCodeList);
    return "services/installation/installationAccessoriesRawPop";
  }

  @RequestMapping(value = "/competitorBrand.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> competitorBrand(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

    logger.debug("=====================competitorBrand=======================");
    logger.debug(" PARAM :: " + params.toString());
    logger.debug("=====================competitorBrand=======================");
    List<EgovMap> competitorBrand = installationResultListService.selectCompetitorBrand();

    return ResponseEntity.ok(competitorBrand);
  }

  @RequestMapping(value = "/getInstallCtPairByCtCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getInstallCtPairByCtCode(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) throws Exception {

    List<EgovMap> list  = installationResultListService.getInstallCtPairByCtCode(params);
      return ResponseEntity.ok(list);
  }

}
