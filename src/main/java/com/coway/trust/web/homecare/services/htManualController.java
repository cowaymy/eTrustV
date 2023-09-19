package com.coway.trust.web.homecare.services;

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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.sales.htOrderDetailService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.homecare.services.htManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberListController;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.biz.sales.common.SalesCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/homecare/services")
public class htManualController {
  private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

  @Resource(name = "htManualService")
  private htManualService htManualService;

  @Resource(name = "htOrderDetailService")
  private htOrderDetailService htOrderDetailService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Resource(name = "hcOrderListService")
  private HcOrderListService hcOrderListService;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/initHTManualList.do")
  public String initHTManagementList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    logger.debug("getUserBranchId : {}", sessionVO.getUserBranchId());

    params.put("memberLevel", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());

//	SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
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


    // params.put("userType", "3");

    logger.debug("=======================================================================================");
    logger.debug("============== initHTManualList params{} ", params);
    logger.debug("=======================================================================================");

    List<EgovMap> branchList = htManualService.selectBranchList(params);
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

    return "homecare/services/htManual";
  }

  @RequestMapping(value = "/selectCSConfigListPop.do")
  public String selectCSConfigListPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) {
    logger.debug("selectCSConfigListPop : {}", params);
    model.addAttribute("brnchCdList", params.get("BrnchId"));
    model.addAttribute("ordCdList", params.get("CheckedItems"));
    model.addAttribute("ManuaMyBSMonth", params.get("ManuaMyBSMonth"));
    model.addAttribute("SalesOrderNo", params.get("SalesOrderNo"));

    return "homecare/services/htConfigPop";
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

    String rtnValue = htManualService.updateAssignCody(params);

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

    logger.debug("selectPopUpCdList	: " + params.toString());

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

    logger.debug("selectPopUpCdList - params : {}", params);

    List<EgovMap> resultList = htManualService.getCdList_1(params);

    List<EgovMap> resultList1 = htManualService.selectHsManualListPop(params);

    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectPopUpCustList.do")
  public ResponseEntity<List<EgovMap>> selectPopUpCustList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    Map parameterMap = request.getParameterMap();
    String[] nameParam = (String[]) parameterMap.get("name");

    logger.debug(" selectPopUpCustList	: " + params.toString());

    if (null != params.get("SaleOrdList")) {

      String olist = (String) params.get("SaleOrdList");

      String[] spl = olist.split(",");

      params.put("saleOrdListSp", spl);
    }

    List<EgovMap> resultList1 = htManualService.selectHsManualListPop(params);
    // model.addAttribute("ordCdList1", resultList1);

    return ResponseEntity.ok(resultList1);
  }

  @RequestMapping(value = "/selectHsManualList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHsManualList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    params.put("user_id", sessionVO.getUserId());
    params.put("userType", sessionVO.getUserTypeId());

	String listProductIdHsManua = (String) params.get("listProductIdHsManua");
	String[] listProductIdHsManuavalue = listProductIdHsManua.split("∈");
	logger.debug(" :::: {}", listProductIdHsManuavalue.length);


	if (listProductIdHsManuavalue != null && !CommonUtils.containsEmpty(listProductIdHsManuavalue)){
		params.put("listProductIdHsManua", listProductIdHsManuavalue);
	}
	else{
		params.put("listProductIdHsManua", null);
	}

	String unitTypeIdHsManua = (String) params.get("unitTypeIdHsManua");
	String[] unitTypeIdHsManuavalue = unitTypeIdHsManua.split("∈");
	logger.debug(" :::: {}", unitTypeIdHsManuavalue.length);

	if (unitTypeIdHsManuavalue != null && !CommonUtils.containsEmpty(unitTypeIdHsManuavalue)){
		params.put("unitTypeIdHsManua", unitTypeIdHsManuavalue);
	}
	else{
		params.put("unitTypeIdHsManuavalue", null);
	}



	logger.debug(" params :  " + params.toString());
    // 조회.
    List<EgovMap> bsManagementList = htManualService.selectHsManualList(params);

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
  @RequestMapping(value = "/initHTConfigSettingList.do")
  public String initHTConfigSettingList(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "homecare/services/htConfigSetting";
  }

  @RequestMapping(value = "/selectHTBasicList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHsBasicList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    params.put("user_id", sessionVO.getUserId());

    // 조회.
    List<EgovMap> hsBasicList = htManualService.selectHsConfigList(params);

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

    String[] arrAppType = request.getParameterValues("cmblistAppType"); // Application
    String[] arrListProductIdHsManagement = request.getParameterValues("listProductIdHsManagement"); // Application
    String[] arrUnitTypeIdHsManagement = request.getParameterValues("unitTypeIdHsManagement"); // Application
                                                                        // Type
    if (arrAppType != null && !CommonUtils.containsEmpty(arrAppType))
      params.put("arrAppType", arrAppType);

    if (arrListProductIdHsManagement != null && !CommonUtils.containsEmpty(arrListProductIdHsManagement))
        params.put("arrListProductIdHsManagement", arrListProductIdHsManagement);

    if (arrUnitTypeIdHsManagement != null && !CommonUtils.containsEmpty(arrUnitTypeIdHsManagement))
        params.put("arrUnitTypeIdHsManagement", arrUnitTypeIdHsManagement);

    logger.debug("userType :  " + sessionVO.getUserTypeId());
    logger.debug("params :  " + params);
    // 조회.
    List<EgovMap> hsAssiintList = htManualService.selectHsAssiinlList(params);

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
    List<EgovMap> resultList = htManualService.getCdUpMemList(params);

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
    List<EgovMap> resultList = htManualService.getCdDeptList(params);

    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/hsOrderSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertHsResult(@RequestBody Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {
    Boolean success = false;
    String msg = "";
    logger.debug("params : " + params);

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    Map<String, Object> resultValue = new HashMap<String, Object>();
    ReturnMessage message = new ReturnMessage();
    resultValue = htManualService.insertHsResult(formMap, updList, sessionVO);

    message.setMessage("Complete to Add a HCS Order.  " + resultValue.get("docNo"));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectCsInitDetailPop.do")
  public String selectHsInitDetailPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    params.put("schdulId", params.get("schdulId"));
    params.put("salesOrderId", params.get("salesOrdId"));

    EgovMap hsDefaultInfo = htManualService.selectHsInitDetailPop(params);
    List<EgovMap> cmbCollectTypeComboList = htManualService.cmbCollectTypeComboList(params);
    // List<EgovMap> cmbServiceMemList =
    // htManualService.cmbServiceMemList(params);
    EgovMap orderDetail = htOrderDetailService.selectOrderBasicInfo(params, sessionVO);//
    List<EgovMap> failReasonList = htManualService.failReasonList(params);
    // List<EgovMap> serMemList = htManualService.serMemList(params);

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

    return "homecare/services/htDetailPop";

  }

  @RequestMapping(value = "/htBasicInfoPop.do")
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

    basicinfo = htManualService.selectHsViewBasicInfo(params);
    orderDetail = htOrderDetailService.selectOrderBasicInfo(params, sessionVO);

    // List<EgovMap> cmbCollectTypeComboList =
    // htManualService.cmbCollectTypeComboList(params);
    List<EgovMap> failReasonList = htManualService.failReasonList(params);
    // List<EgovMap> serMemList = htManualService.serMemList(params);

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    model.put("toDay", toDay);

    model.addAttribute("basicinfo", basicinfo);
    logger.debug("basicinfo : {}", basicinfo);
    model.addAttribute("orderDetail", orderDetail);
    // model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
    model.addAttribute("failReasonList", failReasonList);
    model.addAttribute("MOD", params.get("MOD"));
    // model.addAttribute("serMemList", serMemList);
    model.addAttribute("ROW", params.get("ROW"));
    params.put("groupCode", "511");
    model.addAttribute("unmatchRsnList", commonService.selectCodeList(params));

    return "homecare/services/htEditPop";

  }

  @RequestMapping(value = "/selectHsViewfilterPop.do")
  public ResponseEntity<List<EgovMap>> selectHsViewfilterPop(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> hsViewfilterInfo = null;

    hsViewfilterInfo = htManualService.selectHsViewfilterInfo(params);
    // model.addAttribute("hsViewfilterInfo", hsViewfilterInfo);

    return ResponseEntity.ok(hsViewfilterInfo);
  }

  @RequestMapping(value = "/hSMgtResultViewResultPop.do")
  public String hSMgtResultViewResultPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    EgovMap hSMgtResultViewResult = null;

    hSMgtResultViewResult = htManualService.hSMgtResultViewResult(params);
    model.addAttribute("hSMgtResultViewResult", hSMgtResultViewResult);

    return "services/bs/hSManagementResultViewResultPop";
  }

  @RequestMapping(value = "/hSMgtResultViewResultFilter.do")
  public ResponseEntity<List<EgovMap>> hSMgtResultViewResultFilter(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> hSMgtResultViewResultFilter = null;

    hSMgtResultViewResultFilter = htManualService.hSMgtResultViewResultFilter(params);
    // model.addAttribute("hsViewfilterInfo", hsViewfilterInfo);

    return ResponseEntity.ok(hSMgtResultViewResultFilter);
  }

  @RequestMapping(value = "/selectHistoryHSResult.do")
  public ResponseEntity<List<EgovMap>> selectHistoryHSResult(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> historyHSResult = null;

    historyHSResult = htManualService.selectHistoryHSResult(params);

    return ResponseEntity.ok(historyHSResult);
  }

  @RequestMapping(value = "/selectFilterTransaction.do")
  public ResponseEntity<List<EgovMap>> selectFilterTransaction(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    List<EgovMap> filterTransaction = null;

    filterTransaction = htManualService.selectFilterTransaction(params);

    return ResponseEntity.ok(filterTransaction);
  }

  @RequestMapping(value = "/SelectHsFilterList.do")
  public ResponseEntity<List<EgovMap>> SelectHsFilterList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

    // params.put("salesOrdId", params.get("salesOrdId"));

    List<EgovMap> hsFilterList = htManualService.selectHsFilterList(params);
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
    resultValue = htManualService.addIHsResult(formMap, insList, sessionVO);

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

// Not Applicable for Care Service
// Added to update only "Has Return" flag
//    if (updList != null) {
//        hsManualService.UpdateIsReturn(formMap, updList, sessionVO);
//    }

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

    resultValue = htManualService.UpdateHsResult2(formMap, insList, sessionVO);

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

    resultValue = htManualService.UpdateHsResult(formMap, updList, sessionVO);

    message.setMessage("Complete to Update a HS Result : " + formMap.get("hidHsno"));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/htConfigBasicPop.do	")
  public String hsConfigBasicPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params(pop)================= : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    EgovMap configBasicInfo = htManualService.selectConfigBasicInfo(params);

    // model.put("cmbServiceMemList", cmbServiceMemList);
    model.put("configBasicInfo", configBasicInfo);
    model.put("SALEORD_ID", (String) params.get("salesOrdId"));

    // model.put("as_ord_basicInfo", as_ord_basicInfo);
    // model.put("AS_NO", (String)params.get("AS_NO"));
    model.put("BRNCH_ID", (String) params.get("brnchId"));
    model.put("CODY_MANGR_USER_ID", (String) params.get("codyMangrUserId"));
    model.put("CUST_ID", (String) params.get("custId"));
    model.put("SCHDUL_ID", params.get("schdulId"));
    model.put("IND", params.get("indicator"));
    // logger.debug("configBasicInfo(pop)================= : {}",
    // configBasicInfo);
    //

    return "homecare/services/htConfigBasicPop";
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
    // htManualService.cmbServiceMemList(params);
    // model.put("cmbServiceMemList", cmbServiceMemList);
    // List<EgovMap> serMemList = htManualService.serMemList(params);
    // model.addAttribute("serMemList", serMemList);

    return "homecare/services/htConfigBasicPop";
  }

  @RequestMapping(value = "/getHSCody.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getHSCody(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("params : {}", params);
    EgovMap serMember = null;
    serMember = htManualService.serMember(params);

    return ResponseEntity.ok(serMember);
  }

  @RequestMapping(value = "/selectHTMemberList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSCodyList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    // params.put("codyMangrUserId", params.get("groupCode[codyMangrUserId]"));
    // params.put("custId", params.get("groupCode[custId]"));
    logger.debug("params(selectHTMemberList)============== {}", params);
    List<EgovMap> htMemberList = htManualService.selectHTMemberList(params);
    logger.debug("hsCodyList(selectHTMemberList)============== {}", htMemberList);
    return ResponseEntity.ok(htMemberList);
  }

  @RequestMapping(value = "/hSFilterSettingPop.do")
  public String hSFilterSettingPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    EgovMap hSOrderView = htManualService.selectHSOrderView(params);
    model.put("hSOrderView", hSOrderView);

    return "services/bs/hSFilterSettingPop";
  }

  @RequestMapping(value = "/getActivefilterInfo.do")
  public ResponseEntity<List<EgovMap>> getActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> orderActiveFilter = htManualService.selectOrderActiveFilter(params);

    model.put("orderActiveFilter", orderActiveFilter);

    return ResponseEntity.ok(orderActiveFilter);
  }

  @RequestMapping(value = "/getInActivefilterInfo.do")
  public ResponseEntity<List<EgovMap>> getInActivefilterInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> orderInactiveFilter = htManualService.selectOrderInactiveFilter(params);

    model.put("orderInactiveFilter", orderInactiveFilter);

    return ResponseEntity.ok(orderInactiveFilter);
  }

  @RequestMapping(value = "/hSAddFilterSetPop.do")
  public String hSAddFilterSetInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params : {}", params.toString());
    params.put("orderNo", params.get("salesOrdId"));

    List<EgovMap> hSAddFilterSetInfo = htManualService.selectHSAddFilterSetInfo(params);
    model.put("_salesOrdId", (String) params.get("salesOrdId"));
    model.put("_stkId", (String) params.get("stkId"));
    model.put("hSAddFilterSetInfo", hSAddFilterSetInfo);

    return "services/bs/hsFilterAddPop";
  }

  @RequestMapping(value = "/addSrvFilterID.do")
  public ResponseEntity<List<EgovMap>> addSrvFilterIdCnt(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {
	  logger.debug("params1111 : {}", params.toString());

    List<EgovMap> addSrvFilterIdCnt = htManualService.addSrvFilterIdCnt(params);

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

    int resultValue = htManualService.saveHsFilterInfoAdd(params);
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

    int resultValue = htManualService.saveDeactivateFilter(params);

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
  public ResponseEntity<ReturnMessage> saveHsConfigBasic(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();

    logger.debug("params : {}", params);
    String srvCodyId = "";

    int resultValueMat = 1;
    int resultValueFra = 1;

    //Mattress
    LinkedHashMap hsResultM = (LinkedHashMap) params.get("hsResultM");
    hsResultM.put("hscodyId", hsResultM.get("cmbServiceMem"));
    srvCodyId = htManualService.getSrvCodyIdbyMemcode(hsResultM);
    logger.debug("srvCodyId : " + srvCodyId);
    hsResultM.put("cmbServiceMem", srvCodyId);
    hsResultM.put("hscodyId", srvCodyId);
    logger.debug("hsResultM : {}", hsResultM);
    // htManualService.updateSrvCodyId(hsResultM);
    // logger.debug("params111111111 : {}", params);
    // List<Object> remList = (List<Object>)
    // params.get(AppConstants.AUIGRID_REMOVE);
    String schdulId = (String) hsResultM.get("schdulId");


    logger.debug("hsResultM ===>" + hsResultM.toString());

    resultValueMat = htManualService.updateHsConfigBasic(params, sessionVO);

    // ADDED BY TPY FOR ASSIGN HT CODY_ID IN SVC0008D
    logger.debug("schdulId ===>" + hsResultM.get("schdulId"));

    if (schdulId != null && schdulId != "") {
      params.put("updator", sessionVO.getUserId());
      params.put("codyId", srvCodyId);
      params.put("schdulId", schdulId);
      htManualService.updateAssignHT(params);
    }

    //Frame
    LinkedHashMap hsResultM1 = (LinkedHashMap) params.get("hsResultM");
    hsResultM1.put("srvOrdId",hsResultM1.get("salesOrderId"));

	EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(hsResultM1);

	if (hcOrder != null){

	String fraOrdId = CommonUtils.nvl(hcOrder.get("anoOrdId"));

	    params.put("hscodyId", hsResultM1.get("cmbServiceMem"));
	    hsResultM.put("srvOrdId", hcOrder.get("anoOrdId"));
	    hsResultM.put("salesOrderId", hcOrder.get("anoOrdId"));
	    srvCodyId = htManualService.getSrvCodyIdbyMemcode(hsResultM);
	    logger.debug("srvCodyId : " + srvCodyId);
	    params.put("cmbServiceMem", srvCodyId);
	    params.put("hscodyId", srvCodyId);
	    logger.debug("hsResultM2 : {}", params);
	    // htManualService.updateSrvCodyId(hsResultM);
	    // logger.debug("params111111111 : {}", params);
	    // List<Object> remList = (List<Object>)
	    // params.get(AppConstants.AUIGRID_REMOVE);
	    String schdulIdFra = (String) hsResultM1.get("schdulId");

	if(fraOrdId != "" && fraOrdId != null ){


		    logger.debug("hsResultM ===>" + hsResultM.toString());

		    resultValueFra = htManualService.updateHsConfigBasic(params, sessionVO);

		    // ADDED BY TPY FOR ASSIGN HT CODY_ID IN SVC0008D
		    logger.debug("schdulId ===>" + hsResultM.get("schdulId"));

		    if (schdulId != null && schdulId != "") {
		      params.put("updator", sessionVO.getUserId());
		      params.put("codyId", srvCodyId);
		      params.put("schdulId", schdulId);
		      htManualService.updateAssignHT(params);
		    }
	}
	}else{
		resultValueFra = 1;
	}

    if (resultValueMat > 0 && resultValueFra > 0 ) {
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

  @RequestMapping(value = "/hsReportSinglePop.do")
  public String hsReportSinglePop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/bs/hsReportSinglePop";
  }

  @RequestMapping(value = "/selectBranch_id", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBranch_id(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("params {}", params);
    List<EgovMap> branchList = htManualService.selectBranch_id(params);
    // model.addAttribute("branchList", branchList);
    logger.debug("branchList {}", branchList);
    return ResponseEntity.ok(branchList);
  }

  @RequestMapping(value = "/selectCTMByDSC_id", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCTMByDSC_id(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("params {}", params);
    List<EgovMap> branchList = htManualService.selectCTMByDSC_id(params);
    // model.addAttribute("branchList", branchList);
    logger.debug("branchList {}", branchList);
    return ResponseEntity.ok(branchList);
  }

  @RequestMapping(value = "/checkMemCode")
  public ResponseEntity<ReturnMessage> checkMemberCode(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("params : {}", params.toString());

    EgovMap checkMemCode = htManualService.selectCheckMemCode(params);

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
    // htManualService.selecthSFilterUseHistorycall(params);

    htManualService.selecthSFilterUseHistorycall(params);

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

    int resultValue = htManualService.saveFilterUpdate(params);

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

    List<EgovMap> failReasonList = htManualService.failReasonList(params);
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

    List<EgovMap> cmbCollectTypeComboList = htManualService.cmbCollectTypeComboList2(params);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);

    return ResponseEntity.ok(cmbCollectTypeComboList);
  }

  @RequestMapping(value = "/saveValidation.do", method = RequestMethod.POST)
  public ResponseEntity<Integer> saveValidation(@RequestBody Map<String, Object> params, HttpServletRequest request,
      SessionVO sessionVO) throws ParseException {

    logger.debug("saveValidation params : {}", params);

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

    int resultValue = htManualService.saveValidation(formMap);// hidSalesOrdCd

    return ResponseEntity.ok(resultValue);
  }

  @RequestMapping(value = "/selectHsOrderInMonth.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkHsOrderInMonth(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("selectHsOrderInMonth.do : {}", params);

    EgovMap hsOrderInMonth = htManualService.selectHsOrderInMonth(params);
    EgovMap hsOrder1Time = htManualService.selectHsOrder1Time(params);
    int hsOrderTotal1Year = htManualService.selectHsOrderTotal1Year(params);

    if (hsOrderInMonth != null && hsOrderInMonth.size() != 0) {
      message.setMessage("fail");
    } else if (hsOrder1Time != null && hsOrder1Time.size() != 0) {
      message.setMessage("warning");
    } else if (hsOrderTotal1Year >= 3) {
      message.setMessage("block");
    } else {
      message.setMessage("success");
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

    List<EgovMap> assignDeptMemUpList = htManualService.assignDeptMemUp(params);
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

    List<EgovMap> cmbBrnchCodeList = htManualService.selectBranchList(params);
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

    List<EgovMap> cmbCMList = htManualService.selectCMList(params);
    model.addAttribute("cmbCMList", cmbCMList);

    return ResponseEntity.ok(cmbCMList);
  }

  @RequestMapping(value = "/checkStkDuration.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> checkStkDuration(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("params {}", params);
    String msg = "";
    EgovMap stkId = htManualService.checkStkDuration(params);

    if (stkId != null) {
      msg = "1";
    } else {
      msg = "0";
    }
    logger.debug("checkStkDuration - msg : " + msg);
    message.setMessage(msg);
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/htSummaryList.do")
  public String bSSummaryList(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "homecare/services/htSummaryPop";
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/deptCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectdeptCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> DeptCodeList = htManualService.selectDeptCodeList(params);
    logger.debug("HSReportSingle {}", DeptCodeList);
    return ResponseEntity.ok(DeptCodeList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/dscCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDscCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> DscCode = htManualService.selectDscCodeList(params);
    logger.debug("HSReportSingle {}", DscCode);
    return ResponseEntity.ok(DscCode);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/insStatusCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectInsStatusList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> InsStatusList = htManualService.selectInsStatusList(params);
    logger.debug("HSReportSingle {}", InsStatusList);
    return ResponseEntity.ok(InsStatusList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/codyCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodyCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> CodyCodeList = htManualService.selectCodyCodeList(params);
    logger.debug("HSReportSingle {}", CodyCodeList);
    return ResponseEntity.ok(CodyCodeList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/codyCode_1.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodyCodeList_1(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> CodyCodeList = htManualService.selectCodyCodeList_1(params);
    logger.debug("HSReportSingle {}", CodyCodeList);
    return ResponseEntity.ok(CodyCodeList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/areaCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAreaCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> AreaCodeList = htManualService.selectAreaCodeList(params);
    logger.debug("HSReportSingle {}", AreaCodeList);
    return ResponseEntity.ok(AreaCodeList);
  }

  @RequestMapping(value = "/selectHSReportSingle.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSReportSingle(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> HSReportSingle = htManualService.selectHSReportSingle(params);
    logger.debug("HSReportSingle {}", HSReportSingle);
    return ResponseEntity.ok(HSReportSingle);
  }

  @RequestMapping(value = "/selectHSReportGroup.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSReportGroup(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> HSReportGroup = htManualService.selectHSReportGroup(params);
    logger.debug("HSReportGroup {}", HSReportGroup);
    return ResponseEntity.ok(HSReportGroup);
  }

  @RequestMapping(value = "/htReportGroupPop.do")
  public String htReportGroupPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "homecare/services/htReportGroupPop";
  }

  @RequestMapping(value = "/htReportSinglePop.do")
  public String htReportSinglePop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "homecare/services/htReportSinglePop";
  }

  @RequestMapping(value = "/htConfigRawDataPop.do")
  public String htConfigRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "homecare/services/htConfigRawDataPop";
  }

  @RequestMapping(value = "/HTCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHTCodeList(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("selectHTCodeList - params : " + params);
    List<EgovMap> HTCodeList = htManualService.selectHTCodeListByHTCode(params);
    return ResponseEntity.ok(HTCodeList);
  }

  @RequestMapping(value = "/htConfigBasicMultiplePop.do	")
  public String hsConfigBasicMultiplePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("htConfigBasicMultiplePop.do	 ================= : {}", params.toString());

    model.put("SALEORD_ID", params.get("salesOrdId"));
    model.put("SCHDUL_ID", params.get("schdulId"));

    return "homecare/services/htConfigBasicMultiplePop";
  }

  @RequestMapping(value = "/hsAccConfigBasicMultiplePop.do	")
  public String hsAccConfigBasicMultiplePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("hsAccConfigBasicMultiplePop.do	 ================= : {}", params.toString());

    model.put("SALEORD_ID", params.get("salesOrdId"));
    model.put("SCHDUL_ID", params.get("schdulId"));

    return "homecare/services/hsAccConfigBasicMultiplePop";
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

    params.put("memCode", (String) params.get("cmbServiceMem"));

    logger.debug("saveHsConfigBasicMultiple - params : {}", params);

    // UPDATE SAL0090D - SRV_MEM_ID
    // UPDATE SVC0008D - MEM_ID
    int resultValue = htManualService.updateHsConfigBasicMultiple(params, sessionVO);

    // int resultValue = 0;

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/selectTotalCS.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> selectTotalCS(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    ReturnMessage message = new ReturnMessage();
    logger.debug("selectTotalCS.do : {}", params);

    int hsOrderTotal1Year = htManualService.selectTotalCS(params);

    if (hsOrderTotal1Year == 2) {
      message.setMessage("CS Completed twice before , Left 1 times CS Service.");
    } else if (hsOrderTotal1Year == 1) {
      message.setMessage("CS Completed once before , Left 2 times CS Service.");
    } else {
      message.setMessage(" ");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/cwDisinfSrv.do")
  public String cwDisinfSrv(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "homecare/services/htCwDisinfSrvPop";
  }

  @RequestMapping(value = "/csFilterSettingPop.do")
  public String cSFilterSettingPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    logger.debug("params1111 : {}", params.toString());

    EgovMap csOrderView = htManualService.selectCSOrderView(params);
    model.put("csOrderView", csOrderView);

    return "homecare/services/csFilterSettingPop";
  }


  @RequestMapping(value = "/checkMatFra.do", method = RequestMethod.GET)
  public ResponseEntity <EgovMap> checkMatOrFra(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("checkMatOrFra - params : " + params);
    EgovMap CheckFra = htManualService.checkMatOrFra(params);
    return ResponseEntity.ok(CheckFra);
  }
}
