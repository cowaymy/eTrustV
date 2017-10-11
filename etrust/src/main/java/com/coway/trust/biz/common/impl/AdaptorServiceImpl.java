package com.coway.trust.biz.common.impl;

import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.MimeMessage;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.BulkSmsVO;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
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

	@Override
	public boolean sendEmail(EmailVO email, boolean isTransactional) {
		boolean isSuccess = true;
		try {
			MimeMessage message = mailSender.createMimeMessage();
			boolean isMultiPart = email.getFiles().size() == 0 ? false : true;
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, isMultiPart, AppConstants.DEFAULT_CHARSET);
			messageHelper.setFrom(from);
			messageHelper.setTo(email.getTo().toArray(new String[email.getTo().size()]));
			messageHelper.setSubject(email.getSubject());
			messageHelper.setText(email.getText());

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
	public SmsResult sendSMS(SmsVO smsVO) {

		Map<String, String> reason = new HashMap<>();
		SmsResult result = new SmsResult();
		result.setReqCount(smsVO.getMobiles().size());

		String msgID = "";
		smsVO.getMobiles().forEach(mobileNo -> {
			String smsUrl = "http://" + gensuiteHost + gensuitePath + "?" + "ClientID=" + gensuiteClientId
					+ "&Username=" + gensuiteUserName + "&Password=" + gensuitePassword + "&Type=" + gensuiteType
					+ "&Message=" + changeToHex(smsVO.getMessage()) + "&SenderID=" + gensuiteSenderId + "&Phone="
					+ gensuiteCountryCode + mobileNo + "&MsgID=" + msgID;

			ResponseEntity<String> response = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);

			LOGGER.debug("[sendSMS]getStatusCode : {}", response.getStatusCode());
			LOGGER.debug("[sendSMS]getBody : {}", response.getBody());

			if (response.getStatusCode() == HttpStatus.OK) {
				String body = response.getBody();
				if (GENSUITE_SUCCESS.equals(body)) {
					result.setSuccessCount(result.getSuccessCount() + 1);
				} else {
					result.setFailCount(result.getFailCount() + 1);
					reason.clear();
					reason.put(mobileNo, body);
					result.addFailReason(reason);
				}
			} else {
				result.setErrorCount(result.getErrorCount() + 1);
			}
		});

		return result;
	}

	/**
	 * ------------------------ MVGate Error Code ------------------------
	 * 100 Unauthorized Access
	 * 101 Unknown Target Receiver
	 * 102 Invalid Parameter Format
	 * 103 Text is required
	 * 104 Unknown MT From
	 * 105 Invalid Company Code
	 * 106 Invalid Username or Password
	 * 107 Account is not activated yet
	 * 108 Insufficient Balance
	 * 109 Credit Expired
	 * 110 Insufficient Balance + Credit Expired
	 * 111 DB Error
	 * ----------------------------------------------------------------------------
	 */
	@Override
	public SmsResult sendSMSByBulk(BulkSmsVO bulkSmsVO) {

		SmsResult result = new SmsResult();
		Map<String, String> reason = new HashMap<>();
		result.setReqCount(1);

		String trId = UUIDGenerator.get();

		String smsUrl = "http://" + mvgateHost + mvgatePath + "?to=" + mvgateCountryCode + bulkSmsVO.getMobile()
				+ "&token=" + mvgateToken + "&username=" + mvgateUserName + "&password=" + mvgatePassword + "&code="
				+ mvgateCode + "&mt_from=" + mvgateMtFrom + "&text=" + bulkSmsVO.getMessage() + "&lang=0&trid=" + trId;

		ResponseEntity<String> response = RestTemplateFactory.getInstance().getForEntity(smsUrl, String.class);

		LOGGER.debug("[sendSMSByBulk]getStatusCode : {}", response.getStatusCode());
		LOGGER.debug("[sendSMSByBulk]getBody : {}", response.getBody());

		if (response.getStatusCode() == HttpStatus.OK) {
			String body = response.getBody();
			String[] resArray = body.split(","); // <SUCCESS CODE>,<MSG ID>,<TRID>

			if (MVGATE_SUCCESS.equals(resArray[0])) {
				result.setSuccessCount(result.getSuccessCount() + 1);
			} else {
				result.setFailCount(result.getFailCount() + 1);
				reason.clear();
				reason.put(bulkSmsVO.getMobile(), body);
				result.addFailReason(reason);
			}
		} else {
			result.setErrorCount(result.getErrorCount() + 1);
		}

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
		returnValue = returnValue.replaceAll("{", "%7B");
		returnValue = returnValue.replaceAll("}", "%7D");
		returnValue = returnValue.replaceAll("|", "%7C");
		returnValue = returnValue.replaceAll("[", "%5B");
		returnValue = returnValue.replaceAll("]", "%5D");
		return returnValue;
	}
}
