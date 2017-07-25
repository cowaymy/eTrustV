package com.coway.trust.biz.application.impl;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.application.SampleApplication;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.EmailVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample2.Sample2Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 서비스에서 서비스를 호출 하게되는 경우는 업무 + Application 클래스를 작성하여 서비스 각각의 서비스를 Injection 하여 사용함을 원칙으로 한다.
 * 
 * - [참고] Application에서 서비스 호출을 try{}catch{} 로 묶더라도 롤백 됨. Service 함수에서 try{}catch{} 처리를 해야 롤백 안됨.
 * 
 * @author lim
 *
 */
@Service("sampleApplication")
public class SampleApplicationImpl extends EgovAbstractServiceImpl implements SampleApplication {

	private static final Logger logger = LoggerFactory.getLogger(SampleApplicationImpl.class);

	@Autowired
	private SampleService sampleService;

	@Autowired
	private Sample2Service sample2Service;
	
	@Autowired
	private AdaptorService adaptorService;

	@Override
	public void saveMultiService(Map<String, Object> params) {
		// test 용입니다.
		params.put("id", "transaction.test.99");
		params.put("language", "en");
		params.put("country", "EN");
		params.put("message", "another service test 99 !!!");

		sampleService.insertSample(params);
		sample2Service.saveTransactionForRollback(params);
	}

	/**
	 * 서비스 로직 + 메일 전송 예제.
	 */
	@Override
	public void sendEmailAndProcess(Map<String, Object> params) {

		// 1. service 로직...
		// sampleService.insertClobData(params);

		// 2. mail 처리.
		EmailVO email = new EmailVO();
		email.setFrom("test@mail.com");
		email.setTo("t1706036@partner.coway.co.kr");
		email.setHtml(false);
		email.setSubject("subject");
		email.setText("email text");

		/**
		 * isTransactional == true : 메일 전송 실패시 rollback 처리고 ApplicationException 발생.
		 * isTransactional == false : 메일 전송 실패시 그냥 진행. 결과는 true/false 로 확인. 
		 */
		boolean isSuccess = adaptorService.sendEmail(email, false);
		
	}
}
