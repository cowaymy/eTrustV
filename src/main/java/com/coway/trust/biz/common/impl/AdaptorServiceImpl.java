package com.coway.trust.biz.common.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.coway.trust.util.UUIDGenerator;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("adaptorService")
public class AdaptorServiceImpl implements AdaptorService {
	private static final Logger LOGGER = LoggerFactory.getLogger(AdaptorServiceImpl.class);

	private static final String GENSUITE_SUCCESS = "success";
	private static final String MVGATE_SUCCESS = "000";
	private static final String GI_SUCCESS = "success";

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

	@Value("${sms.preccp.gensuite.client.id}")
	private String preccpGensuiteClientId;

	@Value("${sms.preccp.gensuite.user.name}")
	private String preccpGensuiteUserName;

	@Value("${sms.preccp.gensuite.password}")
	private String preccpGensuitePassword;

//SMS g-i
  @Value("${sms.gi.host}")
  private String giHost;
  @Value("${sms.gi.path}")
  private String giPath;
  @Value("${sms.gi.user.name}")
  private String giUserName;
  @Value("${sms.gi.password}")
  private String giPassword;
  @Value("${sms.gi.country.code}")
  private String giCountryCode;

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

	public boolean sendEmailSupp(EmailVO email, boolean isTransactional) {
		return this.sendEmailSupp(email, isTransactional, null, null);
	}

	@Override
	public boolean sendEmail(EmailVO email, boolean isTransactional, EmailTemplateType templateType,
			Map<String, Object> params) {
		boolean isSuccess = true;
		try {
			MimeMessage message = mailSender.createMimeMessage();
			boolean hasFile = email.getFiles().size() == 0 ? false : true;
			boolean hasInlineImage = email.getHasInlineImage();	//for attaching image in HTML inline
			boolean isMultiPart = hasFile || hasInlineImage;

			MimeMessageHelper messageHelper = new MimeMessageHelper(message, isMultiPart, AppConstants.DEFAULT_CHARSET);
			messageHelper.setFrom(from);
			messageHelper.setTo(email.getTo().toArray(new String[email.getTo().size()]));
			messageHelper.setSubject(email.getSubject());

			if (templateType != null) {
				messageHelper.setText(getMailTextByTemplate(templateType, params), email.isHtml());
			} else {
				messageHelper.setText(email.getText(), email.isHtml());
			}


			if (isMultiPart && email.getHasInlineImage()) {
				try {
					messageHelper.addInline("coway_header", new ClassPathResource("template/stylesheet/images/coway_header.png"));
				} catch (Exception e) {
					LOGGER.error(e.toString());
					throw new ApplicationException(e, AppConstants.FAIL, e.getMessage());
				}
			} else if (isMultiPart) {
				email.getFiles().forEach(file -> {
					try {
						messageHelper.addAttachment(file.getName(), file);
					} catch (Exception e) {
						LOGGER.error(e.toString());
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
	public boolean sendEmailSupp(EmailVO email, boolean isTransactional, EmailTemplateType templateType,
			Map<String, Object> params) {
		boolean isSuccess = true;
		try {
			MimeMessage message = mailSender.createMimeMessage();
			boolean hasFile = email.getFiles().size() == 0 ? false : true;
			boolean hasInlineImage = email.getHasInlineImage();	//for attaching image in HTML inline
			boolean isMultiPart = hasFile || hasInlineImage;

			MimeMessageHelper messageHelper = new MimeMessageHelper(message, isMultiPart, AppConstants.DEFAULT_CHARSET);
			messageHelper.setFrom(from);
			messageHelper.setTo(email.getTo().toArray(new String[email.getTo().size()]));
			messageHelper.setSubject(email.getSubject());

			if (templateType != null) {
				messageHelper.setText(getMailTextByTemplate(templateType, params), email.isHtml());
			} else {
				messageHelper.setText(email.getText(), email.isHtml());
			}


			if (isMultiPart && email.getHasInlineImage()) {
				try {
					messageHelper.addInline("coway_header", new ClassPathResource("template/stylesheet/images/coway_logo.png"));
				} catch (Exception e) {
					LOGGER.error(e.toString());
					throw new ApplicationException(e, AppConstants.FAIL, e.getMessage());
				}
			} else if (isMultiPart) {
				email.getFiles().forEach(file -> {
					try {
						messageHelper.addAttachment(file.getName(), file);
					} catch (Exception e) {
						LOGGER.error(e.toString());
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
	public SmsResult sendSMS(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> templateParams) {

		if (smsVO.getMobiles().size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "required mobiles.....");
		}

		Map<String, String> reason = new HashMap<>();
		SmsResult result = new SmsResult();
		result.setReqCount(smsVO.getMobiles().size());

		if (templateType != null) {
			smsVO.setMessage(getSmsTextByTemplate(templateType, templateParams));
		}

		String msgId = UUIDGenerator.get();
		result.setMsgId(msgId);
		int vendorId = 2;
		smsVO.getMobiles().forEach(mobileNo -> {
			String smsUrl;
			try {
				smsUrl = "https://" + gensuiteHost + gensuitePath + "?" + "ClientID=" + gensuiteClientId + "&Username="
						+ gensuiteUserName + "&Password=" + gensuitePassword + "&Type=" + gensuiteType + "&Message="
						+ URLEncoder.encode("RM0 " + smsVO.getMessage(), StandardCharsets.UTF_8.name())
//								.replaceAll("\\+", " ").replaceAll("%40", "@").replaceAll("%21", "!")
//								.replaceAll("%23", "#").replaceAll("%24", "$").replaceAll("%3A", ":")
//								.replaceAll("%28", "(").replaceAll("%2F", "/").replaceAll("%29", ")")
//								.replaceAll("%26", "&").replaceAll("%3C", "<").replaceAll("%60", "`")
//								.replaceAll("%7E", "~").replaceAll("%24", "$").replaceAll("%5E", "^")
//								.replaceAll("%5F", "_").replaceAll("%7B", "{").replaceAll("%7D", "}")
//								.replaceAll("%7C", "|").replaceAll("%5B", "[").replaceAll("%5D", "]")
//								.replaceAll("%3F", "?").replaceAll("%0A", "\n")
						+ "&SenderID=" + gensuiteSenderId + "&Phone=" + gensuiteCountryCode + mobileNo
						+ "&Concatenated=1&MsgID=" + msgId;
			} catch (UnsupportedEncodingException e) {
				throw new ApplicationException(e, AppConstants.FAIL);
			}

			LOGGER.debug("SMS URL >>>>>>>>>>>>>>>>{}" ,smsUrl);

			Client client = Client.create();
			WebResource webResource = client.resource(smsUrl);
			ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
			String output = response.getEntity(String.class);

			int statusId;
			String body;

			if (response.getStatus() == AppConstants.RESPONSE_CODE_SUCCESS) {
				body = output.trim();

				LOGGER.debug("SMS response.getStatus() >>>>>>>>>>>>>>>>{}" ,response.getStatus());

				if (GENSUITE_SUCCESS.equals(body)) {
					statusId = 4;
					result.setSuccessCount(result.getSuccessCount() + 1);

					LOGGER.debug("SMS GENSUITE_SUCCESS >>>>>>>>>>>>>>>>{}" ,body);

				} else {
					statusId = 21;
					result.setFailCount(result.getFailCount() + 1);
					reason.clear();
					reason.put(mobileNo, body);
					result.addFailReason(reason);
				}

			} else {
				statusId = 1;
				body = output;
				result.setErrorCount(result.getErrorCount() + 1);
			}

			insertSMS(mobileNo, smsVO.getMessage(), smsVO.getUserId(), smsVO.getPriority(), smsVO.getExpireDayAdd(),
					smsVO.getSmsType(), smsVO.getRemark(), statusId, smsVO.getRetryNo(), body, output, msgId, vendorId);
		});

		return result;
	}

	/* 20211112 - LaiKW - Duplicate sendSMS with result returning SMS ID - Start */
	@Override
    public SmsResult sendSMS2(SmsVO smsVO) {
        return this.sendSMS2(smsVO, null, null);
    }

    @Override
    public SmsResult sendSMS2(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> templateParams) {

        if (smsVO.getMobiles().size() == 0) {
            throw new ApplicationException(AppConstants.FAIL, "required mobiles.....");
        }

        Map<String, String> reason = new HashMap<>();
        SmsResult result = new SmsResult();
        result.setReqCount(smsVO.getMobiles().size());

        if (templateType != null) {
            smsVO.setMessage(getSmsTextByTemplate(templateType, templateParams));
        }

        String msgId = UUIDGenerator.get();
        result.setMsgId(msgId);
        int vendorId = 2;
        smsVO.getMobiles().forEach(mobileNo -> {
            String smsUrl;
            try {
                smsUrl = "https://" + gensuiteHost + gensuitePath + "?" + "ClientID=" + gensuiteClientId + "&Username="
                        + gensuiteUserName + "&Password=" + gensuitePassword + "&Type=" + gensuiteType + "&Message="
                        + URLEncoder.encode("RM0.00 " + smsVO.getMessage(), StandardCharsets.UTF_8.name())
//                              .replaceAll("\\+", " ").replaceAll("%40", "@").replaceAll("%21", "!")
//                              .replaceAll("%23", "#").replaceAll("%24", "$").replaceAll("%3A", ":")
//                              .replaceAll("%28", "(").replaceAll("%2F", "/").replaceAll("%29", ")")
//                              .replaceAll("%26", "&").replaceAll("%3C", "<").replaceAll("%60", "`")
//                              .replaceAll("%7E", "~").replaceAll("%24", "$").replaceAll("%5E", "^")
//                              .replaceAll("%5F", "_").replaceAll("%7B", "{").replaceAll("%7D", "}")
//                              .replaceAll("%7C", "|").replaceAll("%5B", "[").replaceAll("%5D", "]")
//                              .replaceAll("%3F", "?").replaceAll("%0A", "\n")
                        + "&SenderID=" + gensuiteSenderId + "&Phone=" + gensuiteCountryCode + mobileNo
                        + "&Concatenated=1&MsgID=" + msgId;
            } catch (UnsupportedEncodingException e) {
                throw new ApplicationException(e, AppConstants.FAIL);
            }

            LOGGER.debug("SMS 2 URL >>>>>>>>>>>>>>>>{}" ,smsUrl);

            Client client = Client.create();
            WebResource webResource = client.resource(smsUrl);
            ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
            String output = response.getEntity(String.class);

            int statusId;
            String body;

            if (response.getStatus() == AppConstants.RESPONSE_CODE_SUCCESS) {
                body = output.trim();

                LOGGER.debug("SMS 2 response.getStatus()  >>>>>>>>>>>>>>>>{}" ,response.getStatus());

                if (GENSUITE_SUCCESS.equals(body)) {
                    statusId = 4;
                    result.setSuccessCount(result.getSuccessCount() + 1);

                    LOGGER.debug("SMS 2 GENSUITE_SUCCESS  >>>>>>>>>>>>>>>>{}" ,body);

                } else {
                    statusId = 21;
                    result.setFailCount(result.getFailCount() + 1);
                    reason.clear();
                    reason.put(mobileNo, body);
                    result.addFailReason(reason);
                }

            } else {
                statusId = 1;
                body = output;
                result.setErrorCount(result.getErrorCount() + 1);
            }

            int smsId = insertSMS(mobileNo, smsVO.getMessage(), smsVO.getUserId(), smsVO.getPriority(), smsVO.getExpireDayAdd(),
                    smsVO.getSmsType(), smsVO.getRemark(), statusId, smsVO.getRetryNo(), body, output, msgId, vendorId);

            result.setSmsStatus(statusId);
            result.setSmsId(smsId);
        });

        return result;
    }
    /* 20211112 - LaiKW - Duplicate sendSMS with result returning SMS ID - End */


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
	public SmsResult sendSMSByBulk(BulkSmsVO bulkSmsVO, SMSTemplateType templateType,
			Map<String, Object> templateParams) {

		if (CommonUtils.isEmpty(bulkSmsVO.getMobile())) {
			throw new ApplicationException(AppConstants.FAIL, "required mobiles.....");
		}

		SmsResult result = new SmsResult();
		Map<String, String> reason = new HashMap<>();
		result.setReqCount(1);

		if (templateType != null) {
			bulkSmsVO.setMessage(getSmsTextByTemplate(templateType, templateParams));
		}

		String trId = UUIDGenerator.get();
		int vendorId = 1;
		result.setMsgId(trId);
		String smsUrl;
		try {
			smsUrl = "http://" + mvgateHost + mvgatePath + "?to=" + mvgateCountryCode + bulkSmsVO.getMobile()
					+ "&token=" + mvgateToken + "&username=" + mvgateUserName + "&password=" + mvgatePassword + "&code="
					+ mvgateCode + "&mt_from=" + mvgateMtFrom + "&text="
					+ URLEncoder.encode(bulkSmsVO.getMessage(), "UTF-8") + "&lang=0&trid=" + trId;
		} catch (UnsupportedEncodingException e) {
			throw new ApplicationException(e);
		}

		Client client = Client.create();
		WebResource webResource = client.resource(smsUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		String output = response.getEntity(String.class);

		int statusId;
		String body;
		String retCode;
		if (response.getStatus() == 200) {

			body = output;
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
			body = output;
			retCode = String.valueOf(response.getStatus());
			result.setErrorCount(result.getErrorCount() + 1);
		}

		insertSMS(bulkSmsVO.getMobile(), bulkSmsVO.getMessage(), bulkSmsVO.getUserId(), bulkSmsVO.getPriority(),
				bulkSmsVO.getExpireDayAdd(), bulkSmsVO.getSmsType(), bulkSmsVO.getRemark(), statusId,
				bulkSmsVO.getRetryNo(), retCode, body, trId, vendorId);

		return result;
	}

	@Override
	public List<EgovMap> getFailList(String msgIds) {
		return smsMapper.selectFailList(msgIds);
	}

	/**
	 * https://www.obkb.com/dcljr/charstxt.html 참조.
	 *
	 * @param value
	 * @return
	 */
	// private String changeToHex(String value) {
	// if (StringUtils.isEmpty(value)) {
	// return "";
	// }
	//
	// String returnValue = value;
	// returnValue = returnValue.replaceAll("&", "%26");
	// returnValue = returnValue.replaceAll("<", "%3C");
	// returnValue = returnValue.replaceAll("`", "%60");
	// returnValue = returnValue.replaceAll("~", "%7E");
	// returnValue = returnValue.replaceAll("$", "%24");
	// returnValue = returnValue.replaceAll("^", "%5E");
	// returnValue = returnValue.replaceAll("_", "%5F");
	// returnValue = returnValue.replaceAll("\\{", "%7B");
	// returnValue = returnValue.replaceAll("}", "%7D");
	// returnValue = returnValue.replaceAll("|", "%7C");
	// returnValue = returnValue.replaceAll("\\[", "%5B");
	// returnValue = returnValue.replaceAll("]", "%5D");
	// returnValue = returnValue.replaceAll("\\+", "%20");
	// return returnValue;
	// }

	private int insertSMS(String mobileNo, String message, int senderUserId, int priority, int expireDayAdd,
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

		return (int) params.get("smsId");
	}


	@Override
    public SmsResult sendSMS3(SmsVO smsVO) {
        return this.sendSMS3(smsVO, null, null);
    }

    @Override
    public SmsResult sendSMS3(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> templateParams) {

        if (smsVO.getMobiles().size() == 0) {
            throw new ApplicationException(AppConstants.FAIL, "required mobiles.....");
        }

        Map<String, String> reason = new HashMap<>();
        SmsResult result = new SmsResult();
        result.setReqCount(smsVO.getMobiles().size());

        if (templateType != null) {
            smsVO.setMessage(getSmsTextByTemplate(templateType, templateParams));
        }

        String msgId = UUIDGenerator.get();
        result.setMsgId(msgId);
        int vendorId = 2;
        smsVO.getMobiles().forEach(mobileNo -> {
            String smsUrl;
            try {
                smsUrl = "https://" + gensuiteHost + gensuitePath + "?" + "ClientID=" + preccpGensuiteClientId + "&Username="
                        + preccpGensuiteUserName + "&Password=" + preccpGensuitePassword + "&Type=" + gensuiteType + "&Message="
                        + URLEncoder.encode("RM0.00 " + smsVO.getMessage(), StandardCharsets.UTF_8.name())
                        + "&SenderID=" + gensuiteSenderId + "&Phone=" + gensuiteCountryCode + mobileNo
                        + "&Concatenated=1&MsgID=" + msgId;
            } catch (UnsupportedEncodingException e) {
                throw new ApplicationException(e, AppConstants.FAIL);
            }

            Client client = Client.create();
            WebResource webResource = client.resource(smsUrl);
            ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
            String output = response.getEntity(String.class);

            int statusId;
            String body;

            if (response.getStatus() == 200) {
                body = output.trim();

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
                body = output;
                result.setErrorCount(result.getErrorCount() + 1);
            }

            int smsId = insertSMS(mobileNo, smsVO.getMessage(), smsVO.getUserId(), smsVO.getPriority(), smsVO.getExpireDayAdd(),
                    smsVO.getSmsType(), smsVO.getRemark(), statusId, smsVO.getRetryNo(), body, output, msgId, vendorId);

            result.setSmsStatus(statusId);
            result.setSmsId(smsId);
        });

        return result;
    }

    //20231211 - Added New Vendor - VendorId 4 --g-i (Pre-booking SMS)
    // Add by Fannie
    @Override
    public SmsResult sendSMS4(SmsVO smsVO) {
      return this.sendSMS4(smsVO, null, null);
    }

    //20231211 - Added New Vendor - VendorId 4 --g-i (Pre-booking SMS)
    public SmsResult sendSMS4(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> templateParams) {

      if (smsVO.getMobiles().size() == 0) {
        throw new ApplicationException(AppConstants.FAIL, "required mobiles.....");
      }

      Map<String, String> reason = new HashMap<>();
      SmsResult result = new SmsResult();
      result.setReqCount(smsVO.getMobiles().size());

      if (templateType != null) {
        smsVO.setMessage(getSmsTextByTemplate(templateType, templateParams));
      }

      String msgId = UUIDGenerator.get();
      result.setMsgId(msgId);
      int vendorId = 4;
      smsVO.getMobiles().forEach(mobileNo -> {
        String smsUrl;
        try {
          smsUrl = "http://" + giHost + giPath + "?user=" + giUserName + "&secret=" + giPassword
              + "&phone_number=" + giCountryCode + smsVO.getMobiles()
              + "&text=" + URLEncoder.encode(smsVO.getMessage(), "UTF-8")
              + "&is_long_message=true"
              + "&is_two_way=true";
           //http://47.254.203.181/api/send?user=gi_xHdw6&secret=VpHVSMLS1E4xa2vq7qtVYtb7XJIBDB&phone_number=6014225372&text=testing123&is_long_message=true&is_two_way=true
        } catch (UnsupportedEncodingException e) {
          throw new ApplicationException(e, AppConstants.FAIL);
        }

        LOGGER.debug("SMS URL >>>>>>>>>>>>>>>>{}" ,smsUrl);

        Client client = Client.create();
        WebResource webResource = client.resource(smsUrl);
        ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
        String output = response.getEntity(String.class);

        int statusId;
        String body = null;

          body = output;

          ObjectMapper objectMapper = new ObjectMapper();
          JsonNode jsonNode = null;
          try {
            jsonNode = objectMapper.readTree(body);

          } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
          }

          if(jsonNode.get("success").asText().equals("true")){
            body = "success";
            output = "success";
            statusId = 4;
            result.setSuccessCount(result.getSuccessCount() + 1);
          } else {
            body= jsonNode.get("error_code").asText();
            output = jsonNode.get("error_message").asText();
            statusId = 21;
            result.setFailCount(result.getFailCount() + 1);
            reason.clear();
            reason.put(mobileNo, body);
            result.addFailReason(reason);
            result.setErrorCount(result.getErrorCount() + 1);
          }

        insertSMS(mobileNo, smsVO.getMessage(), smsVO.getUserId(), smsVO.getPriority(), smsVO.getExpireDayAdd(),
            smsVO.getSmsType(), smsVO.getRemark(), statusId, smsVO.getRetryNo(), body, output, msgId, vendorId);
      });

      return result;
    }
}
