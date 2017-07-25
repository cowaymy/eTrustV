package com.coway.trust.biz.common.impl;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.EmailVO;
import com.coway.trust.cmmn.exception.ApplicationException;

@Service("adaptorService")
public class AdaptorServiceImpl implements AdaptorService {
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Autowired
	private JavaMailSender mailSender;

	@Override
	public boolean sendEmail(EmailVO email, boolean isTransactional) {
		boolean isSuccess = true;
		try {
			MimeMessage message = mailSender.createMimeMessage();
			boolean isMultiPart = email.getFiles().size() == 0 ? false : true;
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, isMultiPart, "UTF-8");
			messageHelper.setFrom(email.getFrom());
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

}
