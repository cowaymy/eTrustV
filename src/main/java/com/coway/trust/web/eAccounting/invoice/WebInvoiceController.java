package com.coway.trust.web.eAccounting.invoice;

import java.io.File;
import java.util.List;
import java.util.Map;

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
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;

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

	@RequestMapping(value = "/supplierSearchPop.do")
	public String supplierSearchPop(ModelMap model) {
		return "eAccounting/webInvoice/memberAccountSearchPop";
	}
	
	@RequestMapping(value = "/costCenterSearchPop.do")
	public String costCenterSearchPop(ModelMap model) {
		return "eAccounting/webInvoice/costCenterSearchPop";
	}
	
	@RequestMapping(value = "/expenseTypeSearchPop.do")
	public String expenseTypeSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("rowIndex", params.get("rowIndex"));
		
		return "eAccounting/webInvoice/expenseTypeSearchPop";
	}
	
	@RequestMapping(value = "/newWebInvoicePop.do")
	public String newWebInvoice(ModelMap model, SessionVO sessionVO) {
		model.addAttribute("userId", sessionVO.getUserId());
		
		return "eAccounting/webInvoice/newWebInvoicePop";
	}
	
	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model, SessionVO sessionVO) {
		return "eAccounting/webInvoice/approveLinePop";
	}
	
	@RequestMapping(value = "/selectSupplier.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectSupplier(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = webInvoiceService.selectSupplier(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectCostCenter.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectcostCenter(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = webInvoiceService.selectCostCenter(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectTextCodeWebInvoiceFlag.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectTextCodeWebInvoiceFlag(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = webInvoiceService.selectTextCodeWebInvoiceFlag();
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/selectWebInvoiceList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectWebInvoiceList(@RequestParam Map<String, Object> params, ModelMap model) {
//		List<EgovMap> list = webInvoiceService.selectSampleList(params);
		
//		return ResponseEntity.ok(list);
		return null;
	}
	
	@RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovFormBasedFileVo>> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				"eAccounting" + File.separator + "webInvoice", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		String param = (String) params.get("file");
		LOGGER.debug("param : {}", param);
		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
//		fileApplication.businessAttach(AppConstants.FILE_WEB, FileVO.createList(list), params);
//		
//		int fileGroupKey = (int) params.get("fileGroupKey");
//		
//		System.out.println("fileGroupKey ===============> " + fileGroupKey);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/tempSave.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> tempSave(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		String clmNo = webInvoiceService.selectNextClmNo();
		params.put("clmNo", clmNo);
		
		webInvoiceService.insertWebInvoiceByMap(params);
//		return ResponseEntity.ok(list);
		return null;
	}

}
