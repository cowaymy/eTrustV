package com.coway.trust.biz.payment.refund.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BatchRefundService {
	
	List<EgovMap> selectBatchRefundList(Map<String, Object> params);
	
	EgovMap selectBatchRefundInfo(Map<String, Object> params);
	
	List<EgovMap> selectBatchRefundItem(Map<String, Object> params);
	
	List<EgovMap> selectAccNoList(Map<String, Object> params);
	
	int saveBatchRefundUpload(Map<String, Object> master, List<Map<String, Object>> detailList);
	
	int batchRefundDeactivate(Map<String, Object> master);
	
	int batchRefundConfirm(Map<String, Object> master, Boolean isConvert);
	
	int batchRefundItemDisab(Map<String, Object> params);
	
}
