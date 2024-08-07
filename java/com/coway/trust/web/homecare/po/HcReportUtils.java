package com.coway.trust.web.homecare.po;

import static com.coway.trust.AppConstants.FAIL;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.cmmn.CRJavaHelper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import com.crystaldecisions.report.web.viewer.CrPrintMode;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.Field;
import com.crystaldecisions.sdk.occa.report.data.FieldDisplayNameType;
import com.crystaldecisions.sdk.occa.report.data.FieldValueType;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.exportoptions.ExportOptions;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKException;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

public class HcReportUtils {
	private static final Logger LOGGER = LoggerFactory.getLogger(HcReportUtils.class);

	private HcReportUtils() {
	}

	public static void setReportParameter(Map<String, Object> params, ParameterFieldController paramController,
			Fields fields) {
		params.forEach((k, v) -> {
			try {
				LOGGER.debug(" k : {}, V : {}", k, v);
				int index = fields.find(k, FieldDisplayNameType.fieldName, Locale.getDefault());
				if (index >= 0) {
					if (((Field) fields.get(index))
							.getType() == com.crystaldecisions.sdk.occa.report.data.FieldValueType.dateField) {
						SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
						Date d;
						try {
							d = format.parse(String.valueOf(v));
						} catch (Exception e) {
							throw new ApplicationException(e, e.getMessage());
						}
						paramController.setCurrentValue("", k, d);
					} else if (((Field) fields.get(index)).getType() == FieldValueType.dateTimeField) {
						SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
						Date d;
						try {
							d = format.parse(String.valueOf(v));
						} catch (Exception e) {
							throw new ApplicationException(e, e.getMessage());
						}
						paramController.setCurrentValue("", k, d);
					} else {
						paramController.setCurrentValue("", k, v);
					}
				}
			} catch (ReportSDKException e) {
				throw new ApplicationException(e, e.getMessage());
			}
		});
	}

	public static void exportFile(HCReportController.ExportFile exportFile, HttpServletResponse response,
			ReportClientDocument clientDoc, String downFileName) {
		try {
			exportFile.export(clientDoc, response, true, downFileName);
		} catch (Exception ex) {
			LOGGER.error(CommonUtils.printStackTraceToString(ex));
			throw new ApplicationException(ex);
		}
	}

	public static void sendMail(ReportClientDocument clientDoc, HCReportController.ViewType viewType,
			Map<String, Object> params) throws IOException, ReportSDKExceptionBase {

		ExportOptions exportOptions;
		String extension;

		switch (viewType) {
		case MAIL_CSV:
			exportOptions = CRJavaHelper.getCSVExportOptions();
			extension = CRJavaHelper.CSV;
			break;
		case MAIL_PDF:
			exportOptions = CRJavaHelper.getPDFExportOptions();
			extension = CRJavaHelper.PDF;
			break;
		case MAIL_EXCEL:
			exportOptions = CRJavaHelper.getExcelExportOptions();
			extension = CRJavaHelper.XLS;
			break;
		default:
			throw new ApplicationException(FAIL, "Invalid viewType !!!!!!!!!!");
		}

		CRJavaHelper.exportToMail(clientDoc, exportOptions, extension, params);
	}

	public static void viewEXCEL(HttpServletResponse response, ReportClientDocument clientDoc, String downFileName) {
		HcReportUtils.exportFile((clientDoc1, response1, attachment, downFileName1) -> CRJavaHelper.exportExcel(clientDoc,
				response, true, downFileName), response, clientDoc, downFileName);
	}

	public static void viewDataEXCEL(HttpServletResponse response, ReportClientDocument clientDoc, String downFileName,
			Map<String, Object> params) {
		HcReportUtils
				.exportFile(
						(clientDoc1, response1, attachment, downFileName1) -> CRJavaHelper
								.exportExcelDataOnly(clientDoc, response, true, downFileName, params),
						response, clientDoc, downFileName);
	}

	public static void viewCSV(HttpServletResponse response, ReportClientDocument clientDoc, String downFileName) {
		HcReportUtils.exportFile((clientDoc1, response1, attachment, downFileName1) -> CRJavaHelper.exportCSV(clientDoc,
				response, true, downFileName), response, clientDoc, downFileName);
	}

	public static void viewPDF(HttpServletResponse response, ReportClientDocument clientDoc, String downFileName) {
		HcReportUtils.exportFile((clientDoc1, response1, attachment, downFileName1) -> CRJavaHelper.exportPDF(clientDoc,
				response, true, downFileName), response, clientDoc, downFileName);
	}



	public static CrystalReportViewer getCrystalReportViewer(Object reportSource) throws ReportSDKExceptionBase {
		CrystalReportViewer crystalReportViewer = new CrystalReportViewer();

		crystalReportViewer.setOwnPage(true);
		crystalReportViewer.setPrintMode(CrPrintMode.PDF);
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

}
