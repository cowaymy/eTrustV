package com.coway.trust.biz.common;

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
	
	boolean sendSMS();
}
