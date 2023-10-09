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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.ReportBatchService;
import com.coway.trust.biz.sales.order.OrderExchangeService;
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

@Service("orderExchangeService")
public class OrderExchangeServiceImpl extends EgovAbstractServiceImpl implements OrderExchangeService {

	private static final Logger logger = LoggerFactory.getLogger(OrderExchangeServiceImpl.class);

	@Resource(name = "orderExchangeMapper")
	private OrderExchangeMapper orderExchangeMapper;

	@Resource(name = "orderSuspensionMapper")
	private OrderSuspensionMapper orderSuspensionMapper;

	@Resource(name = "orderCancelMapper")
	private OrderCancelMapper orderCancelMapper;

	@Resource(name = "orderInvestMapper")
	private OrderInvestMapper orderInvestMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * 글 목록을 조회한다.
	 *
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderExchangeList(Map<String, Object> params) {
		return orderExchangeMapper.orderExchangeList(params);
	}


	/**
	 * Exchange Information. - Product Exchange Type
	 * @param
	 * @return
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoProduct(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoProduct(params);
	}


	/**
	 * Exchange Information. - Product Exchange Type
	 * @param
	 * @return
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoOwnershipFr(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoOwnershipFr(params);
	}


	/**
	 * Exchange Information. - Product Exchange Type
	 * @param
	 * @return
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoOwnershipTo(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoOwnershipTo(params);
	}


	@Override
	public void saveCancelReq(Map<String, Object> params) {

		java.util.Calendar cal = Calendar.getInstance();
		String day = "";
		int yyyy = cal.get(cal.YEAR);
		int month = cal.get(cal.MONTH)+1;
		int date = cal.get(cal.DAY_OF_MONTH);
		day = date +"/"+month+"/"+yyyy;

		EgovMap firstSearchForCancel = orderExchangeMapper.firstSearchForCancel(params);
		EgovMap secondSearchForCancel = orderExchangeMapper.secondSearchForCancel(params);


		logger.info("##### save soExchgId #####" +params.get("soExchgIdDetail"));
		logger.info("##### save soExchgRem #####" +params.get("soExchgRem"));
		logger.info("##### save salesOrderId #####" +params.get("salesOrderId"));
		logger.info("##### save soExchgNwCallEntryId #####" +secondSearchForCancel.get("soExchgNwCallEntryId"));//SO_EXCHG_NW_CALL_ENTRY_ID

		int reqStageId = 0;	// before , after install
		if((String)params.get("exchgCurStusId") != null && !"".equals((String)params.get("exchgCurStusId")) ){
			reqStageId = Integer.parseInt((String)params.get("exchgCurStusId"));
		}
		int soExchgTypeId = 0;	// product , ownership, application exchange
		if((String)params.get("initType") != null && !"".equals((String)params.get("initType")) ){
			soExchgTypeId = Integer.parseInt((String)params.get("initType"));
		}
		logger.info("##### save reqStageId #####" +reqStageId);

		Map<String, Object> drdExchgMt = new HashMap<String, Object>();
		Map<String, Object> prodParam = new HashMap<String, Object>();

		drdExchgMt.put("soExchgUpdUserId", params.get("userId"));
		drdExchgMt.put("callCrtUserId", params.get("userId"));
		drdExchgMt.put("userId", params.get("userId"));

		if(soExchgTypeId == 283){	// product
			drdExchgMt.put("soExchgStusId", 10);
			drdExchgMt.put("soExchgRem", "(Product Exchange Request Cancelled) "+params.get("soExchgRem"));
			drdExchgMt.put("soExchgIdDetail", params.get("soExchgIdDetail"));
			orderExchangeMapper.updateStusSAL0004D(drdExchgMt);

			drdExchgMt.put("soExchgNwCallEntryId", secondSearchForCancel.get("soExchgNwCallEntryId"));
			int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
			drdExchgMt.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
			drdExchgMt.put("callStusId", 10);
			drdExchgMt.put("callDt", SalesConstants.DEFAULT_DATE);
			drdExchgMt.put("callActnDt", SalesConstants.DEFAULT_DATE);
			drdExchgMt.put("callFdbckId", 0);
			drdExchgMt.put("callCtId", 0);
			drdExchgMt.put("callRem", "(Product Exchange Request Cancelled) "+params.get("soExchgRem"));
			drdExchgMt.put("callCrtUserId", params.get("userId"));
			drdExchgMt.put("callCrtUserIdDept", 0);
			drdExchgMt.put("callHcId", 0);
			drdExchgMt.put("callRosAmt", 0);
			drdExchgMt.put("callSms", 0);
			drdExchgMt.put("callSmsRem", "");
			orderExchangeMapper.insertCCR0007D(drdExchgMt);

			if(reqStageId == 25){

				EgovMap thirdSearchForCancel = orderExchangeMapper.thirdSearchForCancel(drdExchgMt);	// new
				drdExchgMt.put("resultId", thirdSearchForCancel.get("resultId"));
				drdExchgMt.put("stusCodeId", 10);
				drdExchgMt.put("callEntryId", secondSearchForCancel.get("soExchgNwCallEntryId"));
				orderSuspensionMapper.updateCCR0006DSuspend(drdExchgMt);

				drdExchgMt.put("movId", secondSearchForCancel.get("soExchgStkRetMovId"));
				EgovMap invStkMovLOG0013D = orderExchangeMapper.invStkMovLOG0013D(drdExchgMt);
				drdExchgMt.put("movStusId", 10);

				orderExchangeMapper.updateExchgLOG0013D(drdExchgMt);

				drdExchgMt.put("refId", params.get("soExchgIdDetail"));
				drdExchgMt.put("salesOrderId", params.get("salesOrderId"));
				EgovMap exchangeLOG0038D = orderExchangeMapper.exchangeLOG0038D(drdExchgMt);
				drdExchgMt.put("stkRetnId", exchangeLOG0038D.get("stkRetnId"));
				drdExchgMt.put("stusCodeId", 8);
				orderExchangeMapper.updateExchangeLOG0038D(drdExchgMt);

				drdExchgMt.put("salesOrdId", params.get("salesOrderId"));
				drdExchgMt.put("prgrsId", 5);
				drdExchgMt.put("isLok", 0);
				drdExchgMt.put("refId", 0);
				orderInvestMapper.insertSalesOrdLog(drdExchgMt);
			}else{

				EgovMap thirdSearchForCancel = orderExchangeMapper.thirdSearchForCancel(drdExchgMt);	// new
				drdExchgMt.put("resultId", thirdSearchForCancel.get("resultId"));
				drdExchgMt.put("soExchgNwCallEntryId", secondSearchForCancel.get("soExchgNwCallEntryId"));
				orderExchangeMapper.updateCCR0006D(drdExchgMt);

				drdExchgMt.put("soExchgOldCallEntryId", secondSearchForCancel.get("soExchgOldCallEntryId"));
				EgovMap fourthSearchForCancel = orderExchangeMapper.fourthSearchForCancel(drdExchgMt);	// old
				int getCallEntryIdMaxSeq = orderExchangeMapper.getCallEntryIdMaxSeq();
				drdExchgMt.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
				drdExchgMt.put("salesOrdId", params.get("salesOrderId"));
				drdExchgMt.put("typeId", fourthSearchForCancel.get("typeId"));
				drdExchgMt.put("stusCodeId", 1);
				drdExchgMt.put("resultId", 0);
				drdExchgMt.put("docId", fourthSearchForCancel.get("docId"));
				drdExchgMt.put("isWaitForCancl", 0);
				drdExchgMt.put("hapyCallerId", 0);
				orderExchangeMapper.insertCCR0006D(drdExchgMt);

				int getCallResultIdMaxSeq2 = orderExchangeMapper.getCallResultIdMaxSeq();
				drdExchgMt.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq2);
				drdExchgMt.put("soExchgNwCallEntryId", getCallEntryIdMaxSeq);
				drdExchgMt.put("callStusId", 1);
				drdExchgMt.put("callDt", day);
				drdExchgMt.put("callActnDt", SalesConstants.DEFAULT_DATE);
				drdExchgMt.put("callFdbckId", 0);
				drdExchgMt.put("callCtId", 0);
				drdExchgMt.put("callRem", "(Reversal From Product Exchange Request Cancellation) "+params.get("soExchgRem"));
				drdExchgMt.put("callCrtUserId", params.get("userId"));
				drdExchgMt.put("callCrtUserIdDept", 0);
				drdExchgMt.put("callHcId", 0);
				drdExchgMt.put("callRosAmt", 0);
				drdExchgMt.put("callSms", 0);
				drdExchgMt.put("callSmsRem", "");
				orderExchangeMapper.insertCCR0007D(drdExchgMt);

				prodParam.put("resultId", getCallResultIdMaxSeq2);
				prodParam.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
				orderExchangeMapper.updateResultIdCCR0006D(prodParam);

				drdExchgMt.put("salesOrdId", params.get("salesOrderId"));
				drdExchgMt.put("prgrsId", 2);
				drdExchgMt.put("isLok", 1);
				drdExchgMt.put("refId", getCallEntryIdMaxSeq);
				orderInvestMapper.insertSalesOrdLog(drdExchgMt);

			}

		}

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
	public ReturnMessage pexSendEmail(Map<String, Object> params) {

		ReturnMessage message = new ReturnMessage();

		List<Integer> soIdArr = new ArrayList<Integer>();
		List<String> ordNoSendArr = new ArrayList<String>();
		List<String> sentArr = new ArrayList<String>();
		List<String> notSentArr = new ArrayList<String>();
		List<String> emailArr = new ArrayList<String>();

		soIdArr = (List<Integer>) params.get("soIdArr");
		ordNoSendArr = (List<String>) params.get("salesOrdNoSendArr");
		emailArr = (List<String>) params.get("emailArr");

	    String emailSubject = "COWAY: Product Return";

	    String content = "";
	    content += "Dear Customer,\n\n";
	    content += "Your product Exchange is successful.\n\n";
	    content += "Kindly refer an attachment for your Exchange Notes.\n";
	    content += "Thank you for your continue support to Coway.\n";
	    content += "If you need assistance may contact our Coway Careline \n\n";
	    content += "1-800-88-8111\n";
	    content += "9am - 8pm (Mon-Fri)\n";
	    content += "9am - 4pm (Weekends & Public Holidays)\n\n";
	    content += "Thank You.\n\n\n";
	    content += "Regards,\n\n";
	    content += "Coway (Malaysia) Sdn Bhd\n\n";
	    content += "This is system generated email, please do not reply to this email.\n\n";

	    params.put(EMAIL_SUBJECT, emailSubject);
	    params.put(EMAIL_TEXT, content);

	    params.put(REPORT_FILE_NAME, "/services/PEXNoteDigitalization.rpt");// visualcut
	    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
	    params.put(REPORT_DOWN_FILE_NAME,  "PEXNoteDigitalization_" + CommonUtils.getNowDate());

		for (int i = 0; i < soIdArr.size(); i++) {
		    List<String> emailNo = new ArrayList<String>();

			int soId = soIdArr.get(i);
			String reqNoSent = ordNoSendArr.get(i);

			if (!"".equals(CommonUtils.nvl(emailArr.get(i)))) {
		        emailNo.add(CommonUtils.nvl(emailArr.get(i)));
		    }
		    //emailNo.add("keyi.por@coway.com.my"); //for self test only

		    params.put(EMAIL_TO, emailNo);
			params.put("V_WHERE", soId);// parameter
			params.put("soId", soId);

			try{
				this.viewProcedure(null, null, params); //Included sending email
				sentArr.add(reqNoSent);
				orderExchangeMapper.updateEmailSentCount(params);
			}catch(Exception e){
				notSentArr.add(reqNoSent);
			}

			if(sentArr.size() > 0){
				message.setCode(AppConstants.SUCCESS);
			    message.setData(String.join(",",sentArr));
			    message.setMessage("Email sent for Order no " + String.join(",",sentArr));
			}

			if(notSentArr.size() > 0){
				message.setCode("98");
		        message.setData(String.join(",",notSentArr));
		        message.setMessage("Email send failed for Order no " + String.join(",",notSentArr));
			}
		}

		return message;
	}

}
