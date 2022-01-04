package com.coway.trust.web.ResearchDevelopment;

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
import com.coway.trust.biz.ResearchDevelopment.AfterPEXTestResultListService;
import com.coway.trust.biz.ResearchDevelopment.UsedPartReTestResultService;
import com.coway.trust.biz.ResearchDevelopment.impl.AfterPEXTestResultListMapper;
import com.coway.trust.biz.ResearchDevelopment.impl.UsedPartReTestResultMapper;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.InHouseRepairService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
/*import com.coway.trust.web.services.as.ASManagementListController;*/

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/ResearchDevelopment")
public class UsedPartReTestResultController {
	 private static final Logger logger = LoggerFactory.getLogger(UsedPartReTestResultController.class);

	 @Resource(name = "UsedPartReTestResultService")
	 private UsedPartReTestResultService UsedPartReTestResultService;

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

	  @Autowired
	  private AdaptorService adaptorService;

	  @Autowired
	  private MessageSourceAccessor messageAccessor;




	@RequestMapping(value = "/selectUsedPartReturnList", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectUsedPartReturnList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
				logger.debug("params =====================================>>  " + params);

			    List<EgovMap> list = UsedPartReTestResultService.selectUsedPartReList(params);

			    logger.debug("list =====================================>>  " + list.toString());
		return ResponseEntity.ok(list);
	}


	  /*	 @RequestMapping(value = "/selectGroupMstList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGroupMstList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	    LOGGER.debug("params =====================================>>  " + params);

	    List<EgovMap> list = groupService.selectGroupMstList(params);

	    LOGGER.debug("list =====================================>>  " + list.toString());
	    return ResponseEntity.ok(list);
		}*/

/*	  @RequestMapping(value = "/searchASManagementList.do", method = RequestMethod.GET)
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
	  }*/

	  @RequestMapping(value = "/UsedPartReTestResult.do")
	  public String usedPartReTestResultList(@RequestParam Map<String, Object> params, ModelMap model) {
	    logger.debug("===========================/UsedPartReTestResult.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/UsedPartReTestResult.do===============================");

	    // GET SEARCH DATE RANGE
	    String range = ASManagementListService.getSearchDtRange();

	    List<EgovMap> asStat = ASManagementListService.selectAsStat();
	    List<EgovMap> asProduct = UsedPartReTestResultService.asProd();

	    model.put("DT_RANGE", CommonUtils.nvl(range));
	    model.put("asStat", asStat);
	    model.put("asProduct", asProduct);

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
	    SalesConstants.DEFAULT_DATE_FORMAT1);
	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("bfDay", bfDay);
	    model.put("toDay", toDay);
	    return "ResearchDevelopment/UsedPartReTestResult";
	  }

	  @RequestMapping(value = "/UsedPartReTestResultEditViewPop.do")
	  public String UsedPartReTestResultEditViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {
	    logger.debug("===========================/UsedPartReTestResultEditViewPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/UsedPartReTestResultEditViewPop.do===============================");

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

	    return "ResearchDevelopment/UsedPartReTestResultEditViewPop";
	  }

	  @RequestMapping(value = "/UsedPartReTestResultViewPop.do")
	  public String TestResultViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {
	    logger.debug("===========================/UsedPartReTestResultViewPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/UsedPartReTestResultViewPop.do===============================");

	    model.put("ORD_ID", (String) params.get("ord_Id"));
	    model.put("ORD_NO", (String) params.get("ord_No"));
	    model.put("AS_ID", (String) params.get("as_Id"));
	    model.put("AS_NO", (String) params.get("as_No"));

	    EgovMap AsEventInfo = ASManagementListService.getAsEventInfo(params);
	    model.put("AsEventInfo", AsEventInfo);

	    EgovMap orderDetail = null;
	    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
	    model.addAttribute("orderDetail", orderDetail);

	    return "ResearchDevelopment/UsedPartReTestResultViewPop";
	  }

	  @RequestMapping(value = "/asResultInfoEdit2.do")
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

	    /*List<EgovMap> lbrFeeChr = ASManagementListService.selectLbrFeeChr();
	    model.addAttribute("lbrFeeChr", lbrFeeChr);

	    List<EgovMap> fltQty = ASManagementListService.selectFltQty();
	    model.addAttribute("fltQty", fltQty);

	    List<EgovMap> fltPmtTyp = ASManagementListService.selectFltPmtTyp();
	    model.addAttribute("fltPmtTyp", fltPmtTyp);*/

	    return "ResearchDevelopment/inc_UsedPartReTestResultEditPop";
	  }

	  @RequestMapping(value = "/getSpareFilterName.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> getSpareFilterName(@RequestParam Map<String, Object> params, HttpServletRequest request,
	      ModelMap model) {
	    List<EgovMap> spareFilterList = UsedPartReTestResultService.getSpareFilterList(params);
	    return ResponseEntity.ok(spareFilterList);
	  }

	  @RequestMapping(value = "/getASRulstSVC0004DInfo1", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> getASRulstSVC0004DInfo(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {
	    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");

	    //List<EgovMap> list = ASManagementListService.getASRulstSVC0004DInfo(params);
	    List<EgovMap> list = UsedPartReTestResultService.getASRulstSVC0004DInfo(params);

	    return ResponseEntity.ok(list);
	  }


	  @RequestMapping(value = "/UsedPartReTestResultNewResultPop.do")
	  public String insertASResult(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    logger.debug("===========================/UsedPartReTestResultNewResultPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/UsedPartReTestResultNewResultPop.do===============================");

	    model.put("TEST_RESULT_ID", (String) params.get("testResultId"));
	    model.put("TEST_RESULT_NO", (String) params.get("testResultNo"));
	    model.put("SO_EXCHG_ID", (String) params.get("soExchgId"));
	    model.put("RCD_TMS", (String) params.get("rcdTms"));
	    model.put("DSC_CODE", (String) params.get("dsc_Code"));
	    params.put("testResultId", params.get("testResultId"));


	    List<EgovMap> asCrtStat = UsedPartReTestResultService.selectAsCrtStat();
	    model.addAttribute("asCrtStat", asCrtStat);

	    List<EgovMap> timePick = UsedPartReTestResultService.selectTimePick();
	    model.addAttribute("timePick", timePick);

	    return "ResearchDevelopment/UsedPartReTestResultNewResultPop";
	  }

	  @RequestMapping(value = "/getTestResultInfo", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> getTestResultInfo(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {
	    logger.debug("===========================/getTestResultInfo.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/getTestResultInfo.do===============================");

	    List<EgovMap> list = UsedPartReTestResultService.getTestResultInfo(params);

	    return ResponseEntity.ok(list);
	  }

}
