package com.coway.trust.biz.services.registration.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("registrationMapper")
public interface RegistrationMapper {

	void insertHeatLog(Map<String, Object> params);

	void updateSuccessStatus(String transactionId);
}
