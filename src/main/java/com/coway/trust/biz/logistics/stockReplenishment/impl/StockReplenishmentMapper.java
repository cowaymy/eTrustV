package com.coway.trust.biz.logistics.stockReplenishment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("StockReplenishmentMapper")

public interface StockReplenishmentMapper {

	List<EgovMap> selectWeekList(Map<String, Object> params);

	List<EgovMap> selectSroForecastHistoryList(Map<String, Object> params);

	List<EgovMap> selectSroSafetyLvlList(Map<String, Object> params);

	int updateMergeLOG0119M(Map<String, Object> params);

	List<EgovMap> selectSroLocationType(Map<String, Object> params);

	List<EgovMap> selectSroStatus(Map<String, Object> params);


}
