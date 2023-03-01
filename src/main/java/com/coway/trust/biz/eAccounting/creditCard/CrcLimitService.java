package com.coway.trust.biz.eAccounting.creditCard;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;

import com.coway.trust.cmmn.model.ReturnMessage;
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
	String deleteRequest(Map<String, Object> params, SessionVO sessionVO);
	List<EgovMap> selectCardholderPendingAmountList(Map<String, Object> params);
	List<EgovMap> selectCardholderUtilisedAmountList(Map<String, Object> params);
	List<EgovMap> selectCardholderApprovedAdjustmentLimitList(Map<String, Object> params);
	EgovMap getFinApprover(Map<String, Object> params);
	int checkExistAdjNo(String adjNo);
	List<String> saveRequestBulk(Map<String, Object> params, SessionVO sessionVO);
	int saveApprovalLineBulk(Map<String, Object> params, SessionVO sessionVO);
	String submitNewAdjustmentWithApprovalLine(Map<String, Object> params, SessionVO sessionVO);
	List<EgovMap> getApprovalLineDescriptionInfo(Map<String, Object> params);
	int checkCurrAppvLineIsBudgetTeam(Map<String, Object> params);
	List<EgovMap> selectApprovalLineForEdit(Map<String, Object> params);
	int editApprovalLineSubmit(Map<String, Object> params, SessionVO sessionVO);
}
