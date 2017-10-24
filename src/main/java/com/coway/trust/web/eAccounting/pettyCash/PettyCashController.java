package com.coway.trust.web.eAccounting.pettyCash;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/pettyCash")
public class PettyCashController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);
	
	@Autowired
	private PettyCashService pettyCashService;
	
	@Value("${app.name}")
	private String appName;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private WebInvoiceService webInvoiceService;
	
	@RequestMapping(value = "/pettyCashCustodian.do")
	public String pettyCashCustodian(ModelMap model) {
		return "eAccounting/pettyCash/pettyCashCustodianManagement";
	}
	
	@RequestMapping(value = "/selectCustodianList.do")
	public ResponseEntity<List<EgovMap>> selectCustodianList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> custodianList = pettyCashService.selectCustodianList(params);
		
		return ResponseEntity.ok(custodianList);
	}
	
	@RequestMapping(value = "/newCustodianPop.do")
	public String newCustodianPop(ModelMap model, SessionVO session) {
		model.addAttribute("userId", session.getUserId());
		return "eAccounting/pettyCash/pettyCashNewCustodianPop";
	}
	
	@RequestMapping(value = "/selectUserNric.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectUserNric(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String memAccId = (String) params.get("memAccId");
		
		String userNric = pettyCashService.selectUserNric(memAccId);
		
		params.put("userNric", userNric);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/newCustodianRegistMsgPop";
	}
	
	@RequestMapping(value = "/insertCustodian.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCustodian(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		// TODO insert
		Map<String, Object> result = pettyCashService.insertCustodian(request, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/newCustodianCompletedMsgPop";
	}
	
	@RequestMapping(value = "/viewCustodianPop.do")
	public String viewCustodianPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap custodianInfo = pettyCashService.selectCustodianInfo(params);
		
		String atchFileGrpId = String.valueOf(custodianInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> custodianAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			model.addAttribute("attachmentList", custodianAttachList);
		}
		model.addAttribute("custodianInfo", custodianInfo);
		return "eAccounting/pettyCash/pettyCashViewEditCustodianPop";
	}
	
	@RequestMapping(value = "/viewRegistMsgPop.do")
	public String viewRegistMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/viewCustodianRegistMsgPop";
	}
	
	@RequestMapping(value = "/updateCustodian.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCustodian(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		// TODO update
		Map<String, Object> result = pettyCashService.updateCustodian(request, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/viewCompletedMsgPop.do")
	public String viewCompletedMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/viewCustodianCompletedMsgPop";
	}
	
	@RequestMapping(value = "/deleteRegistMsgPop.do")
	public String deleteRegistMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/deleteCustodianRegistMsgPop";
	}
	
	@RequestMapping(value = "/deleteCustodian.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteCustodian(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		// TODO delete
		pettyCashService.deleteCustodian(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/deleteCompletedMsgPop.do")
	public String deleteCompletedMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/deleteCustodianCompletedMsgPop";
	}
	
	@RequestMapping(value = "/pettyCashReqstAppv.do")
	public String requestPettyCash(ModelMap model) {
		return "eAccounting/pettyCash/requestPettyCash";
	}
	
	@RequestMapping(value = "/selectRequestList.do")
	public ResponseEntity<List<EgovMap>> selectRequestList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
		
		params.put("appvPrcssStus", appvPrcssStus);
		
		List<EgovMap> requestList = pettyCashService.selectRequestList(params);
		
		return ResponseEntity.ok(requestList);
	}
	
	@RequestMapping(value = "/newRequestPop.do")
	public String newRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("userId", session.getUserId());
		return "eAccounting/pettyCash/newRequestPettyCashPop";
	}
	
	@RequestMapping(value = "/selectCustodianInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectCustodianInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap custodianInfo = pettyCashService.selectCustodianInfo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(custodianInfo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertPettyCashReqst.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertPettyCashReqst(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		// TODO insert
		Map<String, Object> result = pettyCashService.insertPettyCashReqst(request, params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/pettyCash/approveLinePop";
	}
	
	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		// TODO
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/reqstCompletedMsgPop.do")
	public String reqstCompletedMsgPop(ModelMap model) {
		return "eAccounting/pettyCash/reqstCompletedMsgPop";
	}
	
	@RequestMapping(value = "/viewRequestPop.do")
	public String viewRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap requestInfo = pettyCashService.selectRequestInfo(params);
		
		String atchFileGrpId = String.valueOf(requestInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if(atchFileGrpId != "null") {
			List<EgovMap> requestAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
			model.addAttribute("attachmentList", requestAttachList);
		}
		model.addAttribute("requestInfo", requestInfo);
		model.addAttribute("callType", params.get("callType"));
		return "eAccounting/pettyCash/viewRequestPettyCashPop";
	}
	
	
	
	
}
