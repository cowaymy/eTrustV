package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("crcLimitMapper")
public interface CrcLimitMapper {

    List<EgovMap> selectAllowanceCardList();
    List<EgovMap> selectAllowanceCardPicList();

    List<EgovMap> selectAllowanceList(Map<String, Object> params);

    // EgovMap selectAvailableAllowanceAmt(Map<String, Object> params) throws Exception;

    List<EgovMap> selectAttachList(String docNo);
    List<EgovMap> selectAdjItems(Map<String, Object> params);

    EgovMap getCardInfo(Map<String, Object> params);

    String getAdjDocNo();
    int insertAdj_FCM33D(Map<String, Object> params);

    int insertApp_FCM34D(Map<String, Object> params);

    List<EgovMap> selectAdjustmentList(Map<String, Object> params);

    List<EgovMap> selectAdjustmentAppvList(Map<String, Object> params);

    int updateApp_FCM34D(Map<String, Object> params);

    int updateSenderApp_FCM33D(Map<String, Object> params);

    int updateReceiverApp_FCM33D(Map<String, Object> params);

    int deleteApp_FCM33D(Map<String, Object> params);

    EgovMap selectAtchFile(Map<String, Object> params);

    int deleteAttachment_SYS70M(Map<String, Object> params);

    int deleteAttachment_SYS71D(Map<String, Object> params);
	List<EgovMap> selectCardholderApprovedAdjustmentLimitList(Map<String, Object> params);
	List<EgovMap> selectCardholderUtilisedAmountList(Map<String, Object> params);
	List<EgovMap> selectCardholderPendingAmountList(Map<String, Object> params);

	int checkExistAdjNo(String adjNo);
	int insertApp_FCM34D_Approval_Line(Map<String, Object> params);
	int updateApp_FCM33D_Approval_Line(Map<String, Object> params);
	int selectUserIdWithHrCode(Map<String, Object> params);
	EgovMap selectTotalAppLineStusCountInfo(Map<String, Object> params);
	int updateAppLineStus_FCM33D(Map<String, Object> params);
	List<EgovMap> getApprovalLineDescriptionInfo(Map<String, Object> params);
	int checkCurrAppvLineIsBudgetTeam(Map<String, Object> params);
	List<EgovMap> selectApprovalLineForEdit(Map<String, Object> params);
	int updateApp_FCM33D_Approval_Line_Count(Map<String, Object> params);
	int updateApp_FCM34D_Approval_Line(Map<String, Object> params);
	int deleteApp_FCM34D_Excess_Approval_Line(Map<String, Object> params);
}
