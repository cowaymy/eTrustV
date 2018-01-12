package com.coway.trust.biz.sales.trBook.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("salesTrBookRecvMapper")
public interface SalesTrBookRecvMapper {

	List<EgovMap> selectTrBookRecvList(Map<String, Object> params);

	EgovMap selectTransitInfo(Map<String, Object> params);

	List<EgovMap> selectTransitList(Map<String, Object> params);

	Object selectTransitDetailInfo(Map<String, Object> param);

	void updateTransitDetail(Map<String, Object> param);

	Object selectTransitM(Map<String, Object> params);

	void updateTransitM(Map<String, Object> params);

	List<EgovMap> getbrnchList();
	
	List<EgovMap> getTransitListByTransitNo(Map<String, Object> params);
	
	List<EgovMap> trBookSummaryListing(Map<String, Object> params);

}
