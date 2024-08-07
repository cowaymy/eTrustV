package com.coway.trust.biz.sample2.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("sample2Mapper")
public interface Sample2Mapper {
	void insertSampleByMap(Map<String, Object> params);
}
