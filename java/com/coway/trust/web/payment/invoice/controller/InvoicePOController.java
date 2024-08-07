package com.coway.trust.web.payment.invoice.controller;
import java.io.File;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.bouncycastle.util.Arrays.Iterator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.payment.billinggroup.service.BillingGroupService;
import com.coway.trust.biz.payment.invoice.service.InvoicePOService;
import com.coway.trust.biz.payment.invoice.service.InvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import com.coway.trust.biz.application.FileApplication;

import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
@Controller
@RequestMapping(value = "/payment")
public class InvoicePOController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoicePOController.class);

	@Resource(name = "invoicePOService")
	private InvoicePOService invoicePOService;

	//Added by keyi billing statement PO attachment
	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@Resource(name = "billingGroupService")
	private BillingGroupService billGroupService;
	/**
	 * BillingMgnt 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingStatementPO.do")
	public String initInvoiceStatementManagement(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/billingStatementPo";
	}

	@RequestMapping(value = "/selectOrderBasicInfoByOrderId.do")
	public ResponseEntity<EgovMap> selectOrderBasicInfoByOrderId(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderBasicInfo = null;

		LOGGER.debug("params : {}", params);

		orderBasicInfo = invoicePOService.selectOrderBasicInfoByOrderId(params).get(0);

		return ResponseEntity.ok(orderBasicInfo);
	}

	@RequestMapping(value = "/selectHTOrderBasicInfoByOrderId.do")
	public ResponseEntity<EgovMap> selectHTOrderBasicInfoByOrderId(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderBasicInfo = null;

		LOGGER.debug("params : {}", params);

		orderBasicInfo = invoicePOService.selectHTOrderBasicInfoByOrderId(params).get(0);

		return ResponseEntity.ok(orderBasicInfo);
	}

	@RequestMapping(value = "/selectOrderDataByOrderId.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceStmtMgmtList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = null;

		LOGGER.debug("params : {}", params);

		list = invoicePOService.selectOrderDataByOrderId(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/disablePOEntry.do")
	public ResponseEntity<ReturnMessage> disablePOEntry(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		String message = "";
		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		int userId = sessionVO.getUserId();
		params.put("userId", userId);

		LOGGER.debug("params : {}", params);

		if(userId > 0){
			int result = invoicePOService.updateInvoiceStatement(params);
			if(result < 1){
				message = "No records found";
			}
		};

		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/selectInvoiceStatement.do")
	public ResponseEntity<ReturnMessage> selectInvoiceStatementByOrdId(@RequestParam Map<String, Object> params, ModelMap model) {
		String message = "";
		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		LOGGER.debug("params : {}", params);

		//List<EgovMap> result = invoicePOService.selectInvoiceStatementByOrdId(params);
		List<EgovMap> resultStart = invoicePOService.selectInvoiceStatementStart(params);
		List<EgovMap> resultEnd = invoicePOService.selectInvoiceStatementEnd(params);

	/*	if(result.size() > 0){
			message = "Invalid Period Range";
		}else*/

	if(resultStart.size() > 0){
          message = "Invalid Start Period Range";
      }else if(resultEnd.size() > 0){
        message = "Invalid End Period Range";
       }
		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/insertInvoiceStatement.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertInvoiceStatement(@RequestParam Map<String, Object> params, MultipartHttpServletRequest request,
			ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		String atchSubPath = generateAttchmtSubPath();

	    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, atchSubPath, AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		if (list.size() > 0) {
		      params.put("fileName", list.get(0).getServerSubPath() + list.get(0).getFileName());
		      int fileGroupKey = fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		      params.put("fileId", fileGroupKey);
		    }

		invoicePOService.insertInvoicStatement(params);

		return ResponseEntity.ok(params);
	}

	public String generateAttchmtSubPath(){
		Date today = new Date();
		SimpleDateFormat formatAttchtDt = new SimpleDateFormat("yyyyMMdd");
		String dt = formatAttchtDt.format(today);
		String subPath = File.separator  + dt.substring(0, 4) + File.separator + dt.substring(0, 6);
		return subPath;
	}

	@RequestMapping(value = "/getAttachmentInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		Map<String, Object> attachInfo = new HashMap<String, Object>();
		attachInfo.put("atchFileGrpId", params.get("atchFileGrpId"));
		attachInfo.put("atchFileId", params.get("atchFileId"));

		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(attachInfo);

		return ResponseEntity.ok(fileInfo);
	}

	@RequestMapping(value = "/selectInvoiceBillGroupList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceBillGroupList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = null;

		LOGGER.debug("params : {}", params);

		String getCustId = invoicePOService.selectCustBillId(params);

		if(getCustId != null){
        	getCustId = getCustId != null ? getCustId : "";
        	params.put("custBillId", getCustId);
        	list = invoicePOService.selectInvoiceBillGroupList(params);
		}

		return ResponseEntity.ok(list);
	}
}
