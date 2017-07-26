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
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.RestTemplateFactory;

@Service("adaptorService")
public class AdaptorServiceImpl implements AdaptorService {
	private static final Logger logger = LoggerFactory.getLogger(AdaptorServiceImpl.class);
	private static final String SUCCESS = "success";

	@Value("${mail.config.from}")
	private String from;

	@Value("${sms.gensuite.host}")
	private String host;

	@Value("${sms.gensuite.path}")
	private String path;

	@Value("${sms.gensuite.client.id}")
	private String clientId;

	@Value("${sms.gensuite.user.name}")
	private String userName;

	@Value("${sms.gensuite.password}")
	private String password;

	@Value("${sms.gensuite.type}")
	private String type;

	@Value("${sms.gensuite.sender.id}")
	private String senderId;

	@Value("${sms.gensuite.country.code}")
	private String countryCode;

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
			logger.error(e.getMessage());
			if (isTransactional) {
				throw new ApplicationException(e, AppConstants.FAIL, e.getMessage());
			}
		}

		return isSuccess;
	}

	/**
	 * TODO : 테스트 코딩중. 사용하면 안됨.
	 */
	@Override
	public SmsResult sendSMS(SmsVO smsVO) {

		Map<String, String> reason = new HashMap<>();
		SmsResult result = new SmsResult();
		result.setReqCount(smsVO.getMobiles().size());

		String msgID = "";
		smsVO.getMobiles().forEach(mobileNo -> {
			String SMSUrl = "http://" + host + path + "?" + "ClientID=" + clientId + "&Username=" + userName
					+ "&Password=" + password + "&Type=" + type + "&Message=" + changeToHex(smsVO.getMessage())
					+ "&SenderID=" + senderId + "&Phone=" + countryCode + mobileNo + "&MsgID=" + msgID;

			ResponseEntity<String> response = RestTemplateFactory.getInstance().getForEntity(SMSUrl, String.class);
			if (response.getStatusCode() == HttpStatus.OK) {
				String body = response.getBody();
				if (SUCCESS.equals(body)) {
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
