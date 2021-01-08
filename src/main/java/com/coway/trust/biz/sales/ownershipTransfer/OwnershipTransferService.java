package com.coway.trust.biz.sales.ownershipTransfer;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OwnershipTransferService {

    List<EgovMap> selectStatusCode();

    List<EgovMap> selectRootList(Map<String, Object> params) throws Exception;

    List<EgovMap> rootCodeList(Map<String, Object> params);

    int saveRequest(Map<String, Object> params, SessionVO sessionVO);

    List<EgovMap> getSalesOrdId(String params);

    Map<String, Object> selectLoadIncomeRange(Map<String, Object> params) throws Exception;

    EgovMap selectCcpInfoByCcpId(Map<String, Object> params) throws Exception;

    EgovMap selectRootDetails(Map<String, Object> params);

    List<EgovMap> selectRotCallLog(Map<String, Object> params) throws Exception;

    List<EgovMap> selectRotHistory(Map<String, Object> params) throws Exception;

    int insCallLog(List<Object> addList, String userId);

    int saveRotCCP(Map<String, Object> params, SessionVO sessionVO);

    List<EgovMap> getAttachments(Map<String, Object> params);
    EgovMap getAttachmentInfo(Map<String, Object> params);
}
