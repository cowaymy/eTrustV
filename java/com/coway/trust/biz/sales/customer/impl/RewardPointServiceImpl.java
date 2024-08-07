/**************************************
 * Author	Date				Remark
 * Kyron		2023/08/15		Create for Bulk Point
 *
 ***************************************/
package com.coway.trust.biz.sales.customer.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;


import com.coway.trust.biz.sales.customer.RewardPointService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("RewardPointService")
public class RewardPointServiceImpl implements RewardPointService {

	private static final Logger logger = LoggerFactory.getLogger(RewardPointServiceImpl.class);

	@Resource(name = "RewardPointMapper")
	private RewardPointMapper rewardPointMapper;

	@Override
	public int saveRewardBulkPointUpload(Map<String, Object> masterList, List<Map<String, Object>> detailList) {
		int masterSeq = rewardPointMapper.getSAL0400MSEQ();
		masterList.put("tierId", masterSeq);

		int mResult = rewardPointMapper.saveRewardBulkPointMaster(masterList);
		int dResult = 0;

		logger.debug("============= mResult  ", mResult);

		if (mResult > 0 && detailList.size() > 0) {
			List records = new ArrayList();
			for (int i = 0; i < detailList.size(); i++) {
				int detailSeq = rewardPointMapper.getSAL0401DSEQ();

				detailList.get(i).put("detId", detailSeq);
				detailList.get(i).put("tierId", masterSeq);
				logger.debug("============= detailList {}  ", detailList.get(i));
				records.add(detailList.get(i));
			}

			logger.info("============= detailList2 " + records);

			//Split into 1000 per upload
			int batchSize = 1000;
			int totalRecords = records.size();
			int batches = (int) Math.ceil((double) totalRecords / batchSize);

			for (int batch = 0; batch < batches; batch++) {
				int startIdx = batch * batchSize;
			    int endIdx = Math.min(startIdx + batchSize, totalRecords);

			    List<Map<String, Object>> batchDetailList = detailList.subList(startIdx, endIdx);

			    Map<String, Object> batchMasterList = new HashMap<>(masterList);
			    batchMasterList.put("list", batchDetailList);

			    dResult = rewardPointMapper.saveRewardBulkPointDetail(batchMasterList);

			    if(dResult > 0) {
			    	//CALL PROCEDURE
			    	rewardPointMapper.callRewardBulkPointValidateDet(batchMasterList);
			    }
            }
		}
		if(mResult > 0 && dResult > 0)
			return masterSeq;
		else return 0;
	}

	@Override
	public List<EgovMap> selectRewardBulkPointList(Map<String, Object> params)
	{
		return rewardPointMapper.selectRewardBulkPointList(params);
	}

	@Override
	public List<EgovMap> selectRewardBulkPointItem(Map<String, Object> params) {
		return rewardPointMapper.selectRewardBulkPointItem(params);
	}

	@Override
	public int approvalRewardBulkPoint(Map<String, Object> params) {
		int confirmMaster = 0, confirmDetail = 0;
		confirmMaster	= rewardPointMapper.confirmRewardBulkPointMaster(params);

		if(confirmMaster > 0) {
			confirmDetail = rewardPointMapper.confirmRewardBulkPointDetail(params);
		}
		return confirmDetail;
	}
}
