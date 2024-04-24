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
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsAccConfigService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberListController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/hs")
public class HsAccConfigController {
  private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

  @Resource(name = "hsAccConfigService")
  private HsAccConfigService hsAccConfigService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/initHsAccConfigList.do")
  public String initBsManagementList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    logger.debug("getUserBranchId : {}", sessionVO.getUserBranchId());

    params.put("memberLevel", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());

    // params.put("userType", "3");

    logger.debug("=======================================================================================");
    logger.debug("============== initHsAccConfigList params{} ", params);
    logger.debug("=======================================================================================");

    List<EgovMap> branchList = hsAccConfigService.selectBranchList(params);
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

    return "services/bs/hsAccConfig";
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

    String rtnValue = hsAccConfigService.updateAssignCody(params);

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
    List<EgovMap> resultList = hsAccConfigService.getCdList_1(params);
    // model.addAttribute("brnchCdList1", resultList);

    List<EgovMap> resultList1 = hsAccConfigService.selectHsManualListPop(params);
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

    List<EgovMap> resultList1 = hsAccConfigService.selectHsManualListPop(params);
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
    List<EgovMap> bsManagementList = hsAccConfigService.selectHsManualList(params);

    // brnch 임시 셋팅
    for (int i = 0; i < bsManagementList.size(); i++) {

      EgovMap record = (EgovMap) bsManagementList.get(i);// EgovMap으로 형변환하여 담는다.

      // ("brnchId", sessionVO.getUserBranchId());
    }

    return ResponseEntity.ok(bsManagementList);
  }

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
    List<EgovMap> hsBasicList = hsAccConfigService.selectHsConfigList(params);

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
    List<EgovMap> hsAssiintList = hsAccConfigService.selectHsAssiinlList(params);

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
    List<EgovMap> resultList = hsAccConfigService.getCdUpMemList(params);

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
    List<EgovMap> resultList = hsAccConfigService.getCdDeptList(params);

    return ResponseEntity.ok(resultList);
  }


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
    resultValue = hsAccConfigService.insertHsResult(formMap, updList, sessionVO);

    message.setMessage("Complete to Add a HS Order.  " + resultValue.get("docNo"));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectHsInitDetailPop.do")
  public String selectHsInitDetailPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    params.put("schdulId", params.get("schdulId"));
    params.put("salesOrderId", params.get("salesOrdId"));

    EgovMap hsDefaultInfo = hsAccConfigService.selectHsInitDetailPop(params);
    List<EgovMap> cmbCollectTypeComboList = hsAccConfigService.cmbCollectTypeComboList(params);
    // List<EgovMap> cmbServiceMemList =
    // hsAccConfigService.cmbServiceMemList(params);
    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//
    List<EgovMap> failReasonList = hsAccConfigService.failReasonList(params);
    // List<EgovMap> serMemList = hsAccConfigService.serMemList(params);

    logger.debug(" params : ", params);
    logger.debug("hsDefaultInfo : {}", hsDefaultInfo);

    model.addAttribute("hsDefaultInfo", hsDefaultInfo);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
    // model.addAttribute("cmbServiceMemList", cmbServiceMemList);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("failReasonList", failReasonList);
    // model.addAttribute("serMemList", serMemList);

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

    basicinfo = hsAccConfigService.selectHsViewBasicInfo(params);
    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

    List<EgovMap> cmbCollectTypeComboList = hsAccConfigService.cmbCollectTypeComboList(params);
    List<EgovMap> failReasonList = hsAccConfigService.failReasonList(params);
    // List<EgovMap> serMemList = hsAccConfigService.serMemList(params);

    model.addAttribute("basicinfo", basicinfo);
    logger.debug("basicinfo : {}", basicinfo);
    model.addAttribute("orderDetail", orderDetail);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
    model.addAttribute("failReasonList", failReasonList);
    model.addAttribute("MOD", params.get("MOD"));
    // model.addAttribute("serMemList", serMemList);
    model.addAttribute("ROW", params.get("ROW"));

    return "services/bs/hsEditPop";

  }

  @RequestMapping(value = "/selectHsViewfilterPop.do")
  public ResponseEntity<List<EgovMap>> selectHsViewfilterPop(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> hsViewfilterInfo = null;

    hsViewfilterInfo = hsAccConfigService.selectHsViewfilterInfo(params);
    // model.addAttribute("hsViewfilterInfo", hsViewfilterInfo);

    return ResponseEntity.ok(hsViewfilterInfo);
  }

  @RequestMapping(value = "/hSMgtResultViewResultPop.do")
  public String hSMgtResultViewResultPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    EgovMap hSMgtResultViewResult = null;

    hSMgtResultViewResult = hsAccConfigService.hSMgtResultViewResult(params);
    model.addAttribute("hSMgtResultViewResult", hSMgtResultViewResult);

    return "services/bs/hSManagementResultViewResultPop";
  }

  @RequestMapping(value = "/hSMgtResultViewResultFilter.do")
  public ResponseEntity<List<EgovMap>> hSMgtResultViewResultFilter(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> hSMgtResultViewResultFilter = null;

    hSMgtResultViewResultFilter = hsAccConfigService.hSMgtResultViewResultFilter(params);
    // model.addAttribute("hsViewfilterInfo", hsViewfilterInfo);

    return ResponseEntity.ok(hSMgtResultViewResultFilter);
  }

  @RequestMapping(value = "/selectHistoryHSResult.do")
  public ResponseEntity<List<EgovMap>> selectHistoryHSResult(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> historyHSResult = null;

    historyHSResult = hsAccConfigService.selectHistoryHSResult(params);

    return ResponseEntity.ok(historyHSResult);
  }

  @RequestMapping(value = "/selectFilterTransaction.do")
  public ResponseEntity<List<EgovMap>> selectFilterTransaction(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> filterTransaction = null;

    filterTransaction = hsAccConfigService.selectFilterTransaction(params);

    return ResponseEntity.ok(filterTransaction);
  }

  @RequestMapping(value = "/SelectHsFilterList.do")
  public ResponseEntity<List<EgovMap>> SelectHsFilterList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    // params.put("salesOrdId", params.get("salesOrdId"));

    List<EgovMap> hsFilterList = hsAccConfigService.selectHsFilterList(params);
    // model.addAttribute("hsFilterList", hsFilterList);

    return ResponseEntity.ok(hsFilterList);

  }

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
    resultValue = hsAccConfigService.addIHsResult(formMap, insList, sessionVO);

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
    EgovMap useFilterList = hsAccConfigService.getBSFilterInfo(params);
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
        sm = hsAccConfigService.saveASEntryResult(params);
        params.put("asNo", sm.get("asNo").toString());
        params.put("asId", sm.get("asId").toString());
        params.put("asResultNo", sm.get("asResultNo").toString());

        logger.debug("==================== saveASEntryResult [End] ========================");

        // INSERT TAX INVOICE FOR OMBAK -- TPY
        logger.debug("==================== saveASTaxInvoice [Start] ========================");
        logger.debug("saveASTaxInvoice params :" + params.toString());
        Map<String, Object> pb = new HashMap<String, Object>();
        pb = hsAccConfigService.saveASTaxInvoice(params);

        logger.debug("==================== saveASTaxInvoice [End] ========================");

        msg = msg + "<br /> AS NO : " + sm.get("asNo").toString() + "<br /> AS REF : "
            + sm.get("asResultNo").toString();

      }

    }

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

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

    resultValue = hsAccConfigService.UpdateHsResult2(formMap, insList, sessionVO);

    if (updList != null) {
      hsAccConfigService.UpdateIsReturn(formMap, updList, sessionVO);
    }

    message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno"));

    return ResponseEntity.ok(message);
  }


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

    resultValue = hsAccConfigService.UpdateHsResult2Serial(formMap, insList, sessionVO, updList);


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

    resultValue = hsAccConfigService.UpdateHsResult(formMap, updList, sessionVO);

    message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno"));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hsConfigBasicPop.do	")
  public String hsConfigBasicPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params(pop)================= : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));


    EgovMap configBasicInfo = hsAccConfigService.selectConfigBasicInfo(params);

    model.put("configBasicInfo", configBasicInfo);
    model.put("SALEORD_ID", (String) params.get("salesOrdId"));
    model.put("BRNCH_ID", (String) params.get("brnchId"));
    model.put("CODY_MANGR_USER_ID", (String) params.get("codyMangrUserId"));
    model.put("CUST_ID", (String) params.get("custId"));

    return "services/bs/hsConfigBasicPop";
  }

    @RequestMapping(value = "/getHSConfigBasicInfo.do")
  public String getHSConfigBasicInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    return "services/bs/hsConfigBasicPop";
  }

  @RequestMapping(value = "/getHSCody.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getHSCody(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("params : {}", params);
    EgovMap serMember = null;
    serMember = hsAccConfigService.serMember(params);

    return ResponseEntity.ok(serMember);
  }

  @RequestMapping(value = "/selectHSCodyList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSCodyList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("params(selectHSCodyList)============== {}", params);
    List<EgovMap> hsCodyList = hsAccConfigService.selectHSCodyList(params);
    logger.debug("hsCodyList(selectHSCodyList)============== {}", hsCodyList);
    return ResponseEntity.ok(hsCodyList);
  }

  @RequestMapping(value = "/hSFilterSettingPop.do")
  public String hSFilterSettingPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    EgovMap hSOrderView = hsAccConfigService.selectHSOrderView(params);
    model.put("hSOrderView", hSOrderView);

    return "services/bs/hSFilterSettingPop";
  }

  @RequestMapping(value = "/getActivefilterInfo.do")
  public ResponseEntity<List<EgovMap>> getActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> orderActiveFilter = hsAccConfigService.selectOrderActiveFilter(params);

    model.put("orderActiveFilter", orderActiveFilter);

    return ResponseEntity.ok(orderActiveFilter);
  }

  @RequestMapping(value = "/getInActivefilterInfo.do")
  public ResponseEntity<List<EgovMap>> getInActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> orderInactiveFilter = hsAccConfigService.selectOrderInactiveFilter(params);

    model.put("orderInactiveFilter", orderInactiveFilter);

    return ResponseEntity.ok(orderInactiveFilter);
  }

  @RequestMapping(value = "/hSAddFilterSetPop.do")
  public String hSAddFilterSetInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> hSAddFilterSetInfo = hsAccConfigService.selectHSAddFilterSetInfo(params);
    model.put("_salesOrdId", (String) params.get("salesOrdId"));
    model.put("_stkId", (String) params.get("stkId"));
    model.put("hSAddFilterSetInfo", hSAddFilterSetInfo);

    return "services/bs/hsFilterAddPop";
  }

  @RequestMapping(value = "/addSrvFilterID.do")
  public ResponseEntity<List<EgovMap>> addSrvFilterIdCnt(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    List<EgovMap> addSrvFilterIdCnt = hsAccConfigService.addSrvFilterIdCnt(params);

    return ResponseEntity.ok(addSrvFilterIdCnt);
  }

  @RequestMapping(value = "/doSaveFilterInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveHsFilterInfoAdd(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();
    params.put("updator", sessionVO.getUserId());

    logger.debug("params : {}", params);

    int resultValue = hsAccConfigService.saveHsFilterInfoAdd(params);
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

    int resultValue = hsAccConfigService.saveDeactivateFilter(params);

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

   @RequestMapping(value = "/saveHsConfigBasic.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveHsConfigBasic(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();

    logger.debug("params : {}", params);
    String srvCodyId = "";
    LinkedHashMap hsResultM = (LinkedHashMap) params.get("hsResultM");
    hsResultM.put("hscodyId", hsResultM.get("cmbServiceMem"));
    srvCodyId = hsAccConfigService.getSrvCodyIdbyMemcode(hsResultM);
    logger.debug("srvCodyId : " + srvCodyId);
    hsResultM.put("cmbServiceMem", srvCodyId);
    hsResultM.put("hscodyId", srvCodyId);
    logger.debug("hsResultM : {}", hsResultM);
    hsAccConfigService.updateSrvCodyId(hsResultM);

    logger.debug("hsResultM ===>" + hsResultM.toString());

    int resultValue = hsAccConfigService.updateHsConfigBasic(params, sessionVO);

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
  public String hsReportGroupPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/bs/hsReportGroupPop";
  }

  @RequestMapping(value = "/hsReportIndividualGroupPop.do")
  public String hsReportIndividualGroupPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
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
    List<EgovMap> branchList = hsAccConfigService.selectBranch_id(params);
    // model.addAttribute("branchList", branchList);
    logger.debug("branchList {}", branchList);
    return ResponseEntity.ok(branchList);
  }

  @RequestMapping(value = "/selectCTMByDSC_id", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTMByDSC_id(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("params {}", params);
    List<EgovMap> branchList = hsAccConfigService.selectCTMByDSC_id(params);
    // model.addAttribute("branchList", branchList);
    logger.debug("branchList {}", branchList);
    return ResponseEntity.ok(branchList);
  }

  @RequestMapping(value = "/checkMemCode")
  public ResponseEntity<ReturnMessage> checkMemberCode(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());

    EgovMap checkMemCode = hsAccConfigService.selectCheckMemCode(params);

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

    hsAccConfigService.selecthSFilterUseHistorycall(params);

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

    int resultValue = hsAccConfigService.saveFilterUpdate(params);

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }


  @RequestMapping(value = "/selectFailReason.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectFailReason(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> failReasonList = hsAccConfigService.failReasonList(params);
    model.addAttribute("failReasonList", failReasonList);

    return ResponseEntity.ok(failReasonList);
  }


  @RequestMapping(value = "/selectCollectType.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCollectType(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> cmbCollectTypeComboList = hsAccConfigService.cmbCollectTypeComboList2(params);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);

    return ResponseEntity.ok(cmbCollectTypeComboList);
  }

  @RequestMapping(value = "/saveValidation.do", method = RequestMethod.POST)
  public ResponseEntity<Integer> saveValidation(@RequestBody Map<String, Object> params, HttpServletRequest request,
      SessionVO sessionVO) throws ParseException {

    logger.debug("saveValidation params : {}", params);

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

    int resultValue = hsAccConfigService.saveValidation(formMap);// hidSalesOrdCd

    return ResponseEntity.ok(resultValue);
  }

  @RequestMapping(value = "/selectHsOrderInMonth.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkHsOrderInMonth(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("111params111 : {}", params);

    EgovMap hsOrderInMonth = hsAccConfigService.selectHsOrderInMonth(params);

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

    List<EgovMap> assignDeptMemUpList = hsAccConfigService.assignDeptMemUp(params);
    model.addAttribute("assignDeptMemUpList", assignDeptMemUpList);

    return ResponseEntity.ok(assignDeptMemUpList);
  }

 /* @RequestMapping(value = "/assignBrnchCMPop.do")
  public String assignBrnchCMPop(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("assignBrnchCMPop params : {}", params);

    model.addAttribute("brnchCdList", params.get("BrnchId"));
    model.addAttribute("ordCdList", params.get("CheckedItems"));
    model.addAttribute("ManuaMyBSMonth", params.get("ManuaMyBSMonth"));
    model.addAttribute("deptList", params.get("deptList"));

    return "services/bs/hsBrnchCMChangePop";
  }*/


  @RequestMapping(value = "/selectBrnchCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBrnchCode(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    List<EgovMap> cmbBrnchCodeList = hsAccConfigService.selectBranchList(params);
    model.addAttribute("cmbBrnchCodeList", cmbBrnchCodeList);

    return ResponseEntity.ok(cmbBrnchCodeList);
  }

  @RequestMapping(value = "/selectCMList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCMList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    List<EgovMap> cmbCMList = hsAccConfigService.selectCMList(params);
    model.addAttribute("cmbCMList", cmbCMList);

    return ResponseEntity.ok(cmbCMList);
  }

  @RequestMapping(value = "/checkStkDuration.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkStkDuration(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params {}", params);
    String msg = "";
    EgovMap stkId = hsAccConfigService.checkStkDuration(params);

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

    String hsResultNo = "";
    String CNRefNo = "";
    String ASResultNo = "";
    String ReverseASResultNo = "";

    EgovMap stkInfo = hsAccConfigService.checkHsBillASInfo(params); // CHECK HS /

    String stkItem = stkInfo.get("itmStkId").toString();
    if (stkItem.equals("1427")) { // OMBAK - STK ID // 1243 - DEV // 1427 - PRD

      hsResultNo = hsAccConfigService.reverseHSResult(params, sessionVO);
      msg2 += "<br / > HS RESULT NO : " + hsResultNo;

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
        CNRefNo = hsAccConfigService.createCreditNote(params, sessionVO);

        // ADD FUNCTION TO REVERSE AS
        ASResultNo = hsAccConfigService.createASResults(params, sessionVO);

        ReverseASResultNo = hsAccConfigService.createReverseASResults(params, sessionVO);

        msg2 += "<br /> CREDIT NOTE REF NO : " + CNRefNo + "<br /> AS REF : " + ReverseASResultNo;
      }

      msg = "HS REVERSAL SUCCESSFUL. <br /> HS ORDER NO : " + stkInfo.get("salesOrdNo").toString() + "<br />  HS NO : "
          + stkInfo.get("no").toString() + msg2;

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

    EgovMap warrentyInfo = hsAccConfigService.checkWarrentyStatus(params);
    EgovMap serviceMembershipInfo = hsAccConfigService.checkSvcMembershipInfo(params);
    EgovMap rentalStatusInfo = hsAccConfigService.checkRentalStatusInfo(params);
    EgovMap orderStatusInfo = hsAccConfigService.checkOrderStatusInfo(params);

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
      applicationTypeList = hsAccConfigService.getAppTypeList(params);

      return ResponseEntity.ok(applicationTypeList);
  }

  @RequestMapping(value = "/addIHsResultSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> addIHsResultSerial(@RequestBody Map<String, Object> params, HttpServletRequest request,
      SessionVO sessionVO) throws Exception {
    ReturnMessage message = new ReturnMessage();
    logger.debug("addIHsResultSerial params : {}", params);

    String msg = hsAccConfigService.addIHsResultSerial(params, sessionVO);

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/hsReversalSerial.do")
  public ResponseEntity<ReturnMessage> hsReversalSerial(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params {}", params);

    String msg = hsAccConfigService.hsReversalSerial(params, sessionVO);

    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getDeptTreeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDeptTreeList(@RequestParam Map<String, Object>params) {
      // Member Type 에 따른 Organization 조회.
		List<EgovMap> resultList = hsAccConfigService.getDeptTreeList(params);

		return ResponseEntity.ok(resultList);
	}

  @RequestMapping(value = "/getGroupTreeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getGroupTreeList(@RequestParam Map<String, Object>params) {

		logger.debug("  "+params.toString());
		//Member Type 이 선행 조회된 이후(고정) Member Id 변경 시
		// 조회.
		List<EgovMap> resultList = hsAccConfigService.getGroupTreeList(params);

		return ResponseEntity.ok(resultList);
	}

  @RequestMapping(value = "/saveHsConfigBasicMultiple.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveHsConfigBasicMultiple(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();

    logger.debug("saveHsConfigBasicMultiple - params : {}", params);

    if (null != params.get("salesOrderId")) {
      String olist = (String) params.get("salesOrderId");
      String[] spl = olist.split(",");
      params.put("salesOrdListSp", spl);
    }

    if (null != params.get("schdulId")) {
      String deptList = (String) params.get("schdulId");
      String[] spl = deptList.split(",");
      params.put("schdulListSp", spl);
    }

    logger.debug("schdulId...11:: " + params.get("schdulId"));

    params.put("memCode", (String) params.get("cmbServiceMem"));
    /*params.put("TODAY_DD", (String) params.get("TODAY_DD"));*/

    logger.debug("saveHsConfigBasicMultiple - params : {}", params);

    // UPDATE SAL0090D - SRV_MEM_ID
    // UPDATE SVC0008D - MEM_ID
    int resultValue = hsAccConfigService.updateHsAccConfigBasicMultiple(params, sessionVO);

    /*int resultValue = hsAccConfigService.updateHsAccConfigBasicMultiple_backup(params, sessionVO);

    logger.debug("check 000:: " + params.get("TODAY_DD"));

    if (params.get("TODAY_DD").equals("01") || params.get("TODAY_DD").equals("02") || params.get("TODAY_DD").equals("03")
    		|| params.get("TODAY_DD").equals("04") || params.get("TODAY_DD").equals("05")){

  	 hsAccConfigService.updateHsAccConfigBasicMultiple1_5(params, sessionVO);

    logger.debug("check 111 :: " + params.get("TODAY_DD"));

    }*/


    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);

  }

}
