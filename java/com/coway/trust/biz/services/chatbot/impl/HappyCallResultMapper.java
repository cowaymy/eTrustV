package com.coway.trust.biz.services.chatbot.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("happyCallResultMapper")
public interface HappyCallResultMapper {

	List<EgovMap> selectHappyCallType();

	List<EgovMap> selectHappyCallResultList(Map<String, Object> params);

	List<EgovMap> selectHappyCallResultHistList(Map<String, Object> params);

	EgovMap  getUserInfo(Map<String, Object> params);
}
