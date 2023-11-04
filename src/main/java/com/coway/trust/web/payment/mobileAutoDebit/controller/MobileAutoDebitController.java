package com.coway.trust.web.payment.mobileAutoDebit.controller;

import java.io.File;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Field;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.SerializationUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.Base64Utils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.HtmlUtils;

import com.businessobjects.report.web.shared.URIUtil;
import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.EncryptionDecryptionService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.payment.autodebit.service.AutoDebitService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

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

	  @Resource(name = "customerService")
	  private CustomerService customerService;

	@Resource(name = "autoDebitService")
	private AutoDebitService autoDebitService;

	@Resource(name = "encryptionDecryptionService")
	private EncryptionDecryptionService encryptionDecryptionService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@RequestMapping(value = "/autoDebitEnrollmentList.do")
	public String autoDebitEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
	    	sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

    	    EgovMap result =  salesCommonService.getUserInfo(params);

    	    model.put("orgCode", result.get("orgCode"));
    	    model.put("grpCode", result.get("grpCode"));
    	    model.put("deptCode", result.get("deptCode"));
    	    model.put("memCode", result.get("memCode"));
	    }

		return "payment/mobileautodebit/autoDebitEnrollmentList";
	}

	@RequestMapping(value = "/autoDebitAuthorizationPublicForm.do")
	public String autoDebitAuthorizationPublicForm(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		model.put("key", params.get("key").toString());
		return "payment/mobileautodebit/autoDebitAuthorizationPublicForm";
	}

	@RequestMapping(value = "/selectAutoDebitFormData.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectAutoDebitFormData(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws IOException {
		Map<String, Object> result = new HashMap<String,Object>();
		String encryptedString = params.get("key").toString().replaceAll(" ", "+");
		String decryptedString = "";
		List<String> splitStringArr = new ArrayList<String>();
		try {
			decryptedString = encryptionDecryptionService.decrypt(encryptedString,"autodebit");

			LOGGER.debug("decryptedStringPadId: =====================>> " + decryptedString);

			splitStringArr = Arrays.asList(decryptedString.split("&"));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			params.put("padId", Integer.parseInt(splitStringArr.get(0)));

			List<EgovMap> autoDebitDetailInfo = autoDebitService.selectAutoDebitDetailInfo(params);
			EgovMap product = autoDebitService.getProductDescription(params);
			if(autoDebitDetailInfo.size() > 0){
				Map<String, Object> signImg = autoDebitService.getAutoDebitSignImg(params);
				result.put("mobileAutoDebitDetail", autoDebitDetailInfo.get(0));
				result.put("product", product);
				params.put("custCrcId", autoDebitDetailInfo.get(0).get("custCrcId"));
				List<EgovMap> customerCreditCardEnrollInfo = autoDebitService.selectCustomerCreditCardInfo(params);

				if(customerCreditCardEnrollInfo.size() > 0){
					result.put("customerCreditCardEnrollInfo", customerCreditCardEnrollInfo.get(0));
				}

				result.put("signImg",signImg.get("SIGN_IMG").toString());
			}
		}
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/autoDebitAuthorizationFormPop.do")
	public String autoDebitAuthorizationForm(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
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
		List<Map<String, Object>> autoDebitAttachmentInfo = autoDebitService.selectAttachmentInfo(params);

		if(autoDebitDetailInfo.size() > 0){
			String remarks = "";
			if(autoDebitDetailInfo.get(0).get("remarks") != null){
				remarks = autoDebitDetailInfo.get(0).get("remarks").toString();
			}
			remarks = remarks.replaceAll("(\r\n|\n)", "<br>");
			remarks = HtmlUtils.htmlEscape(remarks);
			autoDebitDetailInfo.get(0).put("remarks", remarks);
			model.put("mobileAutoDebitDetail", autoDebitDetailInfo.get(0));

			EgovMap autoDebitDetail = autoDebitDetailInfo.get(0);
			if(autoDebitDetail.get("thirdPartyCustId") != null){
				String thirdPartyCustId = autoDebitDetailInfo.get(0).get("thirdPartyCustId").toString();
				if(thirdPartyCustId != null && thirdPartyCustId.length() > 0){
				    List<EgovMap> customerList = null;
					Map<String, Object> params1 =  new HashMap<>();
					params1.put("custId", thirdPartyCustId);
				    customerList = customerService.selectCustomerList(params1);

				    if(customerList.size() > 0){
						ObjectMapper map = new ObjectMapper();
						try {
							String customerJSONInfo = map.writeValueAsString(customerList.get(0));
							model.put("thirdPartyCustomerInfo", customerJSONInfo);
						} catch (JsonProcessingException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
				    }
				}
			}

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
			String autoDebitAttachmentJSONInfo = "";
			ObjectMapper map = new ObjectMapper();
			try {
				autoDebitAttachmentJSONInfo = map.writeValueAsString(autoDebitAttachmentInfo);
			} catch (JsonProcessingException e) {
				LOGGER.debug("Json Error: =====================>> " + e);
			}
			model.put("autoDebitAttachmentInfo", autoDebitAttachmentJSONInfo);
		}
		else{
			model.put("autoDebitAttachmentInfo", null);
		}

		model.put("authFuncChange",params.get("authFuncChange").toString());
		return "payment/mobileautodebit/autoDebitDetailPop";
	}

	@RequestMapping(value = "/selectRejectReasonCodeOption.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRejectReasonCodeOption(@RequestParam Map<String, Object> params) {
		List<EgovMap> rejectReasonOption = autoDebitService.selectRejectReasonCode(params);
		LOGGER.debug("params: =====================>> " + params);
		return ResponseEntity.ok(rejectReasonOption);

	}

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

	@RequestMapping(value = "/updateFailReason.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateFailReason(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		ReturnMessage message = new ReturnMessage();

		int updResult = autoDebitService.updateFailReason(params, sessionVO);

        if(updResult >= 1){
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
