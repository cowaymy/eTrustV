package com.coway.trust.web.common;

import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_CLIENT_DOCUMENT;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.coway.trust.cmmn.CRJavaHelper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.config.handler.SessionHandler;
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

@Controller
@RequestMapping(value = "/report")
public class ReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReportController.class);

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

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private ServletContext context;

	@RequestMapping(value = "/view-proc.do", method = RequestMethod.GET)
	public void viewProcGet(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params) {
		this.viewProcedure(request, response, params);
	}

	@RequestMapping(value = "/view-proc-submit.do", method = RequestMethod.POST)
	public void viewProcPostSubmit(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params) {
		this.viewProcedure(request, response, params);
	}

	@RequestMapping(value = "/view-proc.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity viewProcPost(HttpServletRequest request, HttpServletResponse response,
			@RequestBody Map<String, Object> params) {
		this.viewProcedure(request, response, params);
		return ResponseEntity.ok(HttpStatus.OK);
	}

	private void viewProcedure(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params) {
		this.checkArgument(params);
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

			
			ArrayList<String> plist = new ArrayList<String>(); 
			plist.add("/services/BSFilterReplacement.rpt");
			plist.add("/services/BSReport_ByBSNo.rpt");
			
			LOGGER.debug(" reportName  ================================> ]"+reportName +"]["+plist.contains(reportFile));
			LOGGER.debug(" open reportUserName]"+reportUserName +"]reportPassword["+reportPassword+"]");
			
			
			if(plist.contains(reportFile)){
				 reportUserName ="GBSLCVAPL1";
				 reportPassword = "GBSLCVD#2017#";
			}
			
			LOGGER.debug(" close  reportUserName]"+reportUserName +"]reportPassword["+reportPassword+"]");
			
			clientDoc.getDatabaseController().logon(reportUserName, reportPassword);

			ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
			Fields fields = clientDoc.getDataDefinition().getParameterFields();
			ReportUtils.setReportParameter(params, paramController, fields);
			{
				this.viewHandle(request, response, viewType, clientDoc,
						ReportUtils.getCrystalReportViewer(clientDoc.getReportSource()), params);
			}
		} catch (Exception ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	@RequestMapping(value = "/view.do", method = RequestMethod.GET)
	public void viewGet(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params) throws IOException {
		this.view(request, response, params);
	}

	@RequestMapping(value = "/view-submit.do", method = RequestMethod.POST)
	public void viewPostSubmit(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params) throws IOException {
		this.view(request, response, params);
	}

	@RequestMapping(value = "/view.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity viewPost(HttpServletRequest request, HttpServletResponse response,
			@RequestBody Map<String, Object> params) throws IOException {
		this.view(request, response, params);
		return ResponseEntity.ok(HttpStatus.OK);
	}

	private void view(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params)
			throws IOException {
		checkArgument(params);
		String reportFile = (String) params.get(REPORT_FILE_NAME);
		ViewType viewType = ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));

		try {

			HttpSession session = sessionHandler.getCurrentSession();
			String reportName = reportFilePath + reportFile;
			ReportClientDocument clientDoc = (ReportClientDocument) session.getAttribute(reportName);

			if (clientDoc == null) {
				// Report can be opened from the relative location specified in the CRConfig.xml, or the report location
				// tag can be removed to open the reports as Java resources or using an absolute path
				// (absolute path not recommended for Web applications).
				clientDoc = new ReportClientDocument();
				clientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
				clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);
				{
					String connectString = reportUrl;
					String driverName = reportDriverClass;
					String jndiName = "";
					String userName = reportUserName;
					String password = reportPassword;
					
					ArrayList<String> plist = new ArrayList<String>(); 
					plist.add("/services/BSFilterReplacement.rpt");
					plist.add("/services/BSReport_ByBSNo.rpt");
					
					LOGGER.debug(" reportName  ================================> "+reportName);
					
					
					if(plist.contains(reportName)){
						 connectString = "jdbc:oracle:thin:@10.201.32.216:1521:gbslcvd";
						 driverName = "oracle.jdbc.OracleDriver";
						 jndiName = "";
						 userName ="GBSLCVAPL1";
						 password = "GBSLCVD#2017#";
					}
					
					// Switch all tables on the main report and sub reports
					CRJavaHelper.changeDataSource(clientDoc, userName, password, connectString, driverName, jndiName);
					// logon to database
					CRJavaHelper.logonDataSource(clientDoc, userName, password);
					
				}
				// Store the report document in session
				// session.setAttribute(reportName, clientDoc);
			}

			String reportSourceSessionKey = reportName + "ReportSource";
			Object reportSource = session.getAttribute(reportSourceSessionKey);

			if (reportSource == null) {
				reportSource = clientDoc.getReportSource();
				// session.setAttribute(reportSourceSessionKey, reportSource);
			}

			ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
			Fields fields = clientDoc.getDataDefinition().getParameterFields();
			ReportUtils.setReportParameter(params, paramController, fields);
			{
				this.viewHandle(request, response, viewType, clientDoc,
						ReportUtils.getCrystalReportViewer(reportSource), params);
			}
		} catch (ReportSDKExceptionBase ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	private void checkArgument(Map<String, Object> params) {
		LOGGER.debug("{} : {}", REPORT_FILE_NAME, params.get(REPORT_FILE_NAME));
		LOGGER.debug("{} : {}", REPORT_VIEW_TYPE, params.get(REPORT_VIEW_TYPE));

		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_FILE_NAME)),
				messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_FILE_NAME }));
		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_VIEW_TYPE)),
				messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_VIEW_TYPE }));
	}

	private void viewHandle(HttpServletRequest request, HttpServletResponse response, ViewType viewType,
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
			viewWindow(request, response, crystalReportViewer);
			break;
		}
	}

	private void viewWindow(HttpServletRequest request, HttpServletResponse response,
			CrystalReportViewer crystalReportViewer) throws ReportSDKExceptionBase {
		crystalReportViewer.processHttpRequest(request, response, context, null);
	}

	public enum ViewType {
		WINDOW, PDF, EXCEL, EXCEL_FULL, CSV, MAIL_PDF, MAIL_EXCEL, MAIL_CSV
	}

	public interface ExportFile {
		void export(ReportClientDocument clientDoc, HttpServletResponse response, boolean attachment,
				String downFileName) throws ReportSDKExceptionBase, IOException;
	}
	
}
