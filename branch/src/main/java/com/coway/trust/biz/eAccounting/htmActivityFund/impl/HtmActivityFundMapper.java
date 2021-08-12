package com.coway.trust.biz.eAccounting.htmActivityFund.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("htmActivityFundMapper")
public interface HtmActivityFundMapper {
    List<EgovMap> selectHtmActFundClaimList(Map<String, Object> params);

    String selectNextClmNo();

    void insertHtmActFundExp(Map<String, Object> params);

    int selectNextClmSeq(String clmNo);

    void insertHtmActFundExpItem(Map<String, Object> params);

    List<EgovMap> selectHtmActFundItems(String clmNo);

    EgovMap selectHtmClaimInfo(Map<String, Object> params);

    List<EgovMap> selectHtmActFundItemGrp(Map<String, Object> params);

    List<EgovMap> selectAttachList(String atchFileGrpId);

    void updateHtmActFundExpTotAmt(Map<String, Object> params);

    void updateHtmActFundExp(Map<String, Object> params);

    void updateHtmActFundExpItem(Map<String, Object> params);

    List<EgovMap> selectHtmActFundItemList(String clmNo);

    void insertApproveItems(Map<String, Object> params);

    void updateAppvPrcssNo(Map<String, Object> params);
}
