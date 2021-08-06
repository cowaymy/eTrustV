package com.coway.trust.biz.incentive.goldPoints;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GoldPointsService {

	int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList );

	int saveCsvRedemptionItems(Map<String, Object> master, List<Map<String, Object>> detailList);

	List<EgovMap> selectPointsSummaryList(Map<String, Object> params);

	EgovMap selectMemInfo(Map<String, Object> params);

	List<EgovMap> selectPointsExpiryList(Map<String, Object> params);

	EgovMap selectRedemptionBasicInfo(Map<String, Object> params);

	String getOrgDtls(Map<String, Object> params);

	List<EgovMap> searchItemCategoryList(Map<String, Object> params);

	List<EgovMap> searchRedemptionItemList(Map<String, Object> params);

	Map<String, Object> createNewRedemption(Map<String, Object> params);

	int sendNotification(Map<String, Object> params);

	List<EgovMap> selectTransactionHistoryList(Map<String, Object> params);

}
