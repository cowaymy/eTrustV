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


}
