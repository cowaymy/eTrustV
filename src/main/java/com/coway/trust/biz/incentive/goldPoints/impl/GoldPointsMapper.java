package com.coway.trust.biz.incentive.goldPoints.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("goldPointsMapper")
public interface GoldPointsMapper {

	int selectNextBatchId();

	int insertGoldPointsMst(Map<String, Object> master);

	void insertGoldPointsDtl(Map<String, Object> goldPointsList);

	void callGoldPointsConfirm(Map<String, Object> master);

	int selectNextRedemptionItemsBatchId();

	int insertRedemptionItemsMst(Map<String, Object> master);

	void insertRedemptionItemsDtl(Map<String, Object> rdmItmList);

	void callRedemptionItemsConfirm(Map<String, Object> master);

}
