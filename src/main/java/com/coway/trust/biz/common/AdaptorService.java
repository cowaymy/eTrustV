package com.coway.trust.biz.common;

import com.coway.trust.cmmn.model.BulkSmsVO;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;

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

	/**
	 * The speed is slow. It is mainly used for single-item transmission.
	 *
	 * 속도가 느린 편입니다. 단건 전송에 주로 사용합니다.
	 *
	 * @param smsVO
	 * @return
	 */
	SmsResult sendSMS(SmsVO smsVO);

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
}
