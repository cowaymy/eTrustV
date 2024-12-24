package com.coway.trust.web.services.as;

import java.util.ArrayList;
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
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT -------------------------------------------------------------------------------------------- 01/04/2019 ONGHC 1.0.1 - Restructure File 26/07/2019 ONGHC 1.0.2 - Add Recall Status 17/07/2019 ONGHC 1.0.3 - Add dftTypPop and getDftTyp 21/10/2019 ONGHC 1.0.4 - Add chkPmtMap 05/10/2020 FARUQ 1.0.4 -Add getAsDefectEntry
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/as")
public class ASManagementListController {
  private static final Logger logger = LoggerFactory.getLogger(ASManagementListController.class);

  @Resource(name = "ASManagementListService")
  private ASManagementListService ASManagementListService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "InHouseRepairService")
  private InHouseRepairService inHouseRepairService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Autowired
  private AdaptorService adaptorService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/initASManagementList.do")
  public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/initASManagementList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/initASManagementList.do===============================");

    // GET SEARCH DATE RANGE
    String range = ASManagementListService.getSearchDtRange();

    List<EgovMap> asTyp = ASManagementListService.selectAsTyp();
    List<EgovMap> asStat = ASManagementListService.selectAsStat();
    List<EgovMap> asProduct = ASManagementListService.asProd();

    model.put("DT_RANGE", CommonUtils.nvl(range));
    model.put("asTyp", asTyp);
    model.put("asStat", asStat);
    model.put("asProduct", asProduct);

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    return "services/as/ASManagementList";
  }

  @RequestMapping(value = "/asResultInfo.do")
  public String asResultInfo(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/asResultInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asResultInfo.do===============================");
    return "services/as/inc_asResultInfoPop";
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

    List<EgovMap> asCrtStat = ASManagementListService.selectAsCrtStat();
    model.addAttribute("asCrtStat", asCrtStat);

    List<EgovMap> timePick = ASManagementListService.selectTimePick();
    model.addAttribute("timePick", timePick);

    EgovMap sstInfo = commonService.getSstRelatedInfo();
    List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr(sstInfo);
    model.addAttribute("lbrFeeChr", lbrFeeChr);

    List<EgovMap> fltQty = ASManagementListService.selectFltQty();
    model.addAttribute("fltQty", fltQty);

    List<EgovMap> fltPmtTyp = ASManagementListService.selectFltPmtTyp();
    model.addAttribute("fltPmtTyp", fltPmtTyp);

    List<EgovMap> waterSrcType = ASManagementListService.selectWaterSrcType();
    model.addAttribute("waterSrcType", waterSrcType);

    List<EgovMap> asNotMatch = ASManagementListService.selectASNotMatch();
    model.addAttribute("asNotMatch", asNotMatch);

    List<EgovMap> reworkProj = ASManagementListService.selectReworkProj();
    model.addAttribute("reworkProj", reworkProj);

    params.put("asEntryId", params.get("as_Id"));
    params.put("salesOrderId", params.get("ord_Id"));
    List<EgovMap> installAcc = ASManagementListService.selectInstallAccWithAsEntryId(params);

    List<String> installAccValues = new ArrayList<>();

    for (EgovMap map : installAcc) {
        Object value = map.get("insAccPartId");
        if (value != null) {
            installAccValues.add(value.toString());
        }
    }

    model.put("installAccValues", installAccValues);

    return "services/as/inc_asResultEditPop";
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
    return "services/as/asInHouseEntryPop";
  }

  @RequestMapping(value = "/getAsDefectEntry.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAsDefectEntry(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getAsDefectEntry.do===============================");
    logger.debug("== params heres" + params.toString());

    List<EgovMap> getAsDefectEntryList = ASManagementListService.getAsDefectEntry(params);

    logger.debug("== getAsDefectEntryList : {}" + getAsDefectEntryList);
    logger.debug("===========================/getAsDefectEntry.do===============================");
    return ResponseEntity.ok(getAsDefectEntryList);
  }

  @RequestMapping(value = "/searchASManagementList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectASManagementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/searchASManagementList.do===============================");
    logger.debug("== params heres" + params.toString());

    String[] asTypeList = request.getParameterValues("asType");
    String[] asProductList = request.getParameterValues("asProduct");
    String[] asStatusList = request.getParameterValues("asStatus");
    String[] cmbbranchIdList = request.getParameterValues("cmbbranchId");

    // String cmbctId = request.getParameter("cmbctId");

    params.put("asTypeList", asTypeList);
    params.put("asStatusList", asStatusList);
    params.put("cmbbranchIdList", cmbbranchIdList);
    params.put("asProductList", asProductList);

    List<EgovMap> ASMList = ASManagementListService.selectASManagementList(params);

    // logger.debug("== ASMList : {}", ASMList);
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

    model.put("PREAS_ORDNO", (String) params.get("preAsSalesOrderNo"));
    model.put("PREAS_DEFECTCODE", (String) params.get("preAsDefectCode"));
    model.put("PREAS_TYPE", (String) params.get("preAsType"));

    if (!"".equals((String) params.get("in_ordId"))) {
      return "services/as/ASReceiveEntryPop";
    } else {
      return "services/as/ASReceiveEntryPop";
    }
  }

  @RequestMapping(value = "/asResultViewPop.do")
  public String asResultViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    logger.debug("===========================/asResultViewPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/asResultViewPop.do===============================");

    model.put("ORD_ID", (String) params.get("ord_Id"));
    model.put("ORD_NO", (String) params.get("ord_No"));
    model.put("AS_ID", (String) params.get("as_Id"));
    model.put("AS_NO", (String) params.get("as_No"));

    EgovMap AsEventInfo = ASManagementListService.getAsEventInfo(params);
    model.put("AsEventInfo", AsEventInfo);

    EgovMap orderDetail = null;
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.addAttribute("orderDetail", orderDetail);

    return "services/as/asResultViewPop";
  }

  @RequestMapping(value = "/searchOrderNo", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderNo(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/searchOrderNo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/searchOrderNo.do===============================");

    EgovMap basicInfo = ASManagementListService.selectOrderBasicInfo(params);

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
    EgovMap as_ord_basicInfo = ASManagementListService.selectOrderBasicInfo(params);

    EgovMap preASInfo = ASManagementListService.selectSubmissionRecords(params);

    List<EgovMap> timePick = ASManagementListService.selectTimePick();

    model.put("orderDetail", orderDetail);
    model.put("as_ord_basicInfo", as_ord_basicInfo);
    model.put("preASInfo",preASInfo);
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

    model.put("preAsType", (String) params.get("preAsType"));

    /*
     * if("VIEW".equals(params.get("mod"))){ asentryInfo = ASManagementListService.selASEntryView(params); model.put("asentryInfo", asentryInfo); }
     */

    String ind = CommonUtils.nvl(params.get("IND"));

    if (CommonUtils.nvl(params.get("IND")).equals("")) {
      ind = "0";
    }
    model.put("IND", ind);

    if (as_ord_basicInfo != null) {
      logger.debug("Basic Info :: " + as_ord_basicInfo.toString());
    } else {
      logger.debug("Basic Info are null");
    }

    return "services/as/resultASReceiveEntryPop";
  }

  @RequestMapping(value = "/saveASEntry.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> saveASEntry(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    logger.debug("===========================/saveASEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/saveASEntry.do===============================");

    ReturnMessage message = new ReturnMessage();
    params.put("USER_ID", sessionVO.getUserId());

    EgovMap sm = ASManagementListService.saveASEntry(params);

    /*
     * if( null !=sm){ HashMap spMap =(HashMap)sm.get("spMap"); logger.debug( "spMap :"+ spMap.toString()); if(! "000".equals(spMap.get("P_RESULT_MSG"))){ sm.put("logerr","Y"); }
     *
     * servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap); }
     */

    return ResponseEntity.ok(sm);
  }

  @RequestMapping(value = "/saveASInHouseEntry.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> saveASInHouseEntry(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("===========================/saveASInHouseEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/saveASInHouseEntry.do===============================");

    params.put("updator", sessionVO.getUserId());

    EgovMap sm = ASManagementListService.saveASInHouseEntry(params);

    if (null != sm) {
      HashMap spMap = (HashMap) sm.get("spMap");
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
    ReturnMessage message = new ReturnMessage();

    logger.debug("===========================/updateASInHouseEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/updateASInHouseEntry.do===============================");
    params.put("updator", sessionVO.getUserId());

    EgovMap sm = ASManagementListService.updateASInHouseEntry(params);

    return ResponseEntity.ok(sm);
  }

  @RequestMapping(value = "/updateASEntry.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> updateASEntry(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    logger.debug("===========================/updateASEntry.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/updateASEntry.do===============================");

    params.put("USER_ID", sessionVO.getUserId());
    EgovMap sm = ASManagementListService.updateASEntry(params);

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

    List<EgovMap> asCrtStat = ASManagementListService.selectAsCrtStat();
    model.addAttribute("asCrtStat", asCrtStat);

    List<EgovMap> timePick = ASManagementListService.selectTimePick();
    model.addAttribute("timePick", timePick);

    EgovMap sstInfo = commonService.getSstRelatedInfo();
    List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr(sstInfo);
    model.addAttribute("lbrFeeChr", lbrFeeChr);

    List<EgovMap> fltQty = ASManagementListService.selectFltQty();
    model.addAttribute("fltQty", fltQty);

    List<EgovMap> fltPmtTyp = ASManagementListService.selectFltPmtTyp();
    model.addAttribute("fltPmtTyp", fltPmtTyp);

    // IN HOUSE SETTING (PROMISE DAYS)
    String days = ASManagementListService.getInHseLmtDy();
    model.addAttribute("inHseLmtDy", days);

    List<EgovMap> waterSrcType = ASManagementListService.selectWaterSrcType();
    List<EgovMap> asNotMatch = ASManagementListService.selectASNotMatch();
    model.addAttribute("waterSrcType", waterSrcType);
    model.addAttribute("asNotMatch", asNotMatch);

    List<EgovMap> reworkProj = ASManagementListService.selectReworkProj();
    model.addAttribute("reworkProj", reworkProj);

    // CELESTE [20240828] - New Product External Filter Registration Enhancement [S]
    EgovMap membershipValidity = ASManagementListService.selectMembershipValidity(params);
    model.addAttribute("membershipValidity", membershipValidity);
    // CELESTE [20240828] - New Product External Filter Registration Enhancement [E]

    return "services/as/newASResultPop";
  }

  @RequestMapping(value = "/asResultEditViewPop.do")
  public String asResultEditViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
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

    return "services/as/asResultEditViewPop";
  }

  @RequestMapping(value = "/asResultEditBasicPop.do")
  public String asResultEditBasicPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
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

    List<EgovMap> asCrtStat = ASManagementListService.selectAsCrtStat();
    model.addAttribute("asCrtStat", asCrtStat);

    List<EgovMap> timePick = ASManagementListService.selectTimePick();
    model.addAttribute("timePick", timePick);

    EgovMap orderDetail;
    params.put("salesOrderId", (String) params.get("ord_Id"));

    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.put("orderDetail", orderDetail);

    return "services/as/asResultEditBasicPop";
  }

  @RequestMapping(value = "/getASHistoryList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASHistoryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASHistoryList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASHistoryList.do===============================");

    List<EgovMap> sHistoryList = ASManagementListService.getASHistoryList(params);

    return ResponseEntity.ok(sHistoryList);
  }

  @RequestMapping(value = "/getBSHistoryList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBSHistoryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getBSHistoryList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getBSHistoryList.do===============================");

    List<EgovMap> bHistoryList = ASManagementListService.getBSHistoryList(params);

    return ResponseEntity.ok(bHistoryList);
  }

  @RequestMapping(value = "/getBrnchId", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBrnchId(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getBrnchId.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getBrnchId.do===============================");

    List<EgovMap> list = ASManagementListService.getBrnchId(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getMemberBymemberID", method = RequestMethod.GET)
  public ResponseEntity<Map> getMemberBymemberID(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getMemberBymemberID.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getMemberBymemberID.do===============================");

    EgovMap meminfo = ASManagementListService.getMemberBymemberID(params);

    Map<String, Object> map = new HashMap();
    map.put("mInfo", meminfo);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/getStockPrice.do", method = RequestMethod.GET)
  public ResponseEntity<Map> getStockPrice(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getStockPrice.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getStockPrice.do===============================");

    EgovMap filterprice = ASManagementListService.getStockPricebyStkID(params);

    Map<String, Object> map = new HashMap();
    map.put("FilPrice", filterprice);

    logger.debug("FilPrice : ", map.get("FilPrice"));
    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/getTotalUnclaimItem", method = RequestMethod.GET)
  public ResponseEntity<Map> getTotalUnclaimItem(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getTotalUnclaimItem.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getTotalUnclaimItem.do===============================");

    EgovMap meminfo = ASManagementListService.spFilterClaimCheck(params);

    Map<String, Object> map = new HashMap();
    map.put("filter", meminfo);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/selASEntryView", method = RequestMethod.GET)
  public ResponseEntity<Map> selASEntryView(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/selASEntryView.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selASEntryView.do===============================");

    EgovMap meminfo = ASManagementListService.selASEntryView(params);

    Map<String, Object> map = new HashMap();
    map.put("asentryInfo", meminfo);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/getASOrderInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASOrderInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASOrderInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASOrderInfo.do===============================");

    List<EgovMap> list = ASManagementListService.getASOrderInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASRclInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRclInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASRclInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRclInfo.do===============================");

    List<EgovMap> list = ASManagementListService.getASRclInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASEvntsInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASEvntsInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASEvntsInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASEvntsInfo.do===============================");

    List<EgovMap> list = ASManagementListService.getASEvntsInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASHistoryInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASHistoryInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASHistoryInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASHistoryInfo.do===============================");

    List<EgovMap> list = ASManagementListService.getASHistoryInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASStockPrice", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASStockPrice(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASStockPrice.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASStockPrice.do===============================");

    List<EgovMap> list = ASManagementListService.getASStockPrice(params);

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

    List<EgovMap> list = ASManagementListService.getASFilterInfo(params);

    if (list.size() == 0) {
      list = ASManagementListService.getASFilterInfoOld(params);
    }

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASReasonCode", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASReasonCode(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASReasonCode.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASReasonCode.do===============================");

    List<EgovMap> list = ASManagementListService.getASReasonCode(params);
    logger.debug("== ASManagementListService.getASReasonCode " + list.toString());

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASReasonCode2", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASReasonCode2(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASReasonCode2.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASReasonCode2.do===============================");

    List<EgovMap> list = ASManagementListService.getASReasonCode2(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASMember", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASMember(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getASMember.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASMember.do===============================");

    List<EgovMap> list = ASManagementListService.getASMember(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getCallLog", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCallLog(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getCallLog.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getCallLog.do===============================");

    List<EgovMap> list = ASManagementListService.getCallLog(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASRulstSVC0004DInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRulstSVC0004DInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");

    List<EgovMap> list = ASManagementListService.getASRulstSVC0004DInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASRulstEditFilterInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRulstEditFilterInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASRulstEditFilterInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRulstEditFilterInfo.do===============================");

    List<EgovMap> list = ASManagementListService.getASRulstEditFilterInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/selectASDataInfo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectASDataInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/selectASDataInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selectASDataInfo.do===============================");

    List<EgovMap> list = ASManagementListService.selectASDataInfo(params);
    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/newResultAdd.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultAdd(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {

	ASManagementListService.insertASResultLog(params.toString(), request.getRequestURI(), String.valueOf(((LinkedHashMap) params.get("asResultM")).get("AS_ID")), sessionVO.getUserId());

    logger.debug("===========================/newResultAdd.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());
    params.put("chkInstallAcc", params.get("INS_ACC_CHK"));

    LinkedHashMap asResultM = (LinkedHashMap) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultAdd.do===============================");

    ReturnMessage message = new ReturnMessage();

    HashMap mp = new HashMap();
    mp.put("serviceNo", asResultM.get("AS_NO"));
    int isAsCnt = ASManagementListService.isAsAlreadyResult(mp);

    if (isAsCnt == 0) {
      EgovMap rtnValue = ASManagementListService.asResult_insert(params);
      if (null != rtnValue) { // LOGISTIC STEP DONE
        HashMap spMap = (HashMap) rtnValue.get("spMap");
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

  @RequestMapping(value = "/newResultUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultUpdate(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultUpdate.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());

    LinkedHashMap asResultM = (LinkedHashMap) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultUpdate.do===============================");

    EgovMap rtnValue = ASManagementListService.asResult_update(params);

    logger.debug("newResultUpdate == " + rtnValue.toString());

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(rtnValue.get("asNo"));
    message.setMessage("");

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/newResultUpdate_1.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultUpdate_1(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultUpdate_1.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());

    ASManagementListService.insertASResultLog(params.toString(), request.getRequestURI(), String.valueOf(((LinkedHashMap) params.get("asResultM")).get("AS_ID")), sessionVO.getUserId());

    LinkedHashMap asResultM = (LinkedHashMap) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    // List<EgovMap> all = (List<EgovMap>) params.get("all");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultUpdate_1.do===============================");

    EgovMap rtnValue = ASManagementListService.asResult_update_1(params);

    logger.debug("newResultUpdate == " + rtnValue.toString());

    boolean rst = ASManagementListService.insertOptFlt(params);

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

    int rtnValue = ASManagementListService.asResultBasic_update(params);

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

    int rtnValue = ASManagementListService.addASRemark(params);

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

    return "services/as/addASRemarkPop";
  }

  @RequestMapping(value = "/assignCTTransferPop.do")
  public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/assignCTTransferPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCTTransferPop.do===============================");

    return "services/as/assignCTTransferPop";
  }

  @RequestMapping(value = "/assignCtList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignCtList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/assignCtList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtList.do===============================");

    List<EgovMap> list = ASManagementListService.assignCtList(params);

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

    List<EgovMap> list = ASManagementListService.assignCtOrderList(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/assignCtOrderListSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> assignCtOrderListSave(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/assignCtOrderListSave.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtOrderListSave.do===============================");

    params.put("updator", sessionVO.getUserId());
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    logger.debug("asResultM ===>" + update.toString());

    int rtnValue = ASManagementListService.updateAssignCT(params);

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

    List<EgovMap> selectCTSubGroupDscList = ASManagementListService.selectCTByDSC(params);
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

  @RequestMapping(value = "/newASInHouseAdd.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newASInHouseAdd(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {

	ASManagementListService.insertASResultLog(params.toString(), request.getRequestURI(), String.valueOf(((Map<String, Object>) params.get("asResultM")).get("AS_ENTRY_ID")), sessionVO.getUserId());
    logger.debug("===========================/newASInHouseAdd.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/newASInHouseAdd.do===============================");

    params.put("updator", sessionVO.getUserId());
    ReturnMessage message = new ReturnMessage();

    HashMap<String, Object> mp = new HashMap<String, Object>();
    Map<?, ?> svc0004dmap = (Map<?, ?>) params.get("asResultM");
    mp.put("serviceNo", svc0004dmap.get("AS_NO"));

    params.put("asNo", svc0004dmap.get("AS_NO"));
    params.put("asEntryId", svc0004dmap.get("AS_ENTRY_ID"));
    params.put("asSoId", svc0004dmap.get("AS_SO_ID"));
    params.put("rcdTms", svc0004dmap.get("RCD_TMS"));
    params.put("chkInstallAcc", svc0004dmap.get("INS_ACC_CHK"));

    int noRcd = ASManagementListService.chkRcdTms(params);

    if (noRcd == 1) { // RECORD ABLE TO UPDATE
      int isAsCnt = ASManagementListService.isAsAlreadyResult(mp);
      logger.debug("== isAsCnt " + isAsCnt);

      if (isAsCnt == 0) {
        EgovMap rtnValue = ASManagementListService.asResult_insert(params);
        if (null != rtnValue) {
          HashMap spMap = (HashMap) rtnValue.get("spMap");
          logger.debug("spMap :" + spMap.toString());
          if (!spMap.isEmpty()) {
            if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
              rtnValue.put("logerr", "Y");
            }
            servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
            logger.debug("SP_SVC_LOGISTIC_REQUEST===> " + spMap.toString());
          }

          // ONGHC ADD FOR OPTIONAL FILTER
          boolean rst = ASManagementListService.insertOptFlt(params);
        }

        message.setCode(AppConstants.SUCCESS);
        message.setData(rtnValue.get("asNo"));
        message.setMessage("");

      } else {
        message.setCode("98");
        message.setData(svc0004dmap.get("AS_NO"));
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

    List<EgovMap> getErrMstList = ASManagementListService.getErrMstList(params);
    return ResponseEntity.ok(getErrMstList);
  }

  @RequestMapping(value = "/getErrDetilList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getErrDetilList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getErrDetilList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getErrDetilList.do===============================");

    List<EgovMap> getErrDetilList = ASManagementListService.getErrDetilList(params);
    return ResponseEntity.ok(getErrDetilList);
  }

  @RequestMapping(value = "/getSLUTN_CODE_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSLUTN_CODE_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getSLUTN_CODE_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getSLUTN_CODE_List.do===============================");

    List<EgovMap> getSLUTN_CODE_List = ASManagementListService.getSLUTN_CODE_List(params);
    return ResponseEntity.ok(getSLUTN_CODE_List);
  }

  @RequestMapping(value = "/getDTAIL_DEFECT_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDTAIL_DEFECT_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDTAIL_DEFECT_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDTAIL_DEFECT_List.do===============================");

    List<EgovMap> getDTAIL_DEFECT_List = ASManagementListService.getDTAIL_DEFECT_List(params);
    return ResponseEntity.ok(getDTAIL_DEFECT_List);
  }

  @RequestMapping(value = "/getDEFECT_PART_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDEFECT_PART_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDEFECT_PART_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDEFECT_PART_List.do===============================");

    List<EgovMap> getDEFECT_PART_List = ASManagementListService.getDEFECT_PART_List(params);
    return ResponseEntity.ok(getDEFECT_PART_List);
  }

  @RequestMapping(value = "/getDEFECT_CODE_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDEFECT_CODE_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDEFECT_CODE_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDEFECT_CODE_List.do===============================");

    List<EgovMap> getDEFECT_CODE_List = ASManagementListService.getDEFECT_CODE_List(params);
    return ResponseEntity.ok(getDEFECT_CODE_List);
  }

  @RequestMapping(value = "/getDEFECT_TYPE_List.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDEFECT_TYPE_List(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getDEFECT_TYPE_List.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getDEFECT_TYPE_List.do===============================");

    List<EgovMap> getDEFECT_TYPE_List = ASManagementListService.getDEFECT_TYPE_List(params);
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

    return "services/as/sendNewSMSPop";
  }

  @RequestMapping(value = "/getCustAddressInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustAddressInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getCustAddressInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getCustAddressInfo.do===============================");

    String address = ASManagementListService.getCustAddressInfo(params);
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

    EgovMap CT = ASManagementListService.getSmsCTMemberById(params);
    return ResponseEntity.ok(CT);
  }

  @RequestMapping(value = "/getSmsCTMMemberById.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getSmsCTMMemberById(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getSmsCTMMemberById.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getSmsCTMMemberById.do===============================");

    EgovMap CTM = ASManagementListService.getSmsCTMMemberById(params);
    logger.debug("CTM {}", CTM);
    return ResponseEntity.ok(CTM);
  }

  @RequestMapping(value = "/getMemberByMemberIdCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getMemberByMemberIdCode(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getMemberByMemberIdCode.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getMemberByMemberIdCode.do===============================");

    EgovMap MEMup = ASManagementListService.getMemberByMemberIdCode(params);
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
    String serialChk = ASManagementListService.getSerialChk(params);
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
      list = ASManagementListService.selectSVC0023T(params);
    } else if ("AS".equals(logType)) {
      list = ASManagementListService.selectSVC0024T(params);
    } else if ("INS".equals(logType)) {
      list = ASManagementListService.selectSVC0025T(params);
    } else if ("PR".equals(logType)) {
      list = ASManagementListService.selectSVC0026T(params);
    }

    logger.debug("list  {}", list);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/initAPILog.do")
  public String initAPILog(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/initAPILog.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/initAPILog.do===============================");

    return "services/as/apiLogList";
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
    EgovMap asReceiveInfo = ASManagementListService.checkASReceiveEntry(params);
    EgovMap asReceiveCom = ASManagementListService.checkASCom(params);
    EgovMap hsInfo = ASManagementListService.checkHSStatus(params);
    EgovMap warrentyInfo = ASManagementListService.checkWarrentyStatus(params);
    EgovMap specialAgreement = ASManagementListService.checkSpecialAgreement(params);

    if (asReceiveInfo != null) {
      if (asReceiveInfo.get("asStus") != null) {
        msg = msg + "* This order AS is under " + asReceiveInfo.get("asStusDesc") + " status.<br />";
      } else {
        msg = msg + "";
      }
    } else {
      msg = msg + "";
    }

    if (asReceiveCom != null) {
      if (asReceiveCom.get("asStus") != null) {
        msg = msg + "* This order AS is under " + asReceiveCom.get("asStusDesc") + " status in current Month.<br />";
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

    if (specialAgreement != null) {
      msg = msg
          + "* This order is under special agreement (Selayang Hospital). Kindly advise customer as per the terms of agreement for Selayang Hospital.<br />";

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

    List<EgovMap> list = ASManagementListService.checkAOASRcdStat(params);
    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/selRcdTms.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkRcdTms(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/selRcdTms.do=======================");
    logger.debug("params : {}", params);

    int noRcd = ASManagementListService.selRcdTms(params);
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

  @RequestMapping(value = "/chkPmtMap.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkPmtMap(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/chkPmtMap.do=======================");
    logger.debug("params : {}", params);

    int noRcd = ASManagementListService.chkPmtMap(params);
    logger.debug("noRcd : ", noRcd);
    logger.debug("==================/chkPmtMap.do=======================");
    if (noRcd == 0) {
      message.setMessage("OK");
      message.setCode("1");
    } else {
      message.setMessage("Payment of This AS Already Map");
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

    List<EgovMap> list = ASManagementListService.getASEntryCommission(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/dftTypPop.do")
  public String dftTypPop(@RequestParam Map<String, Object> params, ModelMap model) {
	  logger.debug("== params - dftTypPop : " + params.toString());
    model.put("callPrgm", params.get("callPrgm"));
    model.put("prodCde", params.get("prodCde"));
    model.put("ddCde", params.get("ddCde"));
    model.put("dtCde", params.get("dtCde"));
    model.put("matchMatDefCode", params.get("matchMatDefCode"));

    return "services/as/dftTypPop";
  }

  @RequestMapping(value = "/getDftTyp.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDftTyp(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getDftTyp.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("== true false " + CommonUtils.nvl(params.get("search4")).toString().equals(null));


    if(!CommonUtils.nvl(params.get("search4")).toString().equals("")){
    	String[] matchMatDefCodeP = params.get("search4").toString().split(",");
    	params.put("matchMatDefCodeP", matchMatDefCodeP);
    }

    List<EgovMap> dftCde = ASManagementListService.getDftTyp(params);

    logger.debug("== dftCde : {}", dftCde);
    logger.debug("===========================/getDftTyp.do===============================");
    return ResponseEntity.ok(dftCde);
  }

  @RequestMapping(value = "/newASInHouseAddSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newASInHouseAddSerial(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newASInHouseAddSerial.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/newASInHouseAddSerial.do===============================");

    params.put("updator", sessionVO.getUserId());
    ReturnMessage message = new ReturnMessage();

    message = ASManagementListService.newASInHouseAddSerial(params);

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

    int rtnValue = ASManagementListService.asResultBasic_updateSerial(params);

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

  @RequestMapping(value = "/newResultUpdateSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> newResultUpdateSerial(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/newResultUpdateSerial.do===============================");
    logger.debug("== params " + params.toString());

    params.put("updator", sessionVO.getUserId());
    params.put("chkInstallAcc", params.get("INS_ACC_CHK"));

    LinkedHashMap asResultM = (LinkedHashMap) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    // List<EgovMap> all = (List<EgovMap>) params.get("all");

    logger.debug("== asResultM = " + asResultM.toString());
    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());
    logger.debug("===========================/newResultUpdateSerial.do===============================");

    EgovMap rtnValue = ASManagementListService.asResult_updateSerial(params);

    logger.debug("newResultUpdate == " + rtnValue.toString());

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(rtnValue.get("asNo"));
    message.setMessage("");

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectCustInstAddJsonInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCustInstAddInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("== params " + params.toString());

    EgovMap custInfo = ASManagementListService.selectCustomerInstallationAddress(params);

    return ResponseEntity.ok(custInfo);
  }

  @RequestMapping(value = "/selectDefectEntry.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDefectEntry(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
	//added by keyi 20211015
    logger.debug("===========================/getErrDetilList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getErrDetilList.do===============================");

    List<EgovMap> selectDefectEntry = ASManagementListService.selectDefectEntry(params);
    return ResponseEntity.ok(selectDefectEntry);
  }

  @RequestMapping(value = "/selectFilterSerialConfig.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectFilterSerialConfig(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("== params " + params.toString());

    EgovMap filterConfig = ASManagementListService.selectFilterSerialConfig(params);

    return ResponseEntity.ok(filterConfig);
  }

}
