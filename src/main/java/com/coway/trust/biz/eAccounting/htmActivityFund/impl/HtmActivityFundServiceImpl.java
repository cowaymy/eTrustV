package com.coway.trust.biz.eAccounting.htmActivityFund.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.eAccounting.htmActivityFund.HtmActivityFundService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("htmActivityFundService")
public class HtmActivityFundServiceImpl implements HtmActivityFundService {

    private static final Logger LOGGER = LoggerFactory.getLogger(HtmActivityFundServiceImpl.class);

    @Autowired
    private HtmActivityFundMapper htmActivityFundMapper;

    @Autowired
    private WebInvoiceMapper webInvoiceMapper;

    @Override
    public List<EgovMap> selectHtmActFundClaimList(Map<String, Object> params) {
        return htmActivityFundMapper.selectHtmActFundClaimList(params);
    }

    @Override
    public void insertHtmActFundExp(Map<String, Object> params) {
        List<Object> gridDataList = (List<Object>) params.get("gridDataList");

        Map<String, Object> masterData = (Map<String, Object>) gridDataList.get(0);


        String clmNo = htmActivityFundMapper.selectNextClmNo();
        params.put("clmNo", clmNo);

        masterData.put("clmNo", clmNo);
        masterData.put("allTotAmt", params.get("allTotAmt"));
        masterData.put("userId", params.get("userId"));
        masterData.put("userName", params.get("userName"));

        LOGGER.debug("masterData =====================================>>  " + masterData);
        htmActivityFundMapper.insertHtmActFundExp(masterData);

        for(int i = 0; i < gridDataList.size(); i++) {
            Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
            int clmSeq = htmActivityFundMapper.selectNextClmSeq(clmNo);
            item.put("clmNo", clmNo);
            item.put("clmSeq", clmSeq);
            item.put("userId", params.get("userId"));
            item.put("userName", params.get("userName"));

            htmActivityFundMapper.insertHtmActFundExpItem(item);
        }
    }

    @Override
    public List<EgovMap> selectHtmActFundItems(String clmNo) {
        return htmActivityFundMapper.selectHtmActFundItems(clmNo);
    }

    @Override
    public EgovMap selectHtmClaimInfo(Map<String, Object> params) {
        return htmActivityFundMapper.selectHtmClaimInfo(params);
    }

    @Override
    public List<EgovMap> selectHtmActFundItemGrp(Map<String, Object> params) {
        return htmActivityFundMapper.selectHtmActFundItemGrp(params);
    }

    @Override
    public List<EgovMap> selectAttachList(String atchFileGrpId) {
        // TODO Auto-generated method stub
        return htmActivityFundMapper.selectAttachList(atchFileGrpId);
    }

    @Override
    public void updateHtmActFundExp(Map<String, Object> params) {

        List<Object> addList = (List<Object>) params.get("add"); // 추가 리스트 얻기
        List<Object> updateList = (List<Object>) params.get("update"); // 수정 리스트 얻기

        if (addList.size() > 0) {
            Map hm = null;
            // biz처리
            for (Object map : addList) {
                hm = (HashMap<String, Object>) map;
                hm.put("clmNo", params.get("clmNo"));
                hm.put("allTotAmt", params.get("allTotAmt"));
                int clmSeq = htmActivityFundMapper.selectNextClmSeq((String) params.get("clmNo"));
                hm.put("clmSeq", clmSeq);
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));

                htmActivityFundMapper.insertHtmActFundExpItem(hm);

                htmActivityFundMapper.updateHtmActFundExpTotAmt(hm);
            }
        }
        if (updateList.size() > 0) {
            Map hm = null;
            hm = (Map<String, Object>) updateList.get(0);
            hm.put("clmNo", params.get("clmNo"));
            hm.put("allTotAmt", params.get("allTotAmt"));
            hm.put("userId", params.get("userId"));
            hm.put("userName", params.get("userName"));
            htmActivityFundMapper.updateHtmActFundExp(hm);
            for (Object map : updateList) {
                hm = (HashMap<String, Object>) map;
                hm.put("clmNo", params.get("clmNo"));
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));
                htmActivityFundMapper.updateHtmActFundExpItem(hm);
            }
        }
    }

    @Override
    public List<EgovMap> selectHtmActFundItemList(String clmNo) {
        return htmActivityFundMapper.selectHtmActFundItemList(clmNo);
    }

    @Override
    public void insertApproveManagement(Map<String, Object> params) {
        // TODO Auto-generated method stub
        LOGGER.debug("params =====================================>>  " + params);

        List<Object> apprGridList = (List<Object>) params.get("apprGridList");
        List<Object> newGridList = (List<Object>) params.get("newGridList");

        params.put("appvLineCnt", apprGridList.size());

        LOGGER.debug("insertApproveManagement =====================================>>  " + params);
        webInvoiceMapper.insertApproveManagement(params);

        if (apprGridList.size() > 0) {
            Map hm = null;

            for (Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                hm.put("appvPrcssNo", params.get("appvPrcssNo"));
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));
                LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
                // TODO appvLineDetailTable Insert
                webInvoiceMapper.insertApproveLineDetail(hm);
            }
        }

        if (newGridList.size() > 0) {
            Map hm = null;

            // biz처리
            for (Object map : newGridList) {
                hm = (HashMap<String, Object>) map;
                hm.put("appvPrcssNo", params.get("appvPrcssNo"));
                //int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
                //hm.put("appvItmSeq", appvItmSeq);
                hm.put("userId", params.get("userId"));
                hm.put("userName", params.get("userName"));
                LOGGER.debug("insertApproveItems =====================================>>  " + hm);
                // TODO appvLineItemsTable Insert
                htmActivityFundMapper.insertApproveItems(hm);
            }
        }

        LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
        // TODO pettyCashReqst table update
        htmActivityFundMapper.updateAppvPrcssNo(params);
    }
}
