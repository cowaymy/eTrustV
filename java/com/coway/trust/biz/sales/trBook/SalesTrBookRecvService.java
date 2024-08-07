package com.coway.trust.biz.sales.trBook;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SalesTrBookRecvService {

	List<EgovMap> selectTrBookRecvList(Map<String, Object> params);

	EgovMap selectTransitInfo(Map<String, Object> params);

	List<EgovMap> selectTransitList(Map<String, Object> params);

	void updateTransit(Map<String, Object> params);

	List<EgovMap> getbrnchList();
	
	List<EgovMap> getTransitListByTransitNo(Map<String, Object> params);
	
	List<EgovMap> trBookSummaryListing(Map<String, Object> params);
	
}
