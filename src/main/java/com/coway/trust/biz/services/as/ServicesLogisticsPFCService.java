package com.coway.trust.biz.services.as;

import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ServicesLogisticsPFCService {


	 Map<String, Object>   SP_LOGISTIC_REQUEST(Map<String, Object> param);
	 Map<String, Object>   SP_SVC_LOGISTIC_REQUEST(Map<String, Object> param);
	 void install_Active_SP_LOGISTIC_REQUEST(Map<String, Object> param);

	 //get AVAILABLE_INVENTORY
	 EgovMap   getFN_GET_SVC_AVAILABLE_INVENTORY(Map<String, Object> param);

	 // KR_HAN ADD
	 Map<String, Object>   SP_SVC_LOGISTIC_REQUEST_SERIAL(Map<String, Object> param);

	 // KR-JIN ADD
	 public EgovMap SP_SVC_BARCODE_SAVE(Map<String, Object> params);
	 public Map<String, Object> SP_LOGISTIC_REQUEST_REVERSE_SERIAL(Map<String, Object> param);
}
