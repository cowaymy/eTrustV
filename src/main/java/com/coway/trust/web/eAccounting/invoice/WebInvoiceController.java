package com.coway.trust.web.eAccounting.invoice;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
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
	
//	@Value("${eAccounting.webInvoice}")
//	private String fileViewPath;
	
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
	
	@RequestMapping(value = "/approve.do")
	public String approve(ModelMap model) {
		return "eAccounting/webInvoice/webInvoiceApprove";
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
	
	@RequestMapping(value = "/expenseTypeSearchPop.do")
	public String expenseTypeSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("rowIndex", params.get("rowIndex"));
		
		return "eAccounting/webInvoice/expenseTypeSearchPop";
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
		int atchFileGrpId = Integer.valueOf(String.valueOf(webInvoiceInfo.get("atchFileGrpId")));
		List<EgovMap> webInvoiceAttachList = webInvoiceService.selectWebInvoiceAttachList(atchFileGrpId);
		
		model.addAttribute("webInvoiceInfo", webInvoiceInfo);
		model.addAttribute("gridDataList", webInvoiceItems);
		model.addAttribute("attachmentList", webInvoiceAttachList);
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		
		return "eAccounting/webInvoice/viewEditWebInvoicePop";
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model, SessionVO sessionVO) {
		return "eAccounting/webInvoice/approveLinePop";
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
	
	@RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestBody Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(params);
//		fileInfo.put("fileViewPath", fileViewPath);
		
		return ResponseEntity.ok(fileInfo);
	}
	
	@RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> sampleUploadCommon(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"eAccounting" + File.separator + "webInvoice", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		fileApplication.businessAttach(AppConstants.FILE_WEB, FileVO.createList(list), params);
		
		params.put("attachment", list);
		
		return ResponseEntity.ok(params);
	}
	
	@RequestMapping(value = "/insertWebInvoiceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertWebInvoiceInfo(@RequestBody Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String clmNo = webInvoiceService.selectNextClmNo();
		params.put("clmNo", clmNo);
		
		webInvoiceService.insertWebInvoiceInfo(params);
		
		return ResponseEntity.ok(params);
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
				int clmSeq = webInvoiceService.selectNextClmSeq();
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

}
