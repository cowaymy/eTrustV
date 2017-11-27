package com.coway.trust.biz.common.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("smsMapper")
public interface SmsMapper {
	void insertSmsEntry(Map<String, Object> params);

	void insertGatewayReply(Map<String, Object> params);
}
