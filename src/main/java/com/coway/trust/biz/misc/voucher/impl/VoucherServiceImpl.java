package com.coway.trust.biz.misc.voucher.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.jsoup.select.Evaluator.IsEmpty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.eAccounting.creditCard.impl.CreditCardAllowancePlanMapper;
import com.coway.trust.biz.misc.voucher.VoucherService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("voucherService")
public class VoucherServiceImpl implements VoucherService {

	private static final Logger LOGGER = LoggerFactory.getLogger(VoucherServiceImpl.class);

	@Resource(name = "voucherMapper")
	private VoucherMapper voucherMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public ReturnMessage createVoucherCampaign(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		if(voucherMapper.isCampaignMasterCodeExist(params) > 0){
			throw new ApplicationException(AppConstants.FAIL,
					"Master Code exist, please enter different code");
		}

		int voucherCampaignId = voucherMapper.getVoucherCampaignNextVal();

		params.put("userId", sessionVO.getUserId());
		params.put("campaignId", voucherCampaignId);
		int campaignResult = voucherMapper.insertVoucherCampaign(params);

		if (campaignResult == 1) {
			// Promotion Package Insert
			String[] promotionPackageIdList = params.get("promotionPackageIdList").toString().split(",");

			for (int i = 0; i < promotionPackageIdList.length; i++) {
				int promoId = Integer.parseInt(promotionPackageIdList[i].toString());

				params.put("promotionPackageId", promoId);
				voucherMapper.insertVoucherPromotionPackage(params);
			}

			// Generate voucher code if any
			int voucherGenerationAmount = Integer.parseInt(params.get("voucherGenAmount").toString());
			if (voucherGenerationAmount > 0) {
				voucherMapper.SP_VOUCHER_GENERATE(params);

				if (!"1".equals(params.get("p1Stus"))) {
					throw new ApplicationException(AppConstants.FAIL,
							"[ERROR]" + params.get("p2Msg") + "Generating Voucher:" + "RETURN Result Error");
				}
			}
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage("Voucher Campaign Creation Failed.");
			return message;
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage editVoucherCampaign(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		params.put("userId", sessionVO.getUserId());
		voucherMapper.editVoucherCampaign(params);

		// Promotion Package Insert
		String[] promotionPackageIdList = params.get("promotionPackageIdList").toString().split(",");

		for (int i = 0; i < promotionPackageIdList.length; i++) {
			if (!CommonUtils.isEmpty(promotionPackageIdList[i].toString())) {
				int promoId = Integer.parseInt(promotionPackageIdList[i].toString());

				params.put("promotionPackageId", promoId);
				voucherMapper.insertVoucherPromotionPackage(params);
			}
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage editVoucherCampaignDate(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		params.put("userId", sessionVO.getUserId());
		voucherMapper.editVoucherCampaignDate(params);

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}


	@Override
	public ReturnMessage editVoucherCampaignStatus(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		params.put("userId", sessionVO.getUserId());
		voucherMapper.editVoucherCampaignStatus(params);

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public List<EgovMap> getVoucherCampaignList(Map<String, Object> params) {
		return voucherMapper.getVoucherCampaignList(params);
	}

	@Override
	public List<EgovMap> getVoucherList(Map<String, Object> params) {
		return voucherMapper.getVoucherList(params);
	}

	@Override
	public List<EgovMap> getVoucherListForExcel(Map<String, Object> params) {
		return voucherMapper.getVoucherListForExcel(params);
	}

	@Override
	public EgovMap getVoucherCampaignDetail(Map<String, Object> params) {
		EgovMap result = voucherMapper.getVoucherCampaignDetail(params);
		int isEditable = voucherMapper.isCampaignEditable(params);
		result.put("isEditable", isEditable);
		return result;
	}

	@Override
	public List<EgovMap> getVoucherCampaignPromotionDetail(Map<String, Object> params) {
		return voucherMapper.getVoucherCampaignPromotionDetail(params);
	}

	@Override
	public List<EgovMap> selectPromotionList(Map<String, Object> params) {
		return voucherMapper.selectPromotionList(params);
	}

	@Override
	public List<EgovMap> selectExistPromotionList(Map<String, Object> params) {
		List<String> existPromotionPackageIdList = new ArrayList();
		List<EgovMap> existingVoucherPromotionList = voucherMapper.getVoucherCampaignPromotionDetail(params);
		for (int i = 0; i < existingVoucherPromotionList.size(); i++) {
			existPromotionPackageIdList.add(existingVoucherPromotionList.get(i).get("promoId").toString());
		}

		if (existPromotionPackageIdList.size() > 0) {
			params.put("arrPromotionId", existPromotionPackageIdList.toArray());
			return voucherMapper.selectPromotionList(params);
		} else {
			return null;
		}
	}

	@Override
	public ReturnMessage deleteVoucherPromotionPackage(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		voucherMapper.deleteVoucherPromotionPackage(params);

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage generateVoucher(Map<String, Object> params, SessionVO sessionVO) {
		int editable = voucherMapper.isCampaignEditable(params);
		if (editable == 0) {
			throw new ApplicationException(AppConstants.FAIL,
					"Voucher Code has been generated before.Only 1 time generation is allowed.");
		}

		params.put("userId", sessionVO.getUserId());

		ReturnMessage message = new ReturnMessage();
		// Generate voucher code if any
		int voucherGenerationAmount = Integer.parseInt(params.get("voucherGenAmount").toString());
		if (voucherGenerationAmount > 0) {
			voucherMapper.SP_VOUCHER_GENERATE(params);

			if (!"1".equals(params.get("p1Stus"))) {
				throw new ApplicationException(AppConstants.FAIL,
						"[ERROR]" + params.get("p2Msg") + "Generating Voucher:" + "RETURN Result Error");
			}
		} else {
			throw new ApplicationException(AppConstants.FAIL, "Please specify the number of voucher to be generated.");
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage deactivateVoucher(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		params.put("userId", sessionVO.getUserId());
		String[] detailIdArr = params.get("detailIdList").toString().split(",");
		params.put("arrDetailId", detailIdArr);

		voucherMapper.voucherDeactivate(params);

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage activateVoucher(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		params.put("userId", sessionVO.getUserId());
		String[] detailIdArr = params.get("detailIdList").toString().split(",");
		params.put("arrDetailId", detailIdArr);

		voucherMapper.voucherActivate(params);

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage voucherCustomerDataUpload(List<Map<String, Object>> params, int campaignId,
			SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> campaignParam = new HashMap<String, Object>();
		ObjectMapper mapper = new ObjectMapper();
		campaignParam.put("campaignId", campaignId);

		int editable = voucherMapper.isCampaignEditable(campaignParam);
		if (editable == 1) { //able to edit, means voucher has not been generated.
			throw new ApplicationException(AppConstants.FAIL,
					"Voucher Code has not been generated for this campaign.");
		}

		int uploadable = voucherMapper.isCampaignUploadable(campaignParam);
		if (uploadable == 0) {//data has been uploaded once before
			throw new ApplicationException(AppConstants.FAIL,
					"Customer Info has been uploaded before.Only once is allowed.");
		}

		int userId = sessionVO.getUserId();
		for (int i = 0; i < params.size(); i++) {
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("campaignId", campaignId);
			data.put("voucherCode", params.get(i).get("voucherCode"));
			int validResult = voucherMapper.isVoucherValidForDataUpload(data);

			if (validResult == 0) {
				throw new ApplicationException(AppConstants.FAIL,
						"Voucher Code: " + params.get(i).get("voucherCode") + " is not valid." );
			}
		}

		for (int i = 0; i < params.size(); i++) {
			int mailIDNextVal = voucherMapper.getBatchEmailNextVal();

			Map<String, Object> data = new HashMap<String, Object>();
			data.put("campaignId", campaignId);
			data.put("userId", userId);
			data.put("voucherCode", params.get(i).get("voucherCode"));
			data.put("custEmail", params.get(i).get("custEmail"));
			data.put("ordId", params.get(i).get("orderId"));
			data.put("custName", params.get(i).get("custName"));
			data.put("custContact", params.get(i).get("contact"));
			data.put("product", params.get(i).get("productName"));
			data.put("obligation", params.get(i).get("obligation"));
			data.put("free", params.get(i).get("freeItem"));
			data.put("mailId", mailIDNextVal);
			voucherMapper.updateVoucherCustomerInfo(data);

			/*
			 * Email Batch Sender Insertion
			 */
			EgovMap emailParam = new EgovMap();
			emailParam.put("voucherCode", params.get(i).get("voucherCode"));
			emailParam.put("custEmail", params.get(i).get("custEmail"));
			emailParam.put("ordId", params.get(i).get("orderId"));
			emailParam.put("custName", params.get(i).get("custName"));
			emailParam.put("custContact", params.get(i).get("contact"));
			emailParam.put("product", params.get(i).get("productName"));
			emailParam.put("obligation", params.get(i).get("obligation"));
			emailParam.put("free", params.get(i).get("freeItem"));
			if(params.get(i).get("freeItem") == null || params.get(i).get("freeItem").toString().trim().isEmpty()){
				emailParam.put("freeItemDisplay", "none");
			}
			else{
				emailParam.put("freeItemDisplay", "block");
			}

			Map<String,Object> masterEmailDet = new HashMap<String, Object>();
			masterEmailDet.put("mailId", mailIDNextVal);
			masterEmailDet.put("emailType",AppConstants.EMAIL_TYPE_TEMPLATE);
			masterEmailDet.put("templateName", AppConstants.E_VOUCHER_RECEIPT_BATCH_TEMPLATE);
			try {
				masterEmailDet.put("emailParams", mapper.writeValueAsString(emailParam));
			} catch (JsonProcessingException e) {
				throw new ApplicationException(AppConstants.FAIL,
						"Unable to trigger email sender. Please inform IT.");
			}
			masterEmailDet.put("email", params.get(i).get("custEmail"));
			masterEmailDet.put("emailSentStus", 1);
			masterEmailDet.put("name", "");
			masterEmailDet.put("userId", userId);
			masterEmailDet.put("categoryId", 1);
			masterEmailDet.put("emailSubject", "[COWAY] E-VOUCHER VERIFICATION CODE");

			voucherMapper.insertBatchEmailSender(masterEmailDet);
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage isVoucherValidToApply(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		if(params.get("voucherCode").toString().isEmpty() || params.get("custEmail").toString().isEmpty()
				|| params.get("platform").toString().isEmpty()){
			message.setCode(AppConstants.FAIL);
			message.setMessage("Please fill in all the required infromation for checking.");
			return message;
		}

		int validResult = voucherMapper.isVoucherValidToApply(params);

		if(validResult == 0){
			message.setCode(AppConstants.FAIL);
			message.setMessage("Voucher not valid to be use. Kindly recheck");
			return message;
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public ReturnMessage isVoucherValidToApplyIneKeyIn(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		if(params.get("voucherCode").toString().isEmpty() || params.get("custEmail").toString().isEmpty()
				|| params.get("platform").toString().isEmpty()){
			message.setCode(AppConstants.FAIL);
			message.setMessage("Please fill in all the required infromation for checking.");
			return message;
		}

		int validResult = voucherMapper.isVoucherValidToApplyIneKeyIn(params);

		if(validResult == 0){
			message.setCode(AppConstants.FAIL);
			message.setMessage("Voucher is applied on other e-KeyIn orders");
			return message;
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageSourceAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@Override
	public List<EgovMap> getVoucherUsagePromotionId(Map<String, Object> params) {
		return voucherMapper.getVoucherUsagePromotionId(params);
	}

	@Override
	public boolean updateVoucherUseStatus(String voucherCode, int isUsed){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("voucherCode", voucherCode);
		params.put("isUsed", isUsed);

		voucherMapper.updateVoucherCodeUseStatus(params);
		return true;
	}

	@Override
	public EgovMap getVoucherInfo(Map<String, Object> params){
		return voucherMapper.getVoucherInfo(params);
	}

	@Override
	public List<EgovMap> getPendingEmailSendInfo(){
		return voucherMapper.getPendingEmailSendInfo();
	}

	@Override
	public void sendEmail(Map<String, Object> params) throws JsonParseException, JsonMappingException, IOException{
	    ObjectMapper mapper = new ObjectMapper();
	    Map<String, Object> additionalParam = new HashMap();
		EmailVO email = new EmailVO();
		String emailSubject = CommonUtils.nvl(params.get("emailSubject"));

		List<String> emailNo = new ArrayList<String>();
	    if (!"".equals(params.get("email"))) {
		      emailNo.add(params.get("email").toString());
		}


	    if(params.get("emailParams") != null && params.get("emailParams").toString() != ""){
		    additionalParam = mapper.readValue(params.get("emailParams").toString(),Map.class);
			 params.putAll(additionalParam);
	    }

	    if (!"".equals(CommonUtils.nvl(params.get("custEmail")))) {
	      emailNo.add(CommonUtils.nvl(params.get("custEmail")));
	    }

	    if(emailNo.size() > 0 && additionalParam != null){
		    email.setTo(emailNo);
		    email.setHtml(true);
		    email.setSubject(emailSubject);
		    email.setHasInlineImage(true);

		    boolean isResult = false;
		    isResult = adaptorService.sendEmail(email, false, EmailTemplateType.E_VOUCHER_RECEIPT, params);

		    if(isResult){
		    	params.put("mailId", params.get("mailId"));
		    	params.put("userId", params.get("userId"));
		    	voucherMapper.updateBatchEmailSuccess(params);
		    }
	    }
	}
}
