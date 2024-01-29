package com.coway.trust.biz.payment.autodebit.service.impl;

import static com.coway.trust.AppConstants.EMAIL_SUBJECT;
import static com.coway.trust.AppConstants.EMAIL_TEXT;
import static com.coway.trust.AppConstants.EMAIL_TO;
import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.autodebit.AutoDebitApiDto;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.EncryptionDecryptionService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.ReportBatchService;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.autodebit.service.AutoDebitService;
import com.coway.trust.cmmn.CRJavaHelper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;
import com.coway.trust.util.ReportUtils;
import com.coway.trust.web.common.ReportController.ViewType;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("autoDebitService")
public class AutoDebitServiceImpl extends EgovAbstractServiceImpl implements AutoDebitService {

  @Value("${report.file.path}")
  private String reportFilePath;

  @Value("${report.datasource.driver-class-name}")
  private String reportDriverClass;

  @Value("${report.datasource.url}")
  private String reportUrl;

  @Value("${report.datasource.username}")
  private String reportUserName;

  @Value("${report.datasource.password}")
  private String reportPassword;

  @Value("${app.name}")
  private String appName;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private ReportBatchService reportBatchService;

  @Autowired
  private FileService fileService;

  @Autowired
  private FileMapper fileMapper;

  @Autowired
  private AdaptorService adaptorService;

  @Autowired
  private LoginMapper loginMapper;

  @Resource(name = "encryptionDecryptionService")
  private EncryptionDecryptionService encryptionDecryptionService;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "autoDebitMapper")
  private AutoDebitMapper autoDebitMapper;

	@Value("${tiny.api.url}")
	private String tinyUrlApi;

	@Value("${tiny.api.token}")
	private String tinyUrlToken;

	@Value("${tiny.api.sub.domain}")
	private String tinyUrlSubDomain;

	@Value("${etrust.base.url}")
	private String etrustBaseUrl;

  private static final Logger LOGGER = LoggerFactory.getLogger(AutoDebitServiceImpl.class);

  @Override
  public List<EgovMap> orderNumberSearchMobile(Map<String, Object> params) {
	  EgovMap userOrg = autoDebitMapper.getUserOrganization(params);

	  if(userOrg != null){
		  params.put("memType", userOrg.get("memType"));
	  }
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
  public EgovMap orderNumberSearchMobileCheckActivePadNo(Map<String, Object> params) {
    return autoDebitMapper.orderNumberSearchMobileCheckActivePadNo(params);
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
  public List<Map<String, Object>> selectAttachmentInfo(Map<String, Object> params) {
    return autoDebitMapper.selectAttachmentInfo(params);
  }

  @Override
  public EgovMap getProductDescription(Map<String, Object> params) {
    return autoDebitMapper.getProductDescription(params);
  }

  @Override
  public List<EgovMap> selectRejectReasonCode(Map<String, Object> params) {
    return autoDebitMapper.selectRejectReasonCode(params);
  }

  @Override
  public Map<String, Object> getAutoDebitSignImg(Map<String, Object> params) {
    return autoDebitMapper.getAutoDebitSignImg(params);
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
            fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGroupId"))),
                Integer.parseInt(atchFileId), list.get(i), type,
                Integer.parseInt(String.valueOf(params.get("userId"))));
          } else {
            int fileGroupId = (Integer.parseInt(params.get("atchFileGroupId").toString()));
            this.insertFile(fileGroupId, list.get(i), type, params, seqs.get(i));
          }
        } else if (updateList != null && i < updateList.length) {
          String atchFileId = updateList[i];
          fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGroupId"))),
              Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
        } else {
          int fileGroupId = (Integer.parseInt(params.get("atchFileGroupId").toString()));
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

    int atchFlId = autoDebitMapper.selectNextFileId();

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
	int statusCodeId = Integer.parseInt(params.get("statusCodeId").toString());
	//If approve, update SAL0074D credit card info
	if(statusCodeId == 5){
		EgovMap padDetail = autoDebitMapper.getPadDetail(params);
		params.put("custCrcId", Integer.parseInt(padDetail.get("custCrcId").toString()));
		params.put("salesOrdNo", padDetail.get("salesOrdNo").toString());
		params.put("is3rdParty", Integer.parseInt(padDetail.get("isThirdPartyPayment").toString()));

		params.put("custId", Integer.parseInt(padDetail.get("custId").toString()));
		if(Integer.parseInt(padDetail.get("isThirdPartyPayment").toString()) == 0){
			params.put("custId", Integer.parseInt(padDetail.get("custId").toString()));
		}
		else{
			params.put("custId", Integer.parseInt(padDetail.get("thirdPartyCustId").toString()));
		}

		EgovMap currentPaymentChannel = autoDebitMapper.getCurrentPaymentChannelDetail(params);
		params.put("rentPayId", Integer.parseInt(currentPaymentChannel.get("rentPayId").toString()));

		EgovMap creditCardDetail = autoDebitMapper.getCreditDebitCardDetail(params);
		params.put("bankId", Integer.parseInt(creditCardDetail.get("custCrcBankId").toString()));
		params.put("ddSubmitDt","01/01/1900");
		params.put("ddStartDt","01/01/1900");
		params.put("ddRejctDt","01/01/1900");
		//Mode ID is either Credit Card/Direct Debit (debit card is a form of credit card, direct debit is bank account)
		params.put("modeId",131);
		params.put("custAccId",0);
		params.put("editTypeId",0);
		params.put("lastApplyUser", Integer.parseInt(padDetail.get("crtBy").toString()));
		params.put("svcCntrctId",0);

		int updateSal0074d = autoDebitMapper.updatePaymentChannel(params);
		if(updateSal0074d > 0){
		    int updatePay0333m = autoDebitMapper.updateAction(params);
		    if (updatePay0333m > 0) {
		      return 1;
		    } else {
		      return 0;
		    }
		}
		else{
			return 0;
		}
	}
	else{
		int updatePay0333m = autoDebitMapper.updateAction(params);
	    if (updatePay0333m > 0) {
	      return 1;
	    } else {
	      return 0;
	    }
	}
  }

  @Override
  public Map<String, Object> autoDebitMobileSubmissionSave(Map<String, Object> params) {
    EgovMap creatorInfo = autoDebitMapper.selectCreatorInfo(params.get("createdBy").toString());

    params.put("signImg", params.get("signData"));
    params.put("creatorId", creatorInfo.get("userId"));
    params.put("userBranch", creatorInfo.get("userBranch"));
    if (params.get("isThirdPartyPayment").toString().toLowerCase() == "true") {
      params.put("isThirdPartyPaymentCheck", 1);
    } else {
      params.put("isThirdPartyPaymentCheck", 0);
      params.put("thirdPartyCustId", null);
    }

    String padNo = commonMapper.selectDocNo("187");
    int padId = Integer.parseInt(padNo.substring(3).replaceFirst("^0+(?!$)", ""));
    params.put("padNo", padNo);
    params.put("padId", padId);

    int insertPay0333M = autoDebitMapper.insertAutoDebitMobileSubmmisionData(params);
    LOGGER.debug("Auto Debit Resubmit Pilot Test Check insertPay0333M : ",insertPay0333M);
    if (insertPay0333M > 0) {
	  params.put("result", "1");
      return params;
    } else {
	  params.put("result", "0");
      return params;
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
  public List<EgovMap> selectCustomerList(CustomerApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSelectType())) {
      throw new ApplicationException(AppConstants.FAIL, "Select Type value does not exist.");
    } else {
      if (("1").equals(param.getSelectType()) && param.getSelectKeyword().length() < 5) {
        throw new ApplicationException(AppConstants.FAIL, "Please fill out at least five characters.");
      }
      if ((("2").equals(param.getSelectType()) || ("3").equals(param.getSelectType()))
          && CommonUtils.isEmpty(param.getSelectKeyword())) {
        throw new ApplicationException(AppConstants.FAIL, "Select Keyword value does not exist.");
      }
    }
    if (CommonUtils.isEmpty(param.getMemId()) || param.getMemId() <= 0) {
      throw new ApplicationException(AppConstants.FAIL, "mdmId value does not exist.");
    }
    return autoDebitMapper.selectCustomerList(CustomerApiForm.createMap(param));
  }

  @Override
  public void sendSms(Map<String, Object> params) {
    if (!"".equals(CommonUtils.nvl(params.get("sms1"))) || !"".equals(CommonUtils.nvl(params.get("sms2")))) {
    	String baseUrl = etrustBaseUrl;
    	String padId =  params.get("padId").toString();
    	String padNo =  params.get("padNo").toString();
    	String combinationKey = padId + "&" + padNo;
    	String encryptedString = "";

    	//creating encryption string for url
    	try {
    		encryptedString = encryptionDecryptionService.encrypt(combinationKey,"autodebit");

    	} catch (Exception e) {
    		// TODO Auto-generated catch block
    		LOGGER.error("autodebitsubmission sms  encryptedString: =====================>> " + e.toString());
    		e.printStackTrace();
    	}
    	params.put("destinationLink", baseUrl + "/payment/mobileautodebit/autoDebitAuthorizationPublicForm.do?key=" + encryptedString);

    	//get tinyUrl link
    	try{
    		Map<String,Object> returnParams = new HashMap<String, Object>();
    		String output1 = "";

    		URL url = new URL(tinyUrlApi + "/create");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.disconnect();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + tinyUrlToken);
            conn.connect();

            DataOutputStream out = new DataOutputStream(conn.getOutputStream());
            String jsonString = "{\"url\":\"" + params.get("destinationLink") + "\",\"domain\": \"" + tinyUrlSubDomain + "\"}";
            out.write(jsonString.getBytes());
            out.flush();
            out.close();

            InputStream inputStream;
            if (conn.getResponseCode() == 200) {
                inputStream = conn.getInputStream();
                returnParams.put("status", AppConstants.SUCCESS);
                returnParams.put("msg", "");
            } else {
                inputStream = conn.getErrorStream();
                returnParams.put("status", AppConstants.FAIL);
            }

            if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
            	BufferedReader br = new BufferedReader(new InputStreamReader(
    	                (conn.getInputStream())));

            	String output = "";
    	        LOGGER.debug("Output from Server .... \n");
    	        while ((output = br.readLine()) != null) {
    	        	output1 = output;
    	        	LOGGER.debug(output);
    	        	returnParams.put("msg", output);
    	        }

    	        JSONObject obj = new JSONObject(output1);
            	String tinyUrl = obj.getJSONObject("data").getString("tiny_url");
            	params.put("tinyUrl", tinyUrl);
            }

    		conn.disconnect();
    	} catch (Exception e) {
    		// TODO Auto-generated catch block
    		LOGGER.error("autodebitsubmission sms  encryptedString error: =====================>> " + e.toString());
    		e.printStackTrace();
    	} finally {
    		//Send Message
    	    EgovMap custCardBankIssuer = autoDebitMapper.selectCustCardBankInformation(params);
    	    String custCardNo = custCardBankIssuer.get("custOriCrcNo").toString();
    	    String cardEnding = custCardNo.substring(custCardNo.length() - 4);
    	    params.put("bankIssuer", custCardBankIssuer.get("bankIssuer"));
    	    params.put("cardEnding", cardEnding);
    	    int userId = autoDebitMapper.getUserID(params.get("createdBy").toString());
    	    SmsVO sms = new SmsVO(userId, 975);
    	    String smsTemplate = autoDebitMapper.getSmsTemplate(params);
    	    String smsNo = "";

    	    params.put("smsTemplate", smsTemplate);

    	    if (!"".equals(CommonUtils.nvl(params.get("sms1")))) {
    	        smsNo = CommonUtils.nvl(params.get("sms1"));
    	    }

            if (!"".equals(CommonUtils.nvl(params.get("sms2")))) {
                if (!"".equals(CommonUtils.nvl(smsNo))) {
                	smsNo += "|!|" + CommonUtils.nvl(params.get("sms2"));
                } else {
                	smsNo = CommonUtils.nvl(params.get("sms2"));
                }
            }

    	    if (!"".equals(CommonUtils.nvl(smsNo))) {
    	      sms.setMessage(CommonUtils.nvl(smsTemplate));
    	      sms.setMobiles(CommonUtils.nvl(smsNo));
    	      sms.setRemark("SMS AUTO DEBIT VIA MOBILE APPS");
    	      sms.setRefNo(CommonUtils.nvl(params.get("padNo")));
    	      SmsResult smsResult = adaptorService.sendSMS(sms);
    	      LOGGER.debug(" autodebitsubmission sms  smsResult : {}", smsResult.getFailReason().toString());
    	    }
    	}
    }
  }

  @SuppressWarnings("unchecked")
  @Override
  public void sendEmail(Map<String, Object> params) {
	//Sending attachment
//	params.put(REPORT_FILE_NAME, "/payment/AutoDebitAuthorization.rpt");// visualcut
//    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
//    params.put("V_WHERESQL", "AND p0333m.PAD_ID = " + params.get("padId").toString());// parameter
//    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
//        "AutoDebitAuthorisationForm_" + CommonUtils.getNowDate());

    EmailVO email = new EmailVO();
    String emailSubject = "COWAY: Credit/Debit Card Auto Debit Authorisation";

    Map<String, Object> additionalParams = (Map<String, Object>) autoDebitMapper.getEmailDescription(params);
    params.putAll(additionalParams);

    List<String> emailNo = new ArrayList<String>();

    if (!"".equals(CommonUtils.nvl(params.get("email1")))) {
      emailNo.add(CommonUtils.nvl(params.get("email1")));
    } else if (!"".equals(CommonUtils.nvl(params.get("email2")))) {
      emailNo.add(CommonUtils.nvl(params.get("email2")));
    }

    String content = "";
    content += "Dear Sir/Madam,\n";
    content += "Thank you for subscribing to Auto-Debit with " + params.get("bankShortName").toString() + " card ending " + params.get("cardLast4Digit").toString() + " for order " + params.get("salesOrdNo").toString() + ".\n\n";
    content += "Monthly Payment Amount : RM" + params.get("monthlyRentalAmount").toString() + ".\n\n";
    content += "Your card info shall be updated within 3 working days upon your signature acknowledgement. Kindly call 1800-888-111 for enquiry. \n\n\n\n";
    content += "This is a system generated email. Please do not respond to this email. \n";

    params.put(EMAIL_SUBJECT, emailSubject);
    params.put(EMAIL_TO, emailNo);
    params.put(EMAIL_TEXT, content);

    	if(emailNo.size() > 0){
            email.setTo(emailNo);
            email.setHtml(true);
            email.setSubject(emailSubject);
            email.setText(content);
    		adaptorService.sendEmail(email, false);
    		//this.view(null, null, params); //Included sending email
    	}
  }


  private void view(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params)
	      throws IOException {
	   Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_FILE_NAME)),
		        messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_FILE_NAME }));

	   Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_VIEW_TYPE)),
		        messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_VIEW_TYPE }));

	    SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS", Locale.getDefault(Locale.Category.FORMAT));
	    Calendar startTime = Calendar.getInstance();
	    Calendar endTime = null;

	    String reportFile = (String) params.get(REPORT_FILE_NAME);
	    ViewType viewType = ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));
	    String reportName = reportFilePath + reportFile;
	    String prodName = "view";
	    int maxLength = 0;
	    String msg = "Completed";
	    try {

	      ReportClientDocument clientDoc = new ReportClientDocument();

	      clientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
	      clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);
	      {
	        String connectString = reportUrl;
	        String driverName = reportDriverClass;
	        String jndiName = "";
	        String userName = reportUserName;
	        String password = reportPassword;

	        //CRJavaHelper.changeDataSource(clientDoc, userName, password, connectString, driverName, jndiName);
	        CRJavaHelper.replaceConnection(clientDoc, userName, password, connectString, driverName, jndiName);
	        CRJavaHelper.logonDataSource(clientDoc, userName, password);
	      }

	      Object reportSource = clientDoc.getReportSource();

	      params.put("repProdName", prodName);

	      ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
	      Fields fields = clientDoc.getDataDefinition().getParameterFields();

	      ReportUtils.setReportParameter(params, paramController, fields);
	      {
	        this.viewHandle(request, response, viewType, clientDoc, ReportUtils.getCrystalReportViewer(reportSource),
	            params);
	      }
	    } catch (Exception ex) {
	      LOGGER.error("autodebitsummission email error {}", CommonUtils.printStackTraceToString(ex));
	      maxLength = CommonUtils.printStackTraceToString(ex).length() <= 4000 ? CommonUtils.printStackTraceToString(ex).length() : 4000;

	      msg = CommonUtils.printStackTraceToString(ex).substring(0, maxLength);
	      throw new ApplicationException(ex);
	    } finally{
	      // Insert Log
	      endTime = Calendar.getInstance();
	      params.put("msg", msg);
	      params.put("startTime", fmt.format(startTime.getTime()));
	      params.put("endTime", fmt.format(endTime.getTime()));
	      params.put("userId", 349);

	      reportBatchService.insertLog(params);
	    }
	  }

  private void viewHandle(HttpServletRequest request, HttpServletResponse response, ViewType viewType,
	      ReportClientDocument clientDoc, CrystalReportViewer crystalReportViewer, Map<String, Object> params)
	      throws ReportSDKExceptionBase, IOException {

	  //Tested with switch case, apparently switch case unable to handle viewtype and return error 505 so use if/else
	    if(viewType == ViewType.MAIL_PDF){
	    	  ReportUtils.sendMailMultiple(clientDoc, viewType, params);
	    }
	    else{
	    	throw new ApplicationException(AppConstants.FAIL, "wrong viewType....");
	    }
   }


  @Override
	public int updateFailReason(Map<String, ArrayList<Object>> params,SessionVO sessionVO)  {

		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

  		int loginId = 0, updResult = 0;
  		if(sessionVO != null){
  			loginId = sessionVO.getUserId();
  		}

  		if(updateList != null && updateList.size() >0){
      		for (Object list : updateList){
      			Map<String, Object> map = (Map<String, Object>) list;
      			map.put("updUserId", loginId);
      			updResult = autoDebitMapper.updateFailReason(map);
      		}
  		}

  		return updResult;
	}



}
