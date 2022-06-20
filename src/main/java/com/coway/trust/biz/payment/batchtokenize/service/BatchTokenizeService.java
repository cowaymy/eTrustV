package com.coway.trust.biz.payment.batchtokenize.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface BatchTokenizeService {
		List<EgovMap> verifyRecord(Map<String, Object> params);

		EgovMap processBatchTokenizeRecord();

		List<EgovMap> getCardDetails(EgovMap BatchID);

		List<EgovMap> selectBatchTokenizeRecord(Map<String, Object> params);

		EgovMap batchTokenizeDetail(Map<String, Object> params);

		List<EgovMap> batchTokenizeViewItmJsonList(Map<String, Object> params);


}

