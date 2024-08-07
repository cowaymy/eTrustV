package com.coway.trust.biz.eAccounting.htmActivityFund;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HtmActivityFundService {
    List<EgovMap> selectHtmActFundClaimList(Map<String, Object> params);

    void insertHtmActFundExp(Map<String, Object> params);

    List<EgovMap> selectHtmActFundItems(String clmNo);

    EgovMap selectHtmClaimInfo(Map<String, Object> params);

    List<EgovMap> selectHtmActFundItemGrp(Map<String, Object> params);

    List<EgovMap> selectAttachList(String atchFileGrpId);

    void updateHtmActFundExp(Map<String, Object> params);

    List<EgovMap> selectHtmActFundItemList(String clmNo);

    void insertApproveManagement(Map<String, Object> params);
}
