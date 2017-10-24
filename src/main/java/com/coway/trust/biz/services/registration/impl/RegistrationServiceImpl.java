package com.coway.trust.biz.services.registration.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.registration.RegistrationService;

@Service("registrationService")
public class RegistrationServiceImpl implements RegistrationService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RegistrationServiceImpl.class);

	@Autowired
	private RegistrationMapper registrationMapper;

	@Override
	public void saveHearLogs(List<Map<String, Object>> logs) {
		LOGGER.debug("saveHearLog....");
		for (Map<String, Object> log : logs) {
			registrationMapper.insertHeatLog(log);
		}
	}

	@Override
	public void updateSuccessStatus(String transactionId) {
		registrationMapper.updateSuccessStatus(transactionId);
	}
}
