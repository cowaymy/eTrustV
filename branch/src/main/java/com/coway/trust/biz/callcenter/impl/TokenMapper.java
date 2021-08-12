package com.coway.trust.biz.callcenter.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("tokenMapper")
public interface TokenMapper {
	String selectToken(Map<String, Object> params);
}
