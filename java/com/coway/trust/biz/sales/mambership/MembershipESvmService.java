package com.coway.trust.biz.sales.mambership;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MembershipESvmService {

	List<EgovMap> selectESvmListAjax(Map<String, Object> params);

	EgovMap selectESvmInfo(Map<String, Object> params);

	EgovMap selectMemberByMemberID(Map<String, Object> params);

	List<EgovMap> getESvmAttachList(Map<String, Object> params);

	List<EgovMap> selectActionOption(Map<String, Object> params);

	List<EgovMap> selectCardMode(Map<String, Object> params);

	List<EgovMap> selectIssuedBank(Map<String, Object> params);

	List<EgovMap> selectCardType(Map<String, Object> params);

	List<EgovMap> selectMerchantBank(Map<String, Object> params);

	EgovMap selectESvmPreSalesInfo(Map<String, Object> params);

	EgovMap selectESvmPaymentInfo(Map<String, Object> params);

	Map<String, Object> updateSVM(Map<String, Object> params, SessionVO sessionVO);

	int updateAction(Map<String, Object> params);

	String checkStatus(Map<String, Object> params);

	void updateTR(Map<String, Object> params);

	String SAL0095D_insert(Map<String, Object> params, SessionVO sessionVO);

	String selectDocNo(Map<String, Object> params);

	EgovMap selectMembershipQuotInfo(Map<String, Object> params);

	EgovMap  getHasBill(Map<String, Object> params);

	int genSrvMembershipBilling(Map<String, Object> params, SessionVO sessionVO);

	String getPOSm(Map<String, Object> params);

	Map<String, Object> eSVMNormalPayment(Map<String, Object> params, SessionVO sessionVO);

    List<EgovMap> eSVMCardPayment(Map<String, Object> params, SessionVO sessionVO);

    int isSARefNoExist(Map<String, Object> params);

    String getPayWorNo(Map<String, Object> params);

    List<EgovMap> selectFailRemark(Map<String, Object> params);

}
