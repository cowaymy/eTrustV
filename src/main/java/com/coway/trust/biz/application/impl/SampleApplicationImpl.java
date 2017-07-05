package com.coway.trust.biz.application.impl;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.application.SampleApplication;
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
}
