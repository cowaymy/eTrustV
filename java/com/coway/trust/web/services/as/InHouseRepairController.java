package com.coway.trust.web.services.as;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.InHouseRepairService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 05/09/2019    ONGHC      1.0.1       - CREATE FOR IN-HOUSE REPAIR
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/inhouse")

public class InHouseRepairController {
  private static final Logger logger = LoggerFactory.getLogger(InHouseRepairController.class);

  @Resource(name = "InHouseRepairService")
  private InHouseRepairService inHouseRepairService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "ASManagementListService")
  private ASManagementListService asManagementListService;

  @Resource(name = "commonService")
  private CommonService commonService;
  
  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private AdaptorService adaptorService;

  @RequestMapping(value = "/inhouseList.do")
  public String main(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/inhouseList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/inhouseList.do===============================");

    String range = inHouseRepairService.getSearchDtRange();

    List<EgovMap> asTyp = inHouseRepairService.selectAsTyp();
    List<EgovMap> asStat = inHouseRepairService.selectAsStat();

    model.put("DT_RANGE", CommonUtils.nvl(range));
    model.put("asTyp", asTyp);
    model.put("asStat", asStat);

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "services/ihr/ihrManagementList";
  }

  @RequestMapping(value = "/searchIHRManagementList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> searchIHRManagementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/searchIHRManagementList.do===============================");
    logger.debug("== params " + params.toString());

    String[] asTypeList = request.getParameterValues("asType");
    String[] asStatusList = request.getParameterValues("asStatus");

    String cmbbranchId = request.getParameter("cmbbranchId");
    String cmbctId = request.getParameter("cmbctId");

    params.put("asTypeList", asTypeList);
    params.put("asStatusList", asStatusList);
    params.put("cmbbranchId", cmbbranchId);
    params.put("cmbctId", cmbctId);

    List<EgovMap> IHRMList = inHouseRepairService.selectIHRManagementList(params);

    logger.debug("== IHRMList : {}", IHRMList);
    logger.debug("===========================/searchIHRManagementList.do===============================");
    return ResponseEntity.ok(IHRMList);
  }

  @RequestMapping(value = "/asResultInfo.do")
  public String asResultInfo(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/asResultInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asResultInfo.do===============================");
    return "services/ihr/inc_asResultInfoPop";
  }

  @RequestMapping(value = "/asResultInfoEdit.do")
  public String asResultInfoEdit(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/asResultInfoEdit.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asResultInfoEdit.do===============================");

    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());
    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());
    model.put("ORD_NO", params.get("ord_No"));

    List<EgovMap> asCrtStat = inHouseRepairService.selectAsCrtStat();
    model.addAttribute("asCrtStat", asCrtStat);

    List<EgovMap> timePick = inHouseRepairService.selectTimePick();
    model.addAttribute("timePick", timePick);

    EgovMap sstInfo = commonService.getSstRelatedInfo();
    List<EgovMap> lbrFeeChr = inHouseRepairService.selectLbrFeeChr(sstInfo);
    model.addAttribute("lbrFeeChr", lbrFeeChr);

    List<EgovMap> fltQty = inHouseRepairService.selectFltQty();
    model.addAttribute("fltQty", fltQty);

    List<EgovMap> fltPmtTyp = inHouseRepairService.selectFltPmtTyp();
    model.addAttribute("fltPmtTyp", fltPmtTyp);

    return "services/ihr/inc_asResultEditPop";
  }

  @RequestMapping(value = "/asInHouseEntryPop.do")
  public String asInHouseEntryPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/asInHouseEntryPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asInHouseEntryPop.do===============================");

    model.put("ORD_ID", (String) params.get("ord_Id"));
    model.put("ORD_NO", (String) params.get("ord_No"));
    model.put("AS_ID", (String) params.get("as_Id"));
    model.put("AS_NO", (String) params.get("as_No"));
    return "services/ihr/asInHouseEntryPop";
  }

  @RequestMapping(value = "/searchASManagementList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectASManagementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/searchASManagementList.do===============================");
    logger.debug("== params " + params.toString());

    String[] asTypeList = request.getParameterValues("asType");
    String[] asStatusList = request.getParameterValues("asStatus");

    String cmbbranchId = request.getParameter("cmbbranchId");
    String cmbctId = request.getParameter("cmbctId");

    params.put("asTypeList", asTypeList);
    params.put("asStatusList", asStatusList);
    params.put("cmbbranchId", cmbbranchId);
    params.put("cmbctId", cmbctId);

    List<EgovMap> ASMList = inHouseRepairService.selectASManagementList(params);

    logger.debug("== ASMList : {}", ASMList);
    logger.debug("===========================/searchASManagementList.do===============================");
    return ResponseEntity.ok(ASMList);
  }

  @RequestMapping(value = "/ASReceiveEntryPop.do")
  public String initASReceiveEntry(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/ASReceiveEntryPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/ASReceiveEntryPop.do===============================");

    model.put("ORD_ID", (String) params.get("in_ordId"));
    model.put("ORD_NO", (String) params.get("in_ordNo"));
    model.put("AS_ID", (String) params.get("in_asId"));
    model.put("AS_NO", (String) params.get("in_asNo"));
    model.put("AS_ResultNO", (String) params.get("asResultNo"));
    model.put("AS_ResultId", (String) params.get("in_asResultId"));

    if (!"".equals((String) params.get("in_ordId"))) {
      return "services/ihr/ASReceiveEntryPop";
    } else {
      return "services/ihr/ASReceiveEntryPop";
    }
  }

  @RequestMapping(value = "/asResultViewPop.do")
  public String asResultViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
    logger.debug("===========================/asResultViewPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asResultViewPop.do===============================");

    model.put("ORD_ID", (String) params.get("ord_Id"));
    model.put("ORD_NO", (String) params.get("ord_No"));
    model.put("AS_ID", (String) params.get("as_Id"));
    model.put("AS_NO", (String) params.get("as_No"));

    EgovMap AsEventInfo = inHouseRepairService.getAsEventInfo(params);
    model.put("AsEventInfo", AsEventInfo);

    EgovMap orderDetail = null;
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.addAttribute("orderDetail", orderDetail);

    return "services/ihr/asResultViewPop";
  }

  @RequestMapping(value = "/searchOrderNo", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderNo(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/searchOrderNo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/searchOrderNo.do===============================");

    EgovMap basicInfo = inHouseRepairService.selectOrderBasicInfo(params);

    return ResponseEntity.ok(basicInfo);
  }

  @RequestMapping(value = "/resultASReceiveEntryPop.do")
  public String resultASReceiveEntryPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    logger.debug("===========================/resultASReceiveEntryPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/resultASReceiveEntryPop.do===============================");

    params.put("orderNo", params.get("ordNo"));

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    EgovMap as_ord_basicInfo = inHouseRepairService.selectOrderBasicInfo(params);

    List<EgovMap> timePick = inHouseRepairService.selectTimePick();

    model.put("orderDetail", orderDetail);
    model.put("as_ord_basicInfo", as_ord_basicInfo);
    model.put("timePick", timePick);
    model.put("AS_NO", (String) params.get("AS_NO"));
    model.put("AS_ID", (String) params.get("AS_ID"));
    model.put("MOD", (String) params.get("mod"));
    model.put("IN_AsResultId", (String) params.get("asResultId"));

    model.put("mafuncId", (String) params.get("mafuncId"));
    model.put("mafuncResnId", (String) params.get("mafuncResnId"));

    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());
    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());

    /*
     * if("VIEW".equals(params.get("mod"))){ asentryInfo =
     * inHouseRepairService.selASEntryView(params); model.put("asentryInfo",
     * asentryInfo); }
     */

    String ind =  CommonUtils.nvl(params.get("IND"));

    if (CommonUtils.nvl(params.get("IND")).equals("")){
      ind = "0";
    }
    model.put("IND", ind);

    if (as_ord_basicInfo != null) {
      logger.debug("Basic Info :: " + as_ord_basicInfo.toString());
    } else {
      logger.debug("Basic Info are null");
    }

    return "services/ihr/resultASReceiveEntryPop";
  }

  @RequestMapping(value = "/saveASEntry.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> saveASEntry(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    logger.debug("===========================/saveASEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/saveASEntry.do===============================");

    params.put("USER_ID", sessionVO.getUserId());

    EgovMap sm = inHouseRepairService.saveASEntry(params);

    return ResponseEntity.ok(sm);
  }

  @RequestMapping(value = "/saveASInHouseEntry.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> saveASInHouseEntry(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    logger.debug("===========================/saveASInHouseEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/saveASInHouseEntry.do===============================");

    params.put("updator", sessionVO.getUserId());

    EgovMap sm = inHouseRepairService.saveASInHouseEntry(params);

    if (null != sm) {
      @SuppressWarnings("unchecked")
      HashMap<String, Object> spMap = (HashMap<String, Object>) sm.get("spMap");
      logger.debug("spMap :" + spMap.toString());
      if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
      }
      servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
    }
    return ResponseEntity.ok(sm);
  }

  @RequestMapping(value = "/updateASInHouseEntry.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateASInHouseEntry(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    logger.debug("===========================/updateASInHouseEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/updateASInHouseEntry.do===============================");
    params.put("updator", sessionVO.getUserId());

    EgovMap sm = inHouseRepairService.updateASInHouseEntry(params);

    return ResponseEntity.ok(sm);
  }

  @RequestMapping(value = "/updateASEntry.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateASEntry(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    logger.debug("===========================/updateASEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/updateASEntry.do===============================");

    params.put("USER_ID", sessionVO.getUserId());
    EgovMap sm = inHouseRepairService.updateASEntry(params);

    return ResponseEntity.ok(sm);
  }

  @RequestMapping(value = "/ASNewResultPop.do")
  public String insertASResult(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/ASNewResultPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/ASNewResultPop.do===============================");

    model.put("ORD_ID", (String) params.get("ord_Id"));
    model.put("ORD_NO", (String) params.get("ord_No"));
    model.put("AS_NO", (String) params.get("as_No"));
    model.put("AS_ID", (String) params.get("as_Id"));
    model.put("REF_REQST", CommonUtils.nvl((String) params.get("refReqst")));
    model.put("AS_RESULT_NO", (String) params.get("as_Rst"));
    model.put("IS_AUTO", (String) params.get("isAuto"));

    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());

    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());
    model.put("RCD_TMS", (String) params.get("rcdTms"));

    params.put("salesOrderId", params.get("ord_Id"));

    EgovMap orderDetail = null;
    // basicinfo = hsManualService.selectHsViewBasicInfo(params);
    try {
      orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    } catch (Exception e) {
      e.printStackTrace();
    }
    model.addAttribute("orderDetail", orderDetail);

    List<EgovMap> asCrtStat = inHouseRepairService.selectAsCrtStat();
    model.addAttribute("asCrtStat", asCrtStat);

    List<EgovMap> timePick = inHouseRepairService.selectTimePick();
    model.addAttribute("timePick", timePick);

    EgovMap sstInfo = commonService.getSstRelatedInfo();
    List<EgovMap> lbrFeeChr = inHouseRepairService.selectLbrFeeChr(sstInfo);
    model.addAttribute("lbrFeeChr", lbrFeeChr);

    List<EgovMap> fltQty = inHouseRepairService.selectFltQty();
    model.addAttribute("fltQty", fltQty);

    List<EgovMap> fltPmtTyp = inHouseRepairService.selectFltPmtTyp();
    model.addAttribute("fltPmtTyp", fltPmtTyp);

    // IN HOUSE SETTING (PROMISE DAYS)
    String days = inHouseRepairService.getInHseLmtDy();
    model.addAttribute("inHseLmtDy", days);

    return "services/ihr/newASResultPop";
  }

  @RequestMapping(value = "/asResultEditViewPop.do")
  public String asResultEditViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
    logger.debug("===========================/asResultEditViewPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asResultEditViewPop.do===============================");

    model.put("ORD_ID", (String) params.get("ord_Id"));
    model.put("ORD_NO", (String) params.get("ord_No"));
    model.put("AS_NO", (String) params.get("as_No"));
    model.put("AS_ID", (String) params.get("as_Id"));
    model.put("AS_RESULT_NO", (String) params.get("as_Result_No"));
    model.put("AS_RESULT_ID", (String) params.get("as_Result_Id"));
    model.put("MOD", (String) params.get("mod"));

    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());

    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());

    params.put("salesOrderId", (String) params.get("ord_Id"));
    EgovMap orderDetail = null;
    // basicinfo = hsManualService.selectHsViewBasicInfo(params);
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.addAttribute("orderDetail", orderDetail);

    return "services/ihr/asResultEditViewPop";
  }

  @RequestMapping(value = "/asResultEditBasicPop.do")
  public String asResultEditBasicPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
    logger.debug("===========================/asResultEditBasicPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asResultEditBasicPop.do===============================");

    model.put("ORD_ID", (String) params.get("ord_Id"));
    model.put("ORD_NO", (String) params.get("ord_No"));
    model.put("AS_NO", (String) params.get("as_No"));
    model.put("AS_ID", (String) params.get("as_Id"));
    model.put("AS_RESULT_NO", (String) params.get("as_Result_No"));
    model.put("AS_RESULT_ID", (String) params.get("as_Result_Id"));
    model.put("MOD", (String) params.get("mod"));

    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());

    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());

    List<EgovMap> asCrtStat = inHouseRepairService.selectAsCrtStat();
    model.addAttribute("asCrtStat", asCrtStat);

    List<EgovMap> timePick = inHouseRepairService.selectTimePick();
    model.addAttribute("timePick", timePick);

    EgovMap orderDetail;
    params.put("salesOrderId", (String) params.get("ord_Id"));

    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.put("orderDetail", orderDetail);


    return "services/ihr/asResultEditBasicPop";
  }

  @RequestMapping(value = "/getASHistoryList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASHistoryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASHistoryList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASHistoryList.do===============================");

    List<EgovMap> sHistoryList = inHouseRepairService.getASHistoryList(params);

    return ResponseEntity.ok(sHistoryList);
  }

  @RequestMapping(value = "/getBSHistoryList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBSHistoryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getBSHistoryList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getBSHistoryList.do===============================");

    List<EgovMap> bHistoryList = inHouseRepairService.getBSHistoryList(params);

    return ResponseEntity.ok(bHistoryList);
  }

  @RequestMapping(value = "/getBrnchId", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBrnchId(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getBrnchId.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getBrnchId.do===============================");

    List<EgovMap> list = inHouseRepairService.getBrnchId(params);

    return ResponseEntity.ok(list);
  }

  @SuppressWarnings("rawtypes")
  @RequestMapping(value = "/getMemberBymemberID", method = RequestMethod.GET)
  public ResponseEntity<Map> getMemberBymemberID(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getMemberBymemberID.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getMemberBymemberID.do===============================");

    EgovMap meminfo = inHouseRepairService.getMemberBymemberID(params);

    Map<String, Object> map = new HashMap<String, Object>();
    map.put("mInfo", meminfo);

    return ResponseEntity.ok(map);
  }

  @SuppressWarnings("rawtypes")
  @RequestMapping(value = "/getStockPrice.do", method = RequestMethod.GET)
  public ResponseEntity<Map> getStockPrice(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getStockPrice.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getStockPrice.do===============================");

    EgovMap filterprice = inHouseRepairService.getStockPricebyStkID(params);

    Map<String, Object> map = new HashMap<String, Object>();
    map.put("FilPrice", filterprice);

    logger.debug("FilPrice : ", map.get("FilPrice"));
    return ResponseEntity.ok(map);
  }

  @SuppressWarnings("rawtypes")
  @RequestMapping(value = "/getTotalUnclaimItem", method = RequestMethod.GET)
  public ResponseEntity<Map> getTotalUnclaimItem(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getTotalUnclaimItem.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getTotalUnclaimItem.do===============================");

    EgovMap meminfo = inHouseRepairService.spFilterClaimCheck(params);

    Map<String, Object> map = new HashMap<String, Object>();
    map.put("filter", meminfo);

    return ResponseEntity.ok(map);
  }

  @SuppressWarnings("rawtypes")
  @RequestMapping(value = "/selASEntryView", method = RequestMethod.GET)
  public ResponseEntity<Map> selASEntryView(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/selASEntryView.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selASEntryView.do===============================");

    EgovMap meminfo = inHouseRepairService.selASEntryView(params);

    Map<String, Object> map = new HashMap<String, Object>();
    map.put("asentryInfo", meminfo);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/getASOrderInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASOrderInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASOrderInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASOrderInfo.do===============================");

    List<EgovMap> list = inHouseRepairService.getASOrderInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASRclInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRclInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASRclInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRclInfo.do===============================");

    List<EgovMap> list = inHouseRepairService.getASRclInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASEvntsInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASEvntsInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASEvntsInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASEvntsInfo.do===============================");

    List<EgovMap> list = inHouseRepairService.getASEvntsInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASHistoryInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASHistoryInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASHistoryInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASHistoryInfo.do===============================");

    List<EgovMap> list = inHouseRepairService.getASHistoryInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getIHRHistoryInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getIHRHistoryInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getIHRHistoryInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getIHRHistoryInfo.do===============================");

    List<EgovMap> list = inHouseRepairService.getIHRHistoryInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASStockPrice", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASStockPrice(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASStockPrice.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASStockPrice.do===============================");

    List<EgovMap> list = inHouseRepairService.getASStockPrice(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASFilterInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASFilterInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASFilterInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASFilterInfo.do===============================");

    if (params.get("prdctCd") != null) {
      String str = params.get("prdctCd").toString();
      String[] Idx = str.split("B");

      params.put("prdctCd", Idx[0]);
    }
    logger.debug("params : {}", params.toString());

    List<EgovMap> list = inHouseRepairService.getASFilterInfo(params);

    if (list.size() == 0) {
      list = inHouseRepairService.getASFilterInfoOld(params);
    }

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASReasonCode", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASReasonCode(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASReasonCode.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASReasonCode.do===============================");

    List<EgovMap> list = inHouseRepairService.getASReasonCode(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASReasonCode2", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASReasonCode2(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASReasonCode2.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASReasonCode2.do===============================");

    List<EgovMap> list = inHouseRepairService.getASReasonCode2(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASMember", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASMember(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getASMember.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASMember.do===============================");

    List<EgovMap> list = inHouseRepairService.getASMember(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getCallLog", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCallLog(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getCallLog.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getCallLog.do===============================");

    List<EgovMap> list = inHouseRepairService.getCallLog(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASRulstEditFilterInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRulstEditFilterInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASRulstEditFilterInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRulstEditFilterInfo.do===============================");

    List<EgovMap> list = inHouseRepairService.getASRulstEditFilterInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/selectASDataInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectASDataInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/selectASDataInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selectASDataInfo.do===============================");

    List<EgovMap> list = inHouseRepairService.selectASDataInfo(params);
    return ResponseEntity.ok(list);
  }

  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/newResultAdd.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultAdd(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultAdd.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());

    LinkedHashMap<?, ?> asResultM = (LinkedHashMap<?, ?>) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultAdd.do===============================");

    ReturnMessage message = new ReturnMessage();

    HashMap<String, Object> mp = new HashMap<String, Object>();
    mp.put("serviceNo", asResultM.get("AS_NO"));
    int isAsCnt = inHouseRepairService.isAsAlreadyResult(mp);

    if (isAsCnt == 0) {
      EgovMap rtnValue = inHouseRepairService.asResult_insert(params);
      if (null != rtnValue) { // LOGISTIC STEP DONE
        HashMap<String, Object> spMap = (HashMap<String, Object>) rtnValue.get("spMap");
        logger.debug("spMap :" + spMap.toString());
        if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
          rtnValue.put("logerr", "Y");
        }
        servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
      }
      message.setCode(AppConstants.SUCCESS);
      message.setData(rtnValue.get("AS_NO"));
      message.setMessage("");

    } else {
      message.setCode("98");
      message.setData(asResultM.get("AS_NO"));
      message.setMessage("Result already exist with Complete status.");
    }

    return ResponseEntity.ok(message);
  }

  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/newResultUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultUpdate(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultUpdate.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());

    LinkedHashMap<?, ?> asResultM = (LinkedHashMap<?, ?>) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultUpdate.do===============================");

    EgovMap rtnValue = inHouseRepairService.asResult_update(params);

    logger.debug("newResultUpdate == " + rtnValue.toString());

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(rtnValue.get("asNo"));
    message.setMessage("");

    return ResponseEntity.ok(message);

  }

  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/newResultUpdate_1.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultUpdate_1(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultUpdate_1.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());

    LinkedHashMap<?, ?> asResultM = (LinkedHashMap<?, ?>) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    // List<EgovMap> all = (List<EgovMap>) params.get("all");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultUpdate_1.do===============================");

    EgovMap rtnValue = inHouseRepairService.asResult_update_1(params);

    logger.debug("newResultUpdate == " + rtnValue.toString());

    inHouseRepairService.insertOptFlt(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(rtnValue.get("asNo"));
    message.setMessage("");

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/newResultBasicUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultBasicUpdate(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultBasicUpdate.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/newResultBasicUpdate.do===============================");

    params.put("updator", sessionVO.getUserId());

    LinkedHashMap<?, ?> asResultM = (LinkedHashMap<?, ?>) params.get("asResultM");

    logger.debug("== asResultM : " + asResultM.toString());

    int rtnValue = inHouseRepairService.asResultBasic_update(params);

    ReturnMessage message = new ReturnMessage();

    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/addASRemark.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> addASRemark(@RequestParam Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/addASRemark.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/addASRemark.do===============================");

    params.put("USER_ID", sessionVO.getUserId());

    params.put("AS_ID", params.get("asId"));
    params.put("CALL_STUS_ID", "40");
    params.put("CALL_FDBCK_ID", "0");
    params.put("CALL_REM", params.get("callRem"));
    params.put("CALL_HC_ID", "0");
    params.put("CALL_ROS_AMT", "0");
    params.put("CALL_SMS", "0");
    params.put("CALL_SMS_REM", "");

    int rtnValue = inHouseRepairService.addASRemark(params);

    ReturnMessage message = new ReturnMessage();
    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/addASRemarkPop.do")
  public String addASRemarkPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/addASRemarkPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/addASRemarkPop.do===============================");

    model.put("AS_ID", (String) params.get("AS_ID"));

    return "services/ihr/addASRemarkPop";
  }

  @RequestMapping(value = "/assignCTTransferPop.do")
  public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/assignCTTransferPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCTTransferPop.do===============================");

    return "services/ihr/assignCTTransferPop";
  }

  @RequestMapping(value = "/assignCtList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignCtList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/assignCtList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtList.do===============================");

    List<EgovMap> list = inHouseRepairService.assignCtList(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/assignCtOrderList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignCtOrderList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/assignCtOrderList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtOrderList.do===============================");

    String vAsNo = (String) params.get("asNo");
    String[] asNo = null;

    if (!StringUtils.isEmpty(vAsNo)) {
      asNo = ((String) params.get("asNo")).split(",");
      params.put("asNo", asNo);
    }

    List<EgovMap> list = inHouseRepairService.assignCtOrderList(params);

    return ResponseEntity.ok(list);
  }

  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/assignCtOrderListSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> assignCtOrderListSave(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/assignCtOrderListSave.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtOrderListSave.do===============================");

    params.put("updator", sessionVO.getUserId());
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    logger.debug("asResultM ===>" + update.toString());

    inHouseRepairService.updateAssignCT(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(99);
    message.setMessage("");

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectCTByDSC.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTMByDSC(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/selectCTByDSC.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selectCTByDSC.do===============================");

    List<EgovMap> selectCTSubGroupDscList = inHouseRepairService.selectCTByDSC(params);
    logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
    return ResponseEntity.ok(selectCTSubGroupDscList);
  }

  @RequestMapping(value = "/inHouseGetProductMasters.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> inHouseGetProductMasters(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/inHouseGetProductMasters.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/inHouseGetProductMasters.do===============================");

    List<EgovMap> getProductMasters = inHouseRepairService.getProductMasters(params);
    return ResponseEntity.ok(getProductMasters);
  }

  @RequestMapping(value = "/inHouseGetProductDetails.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> inHouseGetProductDetails(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/inHouseGetProductDetails.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/inHouseGetProductDetails.do===============================");

    List<EgovMap> getProductDetails = inHouseRepairService.getProductDetails(params);
    return ResponseEntity.ok(getProductDetails);
  }

  @RequestMapping(value = "/inHouseIsAbStck.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> inHouseIsAbStck(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/inHouseIsAbStck.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/inHouseIsAbStck.do===============================");

    EgovMap isAbStck = inHouseRepairService.isAbStck(params);
    return ResponseEntity.ok(isAbStck);
  }

  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/newASInHouseAdd.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newASInHouseAdd(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newASInHouseAdd.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/newASInHouseAdd.do===============================");

    params.put("updator", sessionVO.getUserId());
    ReturnMessage message = new ReturnMessage();

    HashMap<String, Object> mp = new HashMap<String, Object>();
    Map<?, ?> SVC0109Dmap = (Map<?, ?>) params.get("asResultM");
    mp.put("serviceNo", SVC0109Dmap.get("AS_NO"));

    params.put("asNo", SVC0109Dmap.get("AS_NO"));
    params.put("asEntryId", SVC0109Dmap.get("AS_ENTRY_ID"));
    params.put("asSoId", SVC0109Dmap.get("AS_SO_ID"));
    params.put("rcdTms", SVC0109Dmap.get("RCD_TMS"));

    int noRcd = inHouseRepairService.chkRcdTms(params);

    if (noRcd == 1) { // RECORD ABLE TO UPDATE
      int isAsCnt = inHouseRepairService.isAsAlreadyResult(mp);
      logger.debug("== isAsCnt " + isAsCnt);

      if (isAsCnt == 0) {
        EgovMap rtnValue = inHouseRepairService.asResult_insert(params);
        if (null != rtnValue) {
          HashMap<String, Object> spMap = (HashMap<String, Object>) rtnValue.get("spMap");
          logger.debug("spMap :" + spMap.toString());
          if (!spMap.isEmpty()) {
            if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
              rtnValue.put("logerr", "Y");
            }
            servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
            logger.debug("SP_SVC_LOGISTIC_REQUEST===> " + spMap.toString());
          }

          // ONGHC ADD FOR OPTIONAL FILTER
          inHouseRepairService.insertOptFlt(params);
        }

        message.setCode(AppConstants.SUCCESS);
        message.setData(rtnValue.get("asNo"));
        message.setMessage("");

      } else {
        message.setCode("98");
        message.setData(SVC0109Dmap.get("AS_NO"));
        message.setMessage("Result already exist with Complete Status.");
      }
    } else {
      message.setMessage(
          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
      message.setCode("99");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getErrMstList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getErrMstList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getErrMstList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getErrMstList.do===============================");

    List<EgovMap> getErrMstList = inHouseRepairService.getErrMstList(params);
    return ResponseEntity.ok(getErrMstList);
  }

  @RequestMapping(value = "/getErrDetilList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getErrDetilList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getErrDetilList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getErrDetilList.do===============================");

    List<EgovMap> getErrDetilList = inHouseRepairService.getErrDetilList(params);
    return ResponseEntity.ok(getErrDetilList);
  }

  @RequestMapping(value = "/getSLUTN_CODE_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSLUTN_CODE_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getSLUTN_CODE_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getSLUTN_CODE_List.do===============================");

    List<EgovMap> getSLUTN_CODE_List = inHouseRepairService.getSLUTN_CODE_List(params);
    return ResponseEntity.ok(getSLUTN_CODE_List);
  }

  @RequestMapping(value = "/getDTAIL_DEFECT_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDTAIL_DEFECT_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDTAIL_DEFECT_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDTAIL_DEFECT_List.do===============================");

    List<EgovMap> getDTAIL_DEFECT_List = inHouseRepairService.getDTAIL_DEFECT_List(params);
    return ResponseEntity.ok(getDTAIL_DEFECT_List);
  }

  @RequestMapping(value = "/getDEFECT_PART_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDEFECT_PART_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDEFECT_PART_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDEFECT_PART_List.do===============================");

    List<EgovMap> getDEFECT_PART_List = inHouseRepairService.getDEFECT_PART_List(params);
    return ResponseEntity.ok(getDEFECT_PART_List);
  }

  @RequestMapping(value = "/getDEFECT_CODE_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDEFECT_CODE_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDEFECT_CODE_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDEFECT_CODE_List.do===============================");

    List<EgovMap> getDEFECT_CODE_List = inHouseRepairService.getDEFECT_CODE_List(params);
    return ResponseEntity.ok(getDEFECT_CODE_List);
  }

  @RequestMapping(value = "/getDEFECT_TYPE_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDEFECT_TYPE_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDEFECT_TYPE_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDEFECT_TYPE_List.do===============================");

    List<EgovMap> getDEFECT_TYPE_List = inHouseRepairService.getDEFECT_TYPE_List(params);
    return ResponseEntity.ok(getDEFECT_TYPE_List);
  }

  @RequestMapping(value = "/sendSMS.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> sendSMS(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO session) {
    logger.debug("===========================/sendSMS.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/sendSMS.do===============================");

    SmsVO sms = new SmsVO(session.getUserId(), 975);
    sms.setMessage(CommonUtils.nvl(params.get("msg")));
    sms.setMobiles(CommonUtils.nvl(params.get("rTelNo")));
    SmsResult smsResult = adaptorService.sendSMS(sms);
    logger.debug(" smsResult : {}", smsResult.toString());

    EgovMap mp = new EgovMap();
    mp.put("isOky", "OK");

    return ResponseEntity.ok(mp);
  }

  @RequestMapping(value = "/sendSMSPop.do")
  public String sendSMSPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/sendSMSPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/sendSMSPop.do===============================");

    return "services/ihr/sendNewSMSPop";
  }

  @RequestMapping(value = "/getCustAddressInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustAddressInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getCustAddressInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getCustAddressInfo.do===============================");

    String address = inHouseRepairService.getCustAddressInfo(params);
    EgovMap rtnm = new EgovMap();

    rtnm.put("fulladdr", address);

    return ResponseEntity.ok(rtnm);
  }

  @RequestMapping(value = "/getSmsCTMemberById.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getSmsCTMemberById(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getSmsCTMemberById.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getSmsCTMemberById.do===============================");

    EgovMap CT = inHouseRepairService.getSmsCTMemberById(params);
    return ResponseEntity.ok(CT);
  }

  @RequestMapping(value = "/getSmsCTMMemberById.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getSmsCTMMemberById(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getSmsCTMMemberById.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getSmsCTMMemberById.do===============================");

    EgovMap CTM = inHouseRepairService.getSmsCTMMemberById(params);
    logger.debug("CTM {}", CTM);
    return ResponseEntity.ok(CTM);
  }

  @RequestMapping(value = "/getMemberByMemberIdCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getMemberByMemberIdCode(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getMemberByMemberIdCode.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getMemberByMemberIdCode.do===============================");

    EgovMap MEMup = inHouseRepairService.getMemberByMemberIdCode(params);
    return ResponseEntity.ok(MEMup);
  }

  @RequestMapping(value = "/getSVC_AVAILABLE_INVENTORY.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getSVC_AVAILABLE_INVENTORY(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getSVC_AVAILABLE_INVENTORY.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getSVC_AVAILABLE_INVENTORY.do===============================");

    EgovMap logc = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(params);

    // KR-OHK Serial Check
    String serialChk = asManagementListService.getSerialChk(params);
    logc.put("serialChk", serialChk);

    return ResponseEntity.ok(logc);
  }

  @RequestMapping(value = "/getAPILogList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAPILogList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getAPILogList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getAPILogList.do===============================");

    String logType = (String) params.get("LOGTYPE");

    List<EgovMap> list = null;

    if ("HS".equals(logType)) {
      list = inHouseRepairService.selectSVC0023T(params);
    } else if ("AS".equals(logType)) {
      list = inHouseRepairService.selectSVC0024T(params);
    } else if ("INS".equals(logType)) {
      list = inHouseRepairService.selectSVC0025T(params);
    } else if ("PR".equals(logType)) {
      list = inHouseRepairService.selectSVC0026T(params);
    }

    logger.debug("list  {}", list);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/initAPILog.do")
  public String initAPILog(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/initAPILog.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/initAPILog.do===============================");

    return "services/ihr/apiLogList";
  }

  // AS RECEIVED ENTRY POP UP NOTIFICATION -- TPY
  @RequestMapping(value = "/checkASReceiveEntry.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkASReceiveEntry(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/checkASReceiveEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/checkASReceiveEntry.do===============================");

    String msg = "";
    ReturnMessage message = new ReturnMessage();
    EgovMap asReceiveInfo = inHouseRepairService.checkASReceiveEntry(params);
    EgovMap hsInfo = inHouseRepairService.checkHSStatus(params);
    EgovMap warrentyInfo = inHouseRepairService.checkWarrentyStatus(params);

    if (asReceiveInfo != null) {
      if (asReceiveInfo.get("asStus") != null) {
        msg = msg + "* This order AS is under " + asReceiveInfo.get("asStusDesc") + " status.<br />";
      } else {
        msg = msg + "";
      }
    } else {
      msg = msg + "";
    }

    if (warrentyInfo != null) {
      msg = msg + "";
    } else {
      msg = msg + "* This order Membership is under Out of Warranty status.<br />";
    }

    if (hsInfo != null) {
      if (hsInfo.get("hsStus") != null) {
        msg = msg + "* This order HS is under " + hsInfo.get("hsStusDesc") + " status.<br />";
      } else {
        msg = msg + "";
      }
    } else {
      msg = msg + "";
    }

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/checkAOASRcdStat", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> checkAOASRcdStat(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/checkAOASRcdStat.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/checkAOASRcdStat.do===============================");

    List<EgovMap> list = inHouseRepairService.checkAOASRcdStat(params);
    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/selRcdTms.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkRcdTms(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/selRcdTms.do=======================");
    logger.debug("params : {}", params);

    int noRcd = inHouseRepairService.selRcdTms(params);
    logger.debug("noRcd : ", noRcd);
    logger.debug("==================/selRcdTms.do=======================");
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

  @RequestMapping(value = "/getASEntryCommission", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASEntryCommission(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASEntryCommission.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASEntryCommission.do===============================");

    List<EgovMap> list = inHouseRepairService.getASEntryCommission(params);

    return ResponseEntity.ok(list);
  }

  // ------

  @RequestMapping(value = "/inhouseDPop.do")
  public String inhouseDPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/inhouseDPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("== USER_ID " + sessionVO.getMemId());
    logger.debug("== USER_NAME " + sessionVO.getUserName());
    logger.debug("== BRANCH_NAME " + sessionVO.getBranchName());
    logger.debug("== BRANCH_ID " + sessionVO.getUserBranchId());
    logger.debug("===========================/inhouseDPop.do===============================");

    model.put("mode", (String) params.get("mode"));
    model.put("ORD_ID", (String) params.get("ORD_ID"));
    model.put("ORD_NO", (String) params.get("ORD_NO"));
    model.put("AS_NO", (String) params.get("AS_NO"));
    model.put("AS_ID", (String) params.get("AS_ID"));
    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());
    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());

    return "services/ihr/inRHouseNewRepairPop";
  }

  @RequestMapping(value = "/inHouseAsResultEditBasicPop.do")
  public String inHouseAsResultEditBasicPop(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {

    logger.debug("===========================/inHouseAsResultEditBasicPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/inHouseAsResultEditBasicPop.do===============================");

    model.put("mode", (String) params.get("mode"));
    model.put("ORD_ID", (String) params.get("ORD_ID"));
    model.put("ORD_NO", (String) params.get("ORD_NO"));
    model.put("AS_NO", (String) params.get("AS_NO"));
    model.put("AS_ID", (String) params.get("AS_ID"));
    model.put("AS_RESULT_NO", (String) params.get("AS_RESULT_NO"));
    model.put("AS_RESULT_ID", (String) params.get("AS_RESULT_ID"));
    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());

    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());

    // 호출될 화면
    return "services/ihr/inHouseAsResultEditBasicPop";
  }

  @RequestMapping(value = "/selInhouseList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selInhouseList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("===========================/selInhouseList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selInhouseList.do===============================");

    String[] repStateList = request.getParameterValues("repState");
    params.put("repStateList", repStateList);

    List<EgovMap> mList = inHouseRepairService.selInhouseList(params);

    return ResponseEntity.ok(mList);
  }

  @RequestMapping(value = "/selInhouseDetailList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selInhouseDetailList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("===========================/selInhouseDetailList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selInhouseDetailList.do===============================");

    List<EgovMap> dList = null;
    dList = inHouseRepairService.selInhouseDetailList(params);

    return ResponseEntity.ok(dList);
  }

  @RequestMapping(value = "/getASRulstSVC0109DInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRulstSVC0109DInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("===========================/getASRulstSVC0109DInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRulstSVC0109DInfo.do===============================");

    List<EgovMap> dList = null;
    dList = inHouseRepairService.getASRulstSVC0109DInfo(params);

    return ResponseEntity.ok(dList);
  }

  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/save.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> save(@RequestParam Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/save.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/save.do===============================");

    params.put("updator", sessionVO.getUserId());
    int rtnValue = 1;

    List<EgovMap> asresultmst = (List<EgovMap>) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    List<EgovMap> inhouse = (List<EgovMap>) params.get("inhouse");

    logger.debug("== asresultmst = " + asresultmst.toString());
    logger.debug("== asresultmst = " + inhouse.toString());

    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());

    // inHouseRepairService.asResult_insert(params);

    ReturnMessage message = new ReturnMessage();
    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/update.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> update(@RequestParam Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/update.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/update.do===============================");

    params.put("USER_ID", sessionVO.getUserId());

    int rtnValue = 1;
    // inHouseRepairService.addASRemark(params);

    ReturnMessage message = new ReturnMessage();
    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/mListUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> mListUpdate(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/mListUpdate.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/mListUpdate.do===============================");

    params.put("USER_ID", sessionVO.getUserId());

    // LinkedHashMap updateList = (LinkedHashMap) params.get("update");

    int rtnValue = 1;
    // inHouseRepairService.asResultBasic_update(params);

    ReturnMessage message = new ReturnMessage();

    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }
  
  // KR-OHK serial check add
  @RequestMapping(value = "/newASInHouseAddSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newASInHouseAddSerial(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newASInHouseAddSerial.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/newASInHouseAddSerial.do===============================");

    params.put("updator", sessionVO.getUserId());
    ReturnMessage message = new ReturnMessage();

    message = inHouseRepairService.newASInHouseAddSerial(params);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/newResultBasicUpdateSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultBasicUpdateSerial(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultBasicUpdateSerial.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/newResultBasicUpdateSerial.do===============================");

    params.put("updator", sessionVO.getUserId());

    LinkedHashMap<?, ?> asResultM = (LinkedHashMap<?, ?>) params.get("asResultM");

    logger.debug("== asResultM : " + asResultM.toString());

    int rtnValue = inHouseRepairService.asResultBasic_updateSerial(params);

    ReturnMessage message = new ReturnMessage();

    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  //KR-OHK serial check add
  @SuppressWarnings("unchecked")
  @RequestMapping(value = "/newResultUpdateSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultUpdateSerial(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultUpdateSerial.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());

    LinkedHashMap<?, ?> asResultM = (LinkedHashMap<?, ?>) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    // List<EgovMap> all = (List<EgovMap>) params.get("all");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultUpdateSerial.do===============================");

    EgovMap rtnValue = inHouseRepairService.asResult_updateSerial(params);

    logger.debug("newResultUpdate == " + rtnValue.toString());

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(rtnValue.get("asNo"));
    message.setMessage("");

    return ResponseEntity.ok(message);

  }
}
