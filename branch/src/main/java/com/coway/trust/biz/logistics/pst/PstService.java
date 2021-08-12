package com.coway.trust.biz.logistics.pst;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PstService {

	List<EgovMap> PstSearchList(Map<String, Object> map);
	
	void pstMovementReqDelivery(Map<String, Object> map);
	
	void testsample();
	
	List<EgovMap> PstMaterialDocViewList(Map<String, Object> map);

	// KR OHK : PST Serial Check Popup
	List<EgovMap> selectPstIssuePop(Map<String, Object> smap);
	// KR-OHK Serial add
	void pstMovementReqDeliverySerial(Map<String, Object> map);
}
