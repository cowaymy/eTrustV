package com.coway.trust.biz.sample2.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sample2.Sample2Service;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("sample2Service")
public class Sample2ServiceImpl extends EgovAbstractServiceImpl implements Sample2Service {

	private static final Logger LOGGER = LoggerFactory.getLogger(Sample2ServiceImpl.class);

	@Resource(name = "sample2Mapper")
	private Sample2Mapper sample2Mapper;

	@Override
	public String saveTransactionForRollback(Map<String, Object> params) {

		// test 용입니다.
		params.put("id", "transaction.test.01");
		params.put("language", "en");
		params.put("country", "EN");
		params.put("message", "transaction test 01 !!!");

		sample2Mapper.insertSampleByMap(params);

		// test 용입니다.
		params.put("id", "transaction.test.02");
		params.put("language", "en");
		params.put("country", "EN");
		params.put("message", "transaction test 02 !!!");

		sample2Mapper.insertSampleByMap(params);

		LOGGER.debug("before exception");
		// 아래의 exception으로 인해 위의 insert 가 rollback 됩니다.
		throw new ApplicationException(AppConstants.FAIL, "transaction fail Test...");

	}

}
