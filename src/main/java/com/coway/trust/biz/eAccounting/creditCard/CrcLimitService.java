package com.coway.trust.biz.eAccounting.creditCard;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CrcLimitService {

    List<EgovMap> selectAllowanceCardList();
    List<EgovMap> selectAllowanceCardPicList();

    List<EgovMap> selectAllowanceList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO);

    // EgovMap selectAvailableAllowanceAmt(Map<String, Object> params) throws Exception;

    List<EgovMap> selectAttachList(String docNo);
    List<EgovMap> selectAdjItems(Map<String, Object> params);

    EgovMap getCardInfo(Map<String, Object> params);

    String saveRequest(Map<String, Object> params, SessionVO sessionVO);

    String editRequest(Map<String, Object> params, SessionVO sessionVO);

    List<EgovMap> selectAdjustmentList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO);

    int submitAdjustment(Map<String, Object> params, SessionVO sessionVO);

    List<EgovMap> selectAdjustmentAppvList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO);

    int approvalUpdate(Map<String, Object> params, SessionVO sessionVO);
}
