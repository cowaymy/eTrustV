package com.coway.trust.web.payment.mobileAutoDebit.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.payment.autodebit.service.AutoDebitService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/mobileautodebit")
public class MobileAutoDebitController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MobileAutoDebitController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "autoDebitService")
	private AutoDebitService autoDebitService;

	@RequestMapping(value = "/autoDebitEnrollmentList.do")
	public String selectCustomerList(@RequestParam Map<String, Object> params, ModelMap model) {

		return "payment/mobileautodebit/autoDebitEnrollmentList";
	}

	@RequestMapping(value = "/autoDebitAuthorizationForm.do")
	public String autoDebitAuthorizationForm(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

		model.put("params", params);
		return "payment/mobileautodebit/autoDebitAuthorizationFormPop";
	}

	@RequestMapping(value = "/selectAutoDebitEnrollmentList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAutoDebitEnrollmentList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		 String[] statusIdList = request.getParameterValues("status");
		 String[] branchIdList = request.getParameterValues("branchId");
		 String[] regionIdList = request.getParameterValues("region");
		 String[] custTypeIdList = request.getParameterValues("custTypeId");
		 String[] cardTypeIdList = request.getParameterValues("cardTypeId");

		 params.put("statusIdList",statusIdList);
		 params.put("branchIdList",branchIdList);
		 params.put("regionIdList",regionIdList);
		 params.put("custTypeIdList",custTypeIdList);
		 params.put("cardTypeIdList",cardTypeIdList);

		 LOGGER.debug("!@###### PARAMS : " + params);

		List<EgovMap> autoDebitList = autoDebitService.selectAutoDebitEnrollmentList(params);
		return ResponseEntity.ok(autoDebitList);
	}


	/*
	 * Detail
	 *
	 */
	@RequestMapping(value = "/autoDebitDetailPop.do")
	public String autoDebitDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		//SELECT PAYMENTINFO,ATTACHMENT,STATUS
		List<EgovMap> autoDebitDetailInfo = autoDebitService.selectAutoDebitDetailInfo(params);
		List<EgovMap> customerCreditCardEnrollInfo = autoDebitService.selectCustomerCreditCardInfo(params);
		List<EgovMap> autoDebitAttachmentInfo = autoDebitService.selectAttachmentInfo(params);

		if(autoDebitDetailInfo.size() > 0){
			model.put("mobileAutoDebitDetail", autoDebitDetailInfo.get(0));
		}
		else{
			model.put("mobileAutoDebitDetail", null);
		}

		if(customerCreditCardEnrollInfo.size() > 0){
			model.put("customerCreditCardEnrollInfo", customerCreditCardEnrollInfo.get(0));
		}
		else{
			model.put("customerCreditCardEnrollInfo", null);
		}

		if(autoDebitAttachmentInfo.size() > 0){
			model.put("autoDebitAttachmentInfo", autoDebitAttachmentInfo);
		}
		else{
			model.put("autoDebitAttachmentInfo", null);
		}
		return "payment/mobileautodebit/autoDebitDetailPop";
	}

	@RequestMapping(value = "/selectRejectReasonCodeOption.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRejectReasonCodeOption(@RequestParam Map<String, Object> params) {
		List<EgovMap> rejectReasonOption = autoDebitService.selectRejectReasonCode(params);
		LOGGER.debug("params: =====================>> " + params);
		return ResponseEntity.ok(rejectReasonOption);

	}

	//NEED TO CHANGE UPLOAD
	@RequestMapping(value = "/attachmentAutoDebitFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentAutoDebitFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
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

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "payment" + File.separator + "mobilePaymentApi", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			LOGGER.debug("list.size : {}", list.size());
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());


			//INSERT OR UPDATE
			autoDebitService.updateMobileAutoDebitAttachment(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

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

	@RequestMapping(value = "/updateAction.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>updateAction(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("params =====================================>>  " + params);

        params.put("userId", sessionVO.getUserId());
        params.put("updator", sessionVO.getUserId());
        ReturnMessage message = new ReturnMessage();
        int updAct = autoDebitService.updateAction(params);

        if(updAct == 1){
            message.setCode(AppConstants.SUCCESS);
            message.setMessage("<b>Update Success.</b>");
        }
        else{
        	message.setCode(AppConstants.FAIL);
            message.setMessage("<b>Fail to save. Please try again.</b>");
        }

        return ResponseEntity.ok(message);
	}
}
