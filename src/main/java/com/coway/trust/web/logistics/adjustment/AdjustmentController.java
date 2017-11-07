package com.coway.trust.web.logistics.adjustment;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.coway.trust.biz.common.type.FileType;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.logistics.adjustment.AdjustmentService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/adjustment")
public class AdjustmentController {
	private static final Logger logger = LoggerFactory.getLogger(AdjustmentController.class);

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private FileApplication fileApplication;

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

	@RequestMapping(value = "/AdjustmentApprovalList.do", method = RequestMethod.POST)
	public String AdjustmentApprovalList(@RequestParam Map<String, Object> params, Model model,
			HttpServletRequest request, HttpServletResponse response) {
		String rAdjcode = String.valueOf(params.get("rAdjcode"));
		// String rAdjlocId = String.valueOf(params.get("rAdjlocId"));
		// logger.debug("rAdjcode : {} ", rAdjcode);

		model.addAttribute("rAdjcode", rAdjcode);
		// model.addAttribute("rAdjlocId", rAdjlocId);
		return "logistics/adjustment/adjustmentView";
	}

	@RequestMapping(value = "/AdjustmentApprovalSteps.do", method = RequestMethod.POST)
	public String AdjustmentApprovalSteps(@RequestParam Map<String, Object> params, Model model,
			HttpServletRequest request, HttpServletResponse response) {
		String rAdjcode = String.valueOf(params.get("rAdjcode"));
		// String rAdjlocId = String.valueOf(params.get("rAdjlocId"));
		// logger.debug("rAdjcode : {} ", rAdjcode);

		model.addAttribute("rAdjcode", rAdjcode);
		// model.addAttribute("rAdjlocId", rAdjlocId);
		return "logistics/adjustment/adjustmentApproval";
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

		String adjNo=adjustmentService.insertNewAdjustment(params);
		
		logger.info("adjNo : {} ", adjNo);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(adjNo);
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
		logger.debug("srchcdc : {} ", params.get("srchcdc"));
		logger.debug("srchcdcrdc : {} ", params.get("srchcdcrdc"));
		logger.debug("srchcody : {} ", params.get("srchcody"));
		logger.debug("srchct : {} ", params.get("srchct"));
		logger.debug("srchrdc : {} ", params.get("srchrdc"));
		List<Object> locList = new ArrayList<Object>();
		if ("" != params.get("srchcdc") & null != params.get("srchcdc")) {
			locList.add((params.get("srchcdc")));
		}
		if ("" != params.get("srchcdcrdc") & null != params.get("srchcdcrdc")) {
			locList.add((params.get("srchcdcrdc")));
		}
		if ("" != params.get("srchcody") & null != params.get("srchcody")) {
			locList.add((params.get("srchcody")));
		}
		if ("" != params.get("srchct") & null != params.get("srchct")) {
			locList.add((params.get("srchct")));
		}
		if ("" != params.get("srchrdc") & null != params.get("srchrdc")) {
			locList.add((params.get("srchrdc")));
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
		logger.debug("srchcdcrdc : {} ", formMap.get("srchcdcrdc"));
		logger.debug("srchcody : {} ", formMap.get("srchcody"));
		logger.debug("srchct : {} ", formMap.get("srchct"));
		if ("" != formMap.get("srchcdc") & null != formMap.get("srchcdc")) {
			locList.add((formMap.get("srchcdc")));
		}
		if ("" != formMap.get("srchcdcrdc") & null != formMap.get("srchcdcrdc")) {
			locList.add((formMap.get("srchcdcrdc")));
		}
		if ("" != formMap.get("srchcody") & null != formMap.get("srchcody")) {
			locList.add((formMap.get("srchcody")));
		}
		if ("" != formMap.get("srchct") & null != formMap.get("srchct")) {
			locList.add((formMap.get("srchct")));
		}
		if ("" != formMap.get("srchrdc") & null != formMap.get("srchrdc")) {
			locList.add((formMap.get("srchrdc")));
		}
		params.put("locList", locList);

		logger.info("locList : {} ", locList.toString());
		List<EgovMap> reslist = adjustmentService.selectAdjustmentLocationList(params);
		List<EgovMap> reqlist = adjustmentService.selectAdjustmentLocationReqList(params);
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

	@RequestMapping(value = "/adjustmentConfirmCheck.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> adjustmentConfirmCheck(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		logger.debug("adjLocation : {}", params.get("adjLocation"));
		List<EgovMap> list = adjustmentService.selectAdjustmentConfirmCheck(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentConfirm.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> adjustmentConfirm(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		logger.debug("adjLocation : {}", params.get("adjLocation"));
		int cnt = adjustmentService.updateSaveYn(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(cnt);
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

	@RequestMapping(value = "/saveExcelGrid.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveExcelGrid(@RequestBody Map<String, Object> params, Model model) {

		// logger.info("params : {} ", params.toString());
		// params.forEach(obj -> {
		// LOGGER.debug("Product : {}", ((Map<String, Object>) obj).get("Product"));
		// LOGGER.debug("Price : {}", ((Map<String, Object>) obj).get("Price"));
		// });

		// 결과 만들기 예.
		adjustmentService.insertExcel(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/adjustmentApprovalList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> adjustmentApprovalList(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		logger.debug("adjLocation : {}", params.get("adjLocation"));
		List<EgovMap> dataList = adjustmentService.selectAdjustmentApproval(params);
		List<EgovMap> cnt = adjustmentService.selectAdjustmentApprovalCnt(params);
		// ReturnMessage message = new ReturnMessage();
		// message.setCode(AppConstants.SUCCESS);
		// message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("dataList", dataList);
		map.put("cnt", cnt);
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/adjustmentApprovalLineCheck.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> adjustmentApprovalLineCheck(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		logger.debug("adjLocation : {}", params.get("adjLocation"));
		List<EgovMap> dataList = adjustmentService.selectAdjustmentApprovalLineCheck(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/ApprovalUpdate.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> ApprovalUpadate(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		logger.debug("status : {}", params.get("status"));
		adjustmentService.updateApproval(params);
		List<EgovMap> dataList = adjustmentService.selectAdjustmentApprovalLineCheck(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/closeAudit.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> closeAudit(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		adjustmentService.updateAuditToClose(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectInsertSerialCount.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectInsertSerialCount(@RequestParam Map<String, Object> params) {
		logger.debug("adjNo : {}", params.get("adjNo"));
		logger.debug("status : {}", params.get("status"));
		int data = adjustmentService.selectInsertSerialCount(params);
		// params.put("cntQty", data);
		// adjustmentService.insertAdjustmentLocCount(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(data);
		return ResponseEntity.ok(message);
	}

	/**
	 * 공통 파일 테이블 사용 Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/pdfUpload.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovFormBasedFileVo>> pdfUpload(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"logitics" + File.separator + "stock_Audit", AppConstants.UPLOAD_MAX_FILE_SIZE);

		String invntryNo = (String) params.get("adjNo");
		int loginId = sessionVO.getUserId();
		// TODO USER OPERATING SETTING
		String program = "TEST";
		logger.debug("param01 : {}", invntryNo);
		logger.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		Map<String, Object> setmap = new HashMap();
		setmap.put("fileName", list.get(0).getFileName());
		setmap.put("physicalName", list.get(0).getPhysicalName());
		setmap.put("serverPath", list.get(0).getServerPath());
		setmap.put("invntryNo", invntryNo);
		setmap.put("loginId", loginId);
		setmap.put("program", program);
		adjustmentService.updateDoc(setmap);
		adjustmentService.updateStock(setmap);
		return ResponseEntity.ok(list);
	}
}
