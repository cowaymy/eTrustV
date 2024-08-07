package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**************************************
 * Author 	Date 				Remark
 * Kyron     2023/08/15    Create for Bulk Point
 *
 ***************************************/
public interface RewardPointService {

	int saveRewardBulkPointUpload(Map<String, Object> masterList, List<Map<String, Object>> detailList);

	List<EgovMap> selectRewardBulkPointList(Map<String, Object> params);

	List<EgovMap> selectRewardBulkPointItem(Map<String, Object> params);

	int approvalRewardBulkPoint(Map<String, Object> params);
}
