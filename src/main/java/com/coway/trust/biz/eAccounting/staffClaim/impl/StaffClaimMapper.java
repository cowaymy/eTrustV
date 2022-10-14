package com.coway.trust.biz.eAccounting.staffClaim.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("staffClaimMapper")
public interface StaffClaimMapper {

	List<EgovMap> selectStaffClaimList(Map<String, Object> params);

	List<EgovMap> selectTaxCodeStaffClaimFlag();

	String selectNextClmNo();

	void insertStaffClaimExp(Map<String, Object> params);

	int selectNextClmSeq(String clmNo);

	void insertStaffClaimExpItem(Map<String, Object> params);

	void insertStaffClaimExpMileage(Map<String, Object> params);

	List<EgovMap> selectStaffClaimItems(String clmNo);

	EgovMap selectStaffClaimInfo(Map<String, Object> params);

	EgovMap selectStaffClaimInfoForAppv(Map<String, Object> params);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	void updateStaffClaimExp(Map<String, Object> params);

	void updateStaffClaimExpItem(Map<String, Object> params);

	void updateStaffClaimExpMileage(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);

	void updateAppvPrcssNo(Map<String, Object> params);

	void deleteStaffClaimExpItem(Map<String, Object> params);

	void deleteStaffClaimExpMileage(Map<String, Object> params);

	void updateStaffClaimExpTotAmt(Map<String, Object> params);

	List<EgovMap> selectStaffClaimItemGrp(Map<String, Object> params);

	List<EgovMap> selectStaffClaimItemGrpForAppv(Map<String, Object> params);

	int checkOnceAMonth(Map<String, Object> params);

	int reinsertRejectedClaimMasterForEdit(Map<String, Object> params);

	int reinsertRejectedClaimDetailForEdit(Map<String, Object> params);

	List<EgovMap> selectRejectedClaimDetail(Map<String, Object> params);

	List<EgovMap> selectRejectedClaimAttachmentMaster(Map<String, Object> params);

	int reinsertRejectedClaimMasterAttachmentForEdit(Map<String, Object> params);

	int reinsertRejectedClaimDetailAttachmentForEdit(Map<String, Object> params);

	int selectNewAtchFileId();

	int insertFileDetail(FileVO fileVO);

	int reinsertRejectedClaimMileageForEdit(Map<String, Object> params);

	int selectAttachmentStaffClaimExpItemCount(Map<String, Object> params);

	List<EgovMap> selectStaffClaimListForExcel(Map<String, Object> params);
}
