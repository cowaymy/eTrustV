package com.coway.trust.web.eAccounting.invoice;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.apache.commons.lang3.StringUtils;
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
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/webInvoice")
public class WebInvoiceController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(WebInvoiceController.class);
	
	@Autowired
	private WebInvoiceService webInvoiceService;
	
	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;
	
	@Value("${eAccounting.webInvoice}")
	private String fileViewPath;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileApplication fileApplication;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/webInvoice.do")
	public String webInvoice(ModelMap model) {
		return "eAccounting/webInvoice/webInvoice";
	}
	
	@RequestMapping(value = "/selectAppvPrcssStus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAppvPrcssStus(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		//List<EgovMap> statusList = webInvoiceService.selectAppvPrcssStus(params);
		//return ResponseEntity.ok(statusList);
		return null;
	}
	
	@RequestMapping(value = "/supplierSearchPop.do")
	public String supplierSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("params", params);
		return "eAccounting/webInvoice/memberAccountSearchPop";
	}
	
	@RequestMapping(value = "/costCenterSearchPop.do")
	public String costCenterSearchPop(ModelMap model) {
		return "eAccounting/webInvoice/costCenterSearchPop";
	}
	
	@RequestMapping(value = "/newWebInvoicePop.do")
	public String newWebInvoice(ModelMap model, SessionVO sessionVO) {
		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();
		
		model.addAttribute("userId", sessionVO.getUserId());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		
		return "eAccounting/webInvoice/newWebInvoicePop";
	}
	
	@RequestMapping(value = "/viewEditWebInvoicePop.do")
	public String viewEditWebInvoice(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();
		String clmNo = (String)params.get("clmNo");
		EgovMap webInvoiceInfo = webInvoiceService.selectWebInvoiceInfo(clmNo);
		List<EgovMap> webInvoiceItems = webInvoiceService.selectWebInvoiceItems(clmNo);
		String atchFileGrpId = String.valueOf(webInvoiceInfo.get("atchFileGrpId"));
		List<EgovMap> webInvoiceAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
		
		model.addAttribute("webInvoiceInfo", webInvoiceInfo);
		model.addAttribute("gridDataList", webInvoiceItems);
		model.addAttribute("attachmentList", webInvoiceAttachList);
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		
		return "eAccounting/webInvoice/viewEditWebInvoicePop";
	}
	
	@RequestMapping(value = "/webInvoiceAppvViewPop.do")
	public String webInvoiceAppvViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String appvPrcssNo = (String)params.get("appvPrcssNo");
		List<EgovMap> appvInfoAndItems = webInvoiceService.selectAppvInfoAndItems(appvPrcssNo);
		
		model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));
		
		return "eAccounting/webInvoice/webInvoiceApproveViewPop";
	}
	
	@RequestMapping(value = "/fileListPop.do")
	public String fileListPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String atchFileGrpId = (String) params.get("atchFileGrpId");
		List<EgovMap> attachList = webInvoiceService.selectAttachList(atchFileGrpId);
		
		model.addAttribute("attachList", attachList);
		
		return "eAccounting/webInvoice/attachmentFileViewPop";
	}
	
	@RequestMapping(value = "/approveRegistPop.do")
	public String approveRegistPop(ModelMap model) {
		return "eAccounting/webInvoice/approvalOfWebInvoiceRegistMsgPop";
	}
	
	@RequestMapping(value = "/rejectRegistPop.do")
	public String rejectRegistPop(ModelMap model) {
		return "eAccounting/webInvoice/rejectionOfWebInvoiceRegistMsgPop";
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/webInvoice/approveLinePop";
	}
	
	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model) {
		return "eAccounting/webInvoice/newWebInvoiceRegistMsgPop";
	}
	
	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(ModelMap model) {
		return "eAccounting/webInvoice/newWebInvoiceCompletedMsgPop";
	}
	
	@RequestMapping(value = "/selectSupplier.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSupplier(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = webInvoiceService.selectSupplier(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectCostCenter.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectcostCenter(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> list = webInvoiceService.selectCostCenter(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectWebInvoiceList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWebInvoiceList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> list = webInvoiceService.selectWebInvoiceList(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectApproveList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectApproveList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		List<EgovMap> list = webInvoiceService.selectApproveList(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(params);
		fileInfo.put("fileViewPath", fileViewPath);
		
		return ResponseEntity.ok(fileInfo);
	}
	
	@RequestMapping(value = "/insertWebInvoiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertWebInvoiceInfo(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"eAccounting" + File.separator + "webInvoice", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			fileApplication.businessAttach(AppConstants.FILE_WEB, FileVO.createList(list), params);
		}
		
		String clmNo = webInvoiceService.selectNextClmNo();
		params.put("clmNo", clmNo);
		params.put("attachment", list);
		
		webInvoiceService.insertWebInvoiceInfo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/saveGridInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveGridInfo(@RequestBody Map<String, ArrayList<Object>> params, @RequestParam Map<String, Object> queryString, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		LOGGER.debug("queryString =====================================>>  " + queryString);
		
		String clmNo = (String) queryString.get("clmNo");
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // 추가 리스트 얻기
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); // 수정 리스트 얻기
		List<Object> removeList = params.get(AppConstants.AUIGRID_REMOVE); // 제거 리스트 얻기
		
		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", clmNo);
				int clmSeq = webInvoiceService.selectNextClmSeq(clmNo);
				hm.put("clmSeq", clmSeq);
				hm.put("userId", sessionVO.getUserId());
				webInvoiceService.insertWebInvoiceDetail(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			
			// 테스트를 위한 로그 출력
			updateList.forEach(obj -> {
				Map<String, Object> test = (Map<String, Object>) obj;
				test.put("clmNo", clmNo);
				test.put("userId", sessionVO.getUserId());
				LOGGER.debug("====================== update 시작 =====================");
				for(String key : test.keySet()) {
					LOGGER.debug("key : " + key + "=============> value : " + test.get(key));
				}
				LOGGER.debug("====================== update 종료 =====================");
							
			});
			
//			for (Object map : updateList) {
//				hm = (HashMap<String, Object>) map;
//				hm.put("clmNo", clmNo);
//				hm.put("userId", sessionVO.getUserId());
//				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
//			}
		}
		if (removeList.size() > 0) {
			Map hm = null;
			
			// 테스트를 위한 로그 출력
			removeList.forEach(obj -> {
				Map<String, Object> test = (Map<String, Object>) obj;
				test.put("clmNo", clmNo);
				test.put("userId", sessionVO.getUserId());
				LOGGER.debug("====================== remove 시작 =====================");
				for(String key : test.keySet()) {
					LOGGER.debug("key : " + key + "=============> value : " + test.get(key));
				}
				LOGGER.debug("====================== remove 종료 =====================");
							
			});
			
//			for (Object map : removeList) {
//				hm = (HashMap<String, Object>) map;
//				hm.put("clmNo", clmNo);
//				hm.put("userId", sessionVO.getUserId());
//				// TODO biz처리 (clmNo, clmSeq 값으로 delete 처리)
//			}
		}
		
		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
		LOGGER.info("삭제 : {}", removeList.toString());
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateWebInvoiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateWebInvoiceInfo(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put("userId", sessionVO.getUserId());
		//webInvoiceService.updateWebInvoiceInfo(params);
		
		return ResponseEntity.ok(params);
	}
	
	@RequestMapping(value = "/webInvoiceApprove.do")
	public String approve(ModelMap model) {
		return "eAccounting/webInvoice/webInvoiceApprove";
	}
	
	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");
		
		String appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		String clmNo = (String) params.get("clmNo");
		// 신규 상태에서 submit이면 clmNo = null or ""
		if(StringUtils.isEmpty(clmNo)) {
			clmNo = webInvoiceService.selectNextClmNo();
			params.put("clmNo", clmNo);
		}
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		params.put("appvLineCnt", apprGridList.size());
		
		// TODO appvLineMasterTable Insert
		webInvoiceService.insertApproveManagement(params);
		
		if (apprGridList.size() > 0) {
			Map hm = null;
			
			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", appvPrcssNo);
				hm.put(CommonConstants.USER_ID, params.get(CommonConstants.USER_ID));
				params.put("userName", params.get("userName"));
				// TODO appvLineDetailTable Insert
				webInvoiceService.insertApproveLineDetail(hm);
			}
		}
		
		if (newGridList.size() > 0) {
			Map hm = null;
			
			// biz처리
			for (Object map : newGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", appvPrcssNo);
				int appvItmSeq = webInvoiceService.selectNextClmSeq(appvPrcssNo);
				hm.put("appvItmSeq", appvItmSeq);
				hm.put("invcNo", params.get("invcNo"));
				hm.put("invcDt", params.get("invcDt"));
				hm.put("invcType", params.get("invcType"));
				hm.put("memAccId", params.get("memAccId"));
				hm.put("payDueDt", params.get("payDueDt"));
				hm.put("costCentr", params.get("costCentr"));
				hm.put("costCentrName", params.get("costCentrName"));
				hm.put("atchFileGrpId", params.get("atchFileGrpId"));
				hm.put("userName", params.get("userName"));
				// TODO TODO appvLineItemsTable Insert
				webInvoiceService.insertApproveItems(hm);
			}
		}
		
		webInvoiceService.updateAppvPrcssNo(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
}
