package com.coway.trust.biz.api.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ChatbotInboundApiMapper")
public interface ChatbotInboundApiMapper {
	EgovMap checkAccess(Map<String, Object> params);
	List<EgovMap> verifyCustIdentity(Map<String, Object> params);
	int isCustExist(Map<String, Object> params);
	List<EgovMap> getOrderList(Map<String, Object> params);
	int CBT0006M_insert(Map<String, Object> params);
	EgovMap getSoaDet(Map<String, Object> params);
	EgovMap getInvoiceDet(Map<String, Object> params);

	List<Map<String, Object>> getGenPdfList(Map<String, Object> params);
	int insertBatchEmailSender(Map<String, Object> params);
	int update_CBT0006M_Stus(Map<String, Object> params);
}
