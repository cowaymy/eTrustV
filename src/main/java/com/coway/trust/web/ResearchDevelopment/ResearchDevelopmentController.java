package com.coway.trust.web.ResearchDevelopment;

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
import com.coway.trust.biz.ResearchDevelopment.AfterPEXTestResultListService;
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

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/ResearchDevelopment")
public class ResearchDevelopmentController {
	 private static final Logger logger = LoggerFactory.getLogger(ResearchDevelopmentController.class);

	 @Resource(name = "AfterPEXTestResultListService")
	  private AfterPEXTestResultListService AfterPEXTestResultListService;

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

	  @RequestMapping(value = "/AfterPEXTestResult.do")
	  public String AfterPEXTestResultList(@RequestParam Map<String, Object> params, ModelMap model) {
	    logger.debug("===========================/AfterPEXTestResult.do===============================");
	    logger.debug("== params1111 " + params.toString());
	    logger.debug("===========================/AfterPEXTestResult.do===============================");

	    // GET SEARCH DATE RANGE
	    //String range = AfterPEXTestResultListService.getSearchDtRange();

	    List<EgovMap> PEXTRStatus = AfterPEXTestResultListService.selectAsStat();
	    List<EgovMap> Product = AfterPEXTestResultListService.asProd();

	    //model.put("DT_RANGE", CommonUtils.nvl(range));
	    model.put("PEXTRStatus", PEXTRStatus);
	    model.put("Product", Product);

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
	        SalesConstants.DEFAULT_DATE_FORMAT1);
	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("bfDay", bfDay);
	    model.put("toDay", toDay);
	    return "ResearchDevelopment/AfterPEXTestResult";
	  }

	  @RequestMapping(value = "/TestResultNewResultPop.do")
	  public String insertASResult(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    logger.debug("===========================/TestResultNewResultPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/TestResultNewResultPop.do===============================");

	    model.put("TEST_RESULT_ID", (String) params.get("testResultId"));
	    model.put("TEST_RESULT_NO", (String) params.get("testResultNo"));
	    model.put("SO_EXCHG_ID", (String) params.get("soExchgId"));
	    model.put("RCD_TMS", (String) params.get("rcdTms"));
	    model.put("PROD_CDE", (String) params.get("prodCde"));
	    model.put("PROD_CAT", (String) params.get("prodCat"));

	    params.put("testResultId", params.get("testResultId"));

	    List<EgovMap> asCrtStat = AfterPEXTestResultListService.selectAsCrtStat();
	    model.addAttribute("asCrtStat", asCrtStat);

	    List<EgovMap> timePick = AfterPEXTestResultListService.selectTimePick();
	    model.addAttribute("timePick", timePick);

	    return "ResearchDevelopment/TestResultNewResultPop";
	  }

	  @RequestMapping(value = "/TestResultEditBasicPop.do")
	  public String asResultEditBasicPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {
	    logger.debug("===========================/TestResultEditBasicPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/TestResultEditBasicPop.do===============================");

	    model.put("TEST_RESULT_ID", (String) params.get("testResultId"));
	    model.put("TEST_RESULT_NO", (String) params.get("testResultNo"));
	    model.put("SO_EXCHG_ID", (String) params.get("soExchgId"));
	    model.put("ORDER_NO", (String) params.get("orderNo"));
	    model.put("RCD_TMS", (String) params.get("rcdTms"));
	    model.put("PROD_CDE", (String) params.get("prodCde"));
	    model.put("PROD_CAT", (String) params.get("prodCat"));

	   /* model.put("ORD_ID", (String) params.get("ord_Id"));
	    model.put("ORD_NO", (String) params.get("ord_No"));
	    model.put("AS_NO", (String) params.get("as_No"));
	    model.put("AS_ID", (String) params.get("as_Id"));
	    model.put("AS_RESULT_NO", (String) params.get("as_Result_No"));
	    model.put("AS_RESULT_ID", (String) params.get("as_Result_Id"));
	    model.put("MOD", (String) params.get("mod"));*/

	    model.put("USER_ID", sessionVO.getMemId());
	    model.put("USER_NAME", sessionVO.getUserName());

	  /*  model.put("BRANCH_NAME", sessionVO.getBranchName());
	    model.put("BRANCH_ID", sessionVO.getUserBranchId());*/

	    List<EgovMap> asCrtStat = AfterPEXTestResultListService.selectAsCrtStat();
	    model.addAttribute("asCrtStat", asCrtStat);

	    List<EgovMap> timePick = AfterPEXTestResultListService.selectTimePick();
	    model.addAttribute("timePick", timePick);

	   /* EgovMap orderDetail;
	    params.put("salesOrderId", (String) params.get("ord_Id"));

	    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
	    model.put("orderDetail", orderDetail);*/

	    return "ResearchDevelopment/TestResultEditBasicPop";
	  }

	  @RequestMapping(value = "/TestResultEditViewPop.do")
	  public String TestResultEditViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {
	    logger.debug("===========================/TestResultEditViewPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/TestResultEditViewPop.do===============================");

	    model.put("TEST_RESULT_ID", (String) params.get("testResultId"));
	    model.put("TEST_RESULT_NO", (String) params.get("testResultNo"));
	    model.put("SO_EXCHG_ID", (String) params.get("soExchgId"));
	    model.put("ORDER_NO", (String) params.get("orderNo"));
	    model.put("RCD_TMS", (String) params.get("rcdTms"));
	    model.put("PROD_CDE", (String) params.get("prodCde"));
	    model.put("PROD_CAT", (String) params.get("prodCat"));

	    model.put("USER_ID", sessionVO.getMemId());
	    model.put("USER_NAME", sessionVO.getUserName());

	 /*   model.put("BRANCH_NAME", sessionVO.getBranchName());
	    model.put("BRANCH_ID", sessionVO.getUserBranchId());*/

	    //params.put("salesOrderId", (String) params.get("ord_Id"));
	 /*   EgovMap orderDetail = null;
	    // basicinfo = hsManualService.selectHsViewBasicInfo(params);
	    orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
	    model.addAttribute("orderDetail", orderDetail);*/

	    return "ResearchDevelopment/TestResultEditViewPop";
	  }

	  @RequestMapping(value = "/TestResultInfoEdit.do")
	  public String asResultInfoEdit(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    logger.debug("===========================/TestResultInfoEdit.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/TestResultInfoEdit.do===============================");

	    model.put("USER_ID", sessionVO.getMemId());
	    model.put("USER_NAME", sessionVO.getUserName());
	    model.put("BRANCH_NAME", sessionVO.getBranchName());
	    model.put("BRANCH_ID", sessionVO.getUserBranchId());
	    model.put("ORD_NO", params.get("ord_No"));

	    List<EgovMap> asCrtStat = AfterPEXTestResultListService.selectAsCrtStat();
	    model.addAttribute("asCrtStat", asCrtStat);

	    List<EgovMap> timePick = AfterPEXTestResultListService.selectTimePick();
	    model.addAttribute("timePick", timePick);

	    return "ResearchDevelopment/inc_TestResultEditPop";
	  }

	  @RequestMapping(value = "/searchPEXTestResultList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> searchPEXTestResultList(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {
	    logger.debug("===========================/searchPEXTestResultList.do===============================");
	    logger.debug("== params heres" + params.toString());

	    String[] PEXTRStatus = request.getParameterValues("PEXTRStatus");
	    String[] cmbCategoryList = request.getParameterValues("cmbCategory");
	    String[] ProductList = request.getParameterValues("Product");

	    String[] cmbbranchIdList = request.getParameterValues("cmbbranchId");

	    params.put("PEXTRStatus", PEXTRStatus);
	    params.put("cmbCategoryList", cmbCategoryList);
	    params.put("cmbbranchIdList", cmbbranchIdList);
	    params.put("ProductList", ProductList);

	    List<EgovMap> ASMList = AfterPEXTestResultListService.searchPEXTestResultList(params);

	    logger.debug("===========================/searchPEXTestResultList.do===============================");
	    return ResponseEntity.ok(ASMList);
	  }

	  @RequestMapping(value = "/selRcdTms.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> chkRcdTms(@RequestBody Map<String, Object> params, ModelMap model,
	      SessionVO sessionVO) {
	    ReturnMessage message = new ReturnMessage();

	    logger.debug("==================/selRcdTms.do=======================");
	    logger.debug("params : {}", params);

	    int noRcd = AfterPEXTestResultListService.selRcdTms(params);
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

	  @RequestMapping(value = "/getPEXTestResultInfo", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> getPEXTestResultInfo(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {
	    logger.debug("===========================/getPEXTestResultInfo.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/getPEXTestResultInfo.do===============================");

	    List<EgovMap> list = AfterPEXTestResultListService.getPEXTestResultInfo(params);

	    return ResponseEntity.ok(list);
	  }

	  @RequestMapping(value = "/PEXTestResultUpdate.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> PEXTestResultUpdate(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {
	    logger.debug("===========================/PEXTestResultUpdate.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/PEXTestResultUpdate.do===============================");

	    params.put("updator", sessionVO.getUserId());
	    ReturnMessage message = new ReturnMessage();

	    HashMap<String, Object> mp = new HashMap<String, Object>();
	    Map<?, ?> svc0125map = (Map<?, ?>) params.get("PEXResultM");
	    mp.put("TEST_RESULT_NO", svc0125map.get("TEST_RESULT_NO"));

	    params.put("testResultId", svc0125map.get("TEST_RESULT_ID"));
	    params.put("testResultNo", svc0125map.get("TEST_RESULT_NO"));
	    params.put("rcdTms", svc0125map.get("RCD_TMS"));

	    int noRcd = AfterPEXTestResultListService.chkRcdTms(params);

	    if (noRcd == 1) { // RECORD ABLE TO UPDATE
	      int isPEXCnt = AfterPEXTestResultListService.isPEXAlreadyResult(mp);
	      logger.debug("== isPEXCnt " + isPEXCnt);

	      if (isPEXCnt == 0) {
	        EgovMap rtnValue = AfterPEXTestResultListService.PEXResult_Update(params);
	        logger.debug("==/// rtnValue " + rtnValue);

	        message.setCode(AppConstants.SUCCESS);
	        message.setData(rtnValue.get("testResultNo"));
	        message.setMessage("");

	      } else {
	        message.setCode("98");
	        message.setData(svc0125map.get("TEST_RESULT_NO"));
	        message.setMessage("Result already exist with Complete Status.");
	      }
	    } else {
	      message.setMessage(
	          "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
	      message.setCode("99");
	    }

	    return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/PEXTestRawDataPop.do")
		public String PEXTestRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		  	List<EgovMap> PEXTRStatus = AfterPEXTestResultListService.selectAsStat();
		    model.put("PEXTRStatus", PEXTRStatus);

			return "ResearchDevelopment/PEXTestRawDataPop";
		}
}
