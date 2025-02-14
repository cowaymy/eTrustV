package com.coway.trust.biz.services.chatbot.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("chatbotMapper")
public interface ChatbotMapper {
	  EgovMap getCustWADetailsByOrd(Map<String, Object> params);

	  int getCBT0007M_Seq();

	  void insertWAAppointment(Map<String,Object> params);

	  void updateCallLogWAStatus(Map<String,Object> params);
}
