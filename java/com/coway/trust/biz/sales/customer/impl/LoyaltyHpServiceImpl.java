package com.coway.trust.biz.sales.customer.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.customer.LoyaltyHpService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loyaltyHpService")
public class LoyaltyHpServiceImpl extends EgovAbstractServiceImpl implements LoyaltyHpService {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyHpServiceImpl.class);

    @Resource(name = "loyaltyHpMapper")
    private LoyaltyHpMapper loyaltyHpMapper;

	@Override
	public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {

        int masterSeq = loyaltyHpMapper.selectNextBatchId();
        master.put("loyaltyHpBatchId", masterSeq);
        int mResult = loyaltyHpMapper.insertLoyaltyHpMst(master); // INSERT INTO SAL0272D

        int size = 1000;
        int page = detailList.size() / size;
        int start;
        int end;

        Map<String, Object> loyaltyHpList = new HashMap<>();
        loyaltyHpList.put("loyaltyHpBatchId", masterSeq);
        for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if(i == page){
                end = detailList.size();
            }

            loyaltyHpList.put("list",
                detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
            loyaltyHpMapper.insertLoyaltyHpDtl(loyaltyHpList); // INSERT INTO SAL0273D
        }

        return masterSeq;
	}

	@Override
	public List<EgovMap> selectLoyaltyHpMstList(Map<String, Object> params) {

		return loyaltyHpMapper.selectLoyaltyHpMstList(params);
	}

	@Override
	public EgovMap selectLoyaltyHpInfo(Map<String, Object> params) {
		EgovMap loyaltyHpBatchInfo = loyaltyHpMapper.selectLoyaltyHpMasterInfo(params);
	    List<EgovMap> loyaltyHpBatchDtlInfo = loyaltyHpMapper.selectLoyaltyHpDetailInfo(params);

	    loyaltyHpBatchInfo.put("loyaltyHpBatchItem", loyaltyHpBatchDtlInfo);
	    return loyaltyHpBatchInfo;
	}

	@Override
	public void callLoyaltyHpConfirm(Map<String, Object> params) {

        //CALL PROCEDURE
        loyaltyHpMapper.callBatchLoyaltyHpUpd(params); // MERGE INTO SAL0271D
	}

	@Override
	public int updLoyaltyHpReject(Map<String, Object> params) {

        int result = loyaltyHpMapper.updateLoyaltyHpMasterStus(params);

        return result;
	}

}
