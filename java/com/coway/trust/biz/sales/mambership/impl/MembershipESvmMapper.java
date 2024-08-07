package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("membershipESvmMapper")
public interface MembershipESvmMapper {

	List<EgovMap> selectESvmListAjax(Map<String, Object> params);

	EgovMap selectESvmInfo(Map<String, Object> params);

	EgovMap selectMemberByMemberID(Map<String, Object> params);

	List<EgovMap> selectESvmAttachList(Map<String, Object> params);

	int selectNextFileId();

	void insertFileDetail(Map<String, Object> flInfo);

	List<EgovMap> selectActionOption(Map<String, Object> params);

	List<EgovMap> selectCardMode(Map<String, Object> params);

	List<EgovMap> selectIssuedBank(Map<String, Object> params);

	List<EgovMap> selectCardType(Map<String, Object> params);

	List<EgovMap> selectMerchantBank(Map<String, Object> params);

	EgovMap selectESvmPreSalesInfo(Map<String, Object> params);

	EgovMap selectESvmPaymentInfo(Map<String, Object> params);

	String getDocNo(Map<String, Object> params);

	int updateAction(Map<String, Object> params);
	int updateTR(Map<String, Object> params);

	String checkStus298d(Map<String, Object> params);

	EgovMap  getSAL0095D_SEQ(Map<String, Object> params);

	int  SAL0095D_insert(Map<String, Object> params);

	EgovMap  selectMembershipQuotInfo(Map<String, Object> params);

	EgovMap  getHasBill(Map<String, Object> params);

	EgovMap  getSAL0001D_Data(Map<String, Object> params);

	EgovMap  getSAL0090D_Data(Map<String, Object> params);

	EgovMap  getSAL0093D_Data(Map<String, Object> params);

	int  SAL0088D_insert(Map<String, Object> params);

	int update_SAL0090D_Stus(Map<String, Object> params);

	int update_SAL0093D_Stus(Map<String, Object> params);

	int  PAY0007D_insert(Map<String, Object> params);

	int  PAY0024D_insert(Map<String, Object> params);

	int  PAY0016D_insert(Map<String, Object> params);

	EgovMap getNewAddr(Map<String, Object> params);

	int  PAY0031D_insert(Map<String, Object> params);

	int PAY0031D_INVC_ITM_UPDATE(Map<String, Object> params);

	int  PAY0032D_insert(Map<String, Object> params);

	List<EgovMap> getFilterListData(Map<String, Object> params);

	int  PAY0032DFilter_insert(Map<String, Object> params);

	String getPOSm(Map<String, Object> params);

	void updSal93(Map<String, Object> params);

    EgovMap selectBankStatementInfo(Map<String, Object> params);

    EgovMap getPay0024D(Map<String, Object> params);

    int  isSARefNoExist(Map<String, Object> params);

    String getPayWorNo(Map<String, Object> params);

    List<EgovMap> selectFailRemark(Map<String, Object> params);

    int SAL0407D_insert(Map<String, Object> params);
}
