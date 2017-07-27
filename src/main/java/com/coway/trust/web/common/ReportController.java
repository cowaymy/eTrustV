package com.coway.trust.web.common;

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
import org.springframework.ui.ModelMap;
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
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

@Controller
@RequestMapping(value = "/report")
public class ReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReportController.class);

	private static final String REPROT_FILE_NAME = "reportFileName";

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

	@RequestMapping(value = "/view.do")
	public void view(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params,
			ModelMap model) {

		LOGGER.debug("reportName : {}", params.get(REPROT_FILE_NAME));
		String reportFile = (String) params.get(REPROT_FILE_NAME);

		Precondition.checkArgument(CommonUtils.isNotEmpty(reportFile),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { REPROT_FILE_NAME }));

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

				// Open report
				clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);

				// ****** BEGIN SET RUNTIME DATABASE CREDENTIALS ****************
				{
					String connectString = reportUrl;
					String driverName = reportDriverClass;
					String jndiName = "";
					String userName = reportUserName;
					String password = reportPassword;

					// Switch all tables on the main report and sub reports
					CRJavaHelper.changeDataSource(clientDoc, userName, password, connectString, driverName, jndiName);

					// logon to database
					CRJavaHelper.logonDataSource(clientDoc, userName, password);
				}
				// ****** END SET RUNTIME DATABASE CREDENTIALS ****************

				// Store the report document in session
				// session.setAttribute(reportName, clientDoc);

			}

			// ****** BEGIN CONNECT CRYSTALREPORTPAGEVIEWER SNIPPET ****************
			{

				// Create the CrystalReportViewer object
				CrystalReportViewer crystalReportViewer = new CrystalReportViewer();

				String reportSourceSessionKey = reportName + "ReportSource";
				Object reportSource = session.getAttribute(reportSourceSessionKey);

				if (reportSource == null) {
					reportSource = clientDoc.getReportSource();
					// session.setAttribute(reportSourceSessionKey, reportSource);
				}

				// set the reportsource property of the viewer
				crystalReportViewer.setReportSource(reportSource);

				// Apply the viewer preference attributes
				crystalReportViewer = new CrystalReportViewer();
				crystalReportViewer.setOwnPage(true);
				crystalReportViewer.setPrintMode(CrPrintMode.ACTIVEX);
				crystalReportViewer.setReportSource(reportSource);

				crystalReportViewer.setOwnPage(true);
				crystalReportViewer.setDisplayToolbar(true);
				crystalReportViewer.setDisplayPage(true);
				crystalReportViewer.setDisplayGroupTree(false);
				crystalReportViewer.setHasLogo(false);
				crystalReportViewer.setEnableDrillDown(true);
				crystalReportViewer.setHasExportButton(false);
				crystalReportViewer.setHasRefreshButton(false);
				crystalReportViewer.setHasPrintButton(true);

				// Process the report
				crystalReportViewer.processHttpRequest(request, response, context, null);

			}
			// ****** END CONNECT CRYSTALREPORTPAGEVIEWER SNIPPET ****************

		} catch (ReportSDKExceptionBase ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}
}
