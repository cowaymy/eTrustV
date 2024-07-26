package com.coway.trust.web.common;

import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_CLIENT_DOCUMENT;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.IOException;
import java.nio.file.*;

/**************************************
 * Author Date Remark Chew Kah Kit 2019/04/11 API for customer portal
 ***************************************/

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.ApiService;
import com.coway.trust.cmmn.CRJavaHelper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;
import com.coway.trust.util.ReportUtils;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@RestController
@RequestMapping(value = "/api")
public class ApiController {

  private static final Logger LOGGER = LoggerFactory.getLogger(ApiController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Resource(name = "apiService")
  private ApiService apiService;

  @Value("${report.datasource.username}")
  private String reportUserName;

  @Value("${report.datasource.password}")
  private String reportPassword;

  @Value("${report.file.path}")
  private String reportFilePath;

  @Value("${report.datasource.driver-class-name}")
  private String reportDriverClass;

  @Value("${report.datasource.url}")
  private String reportUrl;

  @RequestMapping(value = "/customer/getCowayCustByNricOrPassport.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCowayCustByNricOrPassport(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap cowayCustDetails = apiService.selectCowayCustNricOrPassport(request, params);
    return ResponseEntity.ok(cowayCustDetails);
  }

  @RequestMapping(value = "/customer/isNricOrPassportMatchInvoiceNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> isNricOrPassportMatchInvoiceNo(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap isNricOrPassportMatchInvoiceNo = apiService.isNricOrPassportMatchInvoiceNo(request, params);
    return ResponseEntity.ok(isNricOrPassportMatchInvoiceNo);
  }

  @RequestMapping(value = "/customer/getInvoiceSubscriptionsList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getInvoiceSubscriptionsList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap custInvoiceSubscriptionsList = apiService.selectInvoiceSubscriptionsList(request, params);
    return ResponseEntity.ok(custInvoiceSubscriptionsList);
  }

  @RequestMapping(value = "/customer/getCustTotalProductsCount.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustTotalProductsCount(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap custTotalProducts = apiService.selectCustTotalProductsCount(request, params);
    return ResponseEntity.ok(custTotalProducts);
  }

  @RequestMapping(value = "/customer/getCustomerAccountCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustomerAccountCode(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap custAccountNo = apiService.selectAccountCode(request, params);
    return ResponseEntity.ok(custAccountNo);
  }

  @RequestMapping(value = "/customer/getIndividualLastPayment.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getIndividualLastPayment(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap lastPayment = apiService.selectLastPayment(request, params);
    return ResponseEntity.ok(lastPayment);
  }

  @RequestMapping(value = "/customer/getCustTotalOutstanding.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustTotalOutstanding(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap custOutStand = apiService.getCustTotalOutstanding(request, params);
    return ResponseEntity.ok(custOutStand);
  }

  @RequestMapping(value = "/customer/getTotalMembershipExpired.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getTotalMembershipExpired(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap totalMembershipExpired = apiService.getTotalMembershipExpired(request, params);
    return ResponseEntity.ok(totalMembershipExpired);
  }

  @RequestMapping(value = "/customer/getCustVirtualAccountNumber.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCustVirtualAccountNumber(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap custVANo = apiService.selectCustVANo(request, params);
    return ResponseEntity.ok(custVANo);
  }

  @RequestMapping(value = "/customer/getAutoDebitEnrolmentsList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getAutoDebitEnrolmentsList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap autoDebitEnrolmentsList = apiService.selectAutoDebitEnrolmentsList(request, params);
    return ResponseEntity.ok(autoDebitEnrolmentsList);
  }

  @RequestMapping(value = "/customer/getCowayAccountProductPreviewList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCowayAccountProductPreviewList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap cowayAccountProductPreviewList = apiService.selectCowayAccountProductPreviewList(request, params);
    return ResponseEntity.ok(cowayAccountProductPreviewList);
  }

  @RequestMapping(value = "/customer/getCowayAccountProductPreviewListByAccountCode.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCowayAccountProductPreviewListByAccountCode(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap cowayAccountProductPreviewList = apiService.selectCowayAccountProductPreviewListByAccountCode(request,
        params);
    return ResponseEntity.ok(cowayAccountProductPreviewList);
  }

  @RequestMapping(value = "/customer/getProductDetail.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getProductDetail(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap productDetail = apiService.selectProductDetail(request, params);
    return ResponseEntity.ok(productDetail);
  }

  @RequestMapping(value = "/customer/getHeartServiceList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getHeartServiceList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap heartServiceList = apiService.selectHeartServiceList(request, params);
    return ResponseEntity.ok(heartServiceList);
  }

  @RequestMapping(value = "/customer/getTechnicianServicesList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getTechnicianServicesList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap technicianServicesList = apiService.selectTechnicianServicesList(request, params);
    return ResponseEntity.ok(technicianServicesList);
  }

  @RequestMapping(value = "/customer/isUserHasOrdNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> isUserHasOrdNo(HttpServletRequest request, @RequestParam Map<String, Object> params) {
    EgovMap isUserHasOrdNo = apiService.isUserHasOrdNo(request, params);
    return ResponseEntity.ok(isUserHasOrdNo);
  }

  @RequestMapping(value = "/customer/getInvoiceListByOrderNumber.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getInvoiceListByOrderNumber(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap invoiceListByOrderNumber = apiService.selectInvoiceListByOrderNumber(request, params);
    return ResponseEntity.ok(invoiceListByOrderNumber);
  }

  @RequestMapping(value = "/customer/getTransactionHistoryList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getTransactionHistoryList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap transactionHistoryList = apiService.selectTransactionHistoryList(request, params);
    return ResponseEntity.ok(transactionHistoryList);
  }

  @RequestMapping(value = "/customer/getInvoiceDetailByTaxInvoiceRefNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getInvoiceDetailByTaxInvoiceRefNo(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap getinvoiceDetailByTaxInvoiceRefNo = apiService.selectInvoiceDetailByTaxInvoiceRefNo(request, params);
    return ResponseEntity.ok(getinvoiceDetailByTaxInvoiceRefNo);
  }

  @RequestMapping(value = "/customer/isUserHasTaxInvoiceRefNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> isUserHasTaxInvoiceRefNo(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap isUserHasTaxInvoiceRefNo = apiService.isUserHasTaxInvoiceRefNo(request, params);
    return ResponseEntity.ok(isUserHasTaxInvoiceRefNo);
  }

  @RequestMapping(value = "/customer/getMembershipProgrammesList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getMembershipProgrammesList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap membershipProgrammesList = apiService.selectMembershipProgrammesList(request, params);
    return ResponseEntity.ok(membershipProgrammesList);
  }

  @RequestMapping(value = "/customer/getOrderNumbersList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getOrderNumbersList(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap orderNumberList = apiService.selectOrderNumberList(request, params);
    return ResponseEntity.ok(orderNumberList);
  }

  @RequestMapping(value = "/customer/getProductList.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getProductList(HttpServletRequest request, @RequestParam Map<String, Object> params) {
    EgovMap productList = apiService.selectProductList(request, params);
    return ResponseEntity.ok(productList);
  }

  /*
   * @RequestMapping(value = "/customer/addOrEditPersonInCharge.do", method = RequestMethod.GET) public ResponseEntity<EgovMap> addOrEditPersonInCharge(HttpServletRequest request,@RequestParam Map<String, Object> params) { EgovMap addOrEditPersonInCharge = apiService.addOrEditPersonInCharge(request, params); return ResponseEntity.ok(addOrEditPersonInCharge); }
   */

  @RequestMapping(value = "/customer/addOrEditCustomerInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> addOrEditCustomerInfo(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap addOrEditCustomerInfo = apiService.addOrEditCustomerInfo(request, params);
    return ResponseEntity.ok(addOrEditCustomerInfo);
  }

  @RequestMapping(value = "/customer/addEInvoiceSubscription.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> addEInvoiceSubscription(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap addEInvoiceSubscription = apiService.addEInvoiceSubscription(request, params);
    return ResponseEntity.ok(addEInvoiceSubscription);
  }

  @RequestMapping(value = "/customer/verify.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> verify(HttpServletRequest request, @RequestParam Map<String, Object> params) {
    EgovMap result = apiService.verify(request, params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/customer/genInvoice.do")
  public void genInvoice(HttpServletRequest request, HttpServletResponse response,
      @RequestParam Map<String, Object> params) {
	  EgovMap eInvResult = new EgovMap();
	  boolean getEInv = false;

    // if (params.get("type").equals("133") || params.get("type").equals("134")) {
    if (params.get("type").equals("REN")) {

      eInvResult = apiService.checkRenEInv(params);

      if(eInvResult != null){
    	  String result = eInvResult.get("genEInv").toString();
    	  int year = Integer.parseInt(eInvResult.get("year").toString()) * 100;
    	  int month = Integer.parseInt(eInvResult.get("month").toString());

    	  if(result.equals("Y") && (year + month >= 202408)){
    		  getEInv = true;
    	  }
      }

      if(getEInv == true){
          params.put(REPORT_FILE_NAME, "/statement/TaxInvoice_Rental_PDF_JOMPAY_EIV_2.rpt");
      }else{
          params.put(REPORT_FILE_NAME, "/statement/TaxInvoice_Rental_PDF_JOMPAY_SST_2.rpt");
      }
      params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
      params.put("V_TAXINVOICEID", params.get("taxInvoiceId").toString()); // parameter
      params.put("V_TYPE", "133");
      params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Rental_Invoice_PDF_" + CommonUtils.getNowDate() + ".pdf");

    } else if (params.get("type").equals("OUT")) {

      eInvResult = apiService.checkOutEInv(params);

      if(eInvResult != null){
    	  String result = eInvResult.get("genEInv").toString();
    	  int year = Integer.parseInt(eInvResult.get("year").toString()) * 100;
    	  int month = Integer.parseInt(eInvResult.get("month").toString());

    	  if(result.equals("Y") && (year + month >= 202408)){
    		  getEInv = true;
    	  }
      }

      if(getEInv == true){
    	  params.put(REPORT_FILE_NAME, "/statement/TaxInvoice_Outright_PDF_EIV.rpt");
      }else{
    	  params.put(REPORT_FILE_NAME, "/statement/TaxInvoice_Outright_PDF_SST.rpt");
      }

      params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
      params.put("V_TAXINVOICEID", params.get("taxInvoiceId").toString()); // parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Outright_Invoice_PDF_" + CommonUtils.getNowDate() + ".pdf");

    } else if (params.get("type").equals("SVM")) {

      eInvResult = apiService.checkSvmEInv(params);

      if(eInvResult != null){
    	  String result = eInvResult.get("genEInv").toString();
    	  int year = Integer.parseInt(eInvResult.get("year").toString()) * 100;
    	  int month = Integer.parseInt(eInvResult.get("month").toString());

    	  if(result.equals("Y") && (year + month >= 202408)){
    		  getEInv = true;
    	  }
      }

      if(getEInv == true){
    	  params.put(REPORT_FILE_NAME, "/statement/TaxInvoice_Miscellaneous_Membership_PDF_EIV_2.rpt");
      }else{
    	  params.put(REPORT_FILE_NAME, "/statement/TaxInvoice_Miscellaneous_Membership_PDF_SST_2.rpt");
      }

      params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
      params.put("v_taxInvoiceID", params.get("taxInvoiceId").toString()); // parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "ServiceMembership_Invoice_PDF_" + CommonUtils.getNowDate() + ".pdf");

    } else if (params.get("type").equals("RENSVM")) { // RENSVM is opt out for e-Invoice

      params.put(REPORT_FILE_NAME, "/statement/TaxInvoice_ServiceContract_PDF_SST.rpt");
      params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
      params.put("V_TASKID", 0);
      params.put("V_REFMONTH", 0);
      params.put("V_REFYEAR", 0);
      params.put("V_REFERENCEID", params.get("taxInvoiceId").toString()); // parameter
      params.put("type", "134");
      params.put("V_TYPE", "134");
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "ServiceContractMembership_Invoice_PDF_" + CommonUtils.getNowDate() + ".pdf");

    }

    this.viewProcedure(request, response, params);

  }

  @RequestMapping(value = "/customer/genStatementofAccount.do")
  public void genStatementofAccount(HttpServletRequest request, HttpServletResponse response,
      @RequestParam Map<String, Object> params) {

    params.put(REPORT_FILE_NAME, "/statement/Official_StatementofAccount_Company_PDF_New.rpt");
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_STATEMENTID", params.get("statementId").toString()); // parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Official_StatementofAccount_Company_PDF_" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(request, response, params);
  }

  private void checkArgument(Map<String, Object> params) {

    Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_FILE_NAME)),
        messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_FILE_NAME }));
    Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_VIEW_TYPE)),
        messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_VIEW_TYPE }));

  }

  private void viewHandle(HttpServletRequest request, HttpServletResponse response, ReportController.ViewType viewType,
      ReportClientDocument clientDoc, CrystalReportViewer crystalReportViewer, Map<String, Object> params)
      throws ReportSDKExceptionBase, IOException {

    String downFileName = (String) params.get(REPORT_DOWN_FILE_NAME);

    switch (viewType) {
      case CSV:
        ReportUtils.viewCSV(response, clientDoc, downFileName);
        break;
      case PDF:
        ReportUtils.viewPDF(response, clientDoc, downFileName);
        break;
      case EXCEL:
        ReportUtils.viewDataEXCEL(response, clientDoc, downFileName, params);
        break;
      case EXCEL_FULL:
        ReportUtils.viewEXCEL(response, clientDoc, downFileName);
        break;
      case MAIL_CSV:
      case MAIL_PDF:
      case MAIL_EXCEL:
        ReportUtils.sendMail(clientDoc, viewType, params);
        break;
      default:
        break;
    }
  }

  private void viewProcedure(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params) {

    this.checkArgument(params);
    String reportFile = (String) params.get(REPORT_FILE_NAME);
    String reportName = reportFilePath + reportFile;
    ReportController.ViewType viewType = ReportController.ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));

    try {
      ReportAppSession ra = new ReportAppSession();
      ra.createService(REPORT_CLIENT_DOCUMENT);

      ra.setReportAppServer(ReportClientDocument.inprocConnectionString);
      ra.initialize();
      ReportClientDocument clientDoc = new ReportClientDocument();
      clientDoc.setReportAppServer(ra.getReportAppServer());
      clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);

      {
        String connectString = reportUrl;
        String driverName = reportDriverClass;
        String jndiName = "sp";
        String userName = reportUserName;
        String password = reportPassword;

        // Switch all tables on the main report and sub reports
        //CRJavaHelper.changeDataSource(clientDoc, userName, password, connectString, driverName, jndiName);
        CRJavaHelper.replaceConnection(clientDoc, userName, password, connectString, driverName, jndiName);
        // logon to database
        CRJavaHelper.logonDataSource(clientDoc, userName, password);
      }

      clientDoc.getDatabaseController().logon(reportUserName, reportPassword);

      ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
      Fields fields = clientDoc.getDataDefinition().getParameterFields();
      ReportUtils.setReportParameter(params, paramController, fields);
      {
        this.viewHandle(request, response, viewType, clientDoc,
            ReportUtils.getCrystalReportViewer(clientDoc.getReportSource()), params);

        // Download File
        Path file = Paths.get(reportFilePath, reportFile);
        if (Files.exists(file)) {
          response.setContentType("application/pdf");
          response.addHeader("Content-Disposition", "attachment; filename=" + reportFile);
          try {
            Files.copy(file, response.getOutputStream());
            response.getOutputStream().flush();
          } catch (IOException ex) {
            ex.printStackTrace();
          }
        }
      }
    } catch (Exception ex) {
      LOGGER.error(CommonUtils.printStackTraceToString(ex));
      throw new ApplicationException(ex);
    }
  }

  @RequestMapping(value = "/customer/tokenizationProcess.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> tokenizationProcess(HttpServletRequest request,
      @RequestParam Map<String, Object> params) {
    EgovMap result = apiService.tokenizationProcess(request, params);
    return ResponseEntity.ok(result);
  }

}
