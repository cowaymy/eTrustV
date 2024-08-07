package com.coway.trust.biz.eAccounting.staffClaim.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("newStaffClaimMapper")
public interface NewStaffClaimMapper {

    EgovMap getClaimNo();

    EgovMap getCostCenter(Map<String, Object> params);

    void insertClaimMaster(Map<String, Object> params);

    void insertFileDetail(FileVO fileVO, String claimUn, String claimSeq);

    void updateMasterClaim(Map<String, Object> params);

    List<EgovMap> getAttachGrpList(Map<String, Object> params);

    void deleteFileMaster(Map<String, Object> params);

    void deleteFileDtls(Map<String, Object> params);

    void deleteMasterClaim(Map<String, Object> params);

    void deleteDtlsClaim(Map<String, Object> params);

    void deleteNCDtls(Map<String, Object> params);

    void deleteCMDtls(Map<String, Object> params);

    void insertFileDetail(Map<String, Object> flInfo);

    int selectNextFileId();

    List<EgovMap> getSummary(Map<String, Object> params);

    void insertStaffClaimExpItem(Map<String, Object> params);

    void insertStaffClaimExpMileage(Map<String, Object> params);

    EgovMap getTotAmt(Map<String, Object> params);

    EgovMap selectStaffClaimInfo(Map<String, Object> params);

    List<EgovMap> selectStaffClaimItemGrp(Map<String, Object> params);

    List<EgovMap> selectAttachList(String atchFileGrpId);

    EgovMap checkCM(Map<String, Object> params);

    List<EgovMap> selectStaffClaimItems(String clmNo);
}
