package com.coway.trust.web.ResearchDevelopment;

import java.util.HashMap;
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
import com.coway.trust.biz.ResearchDevelopment.UsedPartReTestResultService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

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

	  @Autowired
	  private MessageSourceAccessor messageAccessor;



	@RequestMapping(value = "/selectUsedPartReturnList", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectUsedPartReturnList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
				logger.debug("params =====================================>>  " + params);

		    	params.put("asStartDt", CommonUtils.changeFormat(String.valueOf(params.get("asStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		    	params.put("asEndDt", CommonUtils.changeFormat(String.valueOf(params.get("asEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

			    List<EgovMap> list = UsedPartReTestResultService.selectUsedPartReList(params);

			    logger.debug("list =====================================>>  " + list.toString());
		return ResponseEntity.ok(list);
	}


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

	  @RequestMapping(value = "/UsedPartReTestResultEditPop.do")
	  public String UsedPartReTestResultEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {
	    logger.debug("===========================/UsedPartReTestResultEditPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/UsedPartReTestResultEditPop.do===============================");

	    model.put("TEST_RESULT_ID", (String) params.get("testResultId"));
	    model.put("TEST_RESULT_NO", (String) params.get("testResultNo"));
	    model.put("SO_EXCHG_ID", (String) params.get("soExchgId"));
	    model.put("RCD_TMS", (String) params.get("rcdTms"));
	    model.put("AS_NO", params.get("as_No"));
	    model.put("DSC_CODE", (String) params.get("dsc_Code"));
	    model.put("CT_CODE", (String) params.get("ct_Code"));
	    model.put("STK_CODE", params.get("stk_Code"));
	    params.put("testResultId", params.get("testResultId"));

	    List<EgovMap> timePick = UsedPartReTestResultService.selectTimePick();
	    model.addAttribute("timePick", timePick);

	    return "ResearchDevelopment/UsedPartReTestResultEditPop";
	  }

	  @RequestMapping(value = "/UsedPartReTestResultViewPop.do")
	  public String UsedPartReTestResultViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {
	    logger.debug("===========================/UsedPartReTestResultViewPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/UsedPartReTestResultViewPop.do===============================");

	    model.put("TEST_RESULT_ID", (String) params.get("testResultId"));
	    model.put("TEST_RESULT_NO", (String) params.get("testResultNo"));
	    model.put("SO_EXCHG_ID", (String) params.get("soExchgId"));
	    model.put("RCD_TMS", (String) params.get("rcdTms"));
	    model.put("AS_NO", params.get("as_No"));
	    model.put("DSC_CODE", (String) params.get("dsc_Code"));
	    model.put("CT_CODE", (String) params.get("ct_Code"));
	    model.put("STK_CODE", params.get("stk_Code"));
	    params.put("testResultId", params.get("testResultId"));

	    List<EgovMap> timePick = UsedPartReTestResultService.selectTimePick();
	    model.addAttribute("timePick", timePick);

	    return "ResearchDevelopment/UsedPartReTestResultViewPop";
	  }


	  @RequestMapping(value = "/UsedPartReTestResultNewResultPop.do")
	  public String insertUPResult(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    logger.debug("===========================/UsedPartReTestResultNewResultPop.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/UsedPartReTestResultNewResultPop.do===============================");

	    model.put("TEST_RESULT_ID", (String) params.get("testResultId"));
	    model.put("TEST_RESULT_NO", (String) params.get("testResultNo"));
	    model.put("SO_EXCHG_ID", (String) params.get("soExchgId"));
	    model.put("RCD_TMS", (String) params.get("rcdTms"));
	    model.put("AS_NO", params.get("as_No"));
	    model.put("AS_RESULT_NO", params.get("as_Result_No"));
	    model.put("DSC_CODE", (String) params.get("dsc_Code"));
	    model.put("STK_CODE", params.get("stk_Code"));
	    model.put("ASR_ITM_ID", (String) params.get("asr_Itm_Id"));
	    model.put("ASR_ITM_CODE", (String) params.get("asr_Itm_Code"));
	    model.put("ASR_ITM_DESC", (String) params.get("asr_Itm_Desc"));
	    params.put("testResultId", params.get("testResultId"));

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

	  @RequestMapping(value = "/newUsedPartReTestResultAdd.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> newUsedPartReTestResultAdd(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {
	    logger.debug("===========================/newUsedPartReTestResultAdd.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/newUsedPartReTestResultAdd.do===============================");

	    params.put("updator", sessionVO.getUserId());
	    ReturnMessage message = new ReturnMessage();

	    HashMap<String, Object> mp = new HashMap<String, Object>();
	    Map<?, ?> upMap = (Map<?, ?>) params.get("upResultM");
	    mp.put("serviceNo", upMap.get("AS_NO"));
	    mp.put("asrItmId", upMap.get("ASR_ITM_ID"));

	    params.put("asNo", upMap.get("AS_NO"));
	    params.put("asEntryId", upMap.get("AS_ENTRY_ID"));
	    params.put("asSoId", upMap.get("AS_SO_ID"));

	    int isReTestCnt = UsedPartReTestResultService.isReTestAlreadyResult_2(mp);
	    logger.debug("== isReTestCnt " + isReTestCnt);

	    if (isReTestCnt == 0) {
	      EgovMap rtnMap = UsedPartReTestResultService.usedPartReTestResult_insert(params);

	      message.setCode(AppConstants.SUCCESS);
	      message.setData(rtnMap.get("testResultNo"));
	      message.setMessage("");

	    } else {
	      message.setCode(AppConstants.FAIL);
	      message.setMessage("Used Part Return Test Result already exists with Complete Status.");
	    }

	    return ResponseEntity.ok(message);
	  }


	  @RequestMapping(value = "/editUsedPartReTestResult.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> editUsedPartReTestResult(@RequestBody Map<String, Object> params, Model model,
		      HttpServletRequest request, SessionVO sessionVO) {
		    logger.debug("===========================/editUsedPartReTestResult.do===============================");
		    logger.debug("== params " + params.toString());
		    logger.debug("===========================/editUsedPartReTestResult.do===============================");

		    params.put("updator", sessionVO.getUserId());
		    ReturnMessage message = new ReturnMessage();

		    EgovMap rtnMap = UsedPartReTestResultService.usedPartReTestResult_update(params);

		    message.setCode(AppConstants.SUCCESS);
		    message.setMessage("");

		    return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/usedPartNotTestedAdd.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> usedPartNotTestedAdd(@RequestBody Map<String, Object> params, Model model,
		      HttpServletRequest request, SessionVO sessionVO) {
		    logger.debug("===========================/usedPartNotTestedAdd.do===============================");
		    logger.debug("== params " + params.toString());
		    logger.debug("===========================/usedPartNotTestedAdd.do===============================");

		    params.put("updator", sessionVO.getUserId());
		    ReturnMessage message = new ReturnMessage();

		    EgovMap isReTestCnt = UsedPartReTestResultService.isReTestAlreadyResult(params);
		    logger.debug("== isReTestCnt " + isReTestCnt);

		    if (isReTestCnt == null) {
		      int rtnValue = UsedPartReTestResultService.usedPartNotTestedAdd(params);

		      if (rtnValue == 1) {
			    	message.setCode(AppConstants.SUCCESS);
			    	message.setMessage("");
			  } else {
			  		message.setCode(AppConstants.FAIL);
			  		message.setMessage("");
			  }

		    } else {
		      message.setCode(AppConstants.FAIL);
		      message.setData(isReTestCnt.get("asNo").toString());
		      message.setMessage("Used Part Return Test Result already exists.");
		    }

		    return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/selectCTList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCTList(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {
	    logger.debug("===========================/selectCTList.do===============================");
	    logger.debug("== params " + params.toString());
	    logger.debug("===========================/selectCTList.do===============================");

	    List<EgovMap> selectCTList = UsedPartReTestResultService.selectCTList(params);
	    logger.debug("selectCTList {}", selectCTList);
	    return ResponseEntity.ok(selectCTList);
	  }

	  @RequestMapping(value = "/getSpareFilterName.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> getSpareFilterName(@RequestParam Map<String, Object> params, HttpServletRequest request,
	      ModelMap model) {
	    List<EgovMap> spareFilterList = UsedPartReTestResultService.getSpareFilterList(params);
	    return ResponseEntity.ok(spareFilterList);
	  }



}
