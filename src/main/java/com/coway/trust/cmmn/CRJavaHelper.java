package com.coway.trust.cmmn;

import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;

import java.io.*;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.crystaldecisions.sdk.occa.report.application.DBOptions;
import com.crystaldecisions.sdk.occa.report.application.DataDefController;
import com.crystaldecisions.sdk.occa.report.application.DatabaseController;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.*;
import com.crystaldecisions.sdk.occa.report.document.PaperSize;
import com.crystaldecisions.sdk.occa.report.document.PaperSource;
import com.crystaldecisions.sdk.occa.report.document.PrintReportOptions;
import com.crystaldecisions.sdk.occa.report.document.PrinterDuplex;
import com.crystaldecisions.sdk.occa.report.exportoptions.*;
import com.crystaldecisions.sdk.occa.report.lib.IStrings;
import com.crystaldecisions.sdk.occa.report.lib.PropertyBag;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKException;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

/**
 * crystal report helper
 */
@Component
public class CRJavaHelper {

	private static final Logger LOGGER = LoggerFactory.getLogger(CRJavaHelper.class);

	public static final String XLS = "xls";
	public static final String CSV = "csv";
	public static final String RTF = "rtf";
	public static final String PDF = "pdf";
	public static final String COL_WIDTH = "colWidth";

	private static String uploadDirWeb;

	@Autowired
	private CRJavaHelper(@Value("${web.resource.upload.file}") String uploadDirWeb) {
		this.uploadDirWeb = uploadDirWeb;
	}

	/**
	 * Logs on to all existing datasource
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param username
	 *            The DB logon user name
	 * @param password
	 *            The DB logon password
	 * @throws ReportSDKException
	 */
	public static void logonDataSource(ReportClientDocument clientDoc, String username, String password)
			throws ReportSDKException {
		clientDoc.getDatabaseController().logon(username, password);
	}

	/**
	 * Changes the DataSource for each Table
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param username
	 *            The DB logon user name
	 * @param password
	 *            The DB logon password
	 * @param connectionURL
	 *            The connection URL
	 * @param driverName
	 *            The driver Name
	 * @param jndiName
	 *            The JNDI name
	 * @throws ReportSDKException
	 */
	public static void changeDataSource(ReportClientDocument clientDoc, String username, String password,
			String connectionURL, String driverName, String jndiName) throws ReportSDKException {

		changeDataSource(clientDoc, null, null, username, password, connectionURL, driverName, jndiName);
	}

	/**
	 * Changes the DataSource for a specific Table
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param reportName
	 *            "" for main report, name of subreport for subreport, null for all reports
	 * @param tableName
	 *            name of table to change. null for all tables.
	 * @param username
	 *            The DB logon user name
	 * @param password
	 *            The DB logon password
	 * @param connectionURL
	 *            The connection URL
	 * @param driverName
	 *            The driver Name
	 * @param jndiName
	 *            The JNDI name
	 * @throws ReportSDKException
	 */
	public static void changeDataSource(ReportClientDocument clientDoc, String reportName, String tableName,
			String username, String password, String connectionURL, String driverName, String jndiName)
			throws ReportSDKException {

		PropertyBag propertyBag = null;
		IConnectionInfo connectionInfo = null;
		ITable origTable = null;
		ITable newTable = null;
		// Declare variables to hold ConnectionInfo values.
		// Below is the list of values required to switch to use a JDBC/JNDI
		// connection
		String trustedConnection = "false";
		String serverType = "JDBC (JNDI)";
		String useJdbc = "true";
		String databaseDll = "crdb_jdbc.dll";
		String jndiDatasourceName = jndiName;
		String connectionUrl = connectionURL;
		String dbClassName = driverName;


		// The next few parameters are optional parameters which you may want to
		// uncomment
		// You may wish to adjust the arguments of the method to pass these
		// values in if necessary
		// String TABLE_NAME_QUALIFIER = "new_table_name";
		// String SERVER_NAME = "new_server_name";
		// String CONNECTION_STRING = "new_connection_string";
		// String DATABASE_NAME = "new_database_name";
		// String URI = "new_URI";

		// Declare variables to hold database User Name and Password values
		String dbUserName = username;
		String dbPassword = password;

		if(jndiDatasourceName !=null ){
			Tables tables = clientDoc.getDatabaseController().getDatabase().getTables();

			for (int i = 0; i < tables.size(); i++) {
				 IProcedure oldTableP = (IProcedure) tables.getTable(i);
				 IProcedure newTableP = (IProcedure)oldTableP.clone(true);

				 ParameterField paramField = (ParameterField)newTableP.getParameters().get(0);
				 Values currentValues = new Values();
				 ParameterFieldDiscreteValue parameterValue = new ParameterFieldDiscreteValue();
				 parameterValue.setValue(new Integer (1));
				 currentValues.add(parameterValue);
				 paramField.setCurrentValues(currentValues);

				 newTableP.setQualifiedName(oldTableP.getQualifiedName());
				 connectionInfo = newTableP.getConnectionInfo();

				propertyBag = new PropertyBag();
				propertyBag.put("Trusted_Connection", trustedConnection);
				propertyBag.put("Server Type", serverType);
				propertyBag.put("Use JDBC", useJdbc);
				propertyBag.put("Database DLL", databaseDll);
				propertyBag.put("JNDI Datasource Name", jndiDatasourceName);
				propertyBag.put("Connection URL", connectionUrl);
				propertyBag.put("Database Class Name", dbClassName);

				connectionInfo.setAttributes(propertyBag);
				connectionInfo.setUserName(dbUserName);
				connectionInfo.setPassword(dbPassword);

				clientDoc.getDatabaseController().setTableLocation(oldTableP, newTableP);
			}
		}

		// Obtain collection of tables from this database controller
		else if (reportName == null || reportName.equals("")) {
			Tables tables = clientDoc.getDatabaseController().getDatabase().getTables();
			for (int i = 0; i < tables.size(); i++) {
				origTable = tables.getTable(i);
				if (tableName == null || origTable.getName().equals(tableName)) {
					newTable = (ITable) origTable.clone(true);

					// We set the Fully qualified name to the Table Alias to keep the
					// method generic
					// This workflow may not work in all scenarios and should likely be
					// customized to work
					// in the developer's specific situation. The end result of this
					// statement will be to strip
					// the existing table of it's db specific identifiers. For example
					// Xtreme.dbo.Customer becomes just Customer
					newTable.setQualifiedName(origTable.getAlias());

					// Change properties that are different from the original datasource
					// For example, if the table name has changed you will be required
					// to change it during this routine
					// table.setQualifiedName(TABLE_NAME_QUALIFIER);

					// Change connection information properties
					connectionInfo = newTable.getConnectionInfo();

					// Set new table connection property attributes
					propertyBag = new PropertyBag();

					// Overwrite any existing properties with updated values
					propertyBag.put("Trusted_Connection", trustedConnection);
					propertyBag.put("Server Type", serverType);
					propertyBag.put("Use JDBC", useJdbc);
					propertyBag.put("Database DLL", databaseDll);
					propertyBag.put("JNDI Datasource Name", jndiDatasourceName);
					propertyBag.put("Connection URL", connectionUrl);
					propertyBag.put("Database Class Name", dbClassName);
					// propertyBag.put("Server Name", SERVER_NAME); //Optional property
					// propertyBag.put("Connection String", CONNECTION_STRING); //Optional property
					// propertyBag.put("Database Name", DATABASE_NAME); //Optional property
					// propertyBag.put("URI", URI); //Optional property
					connectionInfo.setAttributes(propertyBag);

					// Set database username and password
					// NOTE: Even if the username and password properties do not change
					// when switching databases, the
					// database password is *not* saved in the report and must be set at
					// runtime if the database is secured.
					connectionInfo.setUserName(dbUserName);
					connectionInfo.setPassword(dbPassword);

					// Update the table information
					clientDoc.getDatabaseController().setTableLocation(origTable, newTable);
				}
			}
		}
		// Next loop through all the subreports and pass in the same
		// information. You may consider
		// creating a separate method which accepts
		if (reportName == null || !(reportName.equals(""))) {
			IStrings subNames = clientDoc.getSubreportController().getSubreportNames();
			for (int subNum = 0; subNum < subNames.size(); subNum++) {
				Tables tables = clientDoc.getSubreportController().getSubreport(subNames.getString(subNum))
						.getDatabaseController().getDatabase().getTables();
				for (int i = 0; i < tables.size(); i++) {
					origTable = tables.getTable(i);
					if (tableName == null || origTable.getName().equals(tableName)) {
						newTable = (ITable) origTable.clone(true);

						// We set the Fully qualified name to the Table Alias to keep
						// the method generic
						// This workflow may not work in all scenarios and should likely
						// be customized to work
						// in the developer's specific situation. The end result of this
						// statement will be to strip
						// the existing table of it's db specific identifiers. For
						// example Xtreme.dbo.Customer becomes just Customer
						newTable.setQualifiedName(origTable.getAlias());

						// Change properties that are different from the original
						// datasource
						// table.setQualifiedName(TABLE_NAME_QUALIFIER);

						// Change connection information properties
						connectionInfo = newTable.getConnectionInfo();

						// Set new table connection property attributes
						propertyBag = new PropertyBag();

						// Overwrite any existing properties with updated values
						propertyBag.put("Trusted_Connection", trustedConnection);
						propertyBag.put("Server Type", serverType);
						propertyBag.put("Use JDBC", useJdbc);
						propertyBag.put("Database DLL", databaseDll);
						propertyBag.put("JNDI Datasource Name", jndiDatasourceName);
						propertyBag.put("Connection URL", connectionUrl);
						propertyBag.put("Database Class Name", dbClassName);
						// propertyBag.put("Server Name", SERVER_NAME); //Optional property
						// propertyBag.put("Connection String", CONNECTION_STRING); //Optional property
						// propertyBag.put("Database Name", DATABASE_NAME); //Optional property
						// propertyBag.put("URI", URI); //Optional property
						connectionInfo.setAttributes(propertyBag);

						// Set database username and password
						// NOTE: Even if the username and password properties do not
						// change when switching databases, the
						// database password is *not* saved in the report and must be
						// set at runtime if the database is secured.
						connectionInfo.setUserName(dbUserName);
						connectionInfo.setPassword(dbPassword);

						// Update the table information
						clientDoc.getSubreportController().getSubreport(subNames.getString(subNum))
								.getDatabaseController().setTableLocation(origTable, newTable);
					}
				}
			}
		}
	}

	/**
	 * Passes a populated java.sql.Resultset object to a Table object
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param rs
	 *            The java.sql.Resultset used to populate the Table
	 * @param tableAlias
	 *            The alias of the table
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @throws ReportSDKException
	 */
	public static void passResultSet(ReportClientDocument clientDoc, java.sql.ResultSet rs, String tableAlias,
			String reportName) throws ReportSDKException {
		if (reportName.equals(""))
			clientDoc.getDatabaseController().setDataSource(rs, tableAlias, tableAlias);
		else
			clientDoc.getSubreportController().getSubreport(reportName).getDatabaseController().setDataSource(rs,
					tableAlias, tableAlias);

	}

	/**
	 * Passes a populated collection of a Java class to a Table object
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param dataSet
	 *            The java.sql.Resultset used to populate the Table
	 * @param className
	 *            The fully-qualified class name of the POJO objects being passed
	 * @param tableAlias
	 *            The alias of the table
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @throws ReportSDKException
	 */
	public static void passPOJO(ReportClientDocument clientDoc, Collection dataSet, String className, String tableAlias,
			String reportName) throws ReportSDKException, ClassNotFoundException {
		if (reportName.equals(""))
			clientDoc.getDatabaseController().setDataSource(dataSet, Class.forName(className), tableAlias, tableAlias);
		else
			clientDoc.getSubreportController().getSubreport(reportName).getDatabaseController().setDataSource(dataSet,
					Class.forName(className), tableAlias, tableAlias);

	}

	/**
	 * Passes a single discrete parameter value to a report parameter
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @param parameterName
	 *            The name of the parameter
	 * @param newValue
	 *            The new value of the parameter
	 * @throws ReportSDKException
	 */
	public static void addDiscreteParameterValue(ReportClientDocument clientDoc, String reportName,
			String parameterName, Object newValue) throws ReportSDKException {
		DataDefController dataDefController = null;
		if (reportName.equals(""))
			dataDefController = clientDoc.getDataDefController();
		else
			dataDefController = clientDoc.getSubreportController().getSubreport(reportName).getDataDefController();

		ParameterFieldDiscreteValue newDiscValue = new ParameterFieldDiscreteValue();
		newDiscValue.setValue(newValue);

		ParameterField paramField = (ParameterField) dataDefController.getDataDefinition().getParameterFields()
				.findField(parameterName, FieldDisplayNameType.fieldName, Locale.getDefault());
		boolean multiValue = paramField.getAllowMultiValue();

		if (multiValue) {
			Values newVals = (Values) paramField.getCurrentValues().clone(true);
			newVals.add(newDiscValue);
			clientDoc.getDataDefController().getParameterFieldController().setCurrentValue(reportName, parameterName,
					newVals);
		} else {
			clientDoc.getDataDefController().getParameterFieldController().setCurrentValue(reportName, parameterName,
					newValue);
		}
	}

	/**
	 * Passes multiple discrete parameter values to a report parameter
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @param parameterName
	 *            The name of the parameter
	 * @param newValues
	 *            An array of new values to get set on the parameter
	 * @throws ReportSDKException
	 */
	public static void addDiscreteParameterValue(ReportClientDocument clientDoc, String reportName,
			String parameterName, Object[] newValues) throws ReportSDKException {
		clientDoc.getDataDefController().getParameterFieldController().setCurrentValues(reportName, parameterName,
				newValues);
	}

	/**
	 * Passes a single range parameter value to a report parameter. The range is assumed to be inclusive on beginning
	 * and end.
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @param parameterName
	 *            The name of the parameter
	 * @param beginValue
	 *            The value of the beginning of the range
	 * @param endValue
	 *            The value of the end of the range
	 * @throws ReportSDKException
	 */
	public static void addRangeParameterValue(ReportClientDocument clientDoc, String reportName, String parameterName,
			Object beginValue, Object endValue) throws ReportSDKException {
		addRangeParameterValue(clientDoc, reportName, parameterName, beginValue, RangeValueBoundType.inclusive,
				endValue, RangeValueBoundType.inclusive);
	}

	/**
	 * Passes multiple range parameter values to a report parameter.
	 *
	 * This overload of the addRangeParameterValue will only work if the parameter is setup to accept multiple values.
	 *
	 * If the Parameter does not accept multiple values then it is expected that this version of the method will return
	 * an error
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @param parameterName
	 *            The name of the parameter
	 * @param beginValues
	 *            Array of beginning values. Must be same length as endValues.
	 * @param endValues
	 *            Array of ending values. Must be same length as beginValues.
	 * @throws ReportSDKException
	 */
	public static void addRangeParameterValue(ReportClientDocument clientDoc, String reportName, String parameterName,
			Object[] beginValues, Object[] endValues) throws ReportSDKException {
		addRangeParameterValue(clientDoc, reportName, parameterName, beginValues, RangeValueBoundType.inclusive,
				endValues, RangeValueBoundType.inclusive);
	}

	/**
	 * Passes a single range parameter value to a report parameter
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @param parameterName
	 *            The name of the parameter
	 * @param beginValue
	 *            The value of the beginning of the range
	 * @param lowerBoundType
	 *            The inclusion/exclusion range of the start of range.
	 * @param endValue
	 *            The value of the end of the range
	 * @param upperBoundType
	 *            The inclusion/exclusion range of the end of range.
	 * @throws ReportSDKException
	 */
	public static void addRangeParameterValue(ReportClientDocument clientDoc, String reportName, String parameterName,
			Object beginValue, RangeValueBoundType lowerBoundType, Object endValue, RangeValueBoundType upperBoundType)
			throws ReportSDKException {
		DataDefController dataDefController = null;
		if (reportName.equals(""))
			dataDefController = clientDoc.getDataDefController();
		else
			dataDefController = clientDoc.getSubreportController().getSubreport(reportName).getDataDefController();

		ParameterFieldRangeValue newRangeValue = new ParameterFieldRangeValue();
		newRangeValue.setBeginValue(beginValue);
		newRangeValue.setLowerBoundType(lowerBoundType);
		newRangeValue.setEndValue(endValue);
		newRangeValue.setUpperBoundType(upperBoundType);

		ParameterField paramField = (ParameterField) dataDefController.getDataDefinition().getParameterFields()
				.findField(parameterName, FieldDisplayNameType.fieldName, Locale.getDefault());
		boolean multiValue = paramField.getAllowMultiValue();

		if (multiValue) {
			Values newVals = (Values) paramField.getCurrentValues().clone(true);
			newVals.add(newRangeValue);
			clientDoc.getDataDefController().getParameterFieldController().setCurrentValue(reportName, parameterName,
					newVals);
		} else {
			clientDoc.getDataDefController().getParameterFieldController().setCurrentValue(reportName, parameterName,
					newRangeValue);
		}

		LOGGER.debug(">>>>>>>>>>  parameterName : {} ,  newRangeValue : {}", parameterName, newRangeValue);
	}

	/**
	 * Passes multiple range parameter values to a report parameter.
	 *
	 * This overload of the addRangeParameterValue will only work if the parameter is setup to accept multiple values.
	 *
	 * If the Parameter does not accept multiple values then it is expected that this version of the method will return
	 * an error
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param reportName
	 *            The name of the subreport. If tables in the main report is to be used, "" should be passed
	 * @param parameterName
	 *            The name of the parameter
	 * @param beginValues
	 *            Array of beginning values. Must be same length as endValues.
	 * @param lowerBoundType
	 *            The inclusion/exclusion range of the start of range.
	 * @param endValues
	 *            Array of ending values. Must be same length as beginValues.
	 * @param upperBoundType
	 *            The inclusion/exclusion range of the end of range.
	 *
	 * @throws ReportSDKException
	 */
	public static void addRangeParameterValue(ReportClientDocument clientDoc, String reportName, String parameterName,
			Object[] beginValues, RangeValueBoundType lowerBoundType, Object[] endValues,
			RangeValueBoundType upperBoundType) throws ReportSDKException {
		// it is expected that the beginValues array is the same size as the
		// endValues array
		ParameterFieldRangeValue[] newRangeValues = new ParameterFieldRangeValue[beginValues.length];
		for (int i = 0; i < beginValues.length; i++) {
			newRangeValues[i] = new ParameterFieldRangeValue();
			newRangeValues[i].setBeginValue(beginValues[i]);
			newRangeValues[i].setLowerBoundType(lowerBoundType);
			newRangeValues[i].setEndValue(endValues[i]);
			newRangeValues[i].setUpperBoundType(upperBoundType);
		}
		clientDoc.getDataDefController().getParameterFieldController().setCurrentValues(reportName, parameterName,
				newRangeValues);

	}

	/**
	 * Exports a report to PDF
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportPDF(ReportClientDocument clientDoc, HttpServletResponse response, boolean attachment,
			String downFileName) throws ReportSDKExceptionBase, IOException {
		ExportOptions exportOptions = getPDFExportOptions();
		export(clientDoc, exportOptions, response, attachment, "application/pdf", PDF, downFileName);
	}

	public static ExportOptions getPDFExportOptions() {
		// PDF export allows page range export. The following routine ensures
		// that the requested page range is valid
		PDFExportFormatOptions pdfOptions = new PDFExportFormatOptions();
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.PDF);
		exportOptions.setFormatOptions(pdfOptions);
		return exportOptions;
	}

	/**
	 * Exports a report to PDF for a range of pages
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param startPage
	 *            Starting page
	 * @param endPage
	 *            Ending page
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportPDF(ReportClientDocument clientDoc, HttpServletResponse response, ServletContext context,
			int startPage, int endPage, boolean attachment, String downFileName)
			throws ReportSDKExceptionBase, IOException {
		// PDF export allows page range export. The following routine ensures
		// that the requested page range is valid
		PDFExportFormatOptions pdfOptions = new PDFExportFormatOptions();
		pdfOptions.setStartPageNumber(startPage);
		pdfOptions.setEndPageNumber(endPage);
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.PDF);
		exportOptions.setFormatOptions(pdfOptions);

		export(clientDoc, exportOptions, response, attachment, "application/pdf", PDF, downFileName);

	}

	/**
	 * Exports a report to RTF
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportRTF(ReportClientDocument clientDoc, HttpServletResponse response, boolean attachment,
			String downFileName) throws ReportSDKExceptionBase, IOException {
		// RTF export allows page range export. The following routine ensures
		// that the requested page range is valid
		RTFWordExportFormatOptions rtfOptions = new RTFWordExportFormatOptions();
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.RTF);
		exportOptions.setFormatOptions(rtfOptions);

		export(clientDoc, exportOptions, response, attachment, "text/rtf", RTF, downFileName);
	}

	/**
	 * Exports a report to RTF for a range of pages
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param startPage
	 *            Starting page
	 * @param endPage
	 *            Ending page.
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportRTF(ReportClientDocument clientDoc, HttpServletResponse response, ServletContext context,
			int startPage, int endPage, boolean attachment) throws ReportSDKExceptionBase, IOException {
		// RTF export allows page range export. The following routine ensures
		// that the requested page range is valid
		RTFWordExportFormatOptions rtfOptions = new RTFWordExportFormatOptions();
		rtfOptions.setStartPageNumber(startPage);
		rtfOptions.setEndPageNumber(endPage);
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.RTF);
		exportOptions.setFormatOptions(rtfOptions);

		export(clientDoc, exportOptions, response, attachment, "text/rtf", RTF, "");
	}

	/**
	 * Exports a report to RTF
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportRTFEditable(ReportClientDocument clientDoc, HttpServletResponse response,
			boolean attachment, String downFileName) throws ReportSDKExceptionBase, IOException {
		// RTF export allows page range export. The following routine ensures
		// that the requested page range is valid
		EditableRTFExportFormatOptions rtfOptions = new EditableRTFExportFormatOptions();
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.editableRTF);
		exportOptions.setFormatOptions(rtfOptions);

		export(clientDoc, exportOptions, response, attachment, "text/rtf", RTF, downFileName);
	}

	/**
	 * Exports a report to RTF for a range of pages
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param startPage
	 *            Starting page
	 * @param endPage
	 *            Ending page.
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportRTFEditable(ReportClientDocument clientDoc, HttpServletResponse response,
			ServletContext context, int startPage, int endPage, boolean attachment, String downFileName)
			throws ReportSDKExceptionBase, IOException {
		// RTF export allows page range export. The following routine ensures
		// that the requested page range is valid
		EditableRTFExportFormatOptions rtfOptions = new EditableRTFExportFormatOptions();
		rtfOptions.setStartPageNumber(startPage);
		rtfOptions.setEndPageNumber(endPage);
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.editableRTF);
		exportOptions.setFormatOptions(rtfOptions);

		export(clientDoc, exportOptions, response, attachment, "text/rtf", RTF, downFileName);
	}

	/**
	 * Exports a report to Excel (Data Only)
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportExcelDataOnly(ReportClientDocument clientDoc, HttpServletResponse response,
			boolean attachment, String downFileName, Map<String, Object> params)
			throws ReportSDKExceptionBase, IOException {
		ExportOptions exportOptions = getExcelExportptionsDataOnly(params);
		export(clientDoc, exportOptions, response, attachment, "application/excel", XLS, downFileName);
	}

	public static void exportGeneralExcelDataOnly(ReportClientDocument clientDoc, HttpServletResponse response,
			boolean attachment, String downFileName, Map<String, Object> params)
			throws ReportSDKExceptionBase, IOException {
		ExportOptions exportOptions = getExcelExportptionsDataOnly(params);

		boolean isGeneralPath = Boolean.parseBoolean(params.get("isGeneral").toString());

		exportGeneral(clientDoc, exportOptions, response, attachment, "application/excel", XLS, downFileName,isGeneralPath);
}

	public static ExportOptions getExcelExportptionsDataOnly(Map<String, Object> params) {
		DataOnlyExcelExportFormatOptions excelOptions = new DataOnlyExcelExportFormatOptions();
		// excelOptions.setUseConstantColWidth(true);
		if (CommonUtils.isEmpty(params.get(COL_WIDTH))) {
			excelOptions.setConstantColWidth(90);
		} else {
			excelOptions.setConstantColWidth((Integer) params.get(COL_WIDTH));
		}

		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.recordToMSExcel);
		exportOptions.setFormatOptions(excelOptions);
		return exportOptions;
	}

	public static void exportExcel(ReportClientDocument clientDoc, HttpServletResponse response, boolean attachment,
			String downFileName) throws ReportSDKExceptionBase, IOException {
		ExportOptions exportOptions = getExcelExportOptions();
		export(clientDoc, exportOptions, response, attachment, "application/excel", XLS, downFileName);
	}

	public static ExportOptions getExcelExportOptions() {
		ExportOptions exportOptions = new ExportOptions();
		// exportOptions.setExportFormatType(ReportExportFormat.recordToMSExcel);
		exportOptions.setExportFormatType(ReportExportFormat.MSExcel);
		return exportOptions;
	}

	/**
	 * Exports a report to CSV
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param response
	 *            The HttpServletResponse object
	 * @param attachment
	 *            true to prompts for open or save; false opens the report in the specified format after exporting.
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	public static void exportCSV(ReportClientDocument clientDoc, HttpServletResponse response, boolean attachment,
			String downFileName) throws ReportSDKExceptionBase, IOException {
		ExportOptions exportOptions = getCSVExportOptions();
		export(clientDoc, exportOptions, response, attachment, "text/csv", CSV, downFileName);
	}

	public static ExportOptions getCSVExportOptions() {
		CharacterSeparatedValuesExportFormatOptions csvOptions = new CharacterSeparatedValuesExportFormatOptions();
		/* comment by Vannie 20200217. Is to export to CSV file but data is in excel data view (column).
		csvOptions.setSeparator(",");
		csvOptions.setDelimiter("\n");*/
		csvOptions.setReportSectionsOption(CharacterSeparatedValuesExportFormatOptions.ExportSectionsOption.exportIsolated);
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.characterSeparatedValues);
		exportOptions.setFormatOptions(csvOptions);
		return exportOptions;
	}

	public static void exportGeneralCSV(ReportClientDocument clientDoc, HttpServletResponse response, boolean attachment,
			String downFileName, Map<String, Object> params) throws ReportSDKExceptionBase, IOException {
		ExportOptions exportOptions = getCSVExportOptions();

		boolean isGeneralPath = Boolean.parseBoolean(params.get("isGeneral").toString());
		exportGeneral(clientDoc, exportOptions, response, attachment, "text/csv", CSV, downFileName, isGeneralPath);
	}

	/**
	 * Exports a report to a specified format
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param exportOptions
	 *            Export options
	 * @param response
	 *            The response object to write to
	 * @param attachment
	 *            True to prompts for open or save; false opens the report in the specified format after exporting.
	 * @param mimeType
	 *            MIME type of the format being exported
	 * @param extension
	 *            file extension of the format (e.g., "pdf" for Acrobat)
	 * @param downFileName
	 * @throws ReportSDKExceptionBase
	 * @throws IOException
	 */
	private static void export(ReportClientDocument clientDoc, ExportOptions exportOptions,
			HttpServletResponse response, boolean attachment, String mimeType, String extension, String downFileName)
			throws ReportSDKExceptionBase, IOException {

		InputStream is = null;
		try {
			is = new BufferedInputStream(clientDoc.getPrintOutputController().export(exportOptions));

			byte[] data = new byte[1024];

			if (response != null) {
				response.setContentType(mimeType);
			}

			if (response != null && attachment) {
				String name = "";
				if (StringUtils.isNotEmpty(downFileName)) {
					name = downFileName;
				} else if (StringUtils.isEmpty(name)) {
					name = clientDoc.getReportSource().getReportTitle();
					name = name.replaceAll("\"", "");
				}

				if (StringUtils.isEmpty(name)) {
					name = "Report-" + extension;
				}

				response.setHeader("Set-Cookie", "fileDownload=true; path=/"); /// resources/js/jquery.fileDownload.js
				/// callback 호출시 필수.
				response.setHeader("Content-Disposition", "attachment; filename=\"" + name + "." + extension + "\"");
			}

			if (response != null) {
				OutputStream os = response.getOutputStream();
				while (is.read(data) > -1) {
					os.write(data);
				}
			} else {
				LOGGER.info("this line is batch call =>downFileName : {}, mimeType : {}", downFileName, mimeType);

				File targetFile1 = new File(uploadDirWeb + File.separator + "RawData" + File.separator + "Public"
						+ File.separator + downFileName);
				File targetFile2 = new File(uploadDirWeb + File.separator + "RawData" + File.separator + "Privacy"
						+ File.separator + downFileName);
				if (!targetFile1.exists()) {
					LOGGER.debug("make dir1...");
					targetFile1.mkdirs();
				}
				if (!targetFile2.exists()) {
					LOGGER.debug("make dir2...");
					targetFile2.mkdirs();
				}

				java.nio.file.Files.copy(is, targetFile1.toPath(), StandardCopyOption.REPLACE_EXISTING);
				java.nio.file.Files.copy(targetFile1.toPath(), targetFile2.toPath(),
						StandardCopyOption.REPLACE_EXISTING);

				IOUtils.closeQuietly(is);
			}

		} finally {
			if (is != null) {
				is.close();
			}
		}
	}

	private static void exportGeneral(ReportClientDocument clientDoc, ExportOptions exportOptions,
			HttpServletResponse response, boolean attachment, String mimeType, String extension, String downFileName, boolean isGeneral)
			throws ReportSDKExceptionBase, IOException {

		InputStream is = null;
		try {
			is = new BufferedInputStream(clientDoc.getPrintOutputController().export(exportOptions));

			byte[] data = new byte[1024];

			if (response != null) {
				response.setContentType(mimeType);
			}

			if (response != null && attachment) {
				String name = "";
				if (StringUtils.isNotEmpty(downFileName)) {
					name = downFileName;
				} else if (StringUtils.isEmpty(name)) {
					name = clientDoc.getReportSource().getReportTitle();
					name = name.replaceAll("\"", "");
				}

				if (StringUtils.isEmpty(name)) {
					name = "Report-" + extension;
				}

				response.setHeader("Set-Cookie", "fileDownload=true; path=/"); /// resources/js/jquery.fileDownload.js
				/// callback 호출시 필수.
				response.setHeader("Content-Disposition", "attachment; filename=\"" + name + "." + extension + "\"");
			}

			if (response != null) {
				OutputStream os = response.getOutputStream();
				while (is.read(data) > -1) {
					os.write(data);
				}
			} else {
				LOGGER.info("this line is batch call =>downFileName : {}, mimeType : {}", downFileName, mimeType);

				if(isGeneral){
					File targetFile1 = new File(uploadDirWeb + File.separator + downFileName);
					if (!targetFile1.exists()) {
    					LOGGER.debug("make dir1...");
    					targetFile1.mkdirs();
    				}

    				java.nio.file.Files.copy(is, targetFile1.toPath(), StandardCopyOption.REPLACE_EXISTING);

    				IOUtils.closeQuietly(is);
				}
				else{
    				File targetFile1 = new File(uploadDirWeb + File.separator + "RawData" + File.separator + "Public"
    						+ File.separator + downFileName);
    				File targetFile2 = new File(uploadDirWeb + File.separator + "RawData" + File.separator + "Privacy"
    						+ File.separator + downFileName);
    				if (!targetFile1.exists()) {
    					LOGGER.debug("make dir1...");
    					targetFile1.mkdirs();
    				}
    				if (!targetFile2.exists()) {
    					LOGGER.debug("make dir2...");
    					targetFile2.mkdirs();
    				}

    				java.nio.file.Files.copy(is, targetFile1.toPath(), StandardCopyOption.REPLACE_EXISTING);
    				java.nio.file.Files.copy(targetFile1.toPath(), targetFile2.toPath(),
    						StandardCopyOption.REPLACE_EXISTING);

    				IOUtils.closeQuietly(is);
				}
			}

		} finally {
			if (is != null) {
				is.close();
			}
		}
	}

	public static void exportToMail(ReportClientDocument clientDoc, ExportOptions exportOptions, String extension,
			Map<String, Object> params) throws ReportSDKExceptionBase, IOException {

		String subject = (String) params.get(AppConstants.EMAIL_SUBJECT);
		checkParam(subject, AppConstants.EMAIL_SUBJECT);
		String to = (String) params.get(AppConstants.EMAIL_TO);
		checkParam(to, AppConstants.EMAIL_TO);

		String downFileName = (String) params.get(AppConstants.REPORT_DOWN_FILE_NAME);
		String text = (String) params.get(AppConstants.EMAIL_TEXT);

		if (StringUtils.isEmpty(downFileName)) {
			downFileName = clientDoc.getReportSource().getReportTitle();
			downFileName = downFileName.replaceAll("\"", "");
		}

		InputStream is = null;
		try {
			is = new BufferedInputStream(clientDoc.getPrintOutputController().export(exportOptions));
			AdaptorService adaptorService = CommonUtils.getBean("adaptorService", AdaptorService.class);

			EmailVO emailVO = new EmailVO();
			emailVO.addFile(EgovFormBasedFileUtil.streamToFile(is, downFileName, extension));
			emailVO.setTo(Arrays.asList(CommonUtils.getDelimiterValues(to)));
			emailVO.setHtml(false);
			emailVO.setSubject(subject);
			emailVO.setText(text);
			adaptorService.sendEmail(emailVO, true);

		} finally {
			if (is != null) {
				is.close();
			}
		}

	}

	public static void exportToMailMultiple(ReportClientDocument clientDoc, ExportOptions exportOptions, String extension,
			Map<String, Object> params) throws ReportSDKExceptionBase, IOException {


		String subject = (String) params.get(AppConstants.EMAIL_SUBJECT);
		checkParam(subject, AppConstants.EMAIL_SUBJECT);
		List<String> emailTo = (List<String>) params.get(AppConstants.EMAIL_TO);
		String[] to = emailTo.toArray(new String[emailTo.size()]);
		checkParam2(to, AppConstants.EMAIL_TO);
		String downFileName = (String) params.get(AppConstants.REPORT_DOWN_FILE_NAME);
		LOGGER.debug("downFileName111===" + downFileName);

		String text = (String) params.get(AppConstants.EMAIL_TEXT);
		if (StringUtils.isEmpty(downFileName)) {
			downFileName = clientDoc.getReportSource().getReportTitle();
			downFileName = downFileName.replaceAll("\"", "");
		}
		InputStream is = null;
		try {
			is = new BufferedInputStream(clientDoc.getPrintOutputController().export(exportOptions));
			AdaptorService adaptorService = CommonUtils.getBean("adaptorService", AdaptorService.class);

			EmailVO emailVO = new EmailVO();
			emailVO.addFile(EgovFormBasedFileUtil.streamToFile(is, downFileName, extension));
			emailVO.setTo(Arrays.asList(to));
			emailVO.setHtml(false);
			emailVO.setSubject(subject);
			emailVO.setText(text);
			adaptorService.sendEmail(emailVO, true);

		} finally {
			if (is != null) {
				is.close();
			}
		}

	}

	private static void checkParam(String param, String key) {
		if (StringUtils.isEmpty(param)) {
			throw new ApplicationException(AppConstants.FAIL,
					CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class)
							.getMessage(AppConstants.MSG_NECESSARY, new Object[] { key }));
		}
	}

	private static void checkParam2(String[] param, String key) {
		if (StringUtils.isAnyEmpty(param)) {
			throw new ApplicationException(AppConstants.FAIL,
					CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class)
							.getMessage(AppConstants.MSG_NECESSARY, new Object[] { key }));
		}
	}

	/**
	 * Prints to the server printer
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param printerName
	 *            Name of printer used to print the report
	 * @throws ReportSDKException
	 */
	public static void printToServer(ReportClientDocument clientDoc, String printerName) throws ReportSDKException {
		PrintReportOptions printOptions = new PrintReportOptions();
		// Note: Printer with the <printer name> below must already be
		// configured.
		printOptions.setPrinterName(printerName);
		printOptions.setJobTitle("Sample Print Job from Crystal Reports.");
		printOptions.setPrinterDuplex(PrinterDuplex.useDefault);
		printOptions.setPaperSource(PaperSource.auto);
		printOptions.setPaperSize(PaperSize.paperLetter);
		printOptions.setNumberOfCopies(1);
		printOptions.setCollated(false);

		// Print report
		clientDoc.getPrintOutputController().printReport(printOptions);
	}

	/**
	 * Prints a range of pages to the server printer
	 *
	 * @param clientDoc
	 *            The reportClientDocument representing the report being used
	 * @param printerName
	 *            Name of printer used to print the report
	 * @param startPage
	 *            Starting page
	 * @param endPage
	 *            Ending page.
	 * @throws ReportSDKException
	 */
	public static void printToServer(ReportClientDocument clientDoc, String printerName, int startPage, int endPage)
			throws ReportSDKException {
		PrintReportOptions printOptions = new PrintReportOptions();
		// Note: Printer with the <printer name> below must already be
		// configured.
		printOptions.setPrinterName(printerName);
		printOptions.setJobTitle("Sample Print Job from Crystal Reports.");
		printOptions.setPrinterDuplex(PrinterDuplex.useDefault);
		printOptions.setPaperSource(PaperSource.auto);
		printOptions.setPaperSize(PaperSize.paperLetter);
		printOptions.setNumberOfCopies(1);
		printOptions.setCollated(false);
		PrintReportOptions.PageRange printPageRange = new PrintReportOptions.PageRange(startPage, endPage);
		printOptions.addPrinterPageRange(printPageRange);

		// Print report
		clientDoc.getPrintOutputController().printReport(printOptions);
	}

	 public static void replaceConnection(ReportClientDocument clientDoc,String username, String password, String connectionURL, String driverName, String jndiName)
	      throws ReportSDKException {

	    IConnectionInfo oldConnectionInfo =  new ConnectionInfo();
	    IConnectionInfo newConnectionInfo = new ConnectionInfo();

	    Fields pFields = null;
	    DatabaseController dbController = clientDoc.getDatabaseController();

	    if(!dbController.getConnectionInfos(null).isEmpty()){
  	    oldConnectionInfo = dbController.getConnectionInfos(null).getConnectionInfo(0);

  	    PropertyBag propertyBag = new PropertyBag();

  	    boolean trustedConnection = false;
  	    String serverType = "JDBC (JNDI)";
  	    boolean useJdbc = true;
  	    String databaseDll = "crdb_jdbc.dll";
  	    String jndiDatasourceName = jndiName;
  	    String connectionUrl = connectionURL;
  	    String dbClassName = driverName;

  	    // Set new table logon properties
  	    propertyBag.put("Trusted_Connection", trustedConnection);
  	    propertyBag.put("Server Type", serverType);
  	    propertyBag.put("Use JDBC", useJdbc);
  	    propertyBag.put("Database DLL", databaseDll);
  	    propertyBag.put("JNDI Datasource Name", jndiDatasourceName);
  	    propertyBag.put("Connection URL", connectionUrl);
  	    propertyBag.put("Database Class Name", dbClassName);

  	    // Assign the properties to the connection info
  	    newConnectionInfo.setAttributes(propertyBag);

  	    newConnectionInfo.setUserName(username);
  	    newConnectionInfo.setPassword(password);

  	    newConnectionInfo.setKind(ConnectionInfoKind.from_string("CRQE"));

  	  // set the parameters to replace.
  	    // The 4 options are:
  	    // _doNotVerifyDB
  	    // _ignoreCurrentTableQualifiers
  	    // _mapFieldByRowsetPosition
  	    // _useDefault
  	    int replaceParams = DBOptions._ignoreCurrentTableQualifiers + DBOptions._doNotVerifyDB;

  	    dbController.replaceConnection(oldConnectionInfo, newConnectionInfo, pFields, replaceParams);

  	     IStrings subNames = clientDoc.getSubreportController().getSubreportNames();
  	     for (int subNum = 0; subNum < subNames.size(); subNum++) {
  	        Tables tables = clientDoc.getSubreportController().getSubreport(subNames.getString(subNum)).getDatabaseController().getDatabase().getTables();
  	        for (int i = 0; i < tables.size(); i++) {
  	          dbController.replaceConnection(oldConnectionInfo, newConnectionInfo, pFields, replaceParams);
  	          clientDoc.getSubreportController().getSubreport(subNames.getString(subNum))
  	                   .getDatabaseController().replaceConnection(oldConnectionInfo, newConnectionInfo, pFields, replaceParams);;
  	        }
  	     }
	    }

	  }

	 public static void exportExcel2007(ReportClientDocument clientDoc, HttpServletResponse response, boolean attachment,
	      String downFileName) throws ReportSDKExceptionBase, IOException {
	    ExportOptions exportOptions = getExcel2007ExportOptions();
	    export(clientDoc, exportOptions, response, attachment, "application/excel", XLS, downFileName);
	  }

	  public static ExportOptions getExcel2007ExportOptions() {
	    ExportOptions exportOptions = new ExportOptions();
	    exportOptions.setExportFormatType(ReportExportFormat.MSExcel);
	    return exportOptions;
	  }


}
