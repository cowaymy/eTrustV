package com.coway.trust.web.logistics.adjustment;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.adjustment.AdjustmentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/adjustment")
public class AdjustmentController {
	private static final Logger logger = LoggerFactory.getLogger(AdjustmentController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "adjustmentService")
	private AdjustmentService adjustmentService;

	@RequestMapping(value = "/NewAdjustment.do")
	public String NewAdjustment(@RequestParam Map<String, Object> params) {
		return "logistics/adjustment/adjustmentNew";
	}

	@RequestMapping(value = "/AdjustmentRegisterView.do", method = RequestMethod.POST)
	public String AdjustmentRegisterView(@RequestParam Map<String, Object> params, Model model,
			HttpServletRequest request, HttpServletResponse response) {
		// String rAdjcode = request.getParameter("rAdjcode");
		String rAdjcode = String.valueOf(params.get("rAdjcode"));
		String rStatus = String.valueOf(params.get("rStatus"));
		logger.debug("rAdjcode : {} ", rAdjcode);

		model.addAttribute("rAdjcode", rAdjcode);
		model.addAttribute("rStatus", rStatus);
		return "logistics/adjustment/adjustmentRegister";
	}

	@RequestMapping(value = "/AdjustmentCounting.do", method = RequestMethod.POST)
	public String AdjustmentCounting(@RequestParam Map<String, Object> params, Model model, HttpServletRequest request,
			HttpServletResponse response) {
		String rAdjcode = String.valueOf(params.get("rAdjcode"));
		String rAdjlocId = String.valueOf(params.get("rAdjlocId"));
		// logger.debug("rAdjcode : {} ", rAdjcode);

		model.addAttribute("rAdjcode", rAdjcode);
		model.addAttribute("rAdjlocId", rAdjlocId);
		return "logistics/adjustment/adjustmentCounting";
	}

	@RequestMapping(value = "/NewAdjustmentRe.do", method = RequestMethod.POST)
	public String NewAdjustmentRe(@RequestParam Map<String, Object> params, Model model, HttpServletRequest request,
			HttpServletResponse response) {
		// String rAdjcode = request.getParameter("rAdjcode");
		String retnVal = String.valueOf(params.get("retnVal"));
		// String rStatus = String.valueOf(params.get("rStatus"));
		logger.debug("retnVal : {} ", retnVal);

		model.addAttribute("retnVal", retnVal);
		// model.addAttribute("rStatus", rStatus);
		return "logistics/adjustment/adjustmentNew";
	}

	@RequestMapping(value = "/AdjustmentRegister.do", method = RequestMethod.POST)
	public String AdjustmentRegister(@RequestParam Map<String, Object> params, Model model, HttpServletRequest request,
			HttpServletResponse response) {
		// String rAdjcode = request.getParameter("rAdjcode");
		String rAdjcode = String.valueOf(params.get("rAdjcode"));
		return "logistics/adjustment/adjustmentRegister";
	}

	@RequestMapping(value = "/createAdjustment.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> createAdjustment(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		// branch = sessionVO.getBranchName();
		// String close = "";
		int loginId = sessionVO.getUserId();

		logger.info("eventtype : {} ", params.get("eventtype"));
		params.put("loginId", loginId);

		adjustmentService.insertNewAdjustment(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> adjustmentList(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		logger.debug("adjNo : {} ", params);
		List<EgovMap> list = adjustmentService.selectAdjustmentList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/oneAdjustmentNo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> oneAdjustmentNo(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		logger.debug("adjNo : {} ", params.get("adjNo"));
		List<EgovMap> list = adjustmentService.selectAdjustmentList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentLocationList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> adjustmentLocationList(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		logger.debug("adsrchcdcjNo : {} ", params.get("srchcdc"));
		logger.debug("srchrdc : {} ", params.get("srchrdc"));
		logger.debug("srchctcd : {} ", params.get("srchctcd"));
		List<Object> locList = new ArrayList<Object>();
		if ("" != params.get("srchcdc") & null != params.get("srchcdc")) {
			locList.add((params.get("srchcdc")));
		}
		if ("" != params.get("srchrdc") & null != params.get("srchrdc")) {
			locList.add((params.get("srchrdc")));
		}
		if ("" != params.get("srchctcd") & null != params.get("srchctcd")) {
			locList.add((params.get("srchctcd")));
		}
		params.put("locList", locList);

		logger.info("locList : {} ", locList.toString());
		List<EgovMap> list = adjustmentService.selectAdjustmentLocationList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentLocationListView.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> adjustmentLocationListView(@RequestBody Map<String, Object> params,
			Model model, SessionVO sessionVO) throws Exception {
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> locList = new ArrayList<Object>();
		logger.debug("adsrchcdcjNo : {} ", formMap.get("srchcdc"));
		logger.debug("srchrdc : {} ", formMap.get("srchrdc"));
		logger.debug("srchctcd : {} ", formMap.get("srchctcd"));
		if ("" != formMap.get("srchcdc") & null != formMap.get("srchcdc")) {
			locList.add((formMap.get("srchcdc")));
		}
		if ("" != formMap.get("srchrdc") & null != formMap.get("srchrdc")) {
			locList.add((formMap.get("srchrdc")));
		}
		if ("" != formMap.get("srchctcd") & null != formMap.get("srchctcd")) {
			locList.add((formMap.get("srchctcd")));
		}
		params.put("locList", locList);

		logger.info("locList : {} ", locList.toString());
		List<EgovMap> reslist = adjustmentService.selectAdjustmentLocationList(params);
		List<EgovMap> reqlist = adjustmentService.selectAdjustmentLocationReqList(params);
		// ReturnMessage message = new ReturnMessage();
		// message.setCode(AppConstants.SUCCESS);
		// message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		// return ResponseEntity.ok(message);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("reslist", reslist);
		map.put("reqlist", reqlist);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/checkAdjustmentNo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkAdjustmentNo(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		logger.debug("invntryNo : {} ", params.get("invntryNo"));
		int cnt = adjustmentService.selectAdjustmentNo(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(cnt);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> checkSerial(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		List<EgovMap> list = adjustmentService.selectCheckSerial(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentDetailLoc.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> adjustmentDetailLoc(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		logger.debug("invntryNo : {} ", params.get("invntryNo"));
		List<EgovMap> list = adjustmentService.selectAdjustmentDetailLoc(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = adjustmentService.selectCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/adjustmentAuto.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> adjustmentAuto(@RequestParam Map<String, Object> params) {

		logger.debug("invntryNo : {}", params.get("invntryNo"));
		logger.debug("autoFlag : {}", params.get("autoFlag"));
		logger.debug("eventType : {}", params.get("eventType"));
		logger.debug("itmType : {}", params.get("itmType"));

		String tmp = String.valueOf(params.get("eventType"));
		List<Object> eventList = Arrays.asList(tmp.split(","));
		String tmp2 = String.valueOf(params.get("itmType"));
		List<Object> itemList = Arrays.asList(tmp2.split(","));

		params.put("eventList", eventList);
		params.put("itemList", itemList);

		logger.info("eventList : {}", eventList.toString());
		logger.info("itemList : {}", itemList.toString());

		adjustmentService.insertAdjustmentLocAuto(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setData(cnt);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentCountingDetail.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> adjustmentCountingDetail(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		logger.debug("adjLocation : {}", params.get("adjLocation"));
		List<EgovMap> list = adjustmentService.selectAdjustmentCountingDetail(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentLocManual.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> adjustmentLocSave(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		// Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		adjustmentService.insertAdjustmentLocManual(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentSerialSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> adjustmentSerialSave(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		// Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		int loginId = sessionVO.getUserId();

		logger.info("eventtype : {} ", params.get("eventtype"));
		params.put("loginId", loginId);
		adjustmentService.insertAdjustmentLocSerial(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentLocCount.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> adjustmentLocCount(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		// Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		int loginId = sessionVO.getUserId();

		params.put("loginId", loginId);
		adjustmentService.insertAdjustmentLocCount(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
}
