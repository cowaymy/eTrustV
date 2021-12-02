package com.coway.trust.biz.eAccounting.staffBusinessActivity.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("staffBusinessActivityMapper")
public interface staffBusinessActivityMapper {

	List<EgovMap> selectAdvanceList(Map<String, Object> params);

	EgovMap getAdvConfig(Map<String, Object> params);

    EgovMap getRqstInfo(Map<String, Object> params);

    EgovMap getAdvClmInfo(Map<String, Object> params);

    List<EgovMap> selectAdvOccasions(Map<String, Object> params);

    int selectNextClmSeq(String clmNo);

    EgovMap selectClamUn(Map<String, Object> params);

    void updateClamUn(Map<String, Object> params);

    String selectNextClmNo(Map<String, Object> params);

    void insertRequest(Map<String, Object> params);

    void insertTrvDetail(Map<String, Object> params);

    void insertAppvDetails(Map<String, Object> params);

    void editDraftRequestM(Map<String, Object> params);

    void editDraftRequestD(Map<String, Object> params);

    void updateTotal(Map<String, Object> params);

    void updateAdvRequest(Map<String, Object> params);

    void updateAdvanceReqInfo(Map<String, Object> params);

    EgovMap getRefDtls(Map<String, Object> params);

    EgovMap getAdvType(Map<String, Object> params);

    List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

    void insertRefund(Map<String, Object> params);

    List<EgovMap> getRefDtlsGrid(String clmNo);

    List<EgovMap> selectAdvInfoAndItems(Map<String, Object> params);

    EgovMap selectSettlementInfo(Map<String, Object> params);

    EgovMap selectBalanceInfo(Map<String, Object> params);

    void insertBusinessActAdvInterface(Map<String, Object> params);
}
