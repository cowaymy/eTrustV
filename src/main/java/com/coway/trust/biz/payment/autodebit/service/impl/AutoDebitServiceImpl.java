package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.autodebit.AutoDebitApiDto;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.autodebit.service.AutoDebitService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("autoDebitService")
public class AutoDebitServiceImpl extends EgovAbstractServiceImpl implements AutoDebitService {

  @Value("${app.name}")
  private String appName;

  @Autowired
  private FileService fileService;

  @Autowired
  private FileMapper fileMapper;

  @Autowired
  private AdaptorService adaptorService;

  @Autowired
  private LoginMapper loginMapper;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "autoDebitMapper")
  private AutoDebitMapper autoDebitMapper;

  private static final Logger LOGGER = LoggerFactory.getLogger(ClaimServiceImpl.class);

  @Override
  public List<EgovMap> orderNumberSearchMobile(Map<String, Object> params) {
    return autoDebitMapper.orderNumberSearchMobile(params);
  }

  @Override
  public List<EgovMap> autoDebitHistoryMobileList(Map<String, Object> params) {
    return autoDebitMapper.autoDebitHistoryMobileList(params);
  }

  @Override
  public List<EgovMap> selectAutoDebitEnrollmentList(Map<String, Object> params) {
    return autoDebitMapper.selectAutoDebitEnrollmentList(params);
  }

  @Override
  public List<EgovMap> selectAutoDebitDetailInfo(Map<String, Object> params) {
    return autoDebitMapper.selectAutoDebitDetailInfo(params);
  }

  @Override
  public List<EgovMap> selectCustomerCreditCardInfo(Map<String, Object> params) {
    return autoDebitMapper.selectCustomerCreditCardInfo(params);
  }

  @Override
  public List<EgovMap> selectAttachmentInfo(Map<String, Object> params) {
    return autoDebitMapper.selectAttachmentInfo(params);
  }

  @Override
  public List<EgovMap> selectRejectReasonCode(Map<String, Object> params) {
    return autoDebitMapper.selectRejectReasonCode(params);
  }

  @Override
  public void updateMobileAutoDebitAttachment(List<FileVO> list, FileType type, Map<String, Object> params,
      List<String> seqs) {
    // TODO Auto-generated method stub
    LOGGER.debug("params =====================================>>  " + params.toString());
    LOGGER.debug("list.size : {}", list.size());
    String update = (String) params.get("update");
    String remove = (String) params.get("remove");
    String[] updateList = null;
    String[] removeList = null;
    if (!StringUtils.isEmpty(update)) {
      updateList = params.get("update").toString().split(",");
      LOGGER.debug("updateList.length : {}", updateList.length);
    }
    if (!StringUtils.isEmpty(remove)) {
      removeList = params.get("remove").toString().split(",");
      LOGGER.debug("removeList.length : {}", removeList.length);
    }
    // serivce 에서 파일정보를 가지고, DB 처리.
    if (list.size() > 0) {
      for (int i = 0; i < list.size(); i++) {
        if (updateList != null && i < updateList.length && removeList != null && removeList.length > 0) {
          String atchFileId = updateList[i];
          String removeAtchFileId = removeList[i];
          if (atchFileId.equals(removeAtchFileId)) {
            fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))),
                Integer.parseInt(atchFileId), list.get(i), type,
                Integer.parseInt(String.valueOf(params.get("userId"))));
          } else {
            int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
            this.insertFile(fileGroupId, list.get(i), type, params, seqs.get(i));
          }
        } else if (updateList != null && i < updateList.length) {
          String atchFileId = updateList[i];
          fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))),
              Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
        } else {
          int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
          this.insertFile(fileGroupId, list.get(i), type, params, seqs.get(i));
        }
      }
    }
    if (updateList == null && removeList != null && removeList.length > 0) {
      for (String id : removeList) {
        LOGGER.info(id);
        String atchFileId = id;
        fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
      }
    }
  }

  public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params, String seq) {
    LOGGER.debug("insertFile :: Start");

    int atchFlId = Integer.parseInt(params.get("atchFileGroupId").toString());

    FileGroupVO fileGroupVO = new FileGroupVO();

    Map<String, Object> flInfo = new HashMap<String, Object>();
    flInfo.put("atchFileId", atchFlId);
    flInfo.put("atchFileName", flVO.getAtchFileName());
    flInfo.put("fileSubPath", flVO.getFileSubPath());
    flInfo.put("physiclFileName", flVO.getPhysiclFileName());
    flInfo.put("fileExtsn", flVO.getFileExtsn());
    flInfo.put("fileSize", flVO.getFileSize());
    flInfo.put("filePassword", flVO.getFilePassword());
    flInfo.put("fileUnqKey", params.get("claimUn"));
    flInfo.put("fileKeySeq", seq);

    autoDebitMapper.insertFileDetail(flInfo);

    fileGroupVO.setAtchFileGrpId(fileGroupKey);
    fileGroupVO.setAtchFileId(atchFlId);
    fileGroupVO.setChenalType(flType.getCode());
    fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
    fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));

    fileMapper.insertFileGroup(fileGroupVO);

    LOGGER.debug("insertFile :: End");
  }

  @Override
  public int updateAction(Map<String, Object> params) {
    int updatePay0333m = autoDebitMapper.updateAction(params);

    if (updatePay0333m > 0) {
      return 1;
    } else {
      return 0;
    }
  }

  @Override
  public AutoDebitApiDto autoDebitMobileSubmissionSave(Map<String, Object> params) {
	AutoDebitApiDto result = new AutoDebitApiDto();
    EgovMap creatorInfo = autoDebitMapper.selectCreatorInfo(params.get("createdBy").toString());

    params.put("signImg", params.get("signData"));
    params.put("creatorId", creatorInfo.get("userId"));
    params.put("userBranch", creatorInfo.get("userBranch"));
    if (params.get("isThirdPartyPayment").toString().toLowerCase() == "true") {
      params.put("isThirdPartyPaymentCheck", 1);
    } else {
      params.put("isThirdPartyPaymentCheck", 0);
    }

    String padNo = commonMapper.selectDocNo("187");
    int padId = Integer.parseInt(padNo.substring(3).replaceFirst("^0+(?!$)", ""));
    params.put("padNo", padNo);
    params.put("padId", padId);

    LOGGER.debug(" submitSave : {}", params.toString());
    int insertPay0333M = autoDebitMapper.insertAutoDebitMobileSubmmisionData(params);

    if (insertPay0333M > 0) {
      // this.sendSms(params);
      // this.sendEmail(params);
    	result.setResponseCode(1);
      return result;
    } else {
    	result.setResponseCode(0);
      return result;
    }
  }

  @Override
  public int insertAttachmentMobileUpload(List<FileVO> list, Map<String, Object> params) {
    if (null == params) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(params.get("createdBy").toString())) {
      throw new ApplicationException(AppConstants.FAIL, "user value does not exist.");
    }
    if (CommonUtils.isEmpty(params.get("fileKeySeq").toString())) {
      throw new ApplicationException(AppConstants.FAIL, "fileKeySeq value does not exist.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", params.get("createdBy").toString()); // IS USER_NAME
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, "UserID is null for upload.");
    }

    int newFileGroupId = 0;
    newFileGroupId = autoDebitMapper.selectNextFileGroupId();

    for (FileVO data : list) {
      int newFileId = 0;
      newFileId = autoDebitMapper.selectNextFileId();
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put("atchFileId", newFileId);
      sys0071D.put("atchFileName", data.getAtchFileName());
      sys0071D.put("fileSubPath", data.getFileSubPath());
      sys0071D.put("physiclFileName", data.getPhysiclFileName());
      sys0071D.put("fileExtsn", data.getFileExtsn());
      sys0071D.put("fileSize", data.getFileSize());
      sys0071D.put("filePassword", null);
      sys0071D.put("fileUnqKey", null);
      sys0071D.put("fileKeySeq", params.get("fileKeySeq").toString());
      int saveCnt = autoDebitMapper.insertFileDetail(sys0071D);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
      }
      if (CommonUtils.isEmpty(sys0071D.get("atchFileId"))) {
        throw new ApplicationException(AppConstants.FAIL, "atchFileId value does not exist.");
      }

      Map<String, Object> sys0070M = new HashMap<String, Object>();
      sys0070M.put("atchFileGrpId", newFileGroupId);
      sys0070M.put("atchFileId", sys0071D.get("atchFileId"));
      sys0070M.put("chenalType", FileType.MOBILE.getCode());
      sys0070M.put("crtUserId", loginVO.getUserId());
      sys0070M.put("updUserId", loginVO.getUserId());
      saveCnt = autoDebitMapper.insertFileGroup(sys0070M);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, "Insert Exception.");
      }
    }
    return newFileGroupId;
  }

  @Override
  public void sendSms(Map<String, Object> params) {
    EgovMap custCardBankIssuer = autoDebitMapper.selectCustCardBankInformation(params);
    String custCardNo = custCardBankIssuer.get("custOriCrcNo").toString();
    String cardEnding = custCardNo.substring(custCardNo.length() - 4);
    params.put("bankIssuer", custCardBankIssuer.get("bankIssuer"));
    params.put("cardEnding", cardEnding);

    SmsVO sms = new SmsVO(Integer.parseInt(params.get("createdBy").toString()), 975);
    String smsTemplate = autoDebitMapper.getSmsTemplate(params);
    String smsNo = "";

    params.put("smsTemplate", smsTemplate);

    if (!"".equals(CommonUtils.nvl(params.get("sms1")))) {
      smsNo = CommonUtils.nvl(params.get("sms1"));
    } else if (!"".equals(CommonUtils.nvl(params.get("sms2")))) {
      smsNo = CommonUtils.nvl(params.get("sms2"));
    }

    if (!"".equals(CommonUtils.nvl(smsNo))) {
      sms.setMessage(CommonUtils.nvl(smsTemplate));
      sms.setMobiles(CommonUtils.nvl(smsNo));
      sms.setRemark("SMS AUTO DEBIT VIA MOBILE APPS");
      sms.setRefNo(CommonUtils.nvl(params.get("padNo")));
      SmsResult smsResult = adaptorService.sendSMS(sms);
      LOGGER.debug(" smsResult : {}", smsResult.toString());
    }
  }

  // NOT COMPLETED
  @SuppressWarnings("unchecked")
  @Override
  public void sendEmail(Map<String, Object> params) {
    EmailVO email = new EmailVO();
    String emailTitle = autoDebitMapper.getEmailTitle(params);

    Map<String, Object> additionalParams = (Map<String, Object>) autoDebitMapper.getEmailDescription(params);
    params.putAll(additionalParams);

    List<String> emailNo = new ArrayList<String>();

    if (!"".equals(CommonUtils.nvl(params.get("email1")))) {
      emailNo.add(CommonUtils.nvl(params.get("email1")));
    } else if (!"".equals(CommonUtils.nvl(params.get("email2")))) {
      emailNo.add(CommonUtils.nvl(params.get("email2")));
    }

    if (emailNo.size() > 0) {
      email.setTo(emailNo);
      email.setHtml(true);
      email.setSubject(emailTitle);
      email.setHasInlineImage(true);

      boolean isResult = false;

      isResult = adaptorService.sendEmail(email, false, EmailTemplateType.MOBILE_AUTO_DEBIT_SUBMISSION, params);
    }
  }
}
