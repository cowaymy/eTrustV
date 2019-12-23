package com.coway.trust.biz.logistics.inbound;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InboundService {

	List<EgovMap> inBoundList(Map<String, Object> params);

	List<EgovMap> inboundLocation(Map<String, Object> params);

	List<EgovMap> receiptList(Map<String, Object> params);

	List<EgovMap> inboundLocationPort(Map<String, Object> params);

	Map<String, Object> reqSTO(Map<String, Object> params);

	List<EgovMap> searchSMO(Map<String, Object> params);

	void receipt(Map<String, Object> params);

	// KR HAN
	Map<String, Object> receiptSerial(Map<String, Object> params);
}
