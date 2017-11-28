package com.coway.trust.biz.common.impl;

import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.MimeMessage;

import org.apache.commons.lang3.StringUtils;
import org.apache.velocity.app.VelocityEngine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.ui.velocity.VelocityEngineUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.common.type.SMSTemplateType;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.BulkSmsVO;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.RestTemplateFactory;
import com.coway.trust.util.UUIDGenerator;

@Service("adaptorService")
public class AdaptorServiceImpl implements AdaptorService {
	private static final Logger LOGGER = LoggerFactory.getLogger(AdaptorServiceImpl.class);

	private static final String GENSUITE_SUCCESS = "success";
	private static final String MVGATE_SUCCESS = "000";

	@Value("${mail.config.from}")
	private String from;

	@Value("${sms.gensuite.host}")
	private String gensuiteHost;

	@Value("${sms.gensuite.path}")
	private String gensuitePath;

	@Value("${sms.gensuite.client.id}")
	private String gensuiteClientId;

	@Value("${sms.gensuite.user.name}")
	private String gensuiteUserName;

	@Value("${sms.gensuite.password}")
	private String gensuitePassword;

	@Value("${sms.gensuite.type}")
	private String gensuiteType;

	@Value("${sms.gensuite.sender.id}")
	private String gensuiteSenderId;

	@Value("${sms.gensuite.country.code}")
	private String gensuiteCountryCode;

	@Value("${sms.mvgate.host}")
	private String mvgateHost;

	@Value("${sms.mvgate.path}")
	private String mvgatePath;

	@Value("${sms.mvgate.code}")
	private String mvgateCode;

	@Value("${sms.mvgate.mt.from}")
	private String mvgateMtFrom;

	@Value("${sms.mvgate.token}")
	private String mvgateToken;

	@Value("${sms.mvgate.user.name}")
	private String mvgateUserName;

	@Value("${sms.mvgate.user.password}")
	private String mvgatePassword;

	@Value("${sms.mvgate.country.code}")
	private String mvgateCountryCode;

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private VelocityEngine velocityEngine;

	@Autowired
	private SmsMapper smsMapper;

	@Override
	public boolean sendEmail(EmailVO email, boolean isTransactional) {
		return this.sendEmail(email, isTransactional, null, null);
	}

	@Override
	public boolean sendEmail(EmailVO email, boolean isTransactional, EmailTemplateType templateType,
			Map<String, Object> params) {
		boolean isSuccess = true;
		try {
			MimeMessage message = mailSender.createMimeMessage();
			boolean isMultiPart = email.getFiles().size() == 0 ? false : true;
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, isMultiPart, AppConstants.DEFAULT_CHARSET);
			messageHelper.setFrom(from);
			messageHelper.setTo(email.getTo().toArray(new String[email.getTo().size()]));
			messageHelper.setSubject(email.getSubject());

			if (templateType != null) {
				messageHelper.setText(getMailTextByTemplate(templateType, params), email.isHtml());
			} else {
				messageHelper.setText(email.getText(), email.isHtml());
			}

			if (isMultiPart) {
				email.getFiles().forEach(file -> {
					try {
						messageHelper.addAttachment(file.getName(), file);
					} catch (Exception e) {
						throw new ApplicationException(e, AppConstants.FAIL, e.getMessage());
					}
				});
			}

			mailSender.send(message);
		} catch (Exception e) {
			isSuccess = false;
			LOGGER.error(e.getMessage());
			if (isTransactional) {
				throw new ApplicationException(e, AppConstants.FAIL, e.getMessage());
			}
		}

		return isSuccess;
	}

	@Override
	public String getMailTextByTemplate(EmailTemplateType templateType, Map<String, Object> params) {
		return VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, templateType.getFileName(),
				AppConstants.DEFAULT_CHARSET, params);
	}

	@Override
	public String getSmsTextByTemplate(SMSTemplateType templateType, Map<String, Object> params) {
		return VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, templateType.getFileName(),
				AppConstants.DEFAULT_CHARSET, params);
	}

	@Override
	public SmsResult sendSMS(SmsVO smsVO) {
		return this.sendSMS(smsVO, null, null);
	}

	@Override
	public SmsResult sendSMS(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> params) {

		Map<String, String> reason = new HashMap<>();
		SmsResult result = new SmsResult();
		result.setReqCount(smsVO.getMobiles().size());

		if (templateType != null) {
			smsVO.setMessage(getSmsTextByTemplate(templateType, params));
		}

		String msgId = UUIDGenerator.get();
		result.setMsgId(msgId);
		int vendorId = 2;
		smsVO.getMobiles().forEach(mobileNo -> {
			String smsUrl = "http://" + gensuiteHost + gensuitePath + "?" + "ClientID=" + gensuiteClientId
					+ "&Username=" + gensuiteUserName + "&Password=" + gensuitePassword + "&Type=" + gensuiteType
					+ "&Message=" + changeToHex(smsVO.getMessage()) + "&SenderID=" + gensuiteSenderId + "&Phone="
					+ gensuiteCountryCode + mobileNo + "&MsgID=" + msgId;

			ResponseEntity<String> response = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);

			LOGGER.debug("[sendSMS]getStatusCode : {}", response.getStatusCode());
			LOGGER.debug("[sendSMS]getBody : {}", response.getBody());

			int statusId;
			String body;

			if (response.getStatusCode() == HttpStatus.OK) {
				body = response.getBody();

				if (GENSUITE_SUCCESS.equals(body)) {
					statusId = 4;
					result.setSuccessCount(result.getSuccessCount() + 1);
				} else {
					statusId = 21;
					result.setFailCount(result.getFailCount() + 1);
					reason.clear();
					reason.put(mobileNo, body);
					result.addFailReason(reason);
				}

			} else {
				statusId = 1;
				body = response.getStatusCode().getReasonPhrase();
				result.setErrorCount(result.getErrorCount() + 1);
			}

			insertSMS(mobileNo, smsVO.getMessage(), smsVO.getUserId(), 1, 1, 975, "", statusId, 0, body,
					response.getBody(), msgId, vendorId);
		});

		return result;
	}

	/**
	 * ------------------------ MVGate Error Code ------------------------
	 * --------------------------------------------------------------------------------------------------------------
	 * 100 Unauthorized Access 101 Unknown Target Receiver 102 Invalid Parameter Format 103 Text is required 104 Unknown
	 * MT From 105 Invalid Company Code 106 Invalid Username or Password 107 Account is not activated yet 108
	 * Insufficient Balance 109 Credit Expired 110 Insufficient Balance + Credit Expired 111 DB Error
	 * --------------------------------------------------------------------------------------------------------------
	 */
	@Override
	public SmsResult sendSMSByBulk(BulkSmsVO bulkSmsVO) {
		return this.sendSMSByBulk(bulkSmsVO, null, null);
	}

	@Override
	public SmsResult sendSMSByBulk(BulkSmsVO bulkSmsVO, SMSTemplateType templateType, Map<String, Object> params) {

		SmsResult result = new SmsResult();
		Map<String, String> reason = new HashMap<>();
		result.setReqCount(1);

		if (templateType != null) {
			bulkSmsVO.setMessage(getSmsTextByTemplate(templateType, params));
		}

		String trId = UUIDGenerator.get();
		int vendorId = 1;
		result.setMsgId(trId);
		String smsUrl = "http://" + mvgateHost + mvgatePath + "?to=" + mvgateCountryCode + bulkSmsVO.getMobile()
				+ "&token=" + mvgateToken + "&username=" + mvgateUserName + "&password=" + mvgatePassword + "&code="
				+ mvgateCode + "&mt_from=" + mvgateMtFrom + "&text=" + bulkSmsVO.getMessage() + "&lang=0&trid=" + trId;

		ResponseEntity<String> response = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);

		LOGGER.debug("[sendSMSByBulk]getStatusCode : {}", response.getStatusCode());
		LOGGER.debug("[sendSMSByBulk]getBody : {}", response.getBody());

		int statusId;
		String body;
		String retCode;
		if (response.getStatusCode() == HttpStatus.OK) {

			body = response.getBody();
			String[] resArray = body.split(","); // <SUCCESS CODE>,<MSG ID>,<TRID>

			if (MVGATE_SUCCESS.equals(resArray[0])) {
				statusId = 4;
				result.setSuccessCount(result.getSuccessCount() + 1);
			} else {
				statusId = 21;
				result.setFailCount(result.getFailCount() + 1);
				reason.clear();
				reason.put(bulkSmsVO.getMobile(), body);
				result.addFailReason(reason);
			}

			retCode = resArray[0];

		} else {
			statusId = 1;
			body = response.getStatusCode().getReasonPhrase();
			retCode = response.getStatusCode().toString();
			result.setErrorCount(result.getErrorCount() + 1);
		}

		insertSMS(bulkSmsVO.getMobile(), bulkSmsVO.getMessage(), bulkSmsVO.getUserId(), bulkSmsVO.getPriority(),
				bulkSmsVO.getExpireDayAdd(), bulkSmsVO.getSmsType(), bulkSmsVO.getRemark(), statusId,
				bulkSmsVO.getRetryNo(), retCode, body, trId, vendorId);

		return result;
	}

	/**
	 * https://www.obkb.com/dcljr/charstxt.html 참조.
	 * 
	 * @param value
	 * @return
	 */
	private String changeToHex(String value) {
		if (StringUtils.isEmpty(value)) {
			return "";
		}

		String returnValue = value;
		returnValue = returnValue.replaceAll("&", "%26");
		returnValue = returnValue.replaceAll("<", "%3C");
		returnValue = returnValue.replaceAll("`", "%60");
		returnValue = returnValue.replaceAll("~", "%7E");
		returnValue = returnValue.replaceAll("$", "%24");
		returnValue = returnValue.replaceAll("^", "%5E");
		returnValue = returnValue.replaceAll("_", "%5F");
		returnValue = returnValue.replaceAll("\\{", "%7B");
		returnValue = returnValue.replaceAll("}", "%7D");
		returnValue = returnValue.replaceAll("|", "%7C");
		returnValue = returnValue.replaceAll("\\[", "%5B");
		returnValue = returnValue.replaceAll("]", "%5D");
		return returnValue;
	}

	private void insertSMS(String mobileNo, String message, int senderUserId, int priority, int expireDayAdd,
			int smsType, String remark, int statusId, int retryNo, String replyCode, String replyRemark,
			String replyFeedbackId, int vendorId) {

		Map<String, Object> params = new HashMap<>();

		// smsEntry
		params.put("smsMsg", message);
		params.put("smsMsisdn", mobileNo);
		params.put("smsTypeId", smsType);
		params.put("smsPrio", priority);
		params.put("smsRefNo", "");
		params.put("smsBatchUploadId", 0);
		params.put("smsRem", remark);
		params.put("smsStartDt", CommonUtils.getNowDate());
		params.put("smsExprDt", CommonUtils.getCalDate(expireDayAdd));
		params.put("smsStusId", statusId);
		params.put("smsRetry", retryNo);
		params.put("userId", senderUserId);
		params.put("smsVendorId", vendorId);

		smsMapper.insertSmsEntry(params);

		// GatewayReply
		params.put("replyCode", replyCode);
		params.put("replyRem", replyRemark);
		params.put("userId", senderUserId);
		params.put("replyFdbckId", replyFeedbackId);

		smsMapper.insertGatewayReply(params);
	}
}
