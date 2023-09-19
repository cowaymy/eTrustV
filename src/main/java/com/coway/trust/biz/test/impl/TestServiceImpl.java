package com.coway.trust.biz.test.impl;

import java.text.ParseException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.staffClaim.impl.StaffClaimMapper;
import com.coway.trust.biz.test.TestService;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.impl.duration.Period;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("testService")
public class TestServiceImpl extends EgovAbstractServiceImpl implements TestService {

    private static final Logger logger = LoggerFactory.getLogger(TestServiceImpl.class);

    @Resource(name = "testMapper")
    private TestMapper testMapper;

//    @Autowired
//    private FileService fileService;

    @Autowired
    private FileMapper fileMapper;

    @Resource(name = "staffClaimMapper")
    private StaffClaimMapper staffClaimMapper;

    @Override
    public EgovMap getClaimNo() {
        return testMapper.getClaimNo();
    }

    @Override
    public EgovMap getCostCenter(Map<String, Object> params) {
        return testMapper.getCostCenter(params);
    }

    @Override
    public void insertClaimMaster(Map<String, Object> params) {
        testMapper.insertClaimMaster(params);
    }

    @Override
    public void insertNormalClaim(List<FileVO> list, FileType type, Map<String, Object> params, SessionVO sessionVO) {
        logger.debug("insertNormalClaim :: Start");
        int userId = sessionVO.getUserId();

        int fileGroupKey = fileMapper.selectFileGroupKey();

        list.forEach(r -> this.insertFile(fileGroupKey, r, type, userId));

        params.put("fileGroupKey", fileGroupKey);
        logger.debug("insertNormalClaim :: End");
    }

    @Override
    public void insertCarMileageClaim(List<FileVO> list, FileType type, Map<String, Object> params, SessionVO sessionVO) {
        logger.debug("insertCarMileageClaim :: Start");
        int userId = sessionVO.getUserId();

        int fileGroupKey = fileMapper.selectFileGroupKey();

        String claimUn = "";
        String claimSeq = "";
        String cmSeq = "";

        int j = 0;
        int x = 0;
        int y = 0;

        for(String key : params.keySet()) {
            if("n$eum".equals(key)) {
                continue;
            } else {
                claimUn = params.get(key).toString().substring(0, 9);

                if(x == 0) {
                    cmSeq = params.get(key).toString().substring(19);
                    y = Integer.parseInt(cmSeq);

                    System.out.println(cmSeq);

                    if(y == 1) {
                        claimSeq = Integer.toString(staffClaimMapper.selectNextClmSeq(params.get(key).toString().substring(9, 19)));
                        x = Integer.parseInt(claimSeq);
                    } else {
                        claimSeq = Integer.toString(staffClaimMapper.selectNextClmSeq(params.get(key).toString().substring(9, 19)));
                        x = Integer.parseInt(claimSeq);

                        claimSeq = Integer.toString(x + (y-x));
                        x = Integer.parseInt(claimSeq);
                    }
                } else {
                    cmSeq = params.get(key).toString().substring(19);

                    claimSeq = Integer.toString(x + (Integer.parseInt(cmSeq) - y));
                }

                logger.debug("claimUn :: " + claimUn);
                logger.debug("claimSeq :: " + claimSeq);

                this.insertFile(fileGroupKey, list.get(j), type, userId, claimUn, claimSeq);
                j++;
            }
        }

        /*
        for(int i = 1, j = 0; i <= params.size() - 1; i++, j++) {
            String iStr = Integer.toString(i);
            claimUn = params.get(iStr).toString().substring(0, 9);
            claimSeq = params.get(iStr).toString().substring(9);

            logger.debug("claimUn :: " + claimUn);
            logger.debug("claimSeq :: " + claimSeq);

            this.insertFile(fileGroupKey, list.get(j), type, userId, claimUn, claimSeq);
        }*/

        params.put("fileGroupKey", fileGroupKey);
        logger.debug("insertCarMileageClaim :: End");
    }

    @Override
    public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, int userId) {
        this.insertFile(fileGroupKey, flVO, flType, userId, "", "");
    }

//    @Override
    public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, int userId, String claimUn, String claimSeq) {
        logger.debug("insertFile :: Start");

        int atchFlId = testMapper.selectNextFileId();

        FileGroupVO fileGroupVO = new FileGroupVO();

        Map<String, Object> flInfo = new HashMap<String, Object>();
        flInfo.put("atchFileId", atchFlId);
        flInfo.put("atchFileName", flVO.getAtchFileName());
        flInfo.put("fileSubPath", flVO.getFileSubPath());
        flInfo.put("physiclFileName", flVO.getPhysiclFileName());
        flInfo.put("fileExtsn", flVO.getFileExtsn());
        flInfo.put("fileSize", flVO.getFileSize());
        flInfo.put("filePassword", flVO.getFilePassword());
        flInfo.put("fileUnqKey", claimUn);
        flInfo.put("fileKeySeq", claimSeq);

        //fileMapper.insertFileDetail(flVO);
        testMapper.insertFileDetail(flInfo);

        fileGroupVO.setAtchFileGrpId(fileGroupKey);
        fileGroupVO.setAtchFileId(atchFlId);
        fileGroupVO.setChenalType(flType.getCode());
        fileGroupVO.setCrtUserId(userId);
        fileGroupVO.setUpdUserId(userId);

        fileMapper.insertFileGroup(fileGroupVO);

        logger.debug("insertFile :: End");
    }

    @Override
    public void saveClaimDtls(Map<String, Object> params) {
        logger.debug("saveClaimDtls :: Start");
        logger.debug("params :: " + params);

        List<Object> detailData = (List<Object>) params.get("gridData");

        String claimNo = params.get("claimNo").toString();

        for(int i = 0; i < detailData.size(); i++) {
            Map<String, Object> item = (Map<String, Object>) detailData.get(i);
            int clmSeq = staffClaimMapper.selectNextClmSeq(claimNo);
            item.put("clmNo", claimNo);
            item.put("clmSeq", clmSeq);
            item.put("invcDt", params.get("invcDt"));
            item.put("invcType", params.get("invcType"));
            item.put("invcNo", params.get("invcNo"));
            item.put("supplirName", params.get("supplirName"));
            item.put("gstRgistNo", params.get("gstRgistNo"));
            item.put("invcRem", params.get("invcRem"));
            item.put("atchFileGrpId", params.get("atchFileGrpId"));
            item.put("userId", params.get("userId"));
            item.put("userName", params.get("userName"));
            item.put("expDesc", params.get("expDesc"));
            item.put("clmFlg", "N");

            // Car Mileage Expense Value setting
            if("1".equals(item.get("expGrp"))) {
                item.put("expType", "J4001");
                item.put("expTypeName", "Car Mileage");
                item.put("glAccCode", "61130110");
                item.put("glAccCodeName", "TRAVELLING CLAIM - LOCAL (LAND/SEA TRANSPORT)");
                item.put("budgetCode", "01311");
                item.put("budgetCodeName", "Local travel - Milleage");

                float cmTotAmt = Float.parseFloat(item.get("carMilagAmt").toString()) + Float.parseFloat(item.get("tollAmt").toString()) + Float.parseFloat(item.get("parkingAmt").toString());
                item.put("gstBeforAmt", cmTotAmt);
                item.put("gstAmt", 0);
                item.put("taxNonClmAmt", 0);
                item.put("totAmt", cmTotAmt);
            }

            logger.debug("insertStaffClaimExpItem =====================================>>  " + item);
            testMapper.insertStaffClaimExpItem(item);

            // Car Mileage Expense Insert
            logger.debug("expGrp =====================================>>  " + item.get("expGrp"));
            if("1".equals(item.get("expGrp"))) {
                logger.debug("insertStaffClaimExpMileage =====================================>>  " + item);
                testMapper.insertStaffClaimExpMileage(item);
            }
        }

        logger.debug("saveClaimDtls :: End");
    }

    // Update FCM0019M upon add details completion
    @Override
    public void updateMasterClaim(Map<String, Object> params) {
        testMapper.updateMasterClaim(params);
    }

    @Override
    public void deleteMasterClaim(Map<String, Object> params) {
        testMapper.deleteMasterClaim(params);
    }

    @Override
    public void deleteDtlsClaim(Map<String, Object> params) {
        testMapper.deleteDtlsClaim(params);
    }

    @Override
    public void deleteNCDtls(Map<String, Object> params) {
        testMapper.deleteNCDtls(params);
    }

    @Override
    public void deleteCMDtls(Map<String, Object> params) {
        testMapper.deleteCMDtls(params);
    }

    @Override
    public List<EgovMap> getAttachGrpList(Map<String, Object> params) {
        return testMapper.getAttachGrpList(params);
    }

    @Override
    public void deleteFileMaster(Map<String, Object> params) {
        testMapper.deleteFileMaster(params);
    }

    @Override
    public void deleteFileDtls(Map<String, Object> params) {
        testMapper.deleteFileDtls(params);
    }

    @Override
    public List<EgovMap> getSummary(Map<String, Object> params) {
        return testMapper.getSummary(params);
    }

    @Override
    public EgovMap getTotAmt(Map<String, Object> params) {
        return testMapper.getTotAmt(params);
    }

    @Override
    public EgovMap selectStaffClaimInfo(Map<String, Object> params) {
        return testMapper.selectStaffClaimInfo(params);
    }

    @Override
    public List<EgovMap> selectStaffClaimItemGrp(Map<String, Object> params) {
        return testMapper.selectStaffClaimItemGrp(params);
    }

    @Override
    public List<EgovMap> selectAttachList(String atchFileGrpId) {
        // TODO Auto-generated method stub
        return testMapper.selectAttachList(atchFileGrpId);
    }

    @Override
    public EgovMap checkCM(Map<String, Object> params) {
        return testMapper.checkCM(params);
    }

    @Override
    public List<EgovMap> selectStaffClaimItems(String clmNo) {
        // TODO Auto-generated method stub
        return testMapper.selectStaffClaimItems(clmNo);
    }

    // ===========================

    @Override
    public List<EgovMap> selectNtfList(Map<String, Object> params) {
        return testMapper.selectNtfList(params);
    }

    @Override
    public void updateNtfStus(Map<String, Object> params) {
        testMapper.updateNtfStus(params);
    }

    @Override
    public EgovMap verifyUserAccount(Map<String, Object> params) {
      return testMapper.verifyUserAccount(params);
    }

    @Override
    public void insertOtpRecord(Map<String, Object> params) {
      testMapper.insertOtpRecord(params);
    }

    @Override
    public boolean verifyOTPNumber(Map<String, Object> params) throws ParseException {

      EgovMap data = testMapper.verifyOTPNumber(params);
      boolean valid = false;

      if(data != null){
        String isKeyed = data.get("isKeyed").toString();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date crtDt = formatter.parse(data.get("crtDt").toString());
        Date now = new Date();

        long diff = now.getTime() - crtDt.getTime() / 1000; // different in seconds

        if(isKeyed.equals("0") || diff <= 60){
          testMapper.updateOtpRecord(params);
          valid = true;
        }
      }

      return valid;
    }
}
