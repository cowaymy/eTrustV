package com.coway.trust.biz.eAccounting.smGmClaim;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SmGmClaimService {

	List<EgovMap> selectSmGmClaimList(Map<String, Object> params);

	String selectNextSubClmNo(Map<String, Object> params);

	List<EgovMap> selectTaxCodeSmGmClaimFlag();

	void insertSmGmClaimExp(Map<String, Object> params);

	List<EgovMap> selectSmGmClaimItems(String clmNo);

	EgovMap selectSmGmClaimInfo(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	void updateSmGmClaimExpMain(Map<String, Object> params);

	void updateSmGmClaimExp(Map<String, Object> params);

	void insertApproveManagement(Map<String, Object> params);

	void deleteSmGmClaimExpItem(Map<String, Object> params);

	void deleteSmGmClaimExpMileage(Map<String, Object> params);

	void updateSmGmClaimExpTotAmt(Map<String, Object> params);

	List<EgovMap> selectSmGmClaimItemGrp(Map<String, Object> params);

	void updateApprovalInfo(Map<String, Object> params);

	void updateRejectionInfo(Map<String, Object> params);

    String selectEntId(Map<String, Object> params);

    Map<String, Object> insertEntitlementDetail(Map<String, Object> params);

    List<EgovMap> selectSmGmEntitlementList(Map<String, Object> params);

    EgovMap selectMemberEntitlement(Map<String, Object> params);

    List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

    EgovMap selectClaimInfoForAppv(Map<String, Object> params);

    List<EgovMap> selectClaimItemGrpForAppv(Map<String, Object> params);

    int checkOnceAMonth(Map<String, Object> params);
}
