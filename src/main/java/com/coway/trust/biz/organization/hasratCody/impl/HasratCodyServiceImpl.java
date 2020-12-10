/**
 *
 */
package com.coway.trust.biz.organization.hasratCody.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.apache.velocity.app.VelocityEngine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.organization.hasratCody.HasratCodyService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Oct 12, 2020
 *
 */
@Service("hasratCodyService")
public class HasratCodyServiceImpl extends EgovAbstractServiceImpl implements HasratCodyService{
	private static final Logger logger = LoggerFactory.getLogger(HasratCodyService.class);

	@Resource(name="hasratCodyMapper")
	private HasratCodyMapper hasratCodyMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Value("${mail.hasratCody.config.from}")
	private String from;

	@Value("${mail.hasratCody.config.to}")
	private String to;


	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private VelocityEngine velocityEngine;


	public List<EgovMap> selectHasratCodyList(Map<String, Object> params){
		return hasratCodyMapper.selectHasratCodyList(params);
	}

	public void insertHasratCody(Map<String, Object> params){
		try {
			hasratCodyMapper.insertHasratCody(params);
		}catch (Exception e){
			logger.error(e.getMessage());
		}
	}

	public List<EgovMap> selectCodyBranchList(Map<String, Object> params){
		return hasratCodyMapper.selectCodyBranchList(params);
	}

	public EgovMap selectUserInfo (Map<String, Object> params) {
		return hasratCodyMapper.selectUserInfo(params);
	}

	private boolean sendEmail(EmailVO email, boolean isTransactional, Map<String, Object> params) {
		boolean isSuccess = true;
		try {
			MimeMessage message = mailSender.createMimeMessage();
			boolean isMultiPart = email.getFiles().size() == 0 ? false : true;
			isMultiPart = email.getHasInlineImage();

			MimeMessageHelper messageHelper = new MimeMessageHelper(message, isMultiPart, AppConstants.DEFAULT_CHARSET);
			messageHelper.setFrom(from);
			messageHelper.setTo(email.getTo().toArray(new String[email.getTo().size()]));
			messageHelper.setSubject(email.getSubject());

			messageHelper.setText(email.getText(), email.isHtml());

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


	public boolean sendContentEmail(Map<String, Object> params) throws Exception {

		EmailVO email = new EmailVO();
		List<String> toList = new ArrayList<String>();

		if (params != null && params.get("ncodyEmail") != null){
			//toList.add(params.get("ncodyEmail").toString().trim());
			toList.add("huiding.teoh@coway.com.my");
			toList.add(to);
		} else {
			Exception e = new Exception("Error Email - null");
			throw(e);
		}

		String subject = "New Hasrat CODY (" + params.get("ncodyCode") + ")";
		String content = params.get("neContent").toString();

		email.setTo(toList);
		email.setHtml(true);
		email.setSubject(subject);
		email.setText(content);

		boolean isSuccess = this.sendEmail(email, false, null);

		return isSuccess;
	}
}
