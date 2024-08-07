package com.coway.trust.web.homecare.services.as;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.services.as.HcASManagementListService;
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtNewService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.PreASManagementListService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import com.coway.trust.config.handler.SessionHandler;

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

    @Resource(name = "serialMgmtNewService")
    private SerialMgmtNewService serialMgmtNewService;

    @Resource(name = "PreASManagementListService")
    private PreASManagementListService PreASManagementListService;

    @Resource(name = "salesCommonService")
    private SalesCommonService salesCommonService;

    @Resource(name = "hsManualService")
    private HsManualService hsManualService;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Autowired
    private SessionHandler sessionHandler;


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

  @RequestMapping(value = "/selectCTByDSCSearch2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTByDSCSearch2(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {

      List<EgovMap> selectCTSubGroupDscList = hcASManagementListService.selectCTByDSCSearch2(params);
      //logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
      return ResponseEntity.ok(selectCTSubGroupDscList);
  }
  /*@RequestMapping(value = "/selectHTAndDTCode", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHTAndDTCode() throws Exception {
      List<EgovMap> selectHTAndDTCodeList = hcASManagementListService.selectHTAndDTCode();
      logger.debug("selectHTAndDTCodeList {}", selectHTAndDTCodeList);
      return ResponseEntity.ok(selectHTAndDTCodeList);
  }*/

  @RequestMapping(value = "/getErrMstList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getErrMstList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception{
    logger.debug("===========================/getErrMstList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getErrMstList.do===============================");

    List<EgovMap> getErrMstList = hcASManagementListService.getErrMstList(params);
    return ResponseEntity.ok(getErrMstList);
  }

  // AS Search
  @RequestMapping(value = "/searchASManagementList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectASManagementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception {
    logger.debug("===========================/searchASManagementList.do===============================");
    logger.debug("== params " + params.toString());

    String[] asTypeList = request.getParameterValues("asType");
    String[] asStatusList = request.getParameterValues("asStatus");
    String[] productList = request.getParameterValues("asProduct");

    /**String cmbbranchId = request.getParameter("cmbbranchId");  Removed for HA and HC branch merging, Hui Ding, 13/03/2024
    String cmbbranchId2 = request.getParameter("cmbbranchId2"); Removed for HA and HC branch merging, Hui Ding, 13/03/2024 **/

    String[] cmbbranchId = request.getParameterValues("cmbbranchId"); /**Added for HA and HC branch merging, Hui Ding, 13/03/2024 **/
    String[] cmbbranchId3 = request.getParameterValues("cmbbranchId3"); /**Added for HA and HC branch merging, Hui Ding, 13/03/2024 **/
    String cmbctId = request.getParameter("cmbctId");

    params.put("asTypeList", asTypeList);
    params.put("asStatusList", asStatusList);
    params.put("cmbbranchIdList", cmbbranchId);
    params.put("cmbbranchIdList3", cmbbranchId3);
    params.put("cmbctId", cmbctId);
    params.put("productList", productList);

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

    model.put("PREAS_ORDNO", (String) params.get("preAsSalesOrderNo"));
    model.put("PREAS_DEFECTCODE", (String) params.get("preAsDefectCode"));
    model.put("PREAS_TYPE", (String) params.get("preAsType"));

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
    logger.debug("== resultASReceiveEntryPop params " + params.toString());
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

    model.put("preAsType", (String) params.get("preAsType"));

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

    EgovMap sstInfo = commonService.getSstRelatedInfo();
    //List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr();
    List<EgovMap> lbrFeeChr =  hcASManagementListService.selectLbrFeeChr(sstInfo);
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

    String asSol_Disable = "";
    Map<String, Object> sParts = new HashMap<String, Object>();
    sParts.put("AS_RESULT_NO", (String) params.get("as_Result_No"));
    List<EgovMap> partsList = hcASManagementListService.getASRulstEditFilterInfo(sParts);
    for(EgovMap eMap : partsList){
    	if("Y".equals( (String)eMap.get("isSmo") )){
    		asSol_Disable = "T";
    		break;
    	}
    }
    model.put("asSolDisable", asSol_Disable);

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

    EgovMap sstInfo = commonService.getSstRelatedInfo();
    //List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr();
    List<EgovMap> lbrFeeChr =  hcASManagementListService.selectLbrFeeChr(sstInfo);
    model.addAttribute("lbrFeeChr", lbrFeeChr);

    List<EgovMap> fltQty = ASManagementListService.selectFltQty();
    model.addAttribute("fltQty", fltQty);

    List<EgovMap> fltPmtTyp = ASManagementListService.selectFltPmtTyp();
    model.addAttribute("fltPmtTyp", fltPmtTyp);

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

    return "homecare/services/as/hcInc_asResultEditPop";
  }

  @RequestMapping(value = "/assignCTTransferPop.do")
  public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    logger.debug("===========================/assignCTTransferPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCTTransferPop.do===============================");
    //model.put("data", params);

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
    model.put("matchMatDefCode", params.get("matchMatDefCode"));
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


  @RequestMapping(value = "/getASHistoryInfo.do", method = RequestMethod.POST)
  public ResponseEntity<List<EgovMap>> getASHistoryInfo(@RequestBody Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getASHistoryInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASHistoryInfo.do===============================");

    List<EgovMap> list = ASManagementListService.getASHistoryInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/getASRulstEditFilterInfo.do", method = RequestMethod.POST)
  public ResponseEntity<List<EgovMap>> getASRulstEditFilterInfo(@RequestBody Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws Exception{
    logger.debug("===========================/getASRulstEditFilterInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRulstEditFilterInfo.do===============================");

    List<EgovMap> list = hcASManagementListService.getASRulstEditFilterInfo(params);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/assignCtOrderListSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> assignCtOrderListSave(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) throws Exception{
    logger.debug("===========================/assignCtOrderListSave.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/assignCtOrderListSave.do===============================");

    params.put("updator", sessionVO.getUserId());
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    logger.debug("asResultM ===>" + update.toString());

    int rtnValue = hcASManagementListService.updateAssignCT(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(99);
    message.setMessage("");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectSerialYnSearch.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> selectSerialYnSearch(@RequestBody Map<String, Object> params, HttpServletRequest request, Model model) throws Exception{
    String rtnValue = hcASManagementListService.selectSerialYnSearch(params);
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(rtnValue);
    message.setMessage("");
    return ResponseEntity.ok(message);
  }


    @RequestMapping(value = "/selectSerialChk.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectSerialChk(@RequestBody Map<String, Object> params, HttpServletRequest request, Model model) throws Exception{
    	ReturnMessage message = new ReturnMessage();

        String crDate = "";
        String month = "";
        String sDate = "";
        String serial = (String) params.get("serial");

        crDate = serial.substring(8, 13);

        if(StringUtils.isBlank(crDate) || crDate.length() != 5){
          message.setCode(AppConstants.FAIL);
          return ResponseEntity.ok(message);
        }

        month = crDate.substring(2, 3);

        switch(month){
          case "A":
          	month = "10";
          	break;
          case "B":
          	month = "11";
          	break;
          case "C":
          	month = "12";
          	break;
          default:
          	month = "0"+month;
          break;
        }
        sDate = crDate.substring(0, 2) + month + crDate.substring(3, 5);
		if(!validationDate(sDate)){
			message.setCode(AppConstants.FAIL);
			return ResponseEntity.ok(message);
		}

		EgovMap itemmap = serialMgmtNewService.selectItemSerch(params);
		if(itemmap == null || itemmap.size() == 0){
			message.setCode(AppConstants.FAIL);
			return ResponseEntity.ok(message);
		}

		message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
    }
    private boolean validationDate(String checkDate){
    	try{
    		SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd");
    		dateFormat.setLenient(false);
    		dateFormat.parse(checkDate);
    		return true;
    	}catch (ParseException  e){
    		return false;
    	}
    }

    // AS result save
    @RequestMapping(value = "/newASInHouseAddSerial.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> newASInHouseAddSerial(@RequestBody Map<String, Object> params, Model model,
        HttpServletRequest request, SessionVO sessionVO) throws Exception{
      logger.debug("===========================/newASInHouseAddSerial.do===============================");
      logger.debug("== params " + params.toString());
      logger.debug("===========================/newASInHouseAddSerial.do===============================");

      params.put("updator", sessionVO.getUserId());
      ReturnMessage message = new ReturnMessage();

      message = hcASManagementListService.newASInHouseAddSerial(params);
      //logger.debug("[newASInHouseAddSerial] message >> " + message);
      return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/newResultAdd.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> newResultAdd(@RequestBody Map<String, Object> params, Model model,
        HttpServletRequest request, SessionVO sessionVO) throws Exception{
      logger.debug("===========================/newResultAdd.do===============================");
      logger.debug("== params " + params.toString());
      logger.debug("===========================/newResultAdd.do===============================");

      params.put("updator", sessionVO.getUserId());
      ReturnMessage message = new ReturnMessage();

      message = hcASManagementListService.newResultAdd(params);

      return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/newResultUpdateSerial.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> newResultUpdateSerial(@RequestBody Map<String, Object> params, Model model,
        HttpServletRequest request, SessionVO sessionVO) throws Exception{
      logger.debug("===========================/newResultUpdateSerial.do===============================");
      logger.debug("== params " + params.toString());

      params.put("updator", sessionVO.getUserId());

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

      EgovMap rtnValue = hcASManagementListService.asResult_updateSerial(params);

      logger.debug("newResultUpdate == " + rtnValue.toString());

      ReturnMessage message = new ReturnMessage();
      message.setCode(AppConstants.SUCCESS);
      message.setData(rtnValue.get("asNo"));
      message.setMessage("");

      return ResponseEntity.ok(message);

    }

    @RequestMapping(value = "/initPreAsSubmissionList.do")
  	public String initPreAsSubmissionList(@RequestParam Map<String, Object> params, ModelMap model) {

  	  	SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
  		params.put("userId", sessionVO.getUserId());

  		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
  			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
  			model.put("memType", getUserInfo.get("memType"));
  			model.put("orgCode", getUserInfo.get("orgCode"));
  			model.put("grpCode", getUserInfo.get("grpCode"));
  			model.put("deptCode", getUserInfo.get("deptCode"));
  			model.put("memCode", getUserInfo.get("memCode"));
  			logger.info("memType ##### " + getUserInfo.get("memType"));
  		}


      	List<EgovMap> asStat = PreASManagementListService.selectPreAsStat();
      	params.put("errorType", "HC");
      	List<EgovMap> hcErrorCodeList = PreASManagementListService.getErrorCodeList(params);
      	model.put("asStat", asStat);
      	model.put("hcErrorCodeList", hcErrorCodeList);
  		return "homecare/services/as/hcPreAsSubmissionList";
  	}


    @RequestMapping(value = "/hcPreAsSubmissionRegister.do")
	public String hcPreAsSubmissionRegister(@RequestParam Map<String, Object> params, ModelMap model) {
		return "homecare/services/as/hcPreAsSubmissionRegister";
	}

    @RequestMapping(value = "/initPreASManagementList.do")
    public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

      // GET SEARCH DATE RANGE
      String range = ASManagementListService.getSearchDtRange();

      List<EgovMap> asTyp = ASManagementListService.selectAsTyp();
      List<EgovMap> asStat = PreASManagementListService.selectPreAsStat();
      List<EgovMap> asProduct = PreASManagementListService.asProd(params);
      List<EgovMap> branchList = hsManualService.selectBranchList(params);

      model.put("DT_RANGE", CommonUtils.nvl(range));
      model.put("asTyp", asTyp);
      model.put("asStat", asStat);
      model.put("asProduct", asProduct);
      model.put("branchList", branchList);

      return "homecare/services/as/hcPreASManagementList";
    }


    @RequestMapping(value = "/getAsDefectEntry.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getAsDefectEntry(@RequestParam Map<String, Object> params,
        HttpServletRequest request, ModelMap model) {
      logger.debug("===========================/getAsDefectEntry.do===============================");
      logger.debug("== params heres" + params.toString());

      List<EgovMap> getAsDefectEntryList = hcASManagementListService.getAsDefectEntry(params);

      logger.debug("== getAsDefectEntryList : {}" + getAsDefectEntryList);
      logger.debug("===========================/getAsDefectEntry.do===============================");
      return ResponseEntity.ok(getAsDefectEntryList);
    }

    @RequestMapping(value = "/getErrDetilList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getErrDetilList(@RequestParam Map<String, Object> params,
        HttpServletRequest request, ModelMap model) {
      logger.debug("===========================/getErrDetilList.do===============================");
      logger.debug("== params " + params.toString());
      logger.debug("===========================/getErrDetilList.do===============================");

      List<EgovMap> getErrDetilList = hcASManagementListService.getErrDetilList(params);
      return ResponseEntity.ok(getErrDetilList);
    }

    @RequestMapping(value = "/getPartnerMemInfo.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getPartnerMemInfo(@RequestParam Map<String, Object> params, HttpServletRequest request,
        ModelMap model) throws Exception {

  	  List<EgovMap> list = hcASManagementListService.getPartnerMemInfo(params);
        return ResponseEntity.ok(list);
    }

}