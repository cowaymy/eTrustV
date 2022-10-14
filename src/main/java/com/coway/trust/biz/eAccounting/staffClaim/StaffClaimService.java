package com.coway.trust.biz.eAccounting.staffClaim;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StaffClaimService {

	List<EgovMap> selectStaffClaimList(Map<String, Object> params);

	List<EgovMap> selectTaxCodeStaffClaimFlag();

	void insertStaffClaimExp(Map<String, Object> params);

	List<EgovMap> selectStaffClaimItems(String clmNo);

	EgovMap selectStaffClaimInfo(Map<String, Object> params);

	EgovMap selectStaffClaimInfoForAppv(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	void updateStaffClaimExp(Map<String, Object> params);

	void insertApproveManagement(Map<String, Object> params);

	void deleteStaffClaimExpItem(Map<String, Object> params);

	void deleteStaffClaimExpMileage(Map<String, Object> params);

	void updateStaffClaimExpTotAmt(Map<String, Object> params);

	List<EgovMap> selectStaffClaimItemGrp(Map<String, Object> params);

	List<EgovMap> selectStaffClaimItemGrpForAppv(Map<String, Object> params);

	int checkOnceAMonth(Map<String, Object> params);

	ReturnMessage editRejectedClaimExp(Map<String, Object> params);

	List<EgovMap> selectExcelListNew(Map<String, Object> params);

}
