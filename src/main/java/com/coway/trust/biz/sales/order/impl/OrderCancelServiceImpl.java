package com.coway.trust.biz.sales.order.impl;

import static com.coway.trust.AppConstants.EMAIL_SUBJECT;
import static com.coway.trust.AppConstants.EMAIL_TEXT;
import static com.coway.trust.AppConstants.EMAIL_TO;
import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_CLIENT_DOCUMENT;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.ReportBatchService;
import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;
import com.coway.trust.util.ReportUtils;
import com.coway.trust.web.common.ReportController;
import com.coway.trust.web.common.ReportController.ViewType;
import com.coway.trust.web.sales.SalesConstants;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderCancelService")
public class OrderCancelServiceImpl extends EgovAbstractServiceImpl implements OrderCancelService {

  private static final Logger logger = LoggerFactory.getLogger(OrderCancelServiceImpl.class);

  @Resource(name = "orderCancelMapper")
  private OrderCancelMapper orderCancelMapper;

  @Resource(name = "orderSuspensionMapper")
  private OrderSuspensionMapper orderSuspensionMapper;

  @Resource(name = "orderInvestMapper")
  private OrderInvestMapper orderInvestMapper;

  @Resource(name = "orderExchangeMapper")
  private OrderExchangeMapper orderExchangeMapper;

  @Autowired
  private MessageSourceAccessor messageSourceAccessor;

  /**
   * 글 목록을 조회한다.
   *
   * @param OrderCancelVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  public List<EgovMap> orderCancellationList(Map<String, Object> params) {
    return orderCancelMapper.orderCancellationList(params);
  }

  /**
   * 글 목록을 orderCancelStatus.
   *
   * @param searchVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  /** KV cancellation status */
  public List<EgovMap> orderCancelStatus(Map<String, Object> params) {
    return orderCancelMapper.orderCancelStatus(params);
  }

  /**
   * 글 목록을 orderCancelFeedback.
   *
   * @param searchVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  /** KV cancellation Feedback */
  public List<EgovMap> orderCancelFeedback(Map<String, Object> params) {
    return orderCancelMapper.orderCancelFeedback(params);
  }

  /**
   * DSC BRANCH
   *
   * @param -
   * @return combo box
   * @exception Exception
   */
  public List<EgovMap> dscBranch(Map<String, Object> params) {
    return orderCancelMapper.dscBranch(params);
  }

  public List<EgovMap> productRetReason(Map<String, Object> params) {
	    return orderCancelMapper.productRetReason(params);
	  }

  public List<EgovMap> rsoStatus(Map<String, Object> params) {
	    return orderCancelMapper.rsoStatus(params);
	  }

  @Override
  public EgovMap cancelReqInfo(Map<String, Object> params) {

    return orderCancelMapper.cancelReqInfo(params);
  }

  /**
   * 글 목록을 조회한다.
   *
   * @param OrderCancelVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  public List<EgovMap> cancelLogTransctionList(Map<String, Object> params) {
    return orderCancelMapper.cancelLogTransctionList(params);
  }

  /**
   * 글 목록을 조회한다.
   *
   * @param OrderCancelVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  public List<EgovMap> productReturnTransctionList(Map<String, Object> params) {
    return orderCancelMapper.productReturnTransctionList(params);
  }

  @Override
  public void saveCancel(Map<String, Object> params) {
    logger.info("[OrderCancelServiceImpl - saveCancel] param :: {} " + params);

    Map<String, Object> salesReqCancelParam = new HashMap<String, Object>();

    Map<String, Object> saveParam = new HashMap<String, Object>();

    saveParam.put("callEntryId", params.get("paramCallEntryId"));
    saveParam.put("callStusId", params.get("addStatus"));
    saveParam.put("callFdbckId", params.get("cmbFeedbackCd"));
    saveParam.put("callCtId", 0);
    saveParam.put("callRem", params.get("addRem"));
    saveParam.put("callCrtUserId", params.get("userId"));
    saveParam.put("callCrtUserIdDept", 0);
    saveParam.put("callHcId", 0);
    saveParam.put("callRosAmt", 0);
    saveParam.put("callSms", 0);
    saveParam.put("callSmsRem", "");
    saveParam.put("salesOrdId", params.get("paramOrdId"));

    int status = CommonUtils.intNvl(params.get("addStatus")); // recall, calcel, reversal, cancel, continuerental
    int appTypeId = CommonUtils.intNvl(params.get("appTypeId"));
    logger.info("####################### appTypeId ######## " + appTypeId);
    int reqStageId = CommonUtils.intNvl(params.get("reqStageId")); // before , after install
    String reqStageIdValue = ""; // RET, CAN
    int deactPayMode = CommonUtils.intNvl(params.get("deactPayMode"));

    /* java.lang.ClassCastException - modify KR-SH
     if ((String) params.get("reqStageId") != null && !"".equals((String) params.get("reqStageId"))) {
      reqStageId = Integer.parseInt((String) params.get("reqStageId"));
    }*/
    saveParam.put("reqStageId", reqStageId);

    if (status == 19) { // status : Recall
      logger.info("####################### Recall save Start!! #####################");

      saveParam.put("callDt", params.get("addCallRecallDt"));
      saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
      orderSuspensionMapper.insertCCR0007DSuspend(saveParam);

      EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam);
      saveParam.put("resultId", getResultId.get("resultId"));
      orderCancelMapper.updateCancelCCR0006D(saveParam);

      saveParam.put("soReqId", params.get("paramReqId"));
      saveParam.put("_cmbFollowUp", params.get("_cmbFollowUp"));
      orderCancelMapper.updReservalCancelSAL0020D(saveParam);

      logger.info("####################### Recall save End!! #####################");
    } else if (status == 32) { // Confirm To Cancel
      logger.info("####################### Confirm To Cancel save Start!! #####################");
      saveParam.put("userId", params.get("userId"));
      saveParam.put("callDt", SalesConstants.DEFAULT_DATE);
      saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
      orderSuspensionMapper.insertCCR0007DSuspend(saveParam); // CallResult

      EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam); // CallEntry
      saveParam.put("resultId", getResultId.get("resultId"));
      orderCancelMapper.updateCancelCCR0006D(saveParam); // CallEntry

      saveParam.put("soReqId", params.get("paramReqId"));
      orderCancelMapper.updReservalCancelSAL0020D(saveParam); // SalesReqCancel

      EgovMap salesReqCancel = orderCancelMapper.newSearchCancelSAL0020D(saveParam);

      if (appTypeId == 66) { // RENTAL
        EgovMap getRenSchId = orderInvestMapper.saveCallResultSearchFourth(saveParam); // RentalScheme
        saveParam.put("renSchId", getRenSchId.get("renSchId"));
        if (reqStageId == 25) { // after installation
          reqStageIdValue = "RET";
        } else {
          reqStageIdValue = "CAN";
        }
        saveParam.put("rentalSchemeStusId", reqStageIdValue);
        orderCancelMapper.updateCancelSAL0071D(saveParam); // RentalScheme
      }

      if (reqStageId == 25) {
        salesReqCancelParam.put("salesOrdId", salesReqCancel.get("soReqSoId"));
        EgovMap installEntry = orderCancelMapper.newSearchCancelSAL0046D(salesReqCancelParam);
        String getMovId = orderCancelMapper.crtSeqLOG0031D();
        String getStkRetnId = orderCancelMapper.crtSeqLOG0038D();
        saveParam.put("installEntryId", installEntry.get("installEntryId"));
        saveParam.put("movId", getMovId);
        saveParam.put("movFromLocId", 0);
        saveParam.put("movToLocId", 0);
        saveParam.put("movTypeId", 265);
        saveParam.put("movStusId", 1);
        saveParam.put("movCnfm", 0);
        saveParam.put("stkCrdPost", 0);
        saveParam.put("stkCrdPostDt", SalesConstants.DEFAULT_DATE);
        saveParam.put("stkCrdPostToWebOnTm", 0);
        orderCancelMapper.insertCancelLOG0013D(saveParam);

        saveParam.put("docNoId", 30);
        String getDocId = orderInvestMapper.getDocNo(saveParam);

        saveParam.put("stusCodeId", 1);
        saveParam.put("typeId", 296);

        saveParam.put("movId", getMovId);
        saveParam.put("refId", params.get("paramReqId"));
        saveParam.put("stockId", params.get("paramStockId"));

        saveParam.put("isSynch", 0);
        saveParam.put("retnNo", getDocId);
        saveParam.put("appDt", params.get("addAppRetnDt"));
        saveParam.put("ctId", params.get("ctId"));
        saveParam.put("ctGrp", params.get("cmbCtGroup"));

        saveParam.put("cTSSessionCode", params.get("CTSSessionCode"));
        saveParam.put("segmentType", params.get("CTSSessionSegmentType"));
        saveParam.put("brnchId", params.get("brnchId"));
        saveParam.put("requestDate", params.get("requestDate"));
        saveParam.put("cTGroup", params.get("CTGroup"));

        String stkRetnIdSeq = orderCancelMapper.crtSeqLOG0038D();
        saveParam.put("stkRetnId", stkRetnIdSeq);
        orderCancelMapper.insertCancelLOG0038D(saveParam);
      } else {
        EgovMap searchSAL0001D = orderCancelMapper.newSearchCancelSAL0001D(saveParam); // SalesOrderM
        saveParam.put("salesMstusCodeId", 10);

        orderCancelMapper.updateCancelSAL0001D(saveParam); // SalesOrderM

        logger.info("====================== PROMOTION COMBO CHECKING - START - ==========================");
        logger.info("= PARAM = " + searchSAL0001D.toString());

        // CHECK ORDER PROMOTION IS IT FALL ON COMBO PACKAGE PROMOTION
        // 1ST CHECK PCKAGE_BINDING_NO (SUB)
        int count = orderCancelMapper.chkSubPromo(searchSAL0001D);
        logger.info("= CHECK PCKAGE_BINDING_NO (SUB) = " + count);

        if (count > 0) {
          // CANCELLATION IS SUB COMBO PACKAGE.
          // TODO REVERT MAIN PRODUCT PROMO. CODE
          logger.info("====================== CANCELLATION IS SUB COMBO PACKAGE ==========================");

          EgovMap revCboPckage = orderCancelMapper.revSubCboPckage(searchSAL0001D);
          if (revCboPckage != null) {
            revCboPckage.put("reqStageId", reqStageId);

            logger.info("= PARAM 2 = " + revCboPckage.toString());
            orderCancelMapper.insertSAL0254D(revCboPckage);
          }
        } else {
          // 2ND CHECK PACKAGE (MAIN)
          count = orderCancelMapper.chkMainPromo(searchSAL0001D);

          if (count > 0) {
            // CANCELLATION IS MAIN COMBO PACKAGE.
            // TODO REVERT SUB PRODUCT PROMO. CODE AND RENTAL PRICE

            logger.info("====================== CANCELLATION IS MAIN COMBO PACKAGE ==========================");

            EgovMap revCboPckage = orderCancelMapper.revMainCboPckage(searchSAL0001D);
            if (revCboPckage != null) {
              revCboPckage.put("reqStageId", reqStageId);

              logger.info("= PARAM 2 = " + revCboPckage.toString());
              orderCancelMapper.insertSAL0254D(revCboPckage);
            }
          } else {
            // DO NOTHING (IS NOT A COMBO PACKAGE)
          }
        }

        logger.info("====================== PROMOTION COMBO CHECKING - END - ==========================");
      }

      if (reqStageId == 25) {
        saveParam.put("prgrsId", 12);
        saveParam.put("isLok", 1);
      } else {
        saveParam.put("prgrsId", 13);
        saveParam.put("isLok", 0);

        orderCancelMapper.updateCancelSAL0349D(saveParam); // update the table sal0349d disb = 1 for Air Con Bulk promotion package
      }
      saveParam.put("refId", 0);
      orderInvestMapper.insertSalesOrdLog(saveParam); // SalesOrderLog

      logger.info("####################### Confirm To Cancel save END!! #####################");

    } else if (status == 31 || status == 105 || status == 123 ) { // Reversal Of Cancellation or
                                                // Continue Rental
      logger.info("####################### Reversal Of Cancellation or Continue Rental save Start!! #####################");
      // 해야함
      if (reqStageId == 24) {
        saveParam.put("callDt", params.get("addCallRecallDt"));
        saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
      }

      orderSuspensionMapper.insertCCR0007DSuspend(saveParam);

      EgovMap getResultId = orderSuspensionMapper.newSuspendSearch2(saveParam);
      saveParam.put("resultId", getResultId.get("resultId"));

      orderCancelMapper.updateCancelCCR0006D(saveParam);

      saveParam.put("soReqId", params.get("paramReqId"));
      orderCancelMapper.updReservalCancelSAL0020D(saveParam);

      if (reqStageId == 24) {

        int getCallEntryIdMaxSeq = orderExchangeMapper.getCallEntryIdMaxSeq();
        saveParam.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
        saveParam.put("salesOrdId", params.get("paramOrdId"));
        EgovMap getSOReqPrevCallEntryID = orderCancelMapper.newSearchCancelSAL0020D(saveParam);
        logger.info("#####--------------------- callEntryId ###############" + getSOReqPrevCallEntryID.get("soReqPrevCallEntryId"));
        saveParam.put("callEntryId", getSOReqPrevCallEntryID.get("soReqPrevCallEntryId"));
        EgovMap getTypeId = orderSuspensionMapper.newSuspendSearch2(saveParam);
        saveParam.put("typeId", getTypeId.get("typeId"));
        saveParam.put("stusCodeId", 1);
        saveParam.put("resultId", 0);
        saveParam.put("docId", params.get("paramOrdId"));
        saveParam.put("isWaitForCancl", 0);
        saveParam.put("hapyCallerId", 0);
        orderCancelMapper.insertCancelCCR0006D(saveParam);

        saveParam.put("soExchgNwCallEntryId", getCallEntryIdMaxSeq);
        int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
        saveParam.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
        saveParam.put("callStusId", 1);
        saveParam.put("callCtId", 0);
        orderExchangeMapper.insertCCR0007D(saveParam);

        saveParam.put("resultId", getCallResultIdMaxSeq);
        orderExchangeMapper.updateResultIdCCR0006D(saveParam);

        //logger.info("##### reqStageId ###############" + (String) params.get("reqStageId"));
      }

      if (appTypeId == 66) { // RENTAL
        EgovMap getRenSchId = orderInvestMapper.saveCallResultSearchFourth(saveParam); // RentalScheme
        saveParam.put("renSchId", getRenSchId.get("renSchId"));
        saveParam.put("salesOrdId", getRenSchId.get("salesOrdId"));

        int getCountSalesOrdId = orderInvestMapper.saveCallResultSearchOrdId(saveParam);

        if (reqStageId == 24) {
          saveParam.put("rentalSchemeStusId", "ACT");
        } else if (reqStageId == 25) {
          if (getCountSalesOrdId >= 1) {
            orderCancelMapper.insertOrdReactiveFee(saveParam); // Insert Unbill
                                                               // billing
          }
          saveParam.put("rentalSchemeStusId", "REG");
        }
        // saveParam.put("rentalSchemeStusId", reqStageIdValue);
        orderCancelMapper.updateCancelSAL0071D(saveParam); // RentalScheme
      }

      saveParam.put("salesOrderId", params.get("paramOrdId"));
      EgovMap getRefId = orderExchangeMapper.firstSearchForCancel(saveParam);
      if (reqStageId == 25) {
        saveParam.put("prgrsId", 5);
        saveParam.put("isLok", 0);
        saveParam.put("refId", 0);
      } else {
        saveParam.put("prgrsId", 2);
        saveParam.put("isLok", 1);
        saveParam.put("refId", getRefId.get("refId"));
      }
      saveParam.put("userId", params.get("userId"));

      orderInvestMapper.insertSalesOrdLog(saveParam);
    }

    // Deactivate paymode
    if (deactPayMode == 1){
    	 logger.info("####################### Deactivate Paymode Start!! #####################");
        int getSeqId = orderCancelMapper.crtSeqSAL0346D();
        saveParam.put("id", getSeqId);
        saveParam.put("salesOrderId", params.get("paramOrdId"));
        saveParam.put("pgmPath", params.get("pgmPath"));
        saveParam.put("userId", params.get("userId"));
        orderCancelMapper.insertCancelSAL0346D(saveParam);

        int crtSeqSAL0236D = orderCancelMapper.crtSeqSAL0236D();

        int rentPayMode = Integer.parseInt((String) params.get("rentPayMode"));
        params.put("deductId", crtSeqSAL0236D);
        params.put("rentPayId", params.get("rentPayId"));
        params.put("modeId", 130);
        params.put("userId", params.get("userId"));

        if (rentPayMode == 131 || rentPayMode == 132) {
        orderCancelMapper.insertDeductSAL0236D(params);
        orderCancelMapper.updatePaymentChannelvRescue(params);
        logger.debug("params : {}", params);

        SalesOrderMVO salesOrderMVO = new SalesOrderMVO();

        salesOrderMVO.setSalesOrdId(CommonUtils.intNvl(saveParam.get("salesOrdId")));
        salesOrderMVO.setUpdUserId((int) params.get("userId"));
        salesOrderMVO.setEcash(rentPayMode == 131 ? 1 : 0);

        orderCancelMapper.updateECashInfo(salesOrderMVO);
        logger.info("####################### Deactivate Paymode Start!! #####################");
        }

    } else {
    	logger.info("####################### Deactivate Paymode Issue with param: " + deactPayMode + "#######");
    	// Do nothing as This would not deactivate the paymode
    }

  }

  @Override
  public EgovMap ctAssignmentInfo(Map<String, Object> params) {

    return orderCancelMapper.ctAssignmentInfo(params);
  }

  /**
   * Assign CT - New Cancellation Log Result
   *
   * @param -
   * @return combo box
   * @exception Exception
   */
  public List<EgovMap> selectAssignCT(Map<String, Object> params) {
    return orderCancelMapper.selectAssignCT(params);
  }

  /**
   * Assign CT - New Cancellation Log Result
   *
   * @param -
   * @return combo box
   * @exception Exception
   */
  public List<EgovMap> selectFeedback(Map<String, Object> params) {
    return orderCancelMapper.selectFeedback(params);
  }

  public List<EgovMap> getRetReasonList(Map<String, Object> params) {
    return orderCancelMapper.getRetReasonList(params);
  }

  public List<EgovMap> getBranchList(Map<String, Object> params) {
    return orderCancelMapper.getBranchList(params);
  }

  @Override
  public void updateCancelSAL0071D(Map<String, Object> params) {
    // TODO Auto-generated method stub

  }

  @Override
  public void saveCtAssignment(Map<String, Object> params) {

    // Map<String, Object> saveParam = new HashMap<String, Object>();

    String crtSeqLOG0037D = orderCancelMapper.crtSeqLOG0037D();
    params.put("crtSeqLOG0037D", crtSeqLOG0037D);
    orderCancelMapper.insertCancelLOG0037D(params);

    orderCancelMapper.cancelCtLOG0038D(params);

    orderCancelMapper.updateCancelLOG0038D(params);

  }

  public List<EgovMap> ctAssignBulkList(Map<String, Object> params) {
    return orderCancelMapper.ctAssignBulkList(params);
  }

  @Override
  @Transactional
  public int saveCancelBulk(Map<String, Object> params) {

    // GridDataSet<OrderCancelCtBulkMVO> bulkDataSetList =
    // ctbulkvo.getBulkDataSetList();

    // List<OrderCancelCtBulkMVO> updateList = bulkDataSetList.getRemove();
    List<Object> updList = (List<Object>) params.get("saveList");
    int dataCnt = 0;

    // insert & update data
    for (int i = 0; i < updList.size(); i++) {
      Map<String, Object> addMap = (Map<String, Object>) updList.get(i);
      // insert data
      addMap.put("userId", params.get("userId"));
      orderCancelMapper.insertBulkLOG0037D(addMap);
      // update data
      orderCancelMapper.updateBulkLOG0038D(addMap);

      dataCnt++;
    }

    return dataCnt;
  }

  public int selRcdTms(Map<String, Object> params) {
    return orderCancelMapper.selRcdTms(params);
  }

  @Override
  public int chkRcdTms(Map<String, Object> params) {
    return orderCancelMapper.chkRcdTms(params);
  }

  public EgovMap select3MonthBlockList(Map<String, Object> params) {
    return orderCancelMapper.select3MonthBlockList(params);
  }

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private ReportBatchService reportBatchService;

  @Value("${report.datasource.driver-class-name}")
  private String reportDriverClass;

  @Value("${report.datasource.url}")
  private String reportUrl;

  @Value("${report.datasource.username}")
  private String reportUserName;

  @Value("${report.datasource.password}")
  private String reportPassword;

  @Value("${report.file.path}")
  private String reportFilePath;

  private void viewProcedure(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params) {
	  	Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_FILE_NAME)), messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_FILE_NAME }));
		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_VIEW_TYPE)), messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_VIEW_TYPE }));

	    SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS", Locale.getDefault(Locale.Category.FORMAT));
	    String succYn = "E";
	    Calendar startTime = Calendar.getInstance();
	    Calendar endTime = null;

	    String prodName;
	    int maxLength = 0;
	    String msg = "Completed";

		String reportFile = (String) params.get(REPORT_FILE_NAME);
	    String reportName = reportFilePath + reportFile;
	    ViewType viewType = ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));

	    try {
	      ReportAppSession ra = new ReportAppSession();
	      ra.createService(REPORT_CLIENT_DOCUMENT);

	      ra.setReportAppServer(ReportClientDocument.inprocConnectionString);
	      ra.initialize();
	      ReportClientDocument clientDoc = new ReportClientDocument();
	      clientDoc.setReportAppServer(ra.getReportAppServer());
	      clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);

	      clientDoc.getDatabaseController().logon(reportUserName, reportPassword);

	      prodName = clientDoc.getDatabaseController().getDatabase().getTables().size() > 0 ? clientDoc.getDatabaseController().getDatabase().getTables().get(0).getName() : null;

	      params.put("repProdName", prodName);

	      ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
	      Fields fields = clientDoc.getDataDefinition().getParameterFields();
	      ReportUtils.setReportParameter(params, paramController, fields);
	      {
	        this.viewHandle(request, response, viewType, clientDoc, ReportUtils.getCrystalReportViewer(clientDoc.getReportSource()), params);
	      }
	    } catch (Exception ex) {
	      logger.error(CommonUtils.printStackTraceToString(ex));
	      throw new ApplicationException(ex);
	    } finally {
	      endTime = Calendar.getInstance();
	      long tot = endTime.getTimeInMillis() - startTime.getTimeInMillis();
	      logger.info("resultInfo : succYn={}, {}={}, {}={}, time={}~{}, total={}"
	              , succYn
	              , REPORT_FILE_NAME, params.get(REPORT_FILE_NAME)
	              , REPORT_VIEW_TYPE, params.get(REPORT_VIEW_TYPE)
	              , fmt.format(startTime.getTime()), fmt.format(endTime.getTime())
	              , tot
	      );

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


  @SuppressWarnings("unchecked")
	@Override
	public ReturnMessage prSendEmail(Map<String, Object> params) {

		ReturnMessage message = new ReturnMessage();

		List<Integer> soReqIdArr = new ArrayList<Integer>();
		List<String> reqNoSendArr = new ArrayList<String>();
		List<String> sentArr = new ArrayList<String>();
		List<String> notSentArr = new ArrayList<String>();
		List<String> emailArr = new ArrayList<String>();

		soReqIdArr = (List<Integer>) params.get("soReqIdArr");
		reqNoSendArr = (List<String>) params.get("reqNoSendArr");
		emailArr = (List<String>) params.get("emailArr");

	    String emailSubject = "COWAY: Product Cancellation";

	    String content = "";
	    content += "Dear Customer,\n\n";
	    content += "Your Product Cancellation have successful.\n\n";
	    content += "Kindly refer an attachment for your Cancellation Notes.\n";
	    content += "We look forward to serve you better.\n";
	    content += "Thank You.\n\n\n";
	    content += "Regards,\n\n";
	    content += "Coway (Malaysia) Sdn Bhd\n\n";
	    content += "This is system generated email, please do not reply to this email.\n\n";


	    params.put(EMAIL_SUBJECT, emailSubject);
	    params.put(EMAIL_TEXT, content);

	    params.put(REPORT_FILE_NAME, "/services/PRNoteDigitalization.rpt");// visualcut
	    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
	    params.put(REPORT_DOWN_FILE_NAME,  "PRNoteDigitalization_" + CommonUtils.getNowDate());

		for (int i = 0; i < soReqIdArr.size(); i++) {
		    List<String> emailNo = new ArrayList<String>();

			int soReqId = soReqIdArr.get(i);
			String reqNoSent = reqNoSendArr.get(i);

			if (!"".equals(CommonUtils.nvl(emailArr.get(i)))) {
		        emailNo.add(CommonUtils.nvl(emailArr.get(i)));
		    }
		    //emailNo.add("keyi.por@coway.com.my"); //for self test only

		    params.put(EMAIL_TO, emailNo);
			params.put("V_WHERE", soReqId);// parameter
			params.put("soReqId", soReqId);

			try{
				this.viewProcedure(null, null, params); //Included sending email
				sentArr.add(reqNoSent);
				orderCancelMapper.updateEmailSentCount(params);
			}catch(Exception e){
				notSentArr.add(reqNoSent);
			}

			if(sentArr.size() > 0){
				message.setCode(AppConstants.SUCCESS);
			    message.setData(String.join(",",sentArr));
			    message.setMessage("Email sent for " + String.join(",",sentArr));
			}

			if(notSentArr.size() > 0){
				message.setCode("98");
		        message.setData(String.join(",",notSentArr));
		        message.setMessage("Email send failed for " + String.join(",",notSentArr));
			}
		}

		return message;
	}

}
