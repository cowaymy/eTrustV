package com.coway.trust.web.common.visualcut;

import static com.coway.trust.AppConstants.*;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.CRJavaHelper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;
import com.coway.trust.util.ReportUtils;
import com.coway.trust.web.common.ReportController;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

/**
 * CAUTION : 135 Server only //////@Scheduled of ReportBatchController should be uncommented. Then the report batch is
 * executed. Note: If another instance is uncommented, it will be executed multiple times.
 */
@Controller
@RequestMapping(value = "/report/batch")
public class ReportBatchController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReportBatchController.class);

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

	@Value("${web.resource.upload.file}")
	private String uploadDirWeb;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/SQLColorGrid_NoRental-Out-Ins_Excel.do")
	//@Scheduled(cron = "0 0 4 * * *") //Daily (4:00am) // sample : http://fmaker7.tistory.com/163
	public void sqlColorGridNoRentalOutInsExcel() {
		LOGGER.info("[START] SQLColorGrid_NoRental-Out-Ins_Excel...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/SQLColorGrid_NoRental-Out-Ins_Excel.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_NonRentOutIns" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] SQLColorGrid_NoRental-Out-Ins_Excel...");
	}

	@RequestMapping(value = "/SQLColorGrid_NoRental-Out-Ins_Excel_S.do")
	//@Scheduled(cron = "0 10 4 * * *")//Daily (4:10am)
	public void sqlColorGridNoRentalOutInsExcelS() {
		LOGGER.info("[START] SQLColorGrid_NoRental-Out-Ins_Excel_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/SQLColorGrid_NoRental-Out-Ins_Excel_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_NonRentOutIns_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] SQLColorGrid_NoRental-Out-Ins_Excel_S...");
	}

	@RequestMapping(value = "/ColorGrid_Daily_2017_Jan_Dec_S.do")
	//@Scheduled(cron = "0 0 3 * * *")//Daily (3:00am)
	public void colorGridDaily2017JanDecS() {
		LOGGER.info("[START] SQLColorGrid_NoRental-Out-Ins_Excel...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2017_Jan_Dec_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_Daily_2017_Jan_Dec_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] SQLColorGrid_NoRental-Out-Ins_Excel...");
	}

	@RequestMapping(value = "/RentalMembership_CCP.do")
	//@Scheduled(cron = "0 20 4 * * *")//Daily (4:20am)
	public void rentalMembershipCCP() {
		LOGGER.info("[START] RentalMembership_CCP...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/RentalMembership_CCP.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"RentalMembership" + File.separator + "RentalMembership_CCP" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] RentalMembership_CCP...");
	}

	@RequestMapping(value = "/Membership_OUT_REN_Raw.do")
	//@Scheduled(cron = "0 30 4 * * *")//Daily (4:30am)
	public void membershipOutRenRaw() {
		LOGGER.info("[START] Membership_OUT_REN_Raw...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/Membership_OUT_REN_Raw.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Membership_Raw" + File.separator + "Membership_OUT_REN_Raw" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] Membership_OUT_REN_Raw...");
	}

	@RequestMapping(value = "/RCM_Daily_2015_S.do")
	//@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
	public void rcmDaily2015S() {
		LOGGER.info("[START] RCM_Daily_2015_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_2015_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"RCM" + File.separator + "RCM_Daily_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] RCM_Daily_2015_S...");
	}

	@RequestMapping(value = "/RCM_Daily_2015_S_2.do")
	//@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
	public void rcmDaily2015S2() {
		LOGGER.info("[START] RCM_Daily_2015_S_2...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_2015_S_2.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"RCM" + File.separator + "RCM_Daily_S_2" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] RCM_Daily_2015_S_2...");
	}

	@RequestMapping(value = "/ColorGrid_Simplification_2014_2015.do")
	//@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
	public void colorGridSimplification_2014_2015() {
		LOGGER.info("[START] ColorGrid_Simplification_2014_2015...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Simplification_2014_2015.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME, "ColorGrid_Simplification" + File.separator
				+ "ColorGrid_Simplification_2014_2015" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] ColorGrid_Simplification_2014_2015...");
	}

	@RequestMapping(value = "/ColorGrid_Daily_2015_2006-2012_S.do")
	//@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
	public void colorGridDaily_2015_2006_2012_S() {
		LOGGER.info("[START] ColorGrid_Daily_2015_2006-2012_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_2006-2012_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_Daily_2015_2006-2012_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] ColorGrid_Daily_2015_2006-2012_S...");
	}

	@RequestMapping(value = "/ColorGrid_Daily_2015_2013-2014_S.do")
	//@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
	public void colorGridDaily_2015_2013_2014_S() {
		LOGGER.info("[START] ColorGrid_Daily_2015_2013-2014_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_2013-2014_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_Daily_2015_2013-2014_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] ColorGrid_Daily_2015_2013-2014_S...");
	}

	@RequestMapping(value = "/ColorGrid_Daily_2015_Jan_April_S.do")
	//@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
	public void colorGridDaily2015JanAprilS() {
		LOGGER.info("[START] ColorGrid_Daily_2015_Jan_April_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_Jan_April_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_Daily_2015_Jan_April_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] ColorGrid_Daily_2015_Jan_April_S...");
	}

	@RequestMapping(value = "/ColorGrid_Daily_2015_May_Dec_S.do")
	//@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
	public void colorGridDaily2015MayDecS() {
		LOGGER.info("[START] ColorGrid_Daily_2015_May_Dec_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_May_Dec_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_Daily_2015_May_Dec_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] ColorGrid_Daily_2015_May_Dec_S...");
	}

	@RequestMapping(value = "/ColorGrid_Daily_2016_Jan_Dec_S.do")
	//@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
	public void colorGridDaily2016JanDecS() {
		LOGGER.info("[START] ColorGrid_Daily_2016_Jan_Dec_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2016_Jan_Dec_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"ColorGrid" + File.separator + "ColorGrid_Daily_2016_Jan_Dec_S" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] ColorGrid_Daily_2016_Jan_Dec_S...");
	}

	@RequestMapping(value = "/PreBSConfig.do")
	//@Scheduled(cron = "0 24 8 * * MON,WED,FRI")//Weekly (Mon, Wed, Fri) 8:24am
	public void preBSConfig() {
		LOGGER.info("[START] PreBSConfig...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/PreBSConfig.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"BSRaw" + File.separator + "PreBSConfig" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] PreBSConfig...");
	}

	@RequestMapping(value = "/MembershipRawData.do")
	//@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")//Weekly (Mon,Wed,Thu,Fri) 8:00am
	public void membershipRawData() {
		LOGGER.info("[START] MembershipRawData...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/MembershipRawData.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Membership" + File.separator + "MembershipRawData" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] MembershipRawData...");
	}

	@RequestMapping(value = "/StockBalanceListingByLocCodeRAW_CDB.do")
	//@Scheduled(cron = "0 0 4 * * MON,TUE,WED,THU,FRI")//Weekly (Mon,Tue,Wed,Thu,Fri) 4:00am
	public void stockBalanceListingByLocCodeRawCdb() {
		LOGGER.info("[START] StockBalanceListingByLocCodeRAW_CDB...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/StockBalanceListingByLocCodeRAW_CDB.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP"); // parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Logistics" + File.separator
				+ "StockBalanceListingByLocCodeRAW_CDB" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] StockBalanceListingByLocCodeRAW_CDB...");
	}

	@RequestMapping(value = "/StockBalanceListingByLocCodeRAW_DSC.do")
	//@Scheduled(cron = "0 30 3 * * *")//Daily (3:30am)
	public void stockBalanceListingByLocCodeRawDsc() {
		LOGGER.info("[START] StockBalanceListingByLocCodeRAW_DSC...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/StockBalanceListingByLocCodeRAW_DSC.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Logistics" + File.separator
				+ "StockBalanceListingByLocCodeRAW_DSC" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] StockBalanceListingByLocCodeRAW_DSC...");
	}

	@RequestMapping(value = "/BSReport.do")
	//@Scheduled(cron = " 0 0 3 2 * ?")//Monthly (Day 2) 3:00am
	public void bsReport() {
		LOGGER.info("[START] BSReport...");
		String[] deptCodes = { "CCS3013", "CCS3015", "CCS3016", "CCS3017", "CCS3022", "CCS3026", "CCS3031", "CCS3032",
				"CCS3035", "CCS3036", "CCS3050", "CCS3058", "CCS3062", "CCS3067", "CCS3069", "CCS3070", "CCS3073",
				"CCS3075", "CCS3079", "CCS3081", "CCS3082", "CCS3083", "CCS3085", "CCS3086", "CCS3087", "CCS3088",
				"CCS3089", "CCS3092", "CCS3094", "CCS3096", "CCS3097", "CCS3100", "CCS3102", "CCS3103", "CCS3104",
				"CCS3105", "CCS3106", "CCS3107", "CCS3109", "CCS3110", "CCS3111", "CCS3112", "CCS3113", "CCS3114",
				"CCS3115", "CCS3116", "CCS3117", "CCS3118", "CCS3119", "CCS3120", "CCS3121", "CCS3123", "CCS3124",
				"CCS3125", "CCS3126", "CCS3128", "CCS3129", "CCS3130", "CCS3131", "CCS3132", "CCS3133", "CCS3134",
				"CCS3135", "CCS3136", "CCS3137", "CCS3139", "CCS3140", "CCS3141", "CCS3142", "CCS3143", "CCS3144",
				"CCS3145", "CCS3147", "CCS3148", "CCS3149", "CCS3150", "CCS3151", "CCS3152", "CCS3153", "CCS3154",
				"CCS3155", "CCS3156", "CCS3157", "CCS3158", "CCS3159", "CCS3160", "CCS3161", "CCS3162", "CCS3163",
				"CCS3164", "CCS3165", "CCS3166", "CCS3167", "CCS3168", "CCS3169", "CCS3170", "CCS3171", "CCS3172",
				"CCS3173", "CCS3175", "CCS3176", "CCS3177", "CCS3178", "CCS3179", "CCS3180", "CCS3181", "CCS3182",
				"CCS3183", "CCS3184", "CCS3185", "CCS3186", "CCS3187", "CCS3189", "CCS3190", "CCS3191", "CCS3192",
				"CCS3194", "CCS3195", "CCS3196", "CCS3197", "CCS3198", "CCS3199", "CCS3200", "CCS3201", "CCS3202",
				"CCS3203", "CCS3204", "CCS3205", "CCS3206", "CCS3207", "CCS3209", "CCS3210", "CCS3211", "CCS3212",
				"CCS3213", "CCS3214", "CCS3215", "CCS3216", "CCS3217", "CCS3218", "CCS3219", "CCS3221", "CCS3222",
				"CCS3223", "CCS3224", "CCS3225", "CCS3226", "CCS3227", "CCS3228", "CCS3229", "CCS3230", "CCS3231",
				"CCS3232", "CCS3233", "CCS3234", "CCS3235", "CCS3236", "CCS3237", "CCS3238", "CCS3239", "CCS3240",
				"CCS3241", "CCS3242", "CCS3243", "CCS3244", "CCS3245", "CCS3246", "CCS3247", "CCS3248", "CCS3249",
				"CCS3254", "CCS3255", "CCS3256", "CCS3257", "CCS3258", "CCS3259", "CCS3260", "CCS3261", "CCS3262",
				"CCS3263" };

		for (String param : deptCodes) {
			Map<String, Object> params = new HashMap<>();
			params.put(REPORT_FILE_NAME, "/visualcut/BSReport.rpt");// visualcut rpt file name.
			params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
			params.put("V_CODYDEPTCODE", param); // parameter
			params.put(AppConstants.REPORT_DOWN_FILE_NAME,
					"BSReport" + File.separator + "BSReport" + CommonUtils.getNowDate() + "_" + param + ".xls");

			this.viewProcedure(null, null, params);
		}

		LOGGER.info("[END] BSReport...");
	}

	@RequestMapping(value = "/BSReportCT.do")
	//@Scheduled(cron = " 0 0 3 2 * ?")//Monthly (Day 2) 3:00am
	public void bsReportCT() {
		LOGGER.info("[START] BSReportCT...");

		String[] ctCodes = { "CT100049", "CT100052", "CT100370", "CT100374", "CT100401", "CT100410", "CT100420",
				"CT100430", "CT100435", "CT100485", "CT100575", "CT100577", "CT100726" };

		for (String param : ctCodes) {
			Map<String, Object> params = new HashMap<>();
			params.put(REPORT_FILE_NAME, "/visualcut/BSReportCT.rpt");// visualcut rpt file name.
			params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
			params.put("V_CTCODEASC", param);
			params.put(AppConstants.REPORT_DOWN_FILE_NAME,
					"BSReport" + File.separator + "BSReportCT" + CommonUtils.getNowDate() + "_" + param + ".xls");

			this.viewProcedure(null, null, params);
		}

		LOGGER.info("[END] BSReportCT...");
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

	@RequestMapping(value = "/HP_OwnPurchase.do")
	//@Scheduled(cron = "0 40 4 * * *") // 매일 5시에 실행 // sample : http://fmaker7.tistory.com/163
	public void hPOwnPurchase() throws IOException {
		LOGGER.info("[START] HP_OwnPurchase...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/HP_OwnPurchase.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Finance_Control" + File.separator + "HP_OwnPurchase" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] HP_OwnPurchase...");
	}

	@RequestMapping(value = "/LCD_StockTransfer.do")
	//@Scheduled(cron = "0 50 4 * * *")
	public void lcdStockTransfer() throws IOException {
		LOGGER.info("[START] LCD_StockTransfer...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/LCD_StockTransfer.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"LCD" + File.separator + "LCD_StockTransfer" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] LCD_StockTransfer...");
	}

	@RequestMapping(value = "/RCM_Daily_Simplified.do")
	//@Scheduled(cron = "0 10 5 * * *")
	public void rcmDailySimplified() throws IOException {
		LOGGER.info("[START] RCM_Daily_Simplified...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_Simplified.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"RCM" + File.separator + "RCM_Daily_Simplified" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] RCM_Daily_Simplified...");
	}

	@RequestMapping(value = "/MemberRawDate_Excel.do")
	//@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
	public void memberRawDateExcel() throws IOException {
		LOGGER.info("[START] MemberRawDate_Excel...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/MemberRawDate_Excel.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("MemTypeID", "1"); // parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Member" + File.separator + "MemberRawDate_Excel" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] MemberRawDate_Excel...");
	}

	@RequestMapping(value = "/CodyRawDate_Excel.do")
	//@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
	public void codyRawDateExcel() throws IOException {
		LOGGER.info("[START] CodyRawDate_Excel...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/CodyRawDate_Excel.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Member" + File.separator + "CodyRawDate_Excel" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] CodyRawDate_Excel...");
	}

	@RequestMapping(value = "/MemberRawDate_Excel_S.do")
	//@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
	public void memberRawDateExcelS() throws IOException {
		LOGGER.info("[START] MemberRawDate_Excel_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/MemberRawDate_Excel_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("MemTypeID", "1"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Member" + File.separator + "MemberRawDate_Excel_S" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] MemberRawDate_Excel_S...");
	}

	@RequestMapping(value = "/CodyRawDate_Excel_S.do")
	//@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
	public void codyRawDateExcelS() throws IOException {
		LOGGER.info("[START] MemberRawDate_Excel_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/CodyRawDate_Excel_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Member" + File.separator + "CodyRawDate_Excel_S" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] CodyRawDate_Excel_S...");
	}

	@RequestMapping(value = "/BSRawCurrent.do")
	//@Scheduled(cron = "0 24 8 * * MON,WED,FRI")
	public void bsRawCurrent() throws IOException {
		LOGGER.info("[START] BSRawCurrent...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"BSRaw" + File.separator + "BSRawCurrent" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] BSRawCurrent...");
	}

	@RequestMapping(value = "/BSRawCurrent_S1.do")
	//@Scheduled(cron = "0 24 8 * * MON,WED,FRI")
	public void bsRawCurrentS1() throws IOException {
		LOGGER.info("[START] BSRawCurrent_S1...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent_S1.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"BSRaw" + File.separator + "BSRawCurrent_S1" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] BSRawCurrent_S1...");
	}

	@RequestMapping(value = "/BSRawCurrent_S.do")
	//@Scheduled(cron = "0 24 8 * * MON,WED,FRI")
	public void bsRawCurrentS() throws IOException {
		LOGGER.info("[START] BSRawCurrent_S...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent_S.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"BSRaw" + File.separator + "BSRawCurrent_S" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] BSRawCurrent_S...");
	}

	@RequestMapping(value = "/CorpSMSList.do")
	//@Scheduled(cron = "0 0 5 * * MON")//Weekly (Mon) 5:00am
	public void corpSMSList() throws IOException {
		LOGGER.info("[START] CorpSMSList...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/CorpSMSList.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"CorpSMS" + File.separator + "CorpSMSList" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] CorpSMSList...");
	}

	@RequestMapping(value = "/PreMonth_ASResult.do")
	//@Scheduled(cron = " 0 0 6 2 * ?")//Monthly (Day 2) 6:00am
	public void preMonthAsResult() throws IOException {
		LOGGER.info("[START] PreMonth_ASResult...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_ASResult.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"HR" + File.separator + "PreMonth_ASResult" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] PreMonth_ASResult...");
	}

	@RequestMapping(value = "/PreMonth_Installation.do")
	//@Scheduled(cron = " 0 0 6 2 * ?")//Monthly (Day 2) 6:00am
	public void preMonthInstallation() throws IOException {
		LOGGER.info("[START] PreMonth_Installation...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_Installation.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"HR" + File.separator + "PreMonth_Installation" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] PreMonth_Installation...");
	}

	@RequestMapping(value = "/PreMonth_ProductReturn.do")
	//@Scheduled(cron = " 0 0 6 2 * ?")//Monthly (Day 2) 6:00am
	public void preMonthProductReturn() throws IOException {
		LOGGER.info("[START] PreMonth_ProductReturn...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_ProductReturn.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"HR" + File.separator + "PreMonth_ProductReturn" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] PreMonth_ProductReturn...");
	}

	@RequestMapping(value = "/PreMonth_HS_Filter.do")
	//@Scheduled(cron = " 0 0 6 2 * ?")//Monthly (Day 2) 6:00am
	public void preMonthHsFilter() throws IOException {
		LOGGER.info("[START] PreMonth_HS_Filter...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_HS_Filter.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"HR" + File.separator + "PreMonth_HS_Filter" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] PreMonth_HS_Filter...");
	}

	@RequestMapping(value = "/VC_CTCommission_PDF_V2.do")
	//@Scheduled(cron = " 0 5 8 25 * ?")//Monthly (Day 25) 8:05am
	public void vcCtCommissionPdfV2() throws IOException {
		LOGGER.info("[START] VC_CTCommission_PDF_V2...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/VC_CTCommission_PDF_V2.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Finance" + File.separator + "VC_CTCommission_PDF_V2" + CommonUtils.getNowDate() + ".pdf");

		this.view(null, null, params);
		LOGGER.info("[END] VC_CTCommission_PDF_V2...");
	}

	@RequestMapping(value = "/RptReferralsRawData.do")
	//@Scheduled(cron = "0 35 4 * * *") // Daily (4:35am)
	public void rptReferralsRawData() throws IOException {
		LOGGER.info("[START] RptReferralsRawData...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/RptReferralsRawData.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"RptReferrals" + File.separator + "RptReferralsRawData" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] RptReferralsRawData...");
	}

	@RequestMapping(value = "/RptRorAorBor_16th.do")
	//@Scheduled(cron = " 0 30 3 17 * ?") // Monthly (Day 17) 3:30am
	public void rptRorAorBor16th() throws IOException {
		LOGGER.info("[START] RptRorAorBor_16th...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/RptRorAorBor_16th.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Finance_PNC" + File.separator + "RptRorAorBor_16th" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] RptRorAorBor_16th...");
	}

	@RequestMapping(value = "/RptRorAorBor_3th.do")
	//@Scheduled(cron = " 0 26 2 4 * ?") // Monthly (Day 4) 2:26am
	public void rptRorAorBor3th() throws IOException {
		LOGGER.info("[START] RptRorAorBor_3th...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/RptRorAorBor_3th.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Finance_PNC" + File.separator + "RptRorAorBor_3th" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] RptRorAorBor_3th...");
	}

	@RequestMapping(value = "/EInvoiceStatus.do")
	//@Scheduled(cron = " 0 0 8 28 * ?") // Monthly (Day 28) 8:00am
	public void eInvoiceStatus() throws IOException {
		LOGGER.info("[START] EInvoiceStatus...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/EInvoiceStatus.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"EInvoice" + File.separator + "EInvoiceStatus" + CommonUtils.getNowDate() + ".xls");

		this.view(null, null, params);
		LOGGER.info("[END] EInvoiceStatus...");
	}

	@RequestMapping(value = "/CashFlowReport.do")
	//@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am) /*monthly - end of month eg 31 @ 28 ...
	public void CashFlowReport() {
		LOGGER.info("[START] CashFlowReport...");
		Map<String, Object> params = new HashMap<>();
		params.put(REPORT_FILE_NAME, "/visualcut/CashFlowReport.rpt");// visualcut rpt file name.
		params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
		params.put("V_TEMP", "TEMP");// parameter
		params.put(AppConstants.REPORT_DOWN_FILE_NAME,
				"Finance" + File.separator + "CashFlow" + CommonUtils.getNowDate() + ".xls");

		this.viewProcedure(null, null, params);
		LOGGER.info("[END] CashFlowReport...");
	}


	private void view(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params)
			throws IOException {
		checkArgument(params);
		String reportFile = (String) params.get(REPORT_FILE_NAME);
		ReportController.ViewType viewType = ReportController.ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));

		try {

			String reportName = reportFilePath + reportFile;
			ReportClientDocument clientDoc = new ReportClientDocument();

			// Report can be opened from the relative location specified in the CRConfig.xml, or the report location
			// tag can be removed to open the reports as Java resources or using an absolute path
			// (absolute path not recommended for Web applications).
			clientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
			clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);
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

			Object reportSource = clientDoc.getReportSource();

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

	private void viewHandle(HttpServletRequest request, HttpServletResponse response,
			ReportController.ViewType viewType, ReportClientDocument clientDoc, CrystalReportViewer crystalReportViewer,
			Map<String, Object> params) throws ReportSDKExceptionBase, IOException {

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
			throw new ApplicationException(AppConstants.FAIL, "wrong viewType....");
		}
	}
}
