package com.coway.trust.biz.incentive.goldPoints.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

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

	List<EgovMap> selectPointsSummaryList(Map<String, Object> params);

	EgovMap selectMemInfo(Map<String, Object> params);

	List<EgovMap> selectPointsExpiryList(Map<String, Object> params);

	EgovMap selectRedemptionBasicInfo(Map<String, Object> params);

	EgovMap getOrgDtls(Map<String, Object> params);

	List<EgovMap> searchRedemptionItemList(Map<String, Object> params);

	List<EgovMap> searchItemCategoryList(Map<String, Object> params);

	int selectNextRedemptionId();

	String getNextRedemptionNo();

	int insertNewRedemption(Map<String, Object> params);

	void processRedemption(Map<String, Object> params);

	List<EgovMap> selectTransactionHistoryList(Map<String, Object> params);

	List<EgovMap> selectRedemptionList(Map<String, Object> params);

	void cancelRedemption(Map<String, Object> params);

	List<EgovMap> selectRedemptionDetails(Map<String, Object> params);

	int updateRedemption(Map<String, Object> params);

	String getEmailTitle(Map<String, Object> params);

	String getEmailDetails(Map<String, Object> params);

	EgovMap selectRedemptionDetailsEmail(Map<String, Object> params);

	List<EgovMap> selectPointsUploadList(Map<String, Object> params);

	EgovMap selectPointsBatchMaster(Map<String, Object> params);

	List<EgovMap> selectPointsBatchDetail(Map<String, Object> params);

	void callPointsUploadConfirm(Map<String, Object> params);

	int updPointsUploadReject(Map<String, Object> params);

	void adminCancelRedemption(Map<String, Object> params);

	void adminForfeitRedemption(Map<String, Object> params);

	List<EgovMap> selectRedemptionItemList(Map<String, Object> params);

}
