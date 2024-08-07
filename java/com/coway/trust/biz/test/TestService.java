package com.coway.trust.biz.test;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TestService {

    EgovMap getClaimNo();

    EgovMap getCostCenter(Map<String, Object> params);

    void insertClaimMaster(Map<String, Object> params);

    void insertFile(int fileGroupKey, FileVO flVO, FileType flType, int userId);

    void insertFile(int fileGroupKey, FileVO flVO, FileType flType, int userId, String claimUn, String claimSeq);

    void insertNormalClaim(List<FileVO> list, FileType type, Map<String, Object> params, SessionVO sessionVO);

    void insertCarMileageClaim(List<FileVO> list, FileType type, Map<String, Object> params, SessionVO sessionVO);

    void saveClaimDtls(Map<String, Object> params);

    void updateMasterClaim(Map<String, Object> params);

    void deleteMasterClaim(Map<String, Object> params);

    void deleteDtlsClaim(Map<String, Object> params);

    void deleteNCDtls(Map<String, Object> params);

    void deleteCMDtls(Map<String, Object> params);

    List<EgovMap> getAttachGrpList(Map<String, Object> params);

    void deleteFileMaster(Map<String, Object> params);

    void deleteFileDtls(Map<String, Object> params);

    List<EgovMap> getSummary(Map<String, Object> params);

    EgovMap getTotAmt(Map<String, Object> params);

    EgovMap selectStaffClaimInfo(Map<String, Object> params);

    List<EgovMap> selectStaffClaimItemGrp(Map<String, Object> params);

    List<EgovMap> selectAttachList(String atchFileGrpId);

    EgovMap checkCM(Map<String, Object> params);

    List<EgovMap> selectStaffClaimItems(String clmNo);

    // ===========================

    List<EgovMap> selectNtfList(Map<String, Object> params);

    void updateNtfStus(Map<String, Object> params);

    EgovMap verifyUserAccount(Map<String, Object> params);

    void insertOtpRecord(Map<String, Object> params);

    boolean verifyOTPNumber(Map<String, Object> params) throws ParseException;


}