/**************************************
 * Author	Date				Remark
 * Kyron		2023/08/15		Create for Bulk Point
 *
 ***************************************/
package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("RewardPointMapper")
public interface RewardPointMapper
{
	int getSAL0400MSEQ();

	int getSAL0401DSEQ();

	int saveRewardBulkPointMaster(Map<String, Object> params);

	int saveRewardBulkPointDetail(Map<String, Object> params);

	List<EgovMap> selectRewardBulkPointList(Map<String, Object> params);

	List<EgovMap> selectRewardBulkPointItem(Map<String, Object> params);

	void callRewardBulkPointValidateDet(Map<String, Object> params);

	int saveConfirmBatch(Map<String, Object> params);

	EgovMap selectBatchPaymentMs(Map<String, Object> params);

	int confirmRewardBulkPointMaster(Map<String, Object> params);

	int confirmRewardBulkPointDetail(Map<String, Object> params);
}