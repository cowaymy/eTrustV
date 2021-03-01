package com.coway.trust.web.services.ecom;

import java.io.File;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.ecom.CpeService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*******************************************************************
 * DATE 				PIC 	  		COMMENT
 * 17/02/2021 	YONGJH 		- Initial creation
 *******************************************************************/

@Controller
@RequestMapping(value = "/services/ecom")
public class CpeController {

	private static final Logger logger = LoggerFactory.getLogger(CpeController.class);

	@Resource(name = "cpeService")
	private CpeService cpeService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/cpe.do")
	public String viewCpe(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);

		List<EgovMap> cpeStat = cpeService.getCpeStat(params);
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
						SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		model.addAttribute("cpeStat", cpeStat);

		return "services/ecom/cpeList";
	}

	@RequestMapping(value = "/selectMainDept.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getMainDeptList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> mainDeptList = cpeService.getMainDeptList();
		return ResponseEntity.ok(mainDeptList);
	}

	@RequestMapping(value = "/selectSubDept.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSubDept(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> subDeptList = cpeService.getSubDeptList(params);
		return ResponseEntity.ok(subDeptList);
	}

	@RequestMapping(value = "/cpeRequest.do")
	public String cpeRequest(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("In CPE Request");
		logger.debug("Params: " + params.toString());

		return "services/ecom/cpeRequestNewSearchPop";

	}

	@RequestMapping(value = "/searchOrderNoPop.do")
	public String searchOrderNoPopCpe(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "services/ecom/cpeSearchOrderNoPop";
	}

	@RequestMapping(value = "/selectSearchOrderNo")
	public ResponseEntity<List<EgovMap>> selectSearchOrderNo (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{

		List<EgovMap> ordList = null;

		String appType [] = request.getParameterValues("searchOrdAppType");

		params.put("appType", appType);

		ordList = cpeService.selectSearchOrderNo(params);

		return ResponseEntity.ok(ordList);
	}

	@RequestMapping(value = "/getOrderId", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOrderId(@RequestParam Map<String, Object> params) throws Exception{

		EgovMap resultMap = null;
		//서비스
		resultMap = cpeService.getOrderId(params);

		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/cpeNewSearchResultPop.do", method = RequestMethod.POST)
	public String cpeNewSearchResultPop (@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);

        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
        List<EgovMap> mainDeptList = cpeService.getMainDeptList();

		model.put("orderDetail", orderDetail);
		model.addAttribute("mainDeptList", mainDeptList);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));

		return "services/ecom/cpeNewSearchResultPop";
	}

	@RequestMapping(value = "/selectRequestTypeJsonList")
	public ResponseEntity<List<EgovMap>> selectRequestTypeJsonList() throws Exception{

		logger.info("################## Call RequestType List (Combo Box) ##################");

		List<EgovMap> requestType = null;

		requestType = cpeService.selectRequestType();

		return ResponseEntity.ok(requestType);
	}

	@RequestMapping(value = "/selectSubRequestTypeJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSubRequestType(@RequestParam Map<String, Object> params, HttpServletRequest request,
	    ModelMap model) {

		List<EgovMap> subRequestTypeList = cpeService.getSubRequestTypeList(params);
	    return ResponseEntity.ok(subRequestTypeList);
	}

	@RequestMapping(value = "/cpeReqstApproveLinePop.do")
	public String cpeReqstApproveLinePop(ModelMap model) {
		return "services/ecom/cpeReqstApproveLinePop";
	}

	@RequestMapping(value = "/cpeReqstCompletedMsgPop.do")
	public String reqstCompletedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("cpeReqId", params.get("cpeReqId"));
		return "services/ecom/cpeReqstCompletedMsgPop";
	}

	@RequestMapping(value = "/cpeReqstApproveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> cpeReqstApproveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model,
	    SessionVO sessionVO) {

	    String appvPrcssNo = cpeService.selectNextCpeAppvPrcssNo();
	    params.put("appvPrcssNo", appvPrcssNo);
	    params.put(CommonConstants.USER_ID, sessionVO.getUserId());
	    params.put("userName", sessionVO.getUserName());

	    logger.debug("cpeReqstApproveLineSubmit ==========================>>  " + params);

	    cpeService.insertCpeRqstApproveMgmt(params);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setData(params);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    return ResponseEntity.ok(message);
	  }

	@RequestMapping(value = "/insertCpeReqst.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCpeReqst(@RequestBody Map<String, Object> params, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		logger.debug("insertCpeReqst =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

        int cpeReqId = cpeService.selectNextCpeId();
		params.put("cpeReqId", cpeReqId);
		cpeService.insertCpeReqst(params);

		int activeStatusForNew = 1;
		params.put("status", activeStatusForNew);
		cpeService.insertCpeReqstDetail(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectCpeRequestList", method = RequestMethod.GET )
	public ResponseEntity<List<EgovMap>> selectCpeRequestList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		logger.debug("selectCpeRequestList==========================>> " + params);
		List<EgovMap> cpeRequestList = cpeService.selectCpeRequestList(params);
		return ResponseEntity.ok(cpeRequestList);
	}

	@RequestMapping(value = "/cpeRqstUpdateApprovePop.do")
	public String cpeRequestUpdateApprove(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		logger.debug("params =====================================>>  " + params);

		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);

        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		model.put("orderDetail", orderDetail);

		EgovMap requestInfo = cpeService.selectRequestInfo(params);
		model.addAttribute("requestInfo", requestInfo);

		List<EgovMap> cpeStat = cpeService.getCpeStat(params);
		model.addAttribute("cpeStat", cpeStat);

        List<EgovMap> mainDeptList = cpeService.getMainDeptList();
		model.addAttribute("mainDeptList", mainDeptList);

		String approverList = cpeService.getApproverList(params);
		model.addAttribute("approverList", approverList);

		return "services/ecom/cpeRqstUpdateApprovePop";
	}

	@RequestMapping(value = "/selectCpeDetailList", method = RequestMethod.GET )
	public ResponseEntity<List<EgovMap>> selectCpeDetailList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		logger.debug("selectCpeDetailList==========================>> " + params);
		List<EgovMap> cpeDetailList = cpeService.selectCpeDetailList(params);
		return ResponseEntity.ok(cpeDetailList);
	}

	@RequestMapping(value = "/updateCpeStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCpeStatus(@RequestBody Map<String, Object> params, HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

		logger.debug("updateCpeStatus====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		params.put("userFullname", sessionVO.getUserFullname());

		cpeService.insertCpeReqstDetail(params); //insert new status record for CPE
		cpeService.updateCpeStatusMain(params);  //update main table with latest status for CPE

		if (params.get("approvalRequired").equals("1") &&
				(params.get("status").equals("5") || params.get("status").equals("6"))) {
			cpeService.sendNotificationEmail(params); //send email to notify about request approval/rejection
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
