package com.coway.trust.web.eAccounting.contract;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.contract.ContractService;
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashApplication;
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceApplication;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.misc.voucher.VoucherService;
import com.coway.trust.biz.misc.voucher.VoucherUploadVO;
import com.coway.trust.biz.payment.payment.service.BatchPaymentVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.coway.trust.config.csv.CsvReadComponent;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/contract")
public class ContractController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ContractController.class);

	@Autowired
	private ContractService contractService;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@Resource(name = "commonService")
	  private CommonService commonService;

	@Autowired
	private WebInvoiceApplication webInvoiceApplication;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private VoucherService voucherService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/contractTrackingList.do")
	public String contractTrackingList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "eAccounting/contractTracking/contractTrackingList";
	}

	@RequestMapping(value = "/getContractTrackingList.do")
	public ResponseEntity<List<EgovMap>> getContractTrackingList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		String[] listContractType   = request.getParameterValues("listContractType[]");
		String[] listContractStus   = request.getParameterValues("listContractStus");
		if(listContractType      != null && !CommonUtils.containsEmpty(listContractType))      {
			params.put("contractType", listContractType);
		}
		if(listContractStus      != null && !CommonUtils.containsEmpty(listContractStus))      {
			params.put("contractStus", listContractStus);
		}

		List<EgovMap> result = contractService.selectContractTrackingList(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/contractNewPop.do")
	public String contractNewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("action", params.get("callType").toString());
		params.put("orderValue", "code");
		params.put("codeMasterNameVal", "Contract Agreement Type");
		List<EgovMap> codeList = commonService.selectCodeList(params);
		model.addAttribute("contractType", codeList);
		params.put("codeMasterNameVal", "Contract Vendor Type");
		List<EgovMap> vendorCodeList = commonService.selectCodeList(params);
		model.addAttribute("vendorType", vendorCodeList);

		return "eAccounting/contractTracking/contractNewPop";
	}

	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "contractTracking", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		webInvoiceApplication.insertWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

		List<EgovMap> fileInfo = webInvoiceService.selectAttachList(params.get("fileGroupKey").toString());

		if(fileInfo != null){
			params.put("atchFileId", fileInfo.get(0).get("atchFileId"));
		}
		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/insertContractInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertWebInvoiceInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		contractService.insertVendorTrackingInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getContractTrackingView.do")
	public String getContractTrackingView(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap result = contractService.selectContractTrackingViewDetails(params);
		List<EgovMap> cycleResult = contractService.selectContractCycleDetails(params);
		params.put("orderValue", "code");
		params.put("codeMasterNameVal", "Contract Agreement Type");
		List<EgovMap> codeList = commonService.selectCodeList(params);
		params.put("codeMasterNameVal", "Contract Vendor Type");
		List<EgovMap> vendorCodeList = commonService.selectCodeList(params);

		model.put("contTrackId", params.get("contTrackId"));
		model.put("details", result);
		model.put("contractType", codeList);
		model.put("vendorType", vendorCodeList);
		model.put("cycleResult", cycleResult);

		return "eAccounting/contractTracking/contractNewPop";
	}

	@RequestMapping(value = "/selectContractCycleDetails.do")
	public ResponseEntity<List<EgovMap>> selectContractCycleDetails(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
//		String[] moduleArr   = request.getParameterValues("moduleSearch");
//		if(moduleArr      != null && !CommonUtils.containsEmpty(moduleArr))      params.put("moduleArr", moduleArr);

		List<EgovMap> result = contractService.selectContractCycleDetails(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/attachmentUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "contractTracking", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		String remove = (String) params.get("remove");

		LOGGER.debug("list.size : {}", list.size());
		LOGGER.debug("remove : {}", remove);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0 || !StringUtils.isEmpty(remove)) {
			// TODO
			webInvoiceApplication.updateWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
		}

		params.put("attachment", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateContractInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateContractInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		contractService.updateVendorTrackingInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/attachContractFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachContractFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);
		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "eAccounting" + File.separator + "contractTracking", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			LOGGER.debug("list.size : {}", list.size());
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			contractService.updatePreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

			params.put("attachFiles", list);
			code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/contractRawPop.do")
	  public String contractRawPop(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("orderValue", "code");
		params.put("codeMasterNameVal", "Contract Agreement Type");
		List<EgovMap> codeList = commonService.selectCodeList(params);
		params.put("codeMasterNameVal", "Contract Vendor Type");
		List<EgovMap> vendorCodeList = commonService.selectCodeList(params);

		model.put("contractType", codeList);
		model.put("vendorType", vendorCodeList);

	    return "eAccounting/contractTracking/contractRawPop";
	  }

	@RequestMapping(value = "/deleteContractInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteContractInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		contractService.deleteVendorTrackingInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
