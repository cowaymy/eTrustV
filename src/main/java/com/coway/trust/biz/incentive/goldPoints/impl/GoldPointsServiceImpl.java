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

}
