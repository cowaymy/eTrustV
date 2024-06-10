package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.common.type.SMSTemplateType;
import com.coway.trust.cmmn.model.BulkSmsVO;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AdaptorService {
	/**
	 * mail 전송
	 *
	 * @param email
	 * @param isTransactional
	 *            : rollback 필요 한 경우 true, rollback 불필요 false
	 * @return 성공여부
	 */
	boolean sendEmail(EmailVO email, boolean isTransactional);

	boolean sendEmail(EmailVO email, boolean isTransactional, EmailTemplateType templateType,
			Map<String, Object> params);

	/**
	 * The speed is slow. It is mainly used for single-item transmission.
	 *
	 * 속도가 느린 편입니다. 단건 전송에 주로 사용합니다.
	 *
	 * @param smsVO
	 * @return
	 */
	SmsResult sendSMS(SmsVO smsVO);

	SmsResult sendSMS(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> params);

	/*
	 * 20210112 - LaiKW
	 * Duplicated from sendSMS
	 * Returns with additional SMS_ID information
	 */

	SmsResult sendSMS2(SmsVO smsVO);

	SmsResult sendSMS2(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> params);

	/**
	 * The transmission speed is fast and the price is relatively high. [Bulk shipment] Used mainly for invoicing and
	 * eStatement shipment.
	 *
	 * 전송속도가 빠르고 가격이 상대적으로 비쌉니다. 대량 발송...주로 인보이스 및 eStatement 발송에 사용됩니다.
	 *
	 * @param bulkSmsVO
	 * @return
	 */
	SmsResult sendSMSByBulk(BulkSmsVO bulkSmsVO);

	SmsResult sendSMSByBulk(BulkSmsVO bulkSmsVO, SMSTemplateType templateType, Map<String, Object> params);

	/**
	 * SmsResult의 msgId 로 실피한 건에 대해 조회. (매개 변수가 다중 매개 변수이면 쉼표로 구분됩니다)
	 *
	 * @param msgIds
	 *            If the parameter is a multi-parameter, it is separated by a comma. ( msgid01,msgid02,msgid03,msgid04)
	 * @return
	 */
	List<EgovMap> getFailList(String msgIds);

	/**
	 * get template string
	 *
	 * @param templateType
	 * @param params
	 * @return
	 */
	String getMailTextByTemplate(EmailTemplateType templateType, Map<String, Object> params);

	/**
	 * get template string
	 *
	 * @param templateType
	 * @param params
	 * @return
	 */
	String getSmsTextByTemplate(SMSTemplateType templateType, Map<String, Object> params);

	SmsResult sendSMS3(SmsVO smsVO);

	SmsResult sendSMS3(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> params);

	SmsResult sendSMS4(SmsVO smsVO);

  SmsResult sendSMS4(SmsVO smsVO, SMSTemplateType templateType, Map<String, Object> params);

}
