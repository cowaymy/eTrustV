package com.coway.trust.web.homecare.services.as;

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
import com.coway.trust.biz.homecare.services.as.HcASManagementListService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 11/12/2019    KR-JIN      1.0.0       - AS Order -> Homecare Copy
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/homecare/services/as")
public class HcASManagementListController {
  private static final Logger logger = LoggerFactory.getLogger(HcASManagementListController.class);

  @Resource(name = "hcASManagementListService")
  private HcASManagementListService hcASManagementListService;


  @Resource(name = "ASManagementListService")
  private ASManagementListService ASManagementListService;


  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  /*

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "InHouseRepairService")
  private InHouseRepairService inHouseRepairService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Autowired
  private AdaptorService adaptorService;		// SMS
*/

  @Autowired
  private MessageSourceAccessor messageAccessor;


  @RequestMapping(value = "/initASManagementList.do")
  public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
    // GET SEARCH DATE RANGE
    String range = hcASManagementListService.getSearchDtRange();

    // as Type : 58
    List<EgovMap> asTyp = hcASManagementListService.selectAsTyp();

    // as stat : SYS0094M
    List<EgovMap> asStat = hcASManagementListService.selectAsStat();

    // HomeCare Branch : SYS0005M - 5743
    model.addAttribute("branchList", hcASManagementListService.selectHomeCareBranchWithNm());

    model.put("DT_RANGE", CommonUtils.nvl(range));
    model.put("asTyp", asTyp);
    model.put("asStat", asStat);

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "homecare/services/as/hcASManagementList";
  }


  @RequestMapping(value = "/getASFilterInfo.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASFilterInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception{
    logger.debug("===========================/getASFilterInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASFilterInfo.do===============================");

    if (params.get("prdctCd") != null) {
      String str = params.get("prdctCd").toString();
      String[] Idx = str.split("B");

      params.put("prdctCd", Idx[0]);
    }
    logger.debug("params : {}", params.toString());

    List<EgovMap> list = hcASManagementListService.getASFilterInfo(params);

    if (list.size() == 0) {
      list = hcASManagementListService.getASFilterInfoOld(params);
    }

    return ResponseEntity.ok(list);
  }


  @RequestMapping(value = "/selectCTByDSC.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTMByDSC(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {

      List<EgovMap> selectCTSubGroupDscList = hcASManagementListService.selectCTByDSC(params);
      //logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
      return ResponseEntity.ok(selectCTSubGroupDscList);
  }

  @RequestMapping(value = "/selectCTByDSCSearch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTByDSCSearch(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {

      List<EgovMap> selectCTSubGroupDscList = hcASManagementListService.selectCTByDSCSearch(params);
      //logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
      return ResponseEntity.ok(selectCTSubGroupDscList);
  }



  // AS Search
  @RequestMapping(value = "/searchASManagementList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectASManagementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {
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

    List<EgovMap> ASMList = hcASManagementListService.selectASManagementList(params);

    //logger.debug("== ASMList : {}", ASMList);
    logger.debug("===========================/searchASManagementList.do===============================");
    return ResponseEntity.ok(ASMList);
  }

  // Create AS Popup
  @RequestMapping(value = "/hcASReceiveEntryPop.do")
  public String hcASReceiveEntryPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    model.put("ORD_ID", (String) params.get("in_ordId"));
    model.put("ORD_NO", (String) params.get("in_ordNo"));
    model.put("AS_ID", (String) params.get("in_asId"));
    model.put("AS_NO", (String) params.get("in_asNo"));
    model.put("AS_ResultNO", (String) params.get("asResultNo"));
    model.put("AS_ResultId", (String) params.get("in_asResultId"));

    //if (!"".equals((String) params.get("in_ordId"))) {
    //  return "services/as/ASReceiveEntryPop";
    //} else {
      return "homecare/services/as/hcASReceiveEntryPop";
    //}
  }

  @RequestMapping(value = "/searchOrderNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderNo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    EgovMap basicInfo = hcASManagementListService.selectOrderBasicInfo(params);
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
    EgovMap as_ord_basicInfo = hcASManagementListService.selectOrderBasicInfo(params);

    List<EgovMap> timePick = ASManagementListService.selectTimePick();

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

     //*
     //* if("VIEW".equals(params.get("mod"))){ asentryInfo =
     //* ASManagementListService.selASEntryView(params); model.put("asentryInfo",
     //* asentryInfo); }
     //*

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

    return "homecare/services/as/hcResultASReceiveEntryPop";
  }


  @RequestMapping(value = "/getASHistoryList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASHistoryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {
      List<EgovMap> sHistoryList = hcASManagementListService.getASHistoryList(params);
      return ResponseEntity.ok(sHistoryList);
  }

  // Create AS Entry Pop - Before Service Grid Search
  @RequestMapping(value = "/getBSHistoryList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBSHistoryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {
    //logger.debug("===========================/getBSHistoryList.do===============================");
	//logger.debug("== params " + params.toString());
	//logger.debug("===========================/getBSHistoryList.do===============================");

	List<EgovMap> bHistoryList = hcASManagementListService.getBSHistoryList(params);
    return ResponseEntity.ok(bHistoryList);
  }

  @RequestMapping(value = "/getBrnchId.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBrnchId(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) throws Exception {

	  List<EgovMap> list = hcASManagementListService.getBrnchId(params);
      return ResponseEntity.ok(list);
  }

  // Add AS Result
  @RequestMapping(value = "/ASNewResultPop.do")
  public String insertASResult(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
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

    List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr();
    model.addAttribute("lbrFeeChr", lbrFeeChr);

    // fltQty : 1
    //List<EgovMap> fltQty = ASManagementListService.selectFltQty();
    //model.addAttribute("fltQty", fltQty);

    List<EgovMap> fltPmtTyp = ASManagementListService.selectFltPmtTyp();
    model.addAttribute("fltPmtTyp", fltPmtTyp);

    // IN HOUSE SETTING (PROMISE DAYS)
    String days = ASManagementListService.getInHseLmtDy();
    model.addAttribute("inHseLmtDy", days);

    return "homecare/services/as/hcNewASResultPop";
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

    return "homecare/services/as/hcAsResultEditViewPop";
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

    List<EgovMap> asCrtStat = ASManagementListService.selectAsCrtStat();
    model.addAttribute("asCrtStat", asCrtStat);

    List<EgovMap> timePick = ASManagementListService.selectTimePick();
    model.addAttribute("timePick", timePick);

    EgovMap orderDetail;
    params.put("salesOrderId", (String) params.get("ord_Id"));

    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    model.put("orderDetail", orderDetail);

    return "homecare/services/as/hcAsResultEditBasicPop";
  }

  @RequestMapping(value = "/asResultInfoEdit.do")
  public String asResultInfoEdit(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
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

    List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr();
    model.addAttribute("lbrFeeChr", lbrFeeChr);

    List<EgovMap> fltQty = ASManagementListService.selectFltQty();
    model.addAttribute("fltQty", fltQty);

    List<EgovMap> fltPmtTyp = ASManagementListService.selectFltPmtTyp();
    model.addAttribute("fltPmtTyp", fltPmtTyp);

    return "homecare/services/as/hcInc_asResultEditPop";
  }

  @RequestMapping(value = "/assignCTTransferPop.do")
  public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    logger.debug("===========================/assignCTTransferPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCTTransferPop.do===============================");

    return "homecare/services/as/hcAssignCTTransferPop";
  }

  @RequestMapping(value = "/assignCtList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignCtList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {
    logger.debug("===========================/assignCtList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtList.do===============================");

    List<EgovMap> list = hcASManagementListService.assignCtList(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/assignCtOrderList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignCtOrderList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {
    logger.debug("===========================/assignCtOrderList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtOrderList.do===============================");

    String vAsNo = (String) params.get("asNo");
    String[] asNo = null;

    if (!StringUtils.isEmpty(vAsNo)) {
      asNo = ((String) params.get("asNo")).split(",");
      params.put("asNo", asNo);
    }

    List<EgovMap> list = hcASManagementListService.assignCtOrderList(params);

    return ResponseEntity.ok(list);
  }


  @RequestMapping(value = "/hcDftTypPop.do")
  public String dftTypPop(@RequestParam Map<String, Object> params, ModelMap model) {
    model.put("callPrgm", params.get("callPrgm"));
    model.put("prodCde", params.get("prodCde"));
    model.put("ddCde", params.get("ddCde"));
    model.put("dtCde", params.get("dtCde"));
    //logger.debug("== params - hcDftTypPop : " + params.toString());
    return "homecare/services/as/hcDftTypPop";
  }

  @RequestMapping(value = "/getASRulstSVC0004DInfo.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRulstSVC0004DInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception{
    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");

    List<EgovMap> list = hcASManagementListService.getASRulstSVC0004DInfo(params);

    return ResponseEntity.ok(list);
  }

}