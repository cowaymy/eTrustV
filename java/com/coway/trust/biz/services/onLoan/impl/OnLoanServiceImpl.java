package com.coway.trust.biz.services.onLoan.impl;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.impl.OrderDetailMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.sales.order.vo.ASEntryVO;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.CcpDecisionMVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.EStatementReqVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.InstallEntryVO;
import com.coway.trust.biz.sales.order.vo.InstallResultVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.services.onLoan.OnLoanService;
import com.coway.trust.biz.services.onLoan.vo.LoanOrderDVO;
import com.coway.trust.biz.services.onLoan.vo.LoanOrderMVO;
import com.coway.trust.biz.services.onLoan.vo.LoanOrderVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.services.loan.constant.OnLoanOrderConstant;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * IHR On-Loan Order service
 * @author HQIT-HUIDING
 * @date Feb 10, 2020
 *
 */
@Service("onLoanOrderService")
public class OnLoanServiceImpl extends EgovAbstractServiceImpl implements OnLoanService{

	private static Logger logger = LoggerFactory.getLogger(OnLoanServiceImpl.class);

	@Resource(name = "onLoanOrderMapper")
	private OnLoanOrderMapper onLoanOrderMapper;

	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;

	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;

	@Override
	public List<EgovMap> selectLoanOrdList (Map<String, Object> params) {
		return onLoanOrderMapper.selectLoanOrdList(params);
	}

	@Override
	public List<EgovMap> getUserCodeList() {
	    return onLoanOrderMapper.getUserCodeList();
	}

	@Override
	public List<EgovMap> getOrgCodeList(Map<String, Object> params) {
		return onLoanOrderMapper.getOrgCodeList(params);
	}

	@Override
	public List<EgovMap> getGrpCodeList(Map<String, Object> params) {
	    return onLoanOrderMapper.getGrpCodeList(params);
	}

	public void registerOnLoanOrder(LoanOrderVO loanOrderVO, SessionVO sessionVO) throws ParseException {
		logger.info("!@###### OnLoanOrderCo.registerOrder");

		LoanOrderVO regOrderVO = new LoanOrderVO();
		LoanOrderMVO loanOrderMVO = loanOrderVO.getLoanOrderMVO(); // loan order master
		LoanOrderDVO loanOrderDVO = loanOrderVO.getLoanOrderDVO(); // loan order details

		InstallationVO installationVO = loanOrderVO.getInstallationVO();
		CustBillMasterVO custBillMasterVO = loanOrderVO.getCustBillMasterVO();
		//EStatementReqVO eStatementReqVO = loanOrderVO.geteStatementReqVO(); // CCP DETAILS
		GSTEURCertificateVO gSTEURCertificateVO = loanOrderVO.getgSTEURCertificateVO();
		GridDataSet<DocSubmissionVO> documentList = loanOrderVO.getDocSubmissionVOList();
		List<DocSubmissionVO> docSubVOList = documentList.getUpdate();

		int loanOrdAppType = (int) onLoanOrderMapper.selectLoanAppType(); // preset loan order APP_TYPE = IHR
		int custTypeId = loanOrderVO.getCustTypeId();
		int custRaceId = loanOrderVO.getRaceId();
	    String billGrp = loanOrderVO.getBillGrp(); // new, exist
	    String sInstallDate = installationVO.getPreDt();
	    int itmStkId = loanOrderDVO.getItmStkId();
//	    int itmCompId = loanOrderDVO.getItmCompId();
	    int brnchId = installationVO.getBrnchId();

	    DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
	    String dInstallDate = sInstallDate;

	    loanOrderMVO.setAppTypeId(loanOrdAppType);
	    regOrderVO.setCustTypeId(custTypeId);
	    regOrderVO.setRaceId(custRaceId);
	    regOrderVO.setsInstallDate(sInstallDate);
	    regOrderVO.setdInstallDate(dInstallDate);

	    this.preprocLoanOrderMaster(loanOrderMVO, sessionVO);
	    this.preprocLoanOrderDetails(loanOrderDVO, sessionVO);
	    //this.preprocInstallationMaster(installationVO, sessionVO);

	    // ------------------------------------------------------------------------------
	    // START
	    // ------------------------------------------------------------------------------
	    regOrderVO.setLoanOrderDVO(loanOrderDVO);
	    regOrderVO.setInstallationVO(installationVO);

	    this.preprocDocumentList(docSubVOList, sessionVO);
	    regOrderVO.setDocSubVOList(docSubVOList);

	    if ("new".equals(billGrp)) {
	        this.preprocCustomerBillMaster(custBillMasterVO, sessionVO);
	        regOrderVO.setCustBillMasterVO(custBillMasterVO);

	        /*this.preprocEStatementRequest(eStatementReqVO, sessionVO);
	        regOrderVO.seteStatementReqVO(eStatementReqVO);*/
	      }

	  // CALL ENTRY
	    /*CallEntryVO callEntryVO = new CallEntryVO();
		this.preprocCallEntryMaster(callEntryVO, loanOrdAppType, sInstallDate, sessionVO);
		regOrderVO.setCallEntryVO(callEntryVO);*/

	 // SALES ORDER LOG
	    List<SalesOrderLogVO> salesOrderLogVOList = new ArrayList<SalesOrderLogVO>();
	    this.preprocOrderLog(salesOrderLogVOList, custTypeId, custRaceId, sessionVO);
	    regOrderVO.setSalesOrderLogVOList(salesOrderLogVOList);

	 // GST CERTIFICATE
	    if (gSTEURCertificateVO != null && gSTEURCertificateVO.getAtchFileGrpId() > 0) {
	      this.preprocGSTCertificate(gSTEURCertificateVO, loanOrdAppType, sessionVO);
	      regOrderVO.setgSTEURCertificateVO(gSTEURCertificateVO);
	    }

	 // AS ENTRY
	 /*  int count = onLoanOrderMapper.chkCrtAS(loanOrderDVO);
	    if (count > 0) {
	      ASEntryVO aSEntryVO = new ASEntryVO();
	      this.preprocASEntry(aSEntryVO, sessionVO);
	      String asNo = onLoanOrderMapper.selectDocNo(DocTypeConstants.AS_ENTRY);
	      aSEntryVO.setAsNo(asNo);
	      aSEntryVO.setAsAppntDt(installationVO.getPreDt());
	      aSEntryVO.setAsBrnchId(brnchId);

	      regOrderVO.setASEntryVO(aSEntryVO);
	      loanOrderVO.setASEntryVO(aSEntryVO);
	    } */


	    // get loan order number
	    String loanOrdNo = onLoanOrderMapper.selectDocNo(DocTypeConstants.ON_LOAN_REPAIR_NO);
	    loanOrderMVO.setLoanOrdNo(loanOrdNo);

	    logger.info("#### GET NEW LOAN NUMBER :" + loanOrdNo);

	    regOrderVO.setLoanOrderMVO(loanOrderMVO);
	    // save order
	    this.doSaveOrder(regOrderVO);

	    logger.info("egOrderVO.getLoanOrderMVO().getSalesOrdId() : {}" + regOrderVO.getLoanOrderMVO().getSalesOrdId());
	    logger.info("regOrderVO.getSalesOrderMVO().getLoanOrdNo() : {}" + regOrderVO.getLoanOrderMVO().getLoanOrdNo());

	}

	private void doSaveOrder(LoanOrderVO loanOrderVO) {
		logger.info("###### OnLoanServiceImpl.doSaveOrder");

		LoanOrderMVO loanOrderMVO = loanOrderVO.getLoanOrderMVO();
		LoanOrderDVO loanOrderDVO = loanOrderVO.getLoanOrderDVO();
		InstallationVO installationVO = loanOrderVO.getInstallationVO();
		CustBillMasterVO custBillMasterVO = loanOrderVO.getCustBillMasterVO();
	    //EStatementReqVO eStatementReqVO = loanOrderVO.geteStatementReqVO();
	    //CcpDecisionMVO ccpDecisionMVO = loanOrderVO.getCcpDecisionMVO();
	    List<DocSubmissionVO> docSubVOList = loanOrderVO.getDocSubVOList();
	    //CallEntryVO callEntryVO = loanOrderVO.getCallEntryVO();
	    //CallResultVO callResultVO = loanOrderVO.getCallResultVO();
	    InstallEntryVO installEntryVO = loanOrderVO.getInstallEntryVO();
	    InstallResultVO installResultVO = loanOrderVO.getInstallResultVO();
	    List<SalesOrderLogVO> salesOrderLogVOList = loanOrderVO.getSalesOrderLogVOList();
	    GSTEURCertificateVO gSTEURCertificateVO = loanOrderVO.getgSTEURCertificateVO();
	    //ASEntryVO asEntryVO = loanOrderVO.getASEntryVO();

	    // insert installation record

	    logger.info("###### relateOrdNo: " + loanOrderMVO.getRelateOrdNo())  ;

	    int orderAppType = loanOrderVO.getOrderAppType();

	    int salesOrdId = 0;
	    int loanOrdId = 0;
	    String installDate = installationVO.getPreDt();

	    // INSERT loan order master
	    logger.info("!@#### INSERT LOAN ORDER MASTER before --- LOAN ORDER ID: " + loanOrderMVO.getLoanOrdId());
	    logger.info("!@#### INSERT LOAN ORDER MASTER before --- SALES ORDER ID: " + loanOrderMVO.getSalesOrdId());
	    onLoanOrderMapper.insertLoanOrderMaster(loanOrderMVO);

	    logger.info("!@#### INSERT LOAN ORDER MASTER after --- LOAN ORDER ID: " + loanOrderMVO.getLoanOrdId());
	    logger.info("!@#### INSERT LOAN ORDER MASTER after --- SALES ORDER ID: " + loanOrderMVO.getSalesOrdId());

	    loanOrdId = (int) loanOrderMVO.getLoanOrdId();
	    salesOrdId  = (int) loanOrderMVO.getSalesOrdId();

	    // INSERT Loan Order Details
	    loanOrderDVO.setLoanOrdId(loanOrdId);
	    onLoanOrderMapper.insertLoanOrderDetails(loanOrderDVO);

	    // INSTALLATION
	    installationVO.setSalesOrdId(salesOrdId);
	    orderRegisterMapper.insertInstallation(installationVO);

	    // CUSTOMER BILL MASTER
	    if (custBillMasterVO != null && custBillMasterVO.getCustBillCustId() > 0) {
	      String billGroupNo = orderRegisterMapper.selectDocNo(DocTypeConstants.BILLGROUP_NO);

	      custBillMasterVO.setCustBillGrpNo(billGroupNo);
	      custBillMasterVO.setCustBillSoId(salesOrdId);
	      orderRegisterMapper.insertCustBillMaster(custBillMasterVO);

	      logger.info("!@#### GET NEW CUST_BILL_ID  :" + custBillMasterVO.getCustBillId());

	      loanOrderMVO.setCustBillId(custBillMasterVO.getCustBillId());
	      onLoanOrderMapper.updateCustBillId(loanOrderMVO);
	    }

	    // E-STATEMENT
	    /*if (eStatementReqVO != null && eStatementReqVO.getStusCodeId() > 0) {
	        String eStatementReqNo = orderRegisterMapper.selectDocNo(DocTypeConstants.ESTATEMENT_REQ);

	        eStatementReqVO.setRefNo(eStatementReqNo);
	        eStatementReqVO.setCustBillId(loanOrderMVO.getCustBillId());
	        orderRegisterMapper.insertEStatementReq(eStatementReqVO);
	      }*/

	    // DOCUMENT SUBMISSION
	    if (docSubVOList != null && docSubVOList.size() > 0) {
	      for (DocSubmissionVO docSubVO : docSubVOList) {
	        docSubVO.setDocSoId(salesOrdId);
	        orderRegisterMapper.insertDocSubmission(docSubVO);
	      }
	    }

	    // CALL ENTRY MASTER
	    /*if (callEntryVO != null && (int) callEntryVO.getStusCodeId() > 0) {
	        callEntryVO.setSalesOrdId(salesOrdId);
	        callEntryVO.setDocId(salesOrdId);
	        orderRegisterMapper.insertCallEntry(callEntryVO);
	      }*/

	    // insertSalesOrderLog;
	    if (salesOrderLogVOList != null && salesOrderLogVOList.size() > 0) {
	    	for (SalesOrderLogVO salesOrderLogVO : salesOrderLogVOList) {
	    		if (salesOrderLogVO.getPrgrsId() == 14) { // order on-loan request
	    			salesOrderLogVO.setRefId((int)loanOrderMVO.getLoanOrdId());
	    		}

	    		salesOrderLogVO.setSalesOrdId(salesOrdId);
	    		orderRegisterMapper.insertSalesOrderLog(salesOrderLogVO);
	    	}
	    }

	    // INSERT GST CERTIFICATE
	    if (gSTEURCertificateVO != null) {
	      gSTEURCertificateVO.setEurcSalesOrdId(salesOrdId);
	      orderRegisterMapper.insertGSTEURCertificate(gSTEURCertificateVO);
	    }
	}

	private void preprocOrderLog(List<SalesOrderLogVO> salesOrderLogVOList, int custTypeId,
		      int custRaceId, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### preprocOrderLogList START ");

		SalesOrderLogVO salesOrderLogVO = new SalesOrderLogVO();

		int progressId = OnLoanOrderConstant.PROGRESS_LOCK_ID_LOAN; // Order On-Loan Request type

	    salesOrderLogVO.setLogId(0);
	    salesOrderLogVO.setSalesOrdId(0);
	    salesOrderLogVO.setPrgrsId(progressId);
	    salesOrderLogVO.setRefId(0);
	    salesOrderLogVO.setIsLok(OnLoanOrderConstant.LOCK_TRUE);
	    salesOrderLogVO.setLogCrtUserId(sessionVO.getUserId());

	    salesOrderLogVOList.add(salesOrderLogVO);
	}

	private void preprocLoanOrderMaster(LoanOrderMVO loanOrderMVO, SessionVO sessionVO){
		loanOrderMVO.setSalesOrdId(0);
		loanOrderMVO.setLoanOrdId(0);
		loanOrderMVO.setLoanOrdNo("");
		loanOrderMVO.setBrnchId(sessionVO.getUserBranchId());
		loanOrderMVO.setTaxAmt(BigDecimal.ZERO);
		loanOrderMVO.setStusCodeId(1);
//		loanOrderMVO.setUpdUserId();
		loanOrderMVO.setSyncChk(0);
		loanOrderMVO.setSmoNo("");
		loanOrderMVO.setEditTypeId(0);
		loanOrderMVO.setCrtUserId(sessionVO.getUserId());

	}

	private void preprocLoanOrderDetails(LoanOrderDVO loanOrderDVO, SessionVO sessionVO){

		loanOrderDVO.setLoanOrdId(0);
		loanOrderDVO.setItmNo(1);
		loanOrderDVO.setItmQty(1);
		loanOrderDVO.setStusCodeId(1);
		loanOrderDVO.setUpdUserId(sessionVO.getUserId());
		loanOrderDVO.setEditTypeId(0);
		loanOrderDVO.setItmId(0);
		loanOrderDVO.setItmCallEntryId(0);

	}

	private String convert24Tm(String TM) {
	    String ampm = "", HH = "", MI = "", cvtTM = "";

	    if (CommonUtils.isNotEmpty(TM)) {
	      ampm = CommonUtils.right(TM, 2);
	      HH = CommonUtils.left(TM, 2);
	      MI = TM.substring(3, 5);

	      if ("PM".equals(ampm)) {
	        cvtTM = String.valueOf(Integer.parseInt(HH) + 12) + ":" + MI + ":00";
	      } else {
	        cvtTM = HH + ":" + MI + ":00";
	      }
	    }
	    return cvtTM;
	  }

	/*private void preprocInstallationMaster(InstallationVO installationVO, SessionVO sessionVO) {

	    logger.info("!@###### preprocInstallationMaster START ");

	    installationVO.setInstallId(0);
	    installationVO.setSalesOrdId(0);
	    installationVO.setPreTm(this.convert24Tm(installationVO.getPreTm()));
	    installationVO.setActDt(SalesConstants.DEFAULT_DATE2);
	    installationVO.setActTm(SalesConstants.DEFAULT_TM);
	    installationVO.setStusCodeId(1);
	    installationVO.setUpdUserId(sessionVO.getUserId());
	    installationVO.setEditTypeId(0);
	    installationVO.setInstallId(0);

	  }*/

	private Map<String, Object> getInstallMaster(Map<String, Object> params, SessionVO sessionVO) {
		Map<String, Object> installMaster = new HashMap<String, Object>();
	    int CTId = 0;
	    CTId = Integer.parseInt(params.get("assignCTId").toString());
	    String appointmentDate = "";
	    if (params.get("appDate") != null) {
	      appointmentDate = params.get("appDate").toString();
	    }
	    String CTGroup = "";
	    if (params.get("CTgroup") != null) {
	      CTGroup = params.get("CTgroup").toString();
	    }
	    installMaster.put("installEntryId", 0);
	    installMaster.put("installEntryNo", "");
	    installMaster.put("salesOrderId", params.get("salesOrdId"));
	    installMaster.put("statusCodeId", 1);
	    installMaster.put("CTID", CTId);
	    installMaster.put("installDate", appointmentDate);
	    installMaster.put("appDate", appointmentDate);
	    installMaster.put("callEntryId", params.get("callEntryId"));
	    installMaster.put("installStkId",  CommonUtils.intNvl(params.get("hiddenProductId")));
	    installMaster.put("installResultId", 0);
	    installMaster.put("created", new Date());
	    installMaster.put("creator", sessionVO.getUserId());
	    installMaster.put("allowComm", false);
	    installMaster.put("isTradeIn", false);
	    installMaster.put("CTGroup", CTGroup);
	    installMaster.put("updated", new Date());
	    installMaster.put("updator", sessionVO.getUserId());
	    installMaster.put("revId", 0);
	    installMaster.put("stock", params.get("stock"));
	    logger.debug("installMaster : {}", installMaster);
	    return installMaster;
	}



	private void preprocCustomerBillMaster(CustBillMasterVO custBillMasterVO, SessionVO sessionVO) {

	    custBillMasterVO.setCustBillId(0);
	    custBillMasterVO.setCustBillSoId(0);
	    custBillMasterVO.setCustBillStusId(SalesConstants.STATUS_ACTIVE);
	    custBillMasterVO.setCustBillUpdUserId(sessionVO.getUserId());
	    custBillMasterVO.setCustBillGrpNo("");
	    custBillMasterVO.setCustBillCrtUserId(sessionVO.getUserId());
	    custBillMasterVO.setCustBillPayTrm(0);
	    custBillMasterVO.setCustBillInchgMemId(0);
	}

	private void preprocDocumentList(List<DocSubmissionVO> updateDocList, SessionVO sessionVO) {

	    logger.info("!@###### preprocDocumentList START ");

	    for (int i = updateDocList.size() - 1; i >= 0; i--) {

	      DocSubmissionVO docVO = updateDocList.get(i);

	      if (docVO.getChkfield() == 1) {
	        docVO.setDocSubId(0);
	        docVO.setDocSubTypeId(SalesConstants.CCP_DOC_SUB_CODE_ID_ICS);
	        docVO.setDocTypeId(docVO.getCodeId());
	        docVO.setDocSoId(0);
	        docVO.setDocMemId(0);
	        docVO.setDocCopyQty(1);
	        docVO.setStusId(1);
	        docVO.setCrtUserId(sessionVO.getUserId());
	        docVO.setUpdUserId(sessionVO.getUserId());
	        docVO.setDocSubBatchId(0);
	        docVO.setDocSubBrnchId(sessionVO.getUserBranchId());
	      } else {
	        updateDocList.remove(i);
	      }
	    }
	  }


	/*private void preprocEStatementRequest(EStatementReqVO eStatementReqVO, SessionVO sessionVO) {

	    logger.info("!@###### preprocEStatementRequest START ");

	    eStatementReqVO.setReqId(0);
	    eStatementReqVO.setStusCodeId(5);
	    eStatementReqVO.setCustBillId(0);
	    eStatementReqVO.setCnfmCode(CommonUtils.getRandomNumber(10));
	    eStatementReqVO.setCrtUserId(sessionVO.getUserId());
	    eStatementReqVO.setUpdUserId(sessionVO.getUserId());
	    eStatementReqVO.setEmailFailInd(0);
	    eStatementReqVO.setEmailFailDesc("");
	    eStatementReqVO.setRefNo("");

	  }*/

	private void preprocGSTCertificate(GSTEURCertificateVO gSTEURCertificateVO, int orderAppType, SessionVO sessionVO)
		      throws ParseException {

		    logger.info("!@###### preprocGSTCertificate START ");

		    int reliefTypeId = 0;

		    gSTEURCertificateVO.setEurcRliefTypeId(reliefTypeId);
		    gSTEURCertificateVO.setEurcRliefAppTypeId(orderAppType);
		    gSTEURCertificateVO.setEurcStusCodeId(SalesConstants.STATUS_ACTIVE);
		    gSTEURCertificateVO.setEurcCrtUserId(sessionVO.getUserId());
		    gSTEURCertificateVO.setEurcUpdUserId(sessionVO.getUserId());

		    logger.info("!@###### preprocGSTCertificate END ");
		  }


	/*private void preprocCallEntryMaster(CallEntryVO callEntryVO, int orderAppType, String installDate,
		      SessionVO sessionVO) throws ParseException {

		    logger.info("!@###### preprocCallEntryMaster START ");

		    // direct ready to install stage
		    int statusCodeId = 1;

		    // get call log type from SYS0013M
		    int callLogLoanCode = onLoanOrderMapper.selectCallLogCodeLoan("LOAN");
		    logger.info("@#### callLogLoanCode:" + callLogLoanCode);

		    String callDate = installDate;
		    logger.info("@#### callDate:" + callDate);

		    callEntryVO.setCallEntryId(0);
		    callEntryVO.setSalesOrdId(0);
		    callEntryVO.setTypeId(callLogLoanCode);
		    callEntryVO.setStusCodeId(statusCodeId);
		    callEntryVO.setResultId(0);
		    callEntryVO.setDocId(0);
		    callEntryVO.setCrtUserId(sessionVO.getUserId());
		    callEntryVO.setCallDt(callDate);
		    callEntryVO.setIsWaitForCancl(SalesConstants.IS_FALSE);
		    callEntryVO.setHapyCallerId(0);
		    callEntryVO.setUpdUserId(sessionVO.getUserId());
		    callEntryVO.setOriCallDt(callDate);

		    logger.info("!@###### preprocCallEntryMaster END ");

		  }*/

	@Override
	public EgovMap selectLoanOrdBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		EgovMap loanOrdDtl = new EgovMap();

		//Basic Info
		EgovMap basicInfo = onLoanOrderMapper.selectBasicInfo(params);
		EgovMap logView   = orderDetailMapper.selectLatestOrderLogByOrderID(params);
		EgovMap installationInfo = onLoanOrderMapper.selectOrderInstallationInfoByOrderID(params);
		EgovMap salesmanInfo 	 = onLoanOrderMapper.selectOrderSalesmanViewByOrderID(params);
		EgovMap mailingInfo 	 = onLoanOrderMapper.selectOrderMailingInfoByOrderID(params);

		params.put("viewSort", "1");
		List<EgovMap> callLog      = orderDetailMapper.selectCallLogList(params);

		String memInfo = null;
		if (basicInfo != null){
			logger.info("###############CUST_NRIC: " + basicInfo.get("custNric"));
			memInfo = orderDetailMapper.selectMemberInfo(CommonUtils.nvl(basicInfo.get("custNric")));
		}

		if(CommonUtils.isNotEmpty(memInfo)) {
			basicInfo.put("memInfo", "("+memInfo+")");
		}

		this.loadCustInfo(basicInfo);
		if(installationInfo != null) this.loadInstallationInfo(installationInfo);
		if(mailingInfo != null) this.loadMailingInfo(mailingInfo, basicInfo);

		loanOrdDtl.put("basicInfo",     	basicInfo);
		loanOrdDtl.put("logView",       	logView);
		loanOrdDtl.put("installationInfo", installationInfo);
		loanOrdDtl.put("salesmanInfo", 	salesmanInfo);
		loanOrdDtl.put("mailingInfo", 		mailingInfo);
		loanOrdDtl.put("callLog",   	callLog);

		Date loanDt = (Date) basicInfo.get("loanDt");

		DateFormat formatter = new SimpleDateFormat("yyyyMMdd");

		Date dt = formatter.parse("20180101");


		logger.debug("@#### loanDt:"+loanDt);
		logger.debug("@#### dt:"+dt);

		boolean isNew = false;
		if (loanDt != null)
			isNew = loanDt.after(dt);

		logger.debug("@#### isBefore:"+isNew);

		loanOrdDtl.put("isNewVer", isNew ? "Y" : "N");

		return loanOrdDtl;
	}

	private void loadMailingInfo(EgovMap mailingInfo, EgovMap basicInfo) {

		String fullAddress = "";

		if(CommonUtils.isNotEmpty(mailingInfo.get("mailAdd1"))) {
			fullAddress += mailingInfo.get("mailAdd1") + "<br />";
		}
		if(CommonUtils.isNotEmpty(mailingInfo.get("mailAdd2"))) {
			fullAddress += mailingInfo.get("mailAdd2") + "<br />";
		}
		if(CommonUtils.isNotEmpty(mailingInfo.get("mailAdd3"))) {
			fullAddress += mailingInfo.get("mailAdd3") + "<br />";
		}

		mailingInfo.put("fullAddress", fullAddress);

	}

	private void loadCustInfo(EgovMap basicInfo) {

		if(basicInfo != null) {
    		if(CommonUtils.isNotEmpty(basicInfo.get("custGender"))) {
    			if("M".equals(StringUtils.trim((String)basicInfo.get("custGender")))) {
    				basicInfo.put("custGender", "Male");
    			}
    			else if("F".equals(StringUtils.trim((String)basicInfo.get("custGender")))) {
    				basicInfo.put("custGender", "Female");
    			}
    		}
		}

		if(CommonUtils.isEmpty(basicInfo.get("custPassportExpr")) || SalesConstants.DEFAULT_DATE.equals(basicInfo.get("custPassportExpr"))) {
			basicInfo.put("custPassportExpr", "-");
		}

		if(CommonUtils.isEmpty(basicInfo.get("custVisaExpr")) || SalesConstants.DEFAULT_DATE.equals(basicInfo.get("custVisaExpr"))) {
			basicInfo.put("custVisaExpr", "-");
		}
	}


	private String convert12Tm(String TM) {
		String HH = "", MI = "", cvtTM = "";

		if(CommonUtils.isNotEmpty(TM)) {
			HH = CommonUtils.left(TM, 2);
			MI = TM.substring(3, 5);

			if(Integer.parseInt(HH) > 12) {
				cvtTM = String.valueOf(Integer.parseInt(HH) - 12) + ":" + String.valueOf(MI) + " PM";
			}
			else {
				cvtTM = HH + ":" + String.valueOf(MI) + " AM";
			}
		}
		return cvtTM;
	}

	private void loadInstallationInfo(EgovMap installationInfo) {

		if(installationInfo != null) {
    		//TODO 날짜비교 로직 추가
    		if(CommonUtils.isEmpty(installationInfo.get("preferInstDt")) || SalesConstants.DEFAULT_DATE2.equals(installationInfo.get("preferInstDt"))) {
    			installationInfo.put("preferInstDt", "-");
    		}
    		else {
    			installationInfo.put("preferInstDt", CommonUtils.changeFormat(String.valueOf(installationInfo.get("preferInstDt")), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    			/* TypeCast Exception*/
    			//installationInfo.put("preferInstDt", CommonUtils.changeFormat((String)installationInfo.get("preferInstDt"), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));

    		}

    		if(CommonUtils.isEmpty(installationInfo.get("preferInstTm"))) {
    			installationInfo.put("preferInstTm", "-");
    		}

    		if(CommonUtils.isEmpty(installationInfo.get("firstInstallDt")) || SalesConstants.DEFAULT_DATE.equals(installationInfo.get("firstInstallDt"))) {
    			installationInfo.put("firstInstallDt", "-");
    		}
    		else {
    			installationInfo.put("firstInstallDt", CommonUtils.changeFormat(String.valueOf(installationInfo.get("firstInstallDt")), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    			/* TypeCast Exception*/
    			//installationInfo.put("firstInstallDt", CommonUtils.changeFormat((String)installationInfo.get("firstInstallDt"), SalesConstants.DEFAULT_DATE_FORMAT2, SalesConstants.DEFAULT_DATE_FORMAT1));
    		}

    		if(CommonUtils.isEmpty(installationInfo.get("instCntGender"))) {
    			if("M".equals(StringUtils.trim((String)installationInfo.get("instCntGender")))) {
    				installationInfo.put("instCntGender", "Male");
    			}
    			else if("F".equals(StringUtils.trim((String)installationInfo.get("instCntGender")))) {
    				installationInfo.put("instCntGender", "Female");
    			}
    		}

    		if(CommonUtils.isEmpty(installationInfo.get("updDt")) || SalesConstants.DEFAULT_DATE2.equals(installationInfo.get("updDt"))) {
    			installationInfo.put("updDt", "-");
    		}

    		String instct = StringUtils.replace((String)installationInfo.get("instct"), "<", "(");

    		//instct = StringUtils.replace(instct, System.getProperty("line.separator"), "<br>");

    		installationInfo.put("instct", instct);
		}
	}

}
