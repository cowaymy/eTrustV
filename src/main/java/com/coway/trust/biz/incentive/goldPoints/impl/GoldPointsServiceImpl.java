package com.coway.trust.biz.incentive.goldPoints.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.incentive.goldPoints.GoldPointsService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("goldPointsService")
public class GoldPointsServiceImpl extends EgovAbstractServiceImpl implements GoldPointsService {

	private static final Logger logger = LoggerFactory.getLogger(GoldPointsServiceImpl.class);

	@Resource(name = "goldPointsMapper")
	private GoldPointsMapper goldPointsMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Override
	public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {

        int masterSeq = goldPointsMapper.selectNextBatchId();
        master.put("goldPtsBatchId", masterSeq);
        int mResult = goldPointsMapper.insertGoldPointsMst(master); // INSERT INTO ICR0001M

        int size = 1000;
        int page = detailList.size() / size;
        int start;
        int end;

        Map<String, Object> goldPointsList = new HashMap<>();
        goldPointsList.put("goldPtsBatchId", masterSeq);
        for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if(i == page){
                end = detailList.size();
            }

            goldPointsList.put("list",
                detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
            goldPointsMapper.insertGoldPointsDtl(goldPointsList); // INSERT INTO ICR0002D
        }

        //CALL PROCEDURE
        goldPointsMapper.callGoldPointsConfirm(master); // MERGE INTO ICR0003D

		return masterSeq;
	}

	@Override
	public int saveCsvRedemptionItems(Map<String, Object> master, List<Map<String, Object>> detailList) {

        int masterSeq = goldPointsMapper.selectNextRedemptionItemsBatchId();
        master.put("riBatchId", masterSeq);
        int mResult = goldPointsMapper.insertRedemptionItemsMst(master); // INSERT INTO ICR0004M

        int size = 1000;
        int page = detailList.size() / size;
        int start;
        int end;

        Map<String, Object> rdmItmList = new HashMap<>();
        rdmItmList.put("riBatchId", masterSeq);
        for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if(i == page){
                end = detailList.size();
            }

            rdmItmList.put("list",
                detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
            goldPointsMapper.insertRedemptionItemsDtl(rdmItmList); // INSERT INTO ICR0005D
        }

        //CALL PROCEDURE
        goldPointsMapper.callRedemptionItemsConfirm(master); // MERGE INTO ICR0006D

		return masterSeq;
	}

	@Override
	public List<EgovMap> selectPointsSummaryList(Map<String, Object> params) {
		return goldPointsMapper.selectPointsSummaryList(params);
	}

	@Override
	public EgovMap selectTransactionHistory(Map<String, Object> params) {
		return goldPointsMapper.selectTransactionHistory(params);
	}

	@Override
	public List<EgovMap> selectPointsExpiryList(Map<String, Object> params) {
		return goldPointsMapper.selectPointsExpiryList(params);
	}

	@Override
	public EgovMap selectRedemptionBasicInfo(Map<String, Object> params) {
		return goldPointsMapper.selectRedemptionBasicInfo(params);
	}

	@Override
	public String getOrgDtls(Map<String, Object> params) {
		return goldPointsMapper.getOrgDtls(params);
	}

	@Override
	public List<EgovMap> searchItemCategoryList(Map<String, Object> params) {
		return goldPointsMapper.searchItemCategoryList(params);
	}

	@Override
	public List<EgovMap> searchRedemptionItemList(Map<String, Object> params) {
		return goldPointsMapper.searchRedemptionItemList(params);
	}

	@Override
	public Map<String, Object> createNewRedemption(Map<String, Object> params) {

		int redemptionSeq = goldPointsMapper.selectNextRedemptionId();
		String redemptionNo = goldPointsMapper.getNextRedemptionNo();
		params.put("redemptionId", redemptionSeq);
		params.put("redemptionNo", redemptionNo);
		goldPointsMapper.insertNewRedemption(params);

		goldPointsMapper.processRedemption(params);		//CALL SP_GOLD_PTS_REDEEM

		return params;	//return output SP_GOLD_PTS_REDEEM
	}

	@Override
	public int sendNotification(Map<String, Object> params) {
		int smsResult = 0;
		int emailResult = 0;

		smsResult = sendSMS(params);
		emailResult = sendEmail(params);

		return smsResult + emailResult;
	}

	private int sendEmail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return 0;
	}

	private int sendSMS(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return 0;
	}

}
