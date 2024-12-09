package com.coway.trust.web.services.bs;

import java.text.ParseException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberListController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs")
public class HsManualController {
  private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/initHsManualList.do")
  public String initBsManagementList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    logger.debug("getUserBranchId : {}", sessionVO.getUserBranchId());

    params.put("memberLevel", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());

    // params.put("userType123", "3");

    logger.debug("=======================================================================================");
    logger.debug("============== initHsManualList params{} ", params);
    logger.debug("=======================================================================================");

    List<EgovMap> branchList = hsManualService.selectBranchList(params);
    model.addAttribute("branchList", branchList);

    model.addAttribute("userName", sessionVO.getUserName());

    model.addAttribute("memberLevel", sessionVO.getMemberLevel());
    model.addAttribute("userType", sessionVO.getUserTypeId());
    // model.addAttribute("userType","3");

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "services/bs/hsManual";
  }

  @RequestMapping(value = "/selectHSConfigListPop.do")
  public String selectHSConfigListPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) {
    logger.debug("params 222 : {}", params);
    model.addAttribute("brnchCdList", params.get("BrnchId"));
    model.addAttribute("ordCdList", params.get("CheckedItems"));
    model.addAttribute("ManuaMyBSMonth", params.get("ManuaMyBSMonth"));
    model.addAttribute("SalesOrderNo", params.get("SalesOrderNo"));

    return "services/bs/hSConfigPop";
  }

  @RequestMapping(value = "/selecthSCodyChangePop.do")
  public String selecthSCodyChangePop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) {

    logger.debug("selecthSCodyChangePop params : {}", params);

    model.addAttribute("brnchCdList", params.get("BrnchId"));
    model.addAttribute("ordCdList", params.get("CheckedItems"));
    model.addAttribute("ManuaMyBSMonth", params.get("ManuaMyBSMonth"));
    model.addAttribute("deptList", params.get("deptList"));
    return "services/bs/hSCodyChangePop";
  }

  @RequestMapping(value = "/assignCDChangeListSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> assignCDChangeListSave(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {

    logger.debug("in  assignCDChangeListSave ");
    logger.debug("			pram set  log");
    logger.debug("					" + params.toString());
    logger.debug("			pram set end  ");

    params.put("updator", sessionVO.getUserId());
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    logger.debug("HSResultM ===>" + update.toString());

    String rtnValue = hsManualService.updateAssignCody(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(99);
    message.setMessage(rtnValue);

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectPopUpCdList.do")
  public ResponseEntity<List<EgovMap>> selectPopUpCdList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    Map parameterMap = request.getParameterMap();
    String[] nameParam = (String[]) parameterMap.get("name");

    logger.debug(" selectPopUpList in  ");
    logger.debug(" 			: " + params.toString());
    logger.debug(" selectPopUpList in  ");

    if (null != params.get("SaleOrdList")) {
      String olist = (String) params.get("SaleOrdList");
      String[] spl = olist.split(",");
      params.put("saleOrdListSp", spl);
    }

    if (null != params.get("DepartmentList")) {
      String deptList = (String) params.get("DepartmentList");
      String[] spl = deptList.split(",");
      params.put("deptListSpl", spl);
    }

    logger.debug("params1 : {}", params);

    // brnch to CodyList
    List<EgovMap> resultList = hsManualService.getCdList_1(params);
    // model.addAttribute("brnchCdList1", resultList);

    List<EgovMap> resultList1 = hsManualService.selectHsManualListPop(params);
    // model.addAttribute("ordCdList1", resultList1);

    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectPopUpCustList.do")
  public ResponseEntity<List<EgovMap>> selectPopUpCustList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    Map parameterMap = request.getParameterMap();
    String[] nameParam = (String[]) parameterMap.get("name");

    logger.debug(" selectPopUpList in  ");
    logger.debug(" 			: " + params.toString());
    logger.debug(" selectPopUpList in  ");

    if (null != params.get("SaleOrdList")) {

      String olist = (String) params.get("SaleOrdList");

      String[] spl = olist.split(",");

      params.put("saleOrdListSp", spl);
    }

    List<EgovMap> resultList1 = hsManualService.selectHsManualListPop(params);
    // model.addAttribute("ordCdList1", resultList1);

    return ResponseEntity.ok(resultList1);
  }

  @RequestMapping(value = "/selectHsManualList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHsManualList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    params.put("user_id", sessionVO.getUserId());
    params.put("userType", sessionVO.getUserTypeId());

    // params.put("userType", "3");

    // 조회.
    List<EgovMap> bsManagementList = hsManualService.selectHsManualList(params);

    // brnch 임시 셋팅
    for (int i = 0; i < bsManagementList.size(); i++) {

      EgovMap record = (EgovMap) bsManagementList.get(i);// EgovMap으로 형변환하여 담는다.

      // ("brnchId", sessionVO.getUserBranchId());
    }

    return ResponseEntity.ok(bsManagementList);
  }

  /**
   * Services - HS - HSConfigSettingt List 메인 화면
   *
   * @param params
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/initHSConfigSettingList.do")
  public String initHSConfigSettingList(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/bs/hsConfigSetting";
  }

  @RequestMapping(value = "/selectHsBasicList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHsBasicList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    params.put("user_id", sessionVO.getUserId());

    // 조회.
    List<EgovMap> hsBasicList = hsManualService.selectHsConfigList(params);

    // brnch 임시 셋팅
    for (int i = 0; i < hsBasicList.size(); i++) {
      EgovMap record = (EgovMap) hsBasicList.get(i);// EgovMap으로 형변환하여 담는다.
    }

    return ResponseEntity.ok(hsBasicList);
  }

  @RequestMapping(value = "/selectHsAssiinlList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHsAssiinlList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    params.put("user_id", sessionVO.getUserId());
    params.put("userType", sessionVO.getUserTypeId());

    logger.debug("userType :  " + sessionVO.getUserTypeId());
    // 조회.
    List<EgovMap> hsAssiintList = hsManualService.selectHsAssiinlList(params);

    return ResponseEntity.ok(hsAssiintList);
  }

  @RequestMapping(value = "/getCdUpMemList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCdUpMemList(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

    params.put("memLevl", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());

    logger.debug("=======================================================================================");
    logger.debug("============== getCdUpMemList params{} ", params);
    logger.debug("=======================================================================================");

    // Member Type 에 따른 Organization 조회.
    List<EgovMap> resultList = hsManualService.getCdUpMemList(params);

    return ResponseEntity.ok(resultList);
  }

  // HS manual
  @RequestMapping(value = "/getCdDeptList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCdDeptList(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

    params.put("memLevl", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());

    logger.debug("=======================================================================================");
    logger.debug("============== getCdDeptList params{} ", params);
    logger.debug("=======================================================================================");

    // Member Type 에 따른 Organization 조회.
    List<EgovMap> resultList = hsManualService.getCdDeptList(params);

    return ResponseEntity.ok(resultList);
  }

  /* BY KV - Change to textBox - txtcodyCode and below code no more used. */
  /*
   * @RequestMapping(value = "/getCdList.do", method = RequestMethod.GET) public
   * ResponseEntity<List<EgovMap>> getCdList(@RequestParam Map<String,
   * Object>params) { // Member Type 에 따른 Organization 조회. List<EgovMap>
   * resultList = hsManualService.getCdList(params);
   *
   * return ResponseEntity.ok(resultList); }
   */

  @RequestMapping(value = "/hsOrderSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertHsResult(@RequestBody Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {
    Boolean success = false;
    String msg = "";

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    Map<String, Object> resultValue = new HashMap<String, Object>();
    ReturnMessage message = new ReturnMessage();
    resultValue = hsManualService.insertHsResult(formMap, updList, sessionVO);

    message.setMessage("Complete to Add a HS Order.  " + resultValue.get("docNo"));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectHsInitDetailPop.do")
  public String selectHsInitDetailPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    params.put("schdulId", params.get("schdulId"));
    params.put("salesOrderId", params.get("salesOrdId"));

    EgovMap hsDefaultInfo = hsManualService.selectHsInitDetailPop(params);
    List<EgovMap> cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList(params);
    // List<EgovMap> cmbServiceMemList =
    // hsManualService.cmbServiceMemList(params);
    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//
    List<EgovMap> failReasonList = hsManualService.failReasonList(params);
    // List<EgovMap> serMemList = hsManualService.serMemList(params);

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    model.put("toDay", toDay);

    logger.debug(" params : ", params);
    logger.debug("hsDefaultInfo : {}", hsDefaultInfo);

    model.addAttribute("hsDefaultInfo", hsDefaultInfo);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
    // model.addAttribute("cmbServiceMemList", cmbServiceMemList);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("failReasonList", failReasonList);
    // model.addAttribute("serMemList", serMemList);
    params.put("groupCode", "511");
    model.addAttribute("unmatchRsnList", commonService.selectCodeList(params));

    model.addAttribute("serialEditBtnAccess", params.get("serialEditBtnAccess"));

    List<EgovMap> timePick = commonService.selectTimePick();
    model.addAttribute( "timePick", timePick );

    return "services/bs/hsDetailPop";

  }

  @RequestMapping(value = "/hsBasicInfoPop.do")
  public String selecthsBasicInfoPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    EgovMap basicinfo = null;
    EgovMap addresinfo = null;
    EgovMap contactinfo = null;
    EgovMap orderDetail = null;

    params.put("salesOrderId", params.get("salesOrdId"));
    logger.debug("===========================================>");
    logger.debug("params : {}", params);
    logger.debug("===========================================>");

    basicinfo = hsManualService.selectHsViewBasicInfo(params);
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

    List<EgovMap> cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList(params);
    List<EgovMap> failReasonList = hsManualService.failReasonList(params);
    // List<EgovMap> serMemList = hsManualService.serMemList(params);

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    model.put("toDay", toDay);

    model.addAttribute("basicinfo", basicinfo);
    logger.debug("basicinfo : {}", basicinfo);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
    model.addAttribute("failReasonList", failReasonList);
    model.addAttribute("MOD", params.get("MOD"));
    // model.addAttribute("serMemList", serMemList);
    model.addAttribute("ROW", params.get("ROW"));
    params.put("groupCode", "511");
    model.addAttribute("unmatchRsnList", commonService.selectCodeList(params));
    model.addAttribute("serialEditBtnAccess", params.get("serialEditBtnAccess"));

    List<EgovMap> timePick = commonService.selectTimePick();
    model.addAttribute( "timePick", timePick );

    return "services/bs/hsEditPop";

  }

  @RequestMapping(value = "/selectHsViewfilterPop.do")
  public ResponseEntity<List<EgovMap>> selectHsViewfilterPop(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> hsViewfilterInfo = null;

    hsViewfilterInfo = hsManualService.selectHsViewfilterInfo(params);
    // model.addAttribute("hsViewfilterInfo", hsViewfilterInfo);

    return ResponseEntity.ok(hsViewfilterInfo);
  }

  @RequestMapping(value = "/hSMgtResultViewResultPop.do")
  public String hSMgtResultViewResultPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    EgovMap hSMgtResultViewResult = null;

    hSMgtResultViewResult = hsManualService.hSMgtResultViewResult(params);
    model.addAttribute("hSMgtResultViewResult", hSMgtResultViewResult);

    return "services/bs/hSManagementResultViewResultPop";
  }

  @RequestMapping(value = "/hSMgtResultViewResultFilter.do")
  public ResponseEntity<List<EgovMap>> hSMgtResultViewResultFilter(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> hSMgtResultViewResultFilter = null;

    hSMgtResultViewResultFilter = hsManualService.hSMgtResultViewResultFilter(params);
    // model.addAttribute("hsViewfilterInfo", hsViewfilterInfo);

    return ResponseEntity.ok(hSMgtResultViewResultFilter);
  }

  @RequestMapping(value = "/selectHistoryHSResult.do")
  public ResponseEntity<List<EgovMap>> selectHistoryHSResult(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> historyHSResult = null;

    historyHSResult = hsManualService.selectHistoryHSResult(params);

    return ResponseEntity.ok(historyHSResult);
  }

  @RequestMapping(value = "/selectFilterTransaction.do")
  public ResponseEntity<List<EgovMap>> selectFilterTransaction(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> filterTransaction = null;

    filterTransaction = hsManualService.selectFilterTransaction(params);

    return ResponseEntity.ok(filterTransaction);
  }

  @RequestMapping(value = "/SelectHsFilterList.do")
  public ResponseEntity<List<EgovMap>> SelectHsFilterList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    // params.put("salesOrdId", params.get("salesOrdId"));

    List<EgovMap> hsFilterList = hsManualService.selectHsFilterList(params);
    // model.addAttribute("hsFilterList", hsFilterList);

    return ResponseEntity.ok(hsFilterList);

  }

  /**
   * Search rule book management list
   *
   * @param params
   * @param request
   * @return
   * @throws ParseException
   * @throws Exception
   */
  @RequestMapping(value = "/addIHsResult.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> addIHsResult(@RequestBody Map<String, Object> params, HttpServletRequest request,
      SessionVO sessionVO) throws Exception {
    ReturnMessage message = new ReturnMessage();
    logger.debug("addIHsResult params : {}", params);

    String msg = "";
    boolean success = false;

    Map<String, Object> resultValue = new HashMap<String, Object>();

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    logger.debug("insList : {}", insList);
    resultValue = hsManualService.addIHsResult(formMap, insList, sessionVO);

    int status = 0;
    status = Integer.parseInt(formMap.get("cmbStatusType").toString());

    if (null != resultValue && status == 4) {

      HashMap spMap = (HashMap) resultValue.get("spMap");

      logger.debug("spMap :========>" + spMap.toString());

      if (!"000".equals(spMap.get("P_RESULT_MSG"))) {

        resultValue.put("logerr", "Y");
        msg = "Logistics call Error.";
      } else {

        msg = "Complete to Add a HS Order : " + resultValue.get("resultId");
      }

      servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
    } else if (null != resultValue && (status == 21 || status == 10)) {

      msg = "Complete to Add a HS Order : " + resultValue.get("resultId");

    }

    // CHECKING FILTER LIST IN SVC0007D
    params.put("selSchdulId", formMap.get("hidschdulId").toString());
    EgovMap useFilterList = hsManualService.getBSFilterInfo(params);
    // logger.debug("useFilterList : "+ useFilterList.toString());

    // INSERT AS ENTRY FOR OMBAK -- TPY
    if (useFilterList != null) {
      String stkId = useFilterList.get("stkId").toString();
      if (stkId.equals("1428")) { // 1428 - MINERAL FILTER
        logger.debug("==================== saveASEntryResult [Start] ========================");
        // logger.debug("saveASEntryResult params :"+ params.toString());

        params.put("userId", sessionVO.getUserId());
        params.put("salesOrdId", formMap.get("hidSalesOrdId").toString());
        params.put("codyId", formMap.get("hidCodyId").toString());
        params.put("settleDate", formMap.get("settleDate").toString());
        params.put("stkId", useFilterList.get("stkId").toString());
        params.put("stkCode", useFilterList.get("stkCode").toString());
        params.put("stkDesc", useFilterList.get("stkDesc").toString());
        params.put("stkQty", useFilterList.get("bsResultPartQty").toString());
        params.put("amt", useFilterList.get("amt").toString());
        params.put("totalAmt", useFilterList.get("totalAmt").toString());
        params.put("no", useFilterList.get("no").toString());
        // params.put("stkFilterId",
        // useFilterList.get("srvFilterId").toString());
        logger.debug("saveASEntryResult params :" + params.toString());

        Map<String, Object> sm = new HashMap<String, Object>();
        sm = hsManualService.saveASEntryResult(params);
        params.put("asNo", sm.get("asNo").toString());
        params.put("asId", sm.get("asId").toString());
        params.put("asResultNo", sm.get("asResultNo").toString());

        logger.debug("==================== saveASEntryResult [End] ========================");

        // INSERT TAX INVOICE FOR OMBAK -- TPY
        logger.debug("==================== saveASTaxInvoice [Start] ========================");
        logger.debug("saveASTaxInvoice params :" + params.toString());
        Map<String, Object> pb = new HashMap<String, Object>();
        pb = hsManualService.saveASTaxInvoice(params);

        logger.debug("==================== saveASTaxInvoice [End] ========================");

        msg = msg + "<br /> AS NO : " + sm.get("asNo").toString() + "<br /> AS REF : "
            + sm.get("asResultNo").toString();

      }

    }

    // Added to update only "Has Return" flag
    if (updList != null) {
        hsManualService.UpdateIsReturn(formMap, updList, sessionVO);
    }

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  //
  /**
   * Search rule book management list
   *
   * @param params
   * @param request
   * @return
   * @throws ParseException
   * @throws Exception
   */

  @RequestMapping(value = "/UpdateHsResult2.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> UpdateHsResult2(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params : {}", params);

    boolean success = false;
    Map<String, Object> resultValue = new HashMap<String, Object>();

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    logger.debug("UpdateHsResult2=============> in ");
    logger.debug("[" + params.toString() + "]");
    logger.debug("UpdateHsResult2=============> in");

    resultValue = hsManualService.UpdateHsResult2(formMap, insList, sessionVO);

    if (updList != null) {
      hsManualService.UpdateIsReturn(formMap, updList, sessionVO);
    }

    message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno"));

    return ResponseEntity.ok(message);
  }

   /**
 * TO-DO HS Edit Save-Serial version
 * @Author KR-MIN
 * @Date 2019. 12. 31.
 * @param params
 * @param request
 * @param sessionVO
 * @return
 * @throws ParseException
 */
@RequestMapping(value = "/UpdateHsResult2Serial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> UpdateHsResult2Serial(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params : {}", params);

    boolean success = false;
    Map<String, Object> resultValue = new HashMap<String, Object>();

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    logger.debug("UpdateHsResult2=============> in ");
    logger.debug("[" + params.toString() + "]");
    logger.debug("UpdateHsResult2=============> in");

    resultValue = hsManualService.UpdateHsResult2Serial(formMap, insList, sessionVO, updList);


    message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno"));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/UpdateHsResult.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> UpdateHsResult(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params : {}", params);

    boolean success = false;
    Map<String, Object> resultValue = new HashMap<String, Object>();

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    resultValue = hsManualService.UpdateHsResult(formMap, updList, sessionVO);

    message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno"));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hsConfigBasicPop.do	")
  public String hsConfigBasicPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("[HsManualController - hsConfigBasicPop] params :: {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    // List<EgovMap> cmbServiceMemList =
    // hsManualService.cmbServiceMemList(params);
    EgovMap configBasicInfo = hsManualService.selectConfigBasicInfo(params);
    // EgovMap configBasicInfo = hsManualService.selectConfigBasicInfo(params);
    // EgovMap serMember = hsManualService.se ;
    // EgovMap as_ord_basicInfo = hsManualService.selectOrderBasicInfo(params);
    // EgovMap asentryInfo =null;
    // model.put("cmbServiceMemList", cmbServiceMemList);
    model.put("configBasicInfo", configBasicInfo);

    EgovMap promoInfo = hsManualService.getPromoItemInfo(params);
    model.put("promoInfo", promoInfo);

    //order outstanding info
    List<EgovMap> ordOutInfoList = hsManualService.getOderOutsInfo(params);
    EgovMap ordOutInfo = ordOutInfoList.get(0);
    model.addAttribute("ordOutInfo", ordOutInfo);

     // [Project ID 7139026265] Self Service (DIY) Project add by Fannie - 05/12/2024
    //HS Configuration @ Service mode only update in history logs and month end update on changed service mode
    EgovMap srvTypeChgInfo = hsManualService.getSrvTypeChgInfo(params);
    model.put("serviceType", srvTypeChgInfo);

    int srvTypeChgTimes = hsManualService.getSrvTypeChgTm(params);
    model.put("srvTypeChgTimes", srvTypeChgTimes);

    model.put("SALEORD_ID", (String) params.get("salesOrdId"));
    // model.put("as_ord_basicInfo", as_ord_basicInfo);
    // model.put("AS_NO", (String)params.get("AS_NO"));
    model.put("BRNCH_ID", (String) params.get("brnchId"));
    model.put("CODY_MANGR_USER_ID", (String) params.get("codyMangrUserId"));
    model.put("CUST_ID", (String) params.get("custId"));

    // logger.debug("configBasicInfo(pop)================= : {}",
    // configBasicInfo);
    //

    return "services/bs/hsConfigBasicPop";
  }

  /**
   * Services -
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/getHSConfigBasicInfo.do")
  public String getHSConfigBasicInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    // List<EgovMap> cmbServiceMemList =
    // hsManualService.cmbServiceMemList(params);
    // model.put("cmbServiceMemList", cmbServiceMemList);
    // List<EgovMap> serMemList = hsManualService.serMemList(params);
    // model.addAttribute("serMemList", serMemList);

    return "services/bs/hsConfigBasicPop";
  }

  @RequestMapping(value = "/getHSCody.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getHSCody(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("params : {}", params);
    EgovMap serMember = null;
    serMember = hsManualService.serMember(params);

    return ResponseEntity.ok(serMember);
  }

  @RequestMapping(value = "/selectHSCodyList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSCodyList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    // params.put("codyMangrUserId", params.get("groupCode[codyMangrUserId]"));
    // params.put("custId", params.get("groupCode[custId]"));
    logger.debug("params(selectHSCodyList)============== {}", params);
    List<EgovMap> hsCodyList = hsManualService.selectHSCodyList(params);
    logger.debug("hsCodyList(selectHSCodyList)============== {}", hsCodyList);
    return ResponseEntity.ok(hsCodyList);
  }

  @RequestMapping(value = "/hSFilterSettingPop.do")
  public String hSFilterSettingPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    EgovMap hSOrderView = hsManualService.selectHSOrderView(params);
    model.put("hSOrderView", hSOrderView);

    return "services/bs/hSFilterSettingPop";
  }

  @RequestMapping(value = "/getActivefilterInfo.do")
  public ResponseEntity<List<EgovMap>> getActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> orderActiveFilter = hsManualService.selectOrderActiveFilter(params);

    model.put("orderActiveFilter", orderActiveFilter);

    return ResponseEntity.ok(orderActiveFilter);
  }

  @RequestMapping(value = "/getInActivefilterInfo.do")
  public ResponseEntity<List<EgovMap>> getInActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> orderInactiveFilter = hsManualService.selectOrderInactiveFilter(params);

    model.put("orderInactiveFilter", orderInactiveFilter);

    return ResponseEntity.ok(orderInactiveFilter);
  }

  @RequestMapping(value = "/hSAddFilterSetPop.do")
  public String hSAddFilterSetInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> hSAddFilterSetInfo = hsManualService.selectHSAddFilterSetInfo(params);
    model.put("_salesOrdId", (String) params.get("salesOrdId"));
    model.put("_stkId", (String) params.get("stkId"));
    model.put("hSAddFilterSetInfo", hSAddFilterSetInfo);

    return "services/bs/hsFilterAddPop";
  }

  @RequestMapping(value = "/addSrvFilterID.do")
  public ResponseEntity<List<EgovMap>> addSrvFilterIdCnt(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    List<EgovMap> addSrvFilterIdCnt = hsManualService.addSrvFilterIdCnt(params);

    return ResponseEntity.ok(addSrvFilterIdCnt);
  }

  @RequestMapping(value = "/doSaveFilterInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveHsFilterInfoAdd(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    params.put("updator", sessionVO.getUserId());

    logger.debug("params : {}", params);
    // List<Object> remList = (List<Object>)
    // params.get(AppConstants.AUIGRID_REMOVE);

    int resultValue = hsManualService.saveHsFilterInfoAdd(params);
    logger.debug("resultValue : {}", resultValue);

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else if (resultValue == -100) {
      message.setCode("88");
      message.setMessage("Can't add existed filter");
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/doSaveDeactivateFilter.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> doSaveDeactivateFilter(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    params.put("updator", sessionVO.getUserId());
    if (params.get("SRV_FILTER_IS_ACTIVE").toString().equals("1")) {
      params.put("srvFilterStusId", 1);
    } else {
      params.put("srvFilterStusId", 8);
    }

    logger.debug("params : {}", params);

    int resultValue = hsManualService.saveDeactivateFilter(params);

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  /**
   *
   *
   * @param params
   * @param request
   * @return
   * @throws ParseException
   * @throws Exception
   */
  @RequestMapping(value = "/saveHsConfigBasic.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveHsConfigBasic(@RequestBody Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) throws ParseException {
        ReturnMessage message = new ReturnMessage();

        logger.debug("[HsManualController - saveHsConfigBasic] params :: {}", params);
        String srvCodyId = "";
        LinkedHashMap hsResultM = (LinkedHashMap) params.get("hsResultM");
        hsResultM.put("hscodyId", hsResultM.get("cmbServiceMem"));

        srvCodyId = hsManualService.getSrvCodyIdbyMemcode(hsResultM);

        hsResultM.put("cmbServiceMem", srvCodyId);
        hsResultM.put("hscodyId", srvCodyId);

        hsManualService.updateSrvCodyId(hsResultM);

        int resultValue = hsManualService.updateHsConfigBasic(params, sessionVO);

        if (resultValue > 0) {
          message.setCode(AppConstants.SUCCESS);
          message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        } else {
          message.setCode(AppConstants.FAIL);
          message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
        }
        return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hsCountForecastListingPop.do")
  public String hsCountForecastListingPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/bs/hsCountForecastListingPop";
  }

  @RequestMapping(value = "/hsReportGroupPop.do")
  public String hsReportGroupPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
    // 호출될 화면
    return "services/bs/hsReportGroupPop";
  }

  @RequestMapping(value = "/hsReportIndividualGroupPop.do")
  public String hsReportIndividualGroupPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    // 호출될 화면
	  params.put("userId", sessionVO.getUserId());
	  if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
			  sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

		      EgovMap result =  salesCommonService.getUserInfo(params);

		      model.put("orgCode", result.get("orgCode"));
		      model.put("grpCode", result.get("grpCode"));
		      model.put("deptCode", result.get("deptCode"));
		      model.put("memCode", result.get("memCode"));
	   }
	   return "services/bs/hsReportIndividualGroupPop";
  }

  @RequestMapping(value = "/hsReportSinglePop.do")
  public String hsReportSinglePop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/bs/hsReportSinglePop";
  }

  @RequestMapping(value = "/selectBranch_id", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBranch_id(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("params {}", params);
    List<EgovMap> branchList = hsManualService.selectBranch_id(params);
    // model.addAttribute("branchList", branchList);
    logger.debug("branchList {}", branchList);
    return ResponseEntity.ok(branchList);
  }

  @RequestMapping(value = "/selectCTMByDSC_id", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTMByDSC_id(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("params {}", params);
    List<EgovMap> branchList = hsManualService.selectCTMByDSC_id(params);
    // model.addAttribute("branchList", branchList);
    logger.debug("branchList {}", branchList);
    return ResponseEntity.ok(branchList);
  }

  @RequestMapping(value = "/checkMemCode")
  public ResponseEntity<ReturnMessage> checkMemberCode(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());

    EgovMap checkMemCode = hsManualService.selectCheckMemCode(params);

    ReturnMessage message = new ReturnMessage();
    if (checkMemCode != null && checkMemCode.size() != 0) {
      message.setMessage("success");
    } else {
      message.setMessage("fail");
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hSFilterUseHistoryPop.do")
  public String hSFilterUseHistoryPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("orderId", (String) params.get("orderId"));
    model.put("stkId", (String) params.get("stkId"));
    model.put("srvFilterStkId", (String) params.get("srvFilterStkId"));

    // 호출될 화면
    return "services/bs/hSFilterUseHistoryPop";
  }

  @RequestMapping(value = "/hSFilterUseHistory.do")
  public ResponseEntity<List<EgovMap>> gethSFilterUseHistory(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());

    // List<EgovMap> useHistoryInfo =
    // hsManualService.selecthSFilterUseHistorycall(params);

    hsManualService.selecthSFilterUseHistorycall(params);

    List<EgovMap> list = (List<EgovMap>) params.get("cv_1");

    logger.debug(
        "============hSFilterUseHistory useHistoryInfo Start =======================================================");
    logger.debug("==========useHistoryInfo {} ", list);
    logger.debug(
        "============hSFilterUseHistory useHistoryInfo End =======================================================");

    model.put("list", list);

    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/doSaveFilterUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> doSaveFilterUpdate(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    params.put("updator", sessionVO.getUserId());

    logger.debug("params : {}", params);

    params.put("srvFilterStusId", "1");

    int resultValue = hsManualService.saveFilterUpdate(params);

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  /**
   * Services - HS - Result EDIT - Fail Reason 콤보박스 리스트
   *
   * @param params
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectFailReason.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectFailReason(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> failReasonList = hsManualService.failReasonList(params);
    model.addAttribute("failReasonList", failReasonList);

    return ResponseEntity.ok(failReasonList);
  }

  /**
   * Services - HS - New HS Result - Collection Code 콤보박스 리스트
   *
   * @param params
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectCollectType.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCollectType(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList2(params);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);

    return ResponseEntity.ok(cmbCollectTypeComboList);
  }

  @RequestMapping(value = "/saveValidation.do", method = RequestMethod.POST)
  public ResponseEntity<Integer> saveValidation(@RequestBody Map<String, Object> params, HttpServletRequest request,
      SessionVO sessionVO) throws ParseException {

    logger.debug("saveValidation params : {}", params);

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

    int resultValue = hsManualService.saveValidation(formMap);// hidSalesOrdCd

    return ResponseEntity.ok(resultValue);
  }

  @RequestMapping(value = "/selectHsOrderInMonth.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkHsOrderInMonth(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("111params111 : {}", params);

    EgovMap hsOrderInMonth = hsManualService.selectHsOrderInMonth(params);

    if (hsOrderInMonth != null && hsOrderInMonth.size() != 0) {
      message.setMessage("success");
    } else {
      message.setMessage("fail");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/assignDeptMemUp.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> assignDeptMemUp(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) throws ParseException {

    logger.debug("assignDeptMemUp params : {}", params);

    if (null != params.get("deptList")) {

      String deptList = (String) params.get("deptList");

      String[] spl = deptList.split(",");

      params.put("deptListSpl", spl);
    }
    logger.debug("assignDeptMemUp params1 : {}", params);

    List<EgovMap> assignDeptMemUpList = hsManualService.assignDeptMemUp(params);
    model.addAttribute("assignDeptMemUpList", assignDeptMemUpList);

    return ResponseEntity.ok(assignDeptMemUpList);
  }

  @RequestMapping(value = "/assignBrnchCMPop.do")
  public String assignBrnchCMPop(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("assignBrnchCMPop params : {}", params);

    model.addAttribute("brnchCdList", params.get("BrnchId"));
    model.addAttribute("ordCdList", params.get("CheckedItems"));
    model.addAttribute("ManuaMyBSMonth", params.get("ManuaMyBSMonth"));
    model.addAttribute("deptList", params.get("deptList"));

    return "services/bs/hsBrnchCMChangePop";
  }

  /**
   * Services - HS - Assign Cody Transfer - No 팝업 - CM 콤보박스 리스트
   *
   * @param params
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectBrnchCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBrnchCode(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    /*
     * params.put("memberLevel", sessionVO.getMemberLevel());
     * params.put("userName", sessionVO.getUserName()); params.put("userType",
     * sessionVO.getUserTypeId());
     */

    List<EgovMap> cmbBrnchCodeList = hsManualService.selectBranchList(params);
    model.addAttribute("cmbBrnchCodeList", cmbBrnchCodeList);

    return ResponseEntity.ok(cmbBrnchCodeList);
  }

  /**
   * Services - HS - Assign Cody Transfer - No 팝업 - CM 콤보박스 리스트
   *
   * @param params
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectCMList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCMList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> cmbCMList = hsManualService.selectCMList(params);
    model.addAttribute("cmbCMList", cmbCMList);

    return ResponseEntity.ok(cmbCMList);
  }

  @RequestMapping(value = "/checkStkDuration.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkStkDuration(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params {}", params);
    String msg = "";
    EgovMap stkId = hsManualService.checkStkDuration(params);

    if (stkId != null) {
      msg = "1";
    } else {
      msg = "0";
    }
    logger.debug("checkStkDuration - msg : " + msg);
    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hsReversal.do") // ADDED BY TPY - 18/06/2019
  public ResponseEntity<ReturnMessage> hsReversal(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params {}", params);
    String msg = "";
    String msg2 = "";

    String salesOrdNo = params.get("salesordNo").toString();
    String hsNo = params.get("hsNo").toString();

    String hsResultNo = "";
    String CNRefNo = "";
    String ASResultNo = "";
    String ReverseASResultNo = "";

    EgovMap stkInfo;
	try {
		stkInfo = hsManualService.checkHsBillASInfo(params);
	} catch (Exception e) {
		message.setMessage("HS result alredy reversed.");
	    return ResponseEntity.ok(message);
	} // CHECK HS /
     // AS / BILL
     // INFORMATION
     // - ADDED BY
     // TPY -
     // 18/06/2019
    String stkItem = "";
    if(stkInfo != null) {
        logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ITM_STK_ID : " + stkInfo.get("itmStkId").toString());
        stkItem = stkInfo.get("itmStkId").toString();
    }

    if (stkItem.equals("1427") || (stkInfo == null && params.get("stkId").toString().equals("1427"))) { // OMBAK - STK ID // 1243 - DEV // 1427 - PRD

      // ADD FUNCTION TO REVERSE HS
      hsResultNo = hsManualService.reverseHSResult(params, sessionVO);
      msg2 += "<br / > HS RESULT NO : " + hsResultNo;

      if(stkInfo != null) {
          if (stkInfo.get("brNo") != null) {
              params.put("memoAdjustInvoiceNo", stkInfo.get("brNo").toString());
              params.put("memoAdjustTotalAmount", stkInfo.get("invcItmAmtDue").toString());
              params.put("MemoItemInvoiceItemID", stkInfo.get("txinvoiceitemid").toString());
              params.put("memoItemInvoiceItmQty", stkInfo.get("invcItmQty").toString());
              params.put("memoItemCreditAccID", "39"); // TRADE RECEIVABLE - A/S
              params.put("memoItemDebitAccID", "167");// SALES - A/S
              params.put("memoItemTaxCodeID", 0);
              params.put("memoItemStatusID", "4");
              params.put("memoItemRemark", "HS REVERSAL - OMBAK");
              params.put("memoItemGSTRate", stkInfo.get("invcItmGstRate").toString());
              params.put("memoItemCharges", stkInfo.get("invcItmChrg").toString());
              params.put("memoItemTaxes", stkInfo.get("invcItmGstTxs").toString());
              params.put("memoItemAmount", stkInfo.get("invcItmAmtDue").toString());

              params.put("invcSvcNo", stkInfo.get("invcSvcNo").toString());
              params.put("asId", stkInfo.get("asId").toString());
              params.put("bsResultPartId", stkInfo.get("bsResultPartId").toString());
              params.put("invcItmUnitPrc", CommonUtils.nvl(stkInfo.get("invcItmUnitPrc")));
              params.put("invcItmChrg", stkInfo.get("invcItmChrg").toString());
              params.put("invcItmDesc1", stkInfo.get("invcItmDesc1").toString());

              logger.debug("hsReversal params --- : " + params);

              // ADD FUNCTION TO CREATE CN BILLING AND INVOICE
              CNRefNo = hsManualService.createCreditNote(params, sessionVO);

              // ADD FUNCTION TO REVERSE AS
              ASResultNo = hsManualService.createASResults(params, sessionVO);

              ReverseASResultNo = hsManualService.createReverseASResults(params, sessionVO);

              msg2 += "<br /> CREDIT NOTE REF NO : " + CNRefNo + "<br /> AS REF : " + ReverseASResultNo;
            }
      }

      if(stkInfo != null) {
          salesOrdNo = stkInfo.get("salesOrdNo").toString();
          hsNo = stkInfo.get("no").toString();
      }

      msg = "HS REVERSAL SUCCESSFUL. <br /> HS ORDER NO : " + salesOrdNo + "<br />  HS NO : " + hsNo + msg2;

    } else {
      // msg = "HS REVERSAL ONLY ALLOW FOR OMBAK PRODUCT.";
      msg = "HS REVERSAL IS NOT ALLOWED FOR THIS HS.";
    }
    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  // CREATE HS ORDER POP UP NOTIFICATION -- TPY 24/06/2019
  @RequestMapping(value = "/createHSOrderChecking.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> createHSOrderChecking(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/createHSOrderChecking.do===============================");
    logger.debug("== params " + params.toString());

    ReturnMessage message = new ReturnMessage();
    String msg = "";

    EgovMap warrentyInfo = hsManualService.checkWarrentyStatus(params);
    EgovMap serviceMembershipInfo = hsManualService.checkSvcMembershipInfo(params);
    EgovMap rentalStatusInfo = hsManualService.checkRentalStatusInfo(params);
    EgovMap orderStatusInfo = hsManualService.checkOrderStatusInfo(params);

    if (warrentyInfo != null) {
      msg = msg + "";
    } else {
      msg = msg + "* This Sales Order Membership is under Out of Warranty status.<br />";
    }

    if (serviceMembershipInfo != null) {
      msg = msg
          + "* This Sales Order Membership is under Coway Service Membership / Rental Membership (non-starter package).<br />";
    } else {
      msg = msg + "";
    }

    if (rentalStatusInfo != null) {
      msg = msg + "* This Sales Order Rental status is under INV / SUS / RET / TER / CAN / WOF .<br />";
    } else {
      msg = msg + "";
    }

    if (orderStatusInfo != null) {
      msg = msg + "* This Sales Order status is under ACT / CAN .<br />";
    } else {
      msg = msg + "";
    }

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hsExchgBodyAmbientAssyPop.do")
  public String hsExchgBodyAmbientAssyPop(@RequestParam Map<String, Object> params, ModelMap model) {
      // 호출될 화면
      return "services/bs/hsExchgBodyAmbientAssyPop";
  }

  @RequestMapping(value="/getAppTypeList")
  public ResponseEntity<List<EgovMap>> getAppTypeList(@RequestParam Map<String, Object> params) throws Exception{

      List<EgovMap> applicationTypeList = null;
      applicationTypeList = hsManualService.getAppTypeList(params);

      return ResponseEntity.ok(applicationTypeList);
  }

  @RequestMapping(value = "/addIHsResultSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> addIHsResultSerial(@RequestBody Map<String, Object> params, HttpServletRequest request,
      SessionVO sessionVO) throws Exception {
    ReturnMessage message = new ReturnMessage();
    logger.debug("addIHsResultSerial params : {}", params);

    String msg = hsManualService.addIHsResultSerial(params, sessionVO);

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hsReversalSerial.do")
  public ResponseEntity<ReturnMessage> hsReversalSerial(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params {}", params);

    String msg = hsManualService.hsReversalSerial(params, sessionVO);

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/instChkLst.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> instChkLst(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {

    List<EgovMap> instChkLst = hsManualService.instChkLst();

    return ResponseEntity.ok(instChkLst);
  }

//ADDED BY KEYI - EDIT HS SETTLE DATE POP
  @RequestMapping(value = "/selectHSEditSettleDatePop.do")
  public String selectHSEditSettleDatePop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

	    params.put("schdulId", params.get("schdulId"));
	    params.put("salesOrderId", params.get("salesOrdId"));

	    EgovMap basicinfo = hsManualService.selectHsViewBasicInfo(params);
	    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

	    List<EgovMap> failReasonList = hsManualService.failReasonList(params);
	    List<EgovMap> cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList(params);

	    EgovMap hsDefaultInfo = hsManualService.selectHsInitDetailPop(params);

	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
	    model.put("toDay", toDay);

	    model.addAttribute("basicinfo", basicinfo);
	    model.addAttribute("hsDefaultInfo", hsDefaultInfo);
	    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
	    model.addAttribute("orderDetail", orderDetail);
	    model.addAttribute("failReasonList", failReasonList);

    return "services/bs/hsEditSettleDatePop";

  }

  @RequestMapping(value = "/editSettleDate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> editSettleDate(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();

    Map<String, Object> resultValue = new HashMap<String, Object>();

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
   // List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    //List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    logger.debug("editSettleDate=============> in ");
    logger.debug("[" + params.toString() + "]");
    logger.debug("editSettleDate=============> in");

    formMap.put("updator", String.valueOf(sessionVO.getUserId()));
    //resultValue = hsManualService.UpdateHsResult2(formMap, updList, sessionVO);
    hsManualService.editHSEditSettleDate(formMap);

    /*if (updList != null) {
      hsManualService.UpdateIsReturn(formMap, updList, sessionVO);
    }*/

    message.setMessage("Complete to Update HS Settle Date for " +  formMap.get("hsNo"));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getSrvTypeChgHistoryLogInfo.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSrvTypeChgHistoryLogInfo(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

    List<EgovMap> srvTypeChghistoryLogInfo = hsManualService.getSrvTypeChgHistoryLogInfo(params);
    logger.info("[HsManualController - hsConfigBasicPop] srvTypeChghistoryLogInfo :: {} " + srvTypeChghistoryLogInfo);
    model.put("srvTypeChghistoryLogInfo", srvTypeChghistoryLogInfo);

    return ResponseEntity.ok(srvTypeChghistoryLogInfo);
  }

}
