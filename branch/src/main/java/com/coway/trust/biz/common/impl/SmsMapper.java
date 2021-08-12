package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("smsMapper")
public interface SmsMapper {
	void insertSmsEntry(Map<String, Object> params);

	void insertGatewayReply(Map<String, Object> params);

	List<EgovMap> selectFailList(String msgIds);
}
