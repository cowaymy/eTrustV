package com.coway.trust.biz.payment.selfcare.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SelfCareHostToHostService {

	List<EgovMap> getSelfCareTransactionList(Map<String, Object> params);

	List<EgovMap> getSelfCareTransactionDetails(Map<String, Object> params);

	List<EgovMap> getSelfcareBatchDetailReport(Map<String, Object> params);

}