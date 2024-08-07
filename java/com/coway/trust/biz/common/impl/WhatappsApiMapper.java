package com.coway.trust.biz.common.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("WhatappsApiMapper")
public interface WhatappsApiMapper {

	EgovMap checkAccess(Map<String, Object> params);
	void insertApiAccessLog(Map<String, Object> params);
}
