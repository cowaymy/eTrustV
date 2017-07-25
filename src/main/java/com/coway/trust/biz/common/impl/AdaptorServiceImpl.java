package com.coway.trust.biz.common.impl;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.EmailVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.RestTemplateFactory;
import com.coway.trust.util.UUIDGenerator;

@Service("adaptorService")
public class AdaptorServiceImpl implements AdaptorService {
	private static final Logger logger = LoggerFactory.getLogger(AdaptorServiceImpl.class);

	@Value("${mail.config.from}")
	private String from;
	
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

	@Override
	public boolean sendSMS() {

		String HOST_NAME = "gensuite.genusis.com";
		String HOST_PATH = "/api/gateway.php";
		String strClientID = "coway";
		String strUserName = "system";
		String strPassword = "genusis_2015";
		String strType = "SMS";
		String strSenderID = "63839";
		String CountryCode = "6";
		String randoms = UUIDGenerator.get();// Guid.NewGuid().ToString().Replace("-", string.Empty).Replace("+",
											 // string.Empty).Substring(0, 12);
		String strMsgID = "";
		int VendorID = 2;

		String message = "test message";
		String mobileNo = "01091887015";

		String SMSUrl = "http://" + HOST_NAME + HOST_PATH + "?" + "ClientID=" + strClientID + "&Username=" + strUserName
				+ "&Password=" + strPassword + "&Type=" + strType + "&Message=" + message + "&SenderID=" + strSenderID
				+ "&Phone=" + CountryCode + mobileNo + "&MsgID=" + strMsgID;

		RestTemplateFactory.getInstance().getForEntity(SMSUrl, String.class); // postForObject(SMSUrl, form,
																			  // PaymentCardPayDto.class);
		return false;
	}

}
