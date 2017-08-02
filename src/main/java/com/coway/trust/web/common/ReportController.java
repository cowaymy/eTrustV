package com.coway.trust.web.common;

import java.io.IOException;
import java.util.Locale;
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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CRJavaHelper;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;
import com.crystaldecisions.report.web.viewer.CrPrintMode;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.FieldDisplayNameType;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKException;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

@Controller
@RequestMapping(value = "/report")
public class ReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReportController.class);

	private static final String REPORT_FILE_NAME = "reportFileName";
	private static final String REPORT_VIEW_TYPE = "viewType";
	private static final String REPORT_CLIENT_DOCUMENT = "com.crystaldecisions.sdk.occa.report.application.ReportClientDocument";

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

	@RequestMapping(value = "/view-proc.do")
	public void view2(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params) {
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

			clientDoc.getDatabaseController().logon(reportUserName, reportPassword);

			ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
			Fields fields = clientDoc.getDataDefinition().getParameterFields();
			this.setReportParameter(params, paramController, fields);
			this.viewHandle(request, response, viewType, clientDoc,
					this.getCrystalReportViewer(clientDoc.getReportSource()));
		} catch (Exception ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	@RequestMapping(value = "/view.do")
	public void view(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params) {
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

				String connectString = reportUrl;
				String driverName = reportDriverClass;
				String jndiName = "";
				String userName = reportUserName;
				String password = reportPassword;

				// Switch all tables on the main report and sub reports
				CRJavaHelper.changeDataSource(clientDoc, userName, password, connectString, driverName, jndiName);
				// logon to database
				CRJavaHelper.logonDataSource(clientDoc, userName, password);

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
			this.setReportParameter(params, paramController, fields);
			this.viewHandle(request, response, viewType, clientDoc, this.getCrystalReportViewer(reportSource));

		} catch (ReportSDKExceptionBase ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	private void checkArgument(Map<String, Object> params) {
		LOGGER.debug("{} : {}", REPORT_FILE_NAME, params.get(REPORT_FILE_NAME));
		LOGGER.debug("{} : {}", REPORT_VIEW_TYPE, params.get(REPORT_VIEW_TYPE));

		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_FILE_NAME)),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { REPORT_FILE_NAME }));
		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_VIEW_TYPE)),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { REPORT_VIEW_TYPE }));
	}

	private CrystalReportViewer getCrystalReportViewer(Object reportSource) throws ReportSDKExceptionBase {
		CrystalReportViewer crystalReportViewer = new CrystalReportViewer();

		crystalReportViewer.setOwnPage(true);
		crystalReportViewer.setPrintMode(CrPrintMode.ACTIVEX);
		crystalReportViewer.setReportSource(reportSource);

		crystalReportViewer.setDisplayToolbar(true);
		crystalReportViewer.setDisplayPage(true);
		crystalReportViewer.setDisplayGroupTree(false);
		crystalReportViewer.setHasLogo(false);
		crystalReportViewer.setEnableDrillDown(true);
		crystalReportViewer.setHasExportButton(false);
		crystalReportViewer.setHasRefreshButton(false);
		crystalReportViewer.setHasPrintButton(true);
		return crystalReportViewer;
	}

	private void viewHandle(HttpServletRequest request, HttpServletResponse response, ViewType viewType,
			ReportClientDocument clientDoc, CrystalReportViewer crystalReportViewer) throws ReportSDKExceptionBase {
		switch (viewType) {
		case CSV:
			viewCSV(response, clientDoc);
			break;
		case PDF:
			viewPDF(response, clientDoc);
			break;
		case EXCEL:
			viewEXCEL(response, clientDoc);
			break;
		default:
			viewWindow(request, response, crystalReportViewer);
			break;
		}
	}

	private void viewEXCEL(HttpServletResponse response, ReportClientDocument clientDoc) throws ReportSDKExceptionBase {
		try {
			CRJavaHelper.exportExcelDataOnly(clientDoc, response, true);
		} catch (IOException ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	private void viewCSV(HttpServletResponse response, ReportClientDocument clientDoc) throws ReportSDKExceptionBase {
		try {
			CRJavaHelper.exportCSV(clientDoc, response, true);
		} catch (IOException ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	private void viewPDF(HttpServletResponse response, ReportClientDocument clientDoc) throws ReportSDKExceptionBase {
		try {
			CRJavaHelper.exportPDF(clientDoc, response, true);
		} catch (IOException ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	private void viewWindow(HttpServletRequest request, HttpServletResponse response,
			CrystalReportViewer crystalReportViewer) throws ReportSDKExceptionBase {
		crystalReportViewer.processHttpRequest(request, response, context, null);
	}

	private void setReportParameter(@RequestParam Map<String, Object> params, ParameterFieldController paramController,
			Fields fields) {
		params.forEach((k, v) -> {
			try {
				int index = fields.find(k, FieldDisplayNameType.fieldName, Locale.getDefault());
				if (index >= 0) {
					paramController.setCurrentValue("", k, v);
				}
			} catch (ReportSDKException e) {
				throw new ApplicationException(e, e.getMessage());
			}
		});
	}

	enum ViewType {
		WINDOW, PDF, EXCEL, CSV
	}
}
