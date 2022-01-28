package com.coway.trust.biz.eAccounting.staffBusinessActivity;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface staffBusinessActivityService {

	List<EgovMap> selectAdvanceList(Map<String, Object> params);

	EgovMap getAdvConfig(Map<String, Object> params);

    EgovMap getRqstInfo(Map<String, Object> params);

    EgovMap getAdvClmInfo(Map<String, Object> params);

    List<EgovMap> selectAdvOccasions(Map<String, Object> params);

    String selectNextClmNo(Map<String, Object> params);

    void insertRequest(Map<String, Object> params);

    void insertTrvDetail(Map<String, Object> params);

    void insertApproveManagement(Map<String, Object> params);

    void insertApproveLineDetail(Map<String, Object> params);

    void editDraftRequestM(Map<String, Object> params);

    void editDraftRequestD(Map<String, Object> params);

    void updateTotal(Map<String, Object> params);

    void insMissAppr(Map<String, Object> params);

    EgovMap getClmDesc(Map<String, Object> params);

    EgovMap getNtfUser(Map<String, Object> params);

    void insertAppvDetails(Map<String, Object> params);

    void updateAdvRequest(Map<String, Object> params);

    void updateAdvanceReqInfo(Map<String, Object> params);

    EgovMap getRefDtls(Map<String, Object> params);

    List<EgovMap> getRefDtlsGrid(String clmNo);

    EgovMap getAdvType(Map<String, Object> params);

    List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

    void insertRefund(Map<String, Object> params);

    EgovMap selectClamUn(Map<String, Object> params);

    void updateClamUn(Map<String, Object> params);

    void insertNotification(Map<String, Object> params);

 // Edit Rejected 27/12/2021
    String selectNextReqNo(Map<String, Object> params);
    void editRejected(Map<String, Object> params);

    String checkRefdDate(Map<String, Object> params);

    List<EgovMap> selectAttachList(String atchFileGrpId);
}
