package com.coway.trust.biz.sales.pst;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PSTDealerService {

	List<EgovMap> pstDealerList(Map<String, Object> params);
	
	EgovMap pstDealerDtBasicInfo(Map<String, Object> params);
	
	EgovMap pstDealerDtUserInfo(Map<String, Object> params);
	
	List<EgovMap> pstDealerAddrComboList(Map<String, Object> params);
	
	EgovMap getAreaId (Map<String, Object> params);
	
	void newDealer(Map<String, Object> params);
	
	List<EgovMap> dealerBrnchList();
	
	void editDealer(Map<String, Object> params);
	
	void updDealerCntSAL0032D(Map<String, Object> params);
}
