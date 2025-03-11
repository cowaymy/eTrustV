package com.coway.trust.web.common.visualcut;

import static com.coway.trust.AppConstants.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
//import com.coway.trust.biz.attendance.AttendanceService;
import com.coway.trust.biz.api.ChatbotInboundApiService;
import com.coway.trust.biz.common.ReportBatchService;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.payment.autodebit.service.impl.AutoDebitMapper;
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
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * CAUTION : 135 Server only //////@Scheduled of ReportBatchController should be
 * uncommented. Then the report batch is executed. Note: If another instance is
 * uncommented, it will be executed multiple times.
 * Cron job formatter: https://fmaker7.tistory.com/163
 * http://10.201.32.135:8094/
 * Path: /apps/domains/SalesDmain/servers/eTRUST_report/WEB-INF/classes/com/coway/trust/web/common/visualcut
 * Folder: /apps/apache/htdocs/resources/WebShare/RawData/Public
 */
@Controller
@RequestMapping(value = "/report/batch")
public class ReportBatchController {

  private static final Logger LOGGER = LoggerFactory.getLogger(ReportBatchController.class);

//  @Resource(name = "AttendanceService")
//  private AttendanceService attendanceService;

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

  @Value("${autodebit.authorization.destination.path}")
  private String adAuthDestinationDir;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private ReportBatchService reportBatchService;

  @Resource(name="chatbotInboundApiService")
	private ChatbotInboundApiService chatbotInboundApiService;

  @Resource(name = "voucherMapper")
	private VoucherMapper voucherMapper;

  @Resource(name="autoDebitMapper")
  private AutoDebitMapper autoDebitMapper;

  @RequestMapping(value = "/SQLColorGrid_NoRental-Out-Ins_Excel.do")
  //@Scheduled(cron = "0 0 4 * * *") //Daily (4:00am) // sample :
  // http://fmaker7.tistory.com/163
  public void sqlColorGridNoRentalOutInsExcel() {
    LOGGER.info("[START] SQLColorGrid_NoRental-Out-Ins_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/SQLColorGrid_NoRental-Out-Ins_Excel.rpt");// visualcut
                                                                                       // rpt
                                                                                       // file
                                                                                       // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/SQLColorGrid_NoRental-Out-Ins_Excel_S.rpt");// visualcut
                                                                                         // rpt
                                                                                         // file
                                                                                         // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2017_Jan_Dec_S.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/RentalMembership_CCP.rpt");// visualcut
                                                                        // rpt
                                                                        // file
                                                                        // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/Membership_OUT_REN_Raw.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_2015_S.rpt");// visualcut
                                                                    // rpt file
                                                                    // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_2015_S_2.rpt");// visualcut
                                                                      // rpt
                                                                      // file
                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM" + File.separator + "RCM_Daily_S1_2" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Daily_2015_S_2...");
  }

  @RequestMapping(value = "/RCM_Daily_2015_S1_2.do")
  //@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
  public void rcmDaily2015S2_1() {
    LOGGER.info("[START] RCM_Daily_2015_S1_2...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_2015_S1_2.rpt");// visualcut
                                                                       // rpt
                                                                       // file
                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM" + File.separator + "RCM_Daily_S2_2" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Daily_2015_S1_2...");
  }

  @RequestMapping(value = "/RCM_Daily_2015_S2_2.do")
  //@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
  public void rcmDaily2015S2_2() {
    LOGGER.info("[START] RCM_Daily_2015_S2_2...");
    // RCM report for YEAR 2019
    String startYear = "2019";
    String endYear = "2019";

    Map<String, Object> params = new HashMap<>();
    //params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_2015_S2_2.rpt");// visualcut
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily.rpt");// visualcut
                                                                       // rpt
                                                                       // file
                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_STARTYEAR", startYear);// parameter
    params.put("V_ENDYEAR", endYear);// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM" + File.separator + "RCM_Daily_S3_2" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Daily_2015_S2_2...");
  }

  @RequestMapping(value = "/RCM_Daily.do")
  //@Scheduled(cron = "0 30 5 * * *")//Daily (5:30am)
  public void rcmDaily() {

    int startYear = 2020;
    int currentYear = LocalDate.now().getYear();

    for(int year= startYear;year <= currentYear; year++){
      LOGGER.info("[START] RCM_Daily_Current_Year...");
      Map<String, Object> params = new HashMap<>();
      params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily.rpt");// visualcut
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_TEMP", "TEMP");// parameter
      params.put("V_STARTYEAR", year);// parameter
      params.put("V_ENDYEAR", "");// parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "RCM" + File.separator + "RCM_Daily_" + year + "_" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);
      LOGGER.info("[END] RCM_Daily_Current_Year...");
    }

  }

  @RequestMapping(value = "/RCM_Daily_2015_Company.do")
  //@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
  public void rcmDaily2015S2_Company() {
    LOGGER.info("[START] RCM_Daily_2015_Company...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_2015_Company.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM" + File.separator + "RCM_Daily_Company" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Daily_2015_Company...");
  }

  @RequestMapping(value = "/RCM_Daily_HT.do")
  //@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
  public void rcmDailyHtMattress() {
    LOGGER.info("[START] RCM_Daily_HT...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_HTMattress.rpt");// visualcut
                                                                      // rpt
                                                                      // file
                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM_HT" + File.separator + "RCM_Daily_HT_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Daily_HT...");
  }

  //No longer using this report
  /*@RequestMapping(value = "/ColorGrid_Simplification_2014_2015.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
  public void colorGridSimplification_2014_2015() {
    LOGGER.info("[START] ColorGrid_Simplification_2014_2015...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Simplification_2014_2015.rpt");// visualcut
                                                                                      // rpt
                                                                                      // file
                                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "ColorGrid_Simplification" + File.separator
        + "ColorGrid_Simplification_2014_2015" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ColorGrid_Simplification_2014_2015...");
  }*/

  //No longer using this report
  /*@RequestMapping(value = "/ColorGrid_Simplification_2018.do")
  //@Scheduled(cron = "0 20 6 * * *")//Daily (6:20am)
  public void colorGridSimplification_2018() {
    LOGGER.info("[START] ColorGrid_Simplification_2018...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Simplification_2018.rpt");// visualcut
                                                                                      // rpt
                                                                                      // file
                                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "ColorGrid_Simplification" + File.separator
        + "ColorGrid_Simplification_2018" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ColorGrid_Simplification_2018...");
  }*/

  @RequestMapping(value = "/ColorGrid_Daily_2015_2006-2012_S.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void colorGridDaily_2015_2006_2012_S() {
    LOGGER.info("[START] ColorGrid_Daily_2015_2006-2012_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_2006-2012_S.rpt");// visualcut
                                                                                    // rpt
                                                                                    // file
                                                                                    // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "ColorGrid" + File.separator + "ColorGrid_Daily_2015_2006-2012_S" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ColorGrid_Daily_2015_2006-2012_S...");
  }

  @RequestMapping(value = "/ColorGrid_Daily_2015_2013-2014_S.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void colorGridDaily_2015_2013_2014_S() {
    LOGGER.info("[START] ColorGrid_Daily_2015_2013-2014_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_2013-2014_S.rpt");// visualcut
                                                                                    // rpt
                                                                                    // file
                                                                                    // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "ColorGrid" + File.separator + "ColorGrid_Daily_2015_2013-2014_S" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ColorGrid_Daily_2015_2013-2014_S...");
  }

  @RequestMapping(value = "/ColorGrid_Daily_2015_Jan_April_S.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void colorGridDaily2015JanAprilS() {
    LOGGER.info("[START] ColorGrid_Daily_2015_Jan_April_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_Jan_April_S.rpt");// visualcut
                                                                                    // rpt
                                                                                    // file
                                                                                    // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "ColorGrid" + File.separator + "ColorGrid_Daily_2015_Jan_April_S" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ColorGrid_Daily_2015_Jan_April_S...");
  }

  @RequestMapping(value = "/ColorGrid_Daily_2015_May_Dec_S.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void colorGridDaily2015MayDecS() {
    LOGGER.info("[START] ColorGrid_Daily_2015_May_Dec_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2015_May_Dec_S.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "ColorGrid" + File.separator + "ColorGrid_Daily_2015_May_Dec_S" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ColorGrid_Daily_2015_May_Dec_S...");
  }

  @RequestMapping(value = "/ColorGrid_Daily_2016_Jan_Dec_S.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void colorGridDaily2016JanDecS() {
    LOGGER.info("[START] ColorGrid_Daily_2016_Jan_Dec_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2016_Jan_Dec_S.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "ColorGrid" + File.separator + "ColorGrid_Daily_2016_Jan_Dec_S" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ColorGrid_Daily_2016_Jan_Dec_S...");
  }

  @RequestMapping(value = "/PreBSConfig.do")
  //@Scheduled(cron = "0 20 8 * * MON,WED,FRI")//Weekly (Mon, Wed, Fri) 8:24am
  public void preBSConfig() {
    LOGGER.info("[START] PreBSConfig...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PreBSConfig.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HSRaw" + File.separator + "PreHSConfig" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] PreBSConfig...");
  }

  @RequestMapping(value = "/MembershipRawData.do")
  //@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")//Weekly (Mon,Wed,Thu,Fri)
  // 8:00am
  public void membershipRawData() {
    LOGGER.info("[START] MembershipRawData...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MembershipRawData.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Membership" + File.separator + "MembershipRawData" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] MembershipRawData...");
  }

  @RequestMapping(value = "/StockBalanceListingByLocCodeRAW_CDB.do")
  //@Scheduled(cron = "0 0 4 * * MON,TUE,WED,THU,FRI")//Weekly
  // (Mon,Tue,Wed,Thu,Fri) 4:00am
  public void stockBalanceListingByLocCodeRawCdb() {
    LOGGER.info("[START] StockBalanceListingByLocCodeRAW_CDB...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/StockBalanceListingByLocCodeRAW_CDB.rpt");// visualcut
                                                                                       // rpt
                                                                                       // file
                                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP"); // parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Logistics" + File.separator + "StockBalanceListingByLocCodeRAW_CDB" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] StockBalanceListingByLocCodeRAW_CDB...");
  }

  @RequestMapping(value = "/StockBalanceListingByLocCodeRAW_DSC.do")
  //@Scheduled(cron = "0 30 3 * * *")//Daily (3:30am)
  public void stockBalanceListingByLocCodeRawDsc() {
    LOGGER.info("[START] StockBalanceListingByLocCodeRAW_DSC...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/StockBalanceListingByLocCodeRAW_DSC.rpt");// visualcut
                                                                                       // rpt
                                                                                       // file
                                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Logistics" + File.separator + "StockBalanceListingByLocCodeRAW_DSC" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] StockBalanceListingByLocCodeRAW_DSC...");
  }

  @RequestMapping(value = "/RentalAging12Month.do")
  //@Scheduled(cron = "0 0 2 * * *")//2nd day of the month (2am)
  public void RentalAging12Month() {
    LOGGER.info("[START] RentalAging12Month...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalAging12Month.rpt");// visualcut
                                                                      // rpt
                                                                      // file
                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("AgingDate", "");// parameter
    params.put("RentalStatus", "");// parameter
    params.put("OrderType", "HA");// parameter
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "HA_RentalAging12Month" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalAging12Month...");
    this.HCRentalAging12Month();
  }

  @RequestMapping(value = "/HCRentalAging12Month.do")
  //Generated after HA RentalAging12Month Report.
  public void HCRentalAging12Month() {
    LOGGER.info("[START] RentalAging12Month...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalAging12Month.rpt");// visualcut
                                                                      // rpt
                                                                      // file
                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("AgingDate", "");// parameter
    params.put("RentalStatus", "");// parameter
    params.put("OrderType", "HC");// parameter
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "HC_RentalAging12Month" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] HCRentalAging12Month...");
  }


  @RequestMapping(value = "/RentalAgingReport.do")
  //@Scheduled(cron = "0 0 3 2 * *")//2nd day of the month (3am)
  public void RentalAgingReport() {
    LOGGER.info("[START] RentalAgingReport...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalAgingReport.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("OrderType", "HA");// parameter
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "HA_RentalAgingReport" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalAgingReport...");
  }

  @RequestMapping(value = "/HCRentalAgingReport.do")
  //Generated after HA RentalAgingReport.
  public void HCRentalAgingReport() {
    LOGGER.info("[START] HCRentalAgingReport...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalAgingReport.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("OrderType", "HC");// parameter
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "HC_RentalAgingReport" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] HCRentalAgingReport...");
  }

  @RequestMapping(value = "/OutrightPlusAgingCollection_12Month.do")
  //@Scheduled(cron = "0 0 4 2 * *")//2nd day of the month (4am)
  public void OutrightPlusAgingCollection_12Month() {
    LOGGER.info("[START] OutrightPlusAgingCollection_12Month...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/OutrightPlusAgingCollection_12Month.rpt");// visualcut
                                                                                       // rpt
                                                                                       // file
                                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("AgingDate", "");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "OutrightPlusAgingCollection_12Month" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] OutrightPlusAgingCollection_12Month...");
  }

  @RequestMapping(value = "/OutrightPlusAging_12Month.do")
  //@Scheduled(cron = "0 30 4 2 * *")//2nd day of the month (4.30am)
  public void OutrightPlusAging_12Month() {
    LOGGER.info("[START] OutrightPlusAging_12Month...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/OutrightPlusAging_12Month.rpt");// visualcut
                                                                             // rpt
                                                                             // file
                                                                             // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("AgingDate", "");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "OutrightPlusAging_12Month" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] OutrightPlusAging_12Month...");
  }

  /*	Temporary Not using.
  @RequestMapping(value = "/BSReport.do")
  //@Scheduled(cron = " 0 0 3 2 * ?")//Monthly (Day 2) 3:00am
  public void bsReport() {
    LOGGER.info("[START] BSReport...");
    String[] deptCodes = { "CCS3013", "CCS3015", "CCS3016", "CCS3017", "CCS3022", "CCS3026", "CCS3031", "CCS3032",
        "CCS3035", "CCS3036", "CCS3050", "CCS3058", "CCS3062", "CCS3067", "CCS3069", "CCS3070", "CCS3073", "CCS3075",
        "CCS3079", "CCS3081", "CCS3082", "CCS3083", "CCS3085", "CCS3086", "CCS3087", "CCS3088", "CCS3089", "CCS3092",
        "CCS3094", "CCS3096", "CCS3097", "CCS3100", "CCS3102", "CCS3103", "CCS3104", "CCS3105", "CCS3106", "CCS3107",
        "CCS3109", "CCS3110", "CCS3111", "CCS3112", "CCS3113", "CCS3114", "CCS3115", "CCS3116", "CCS3117", "CCS3118",
        "CCS3119", "CCS3120", "CCS3121", "CCS3123", "CCS3124", "CCS3125", "CCS3126", "CCS3128", "CCS3129", "CCS3130",
        "CCS3131", "CCS3132", "CCS3133", "CCS3134", "CCS3135", "CCS3136", "CCS3137", "CCS3139", "CCS3140", "CCS3141",
        "CCS3142", "CCS3143", "CCS3144", "CCS3145", "CCS3147", "CCS3148", "CCS3149", "CCS3150", "CCS3151", "CCS3152",
        "CCS3153", "CCS3154", "CCS3155", "CCS3156", "CCS3157", "CCS3158", "CCS3159", "CCS3160", "CCS3161", "CCS3162",
        "CCS3163", "CCS3164", "CCS3165", "CCS3166", "CCS3167", "CCS3168", "CCS3169", "CCS3170", "CCS3171", "CCS3172",
        "CCS3173", "CCS3175", "CCS3176", "CCS3177", "CCS3178", "CCS3179", "CCS3180", "CCS3181", "CCS3182", "CCS3183",
        "CCS3184", "CCS3185", "CCS3186", "CCS3187", "CCS3189", "CCS3190", "CCS3191", "CCS3192", "CCS3194", "CCS3195",
        "CCS3196", "CCS3197", "CCS3198", "CCS3199", "CCS3200", "CCS3201", "CCS3202", "CCS3203", "CCS3204", "CCS3205",
        "CCS3206", "CCS3207", "CCS3209", "CCS3210", "CCS3211", "CCS3212", "CCS3213", "CCS3214", "CCS3215", "CCS3216",
        "CCS3217", "CCS3218", "CCS3219", "CCS3221", "CCS3222", "CCS3223", "CCS3224", "CCS3225", "CCS3226", "CCS3227",
        "CCS3228", "CCS3229", "CCS3230", "CCS3231", "CCS3232", "CCS3233", "CCS3234", "CCS3235", "CCS3236", "CCS3237",
        "CCS3238", "CCS3239", "CCS3240", "CCS3241", "CCS3242", "CCS3243", "CCS3244", "CCS3245", "CCS3246", "CCS3247",
        "CCS3248", "CCS3249", "CCS3254", "CCS3255", "CCS3256", "CCS3257", "CCS3258", "CCS3259", "CCS3260", "CCS3261",
        "CCS3262", "CCS3263" };

    for (String param : deptCodes) {
      Map<String, Object> params = new HashMap<>();
      params.put(REPORT_FILE_NAME, "/visualcut/BSReport.rpt");// visualcut rpt
                                                              // file name.
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_CODYDEPTCODE", param); // parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "HSReport" + File.separator + "HSReport" + CommonUtils.getNowDate() + "_" + param + ".xls");

      this.viewProcedure(null, null, params);
    }

    LOGGER.info("[END] BSReport...");
  }
  */

  /*
  @RequestMapping(value = "/BSReportCT.do")
  //@Scheduled(cron = " 0 0 3 2 * ?")//Monthly (Day 2) 3:00am
  public void bsReportCT() {
    LOGGER.info("[START] BSReportCT...");

    String[] ctCodes = { "CT100049", "CT100052", "CT100370", "CT100374", "CT100401", "CT100410", "CT100420", "CT100430",
        "CT100435", "CT100485", "CT100575", "CT100577", "CT100726" };

    for (String param : ctCodes) {
      Map<String, Object> params = new HashMap<>();
      params.put(REPORT_FILE_NAME, "/visualcut/BSReportCT.rpt");// visualcut rpt
                                                                // file name.
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_CTCODEASC", param);
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "HSReport" + File.separator + "HSReportCT" + CommonUtils.getNowDate() + "_" + param + ".xls");

      this.viewProcedure(null, null, params);
    }

    LOGGER.info("[END] BSReportCT...");
  }
  */

  @RequestMapping(value = "/OrderCancellationProductReturnRawData.do")
  //@Scheduled(cron = "0 0 8 * * *")//Daily (8:00am)
  public void orderCancellationProductReturn() {
    LOGGER.info("[START] OrderCancellationProductReturnRawData...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/OrderCancellationProductReturnRawData_3.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL");
    params.put("V_TEMP", "TEMP");// parameter// viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "OrderCancellationRaw_CSP" + File.separator + "OrderCancellationProductReturnRawData_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] OrderCancellationProductReturnRawData...");
  }


  @RequestMapping(value = "/RejoinNetRawData.do")
  //@Scheduled(cron = "0 0 3 * * *")//Daily (3:00am)
  public void rejoinNetRawData() {
    LOGGER.info("[START] RejoinNetRawData...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RejoinNetRaw.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.

    String dt = CommonUtils.getCalMonth(0);
    dt = dt.substring(4,6) + "/" + dt.substring(0,4);


    params.put(REPORT_VIEW_TYPE, "EXCEL");
    params.put("V_TEMP", "TEMP");// parameter// viewType
    params.put("V_GENDATE", dt);
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RejoinNetRawData" + File.separator + "RejoinNetRawData_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RejoinNetRawData...");
  }

  @RequestMapping(value = "/accumAccRenFinLease_Simplified.do")
  //@Scheduled(cron = "0 0 9 1 * *")//Monthly (8:00am)
  public void accumAccRenFinLease_Simplified() {
    LOGGER.info("[START] accumAccRenFinLease_Simplified...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PQC/AccumulatedAccRentalFinLease_Simplified_Excel.rpt");

    params.put(REPORT_VIEW_TYPE, "EXCEL");
    params.put("V_TEMP", "TEMP");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "PQC" + File.separator + "AccumulatedAccRentalFinLease_Simplified_Excel" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] accumAccRenFinLease_Simplified...");
  }

  @RequestMapping(value = "/accumAccRenOptLease_Simplified.do")
  //@Scheduled(cron = "0 30 8 1 * *")//Monthly (8:00am)
  public void accumAccRenOptLease_Simplified() {
    LOGGER.info("[START] accumAccRenOptLease_Simplified...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PQC/AccumulatedAccRentalOptLease_Simplified_Excel.rpt");

    params.put(REPORT_VIEW_TYPE, "EXCEL");
    params.put("V_TEMP", "TEMP");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "PQC" + File.separator + "AccumulatedAccRentalOptLease_Simplified_Excel" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] accumAccRenOptLease_Simplified...");
  }

  @RequestMapping(value = "/accumAccOutright_Simplified.do")
  //@Scheduled(cron = "0 0 8 1 * *")//Monthly (8:00am)
  public void accumAccOutright_Simplified() {
    LOGGER.info("[START] accumAccRenOutright_Simplified...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PQC/AccumulatedAccOutright_Simplified_Excel.rpt");

    params.put(REPORT_VIEW_TYPE, "EXCEL");
    params.put("V_TEMP", "TEMP");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "PQC" + File.separator + "AccumulatedAccOutright_Simplified_Excel" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] accumAccOutright_Simplified...");
  }

  @RequestMapping(value = "/accumAccMembership_Simplified.do")
  //@Scheduled(cron = "0 15 8 1 * *")//Monthly (8:15am)
  public void accumAccMembership_Simplified() {
    LOGGER.info("[START] accumAccMembership_Simplified...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PQC/AccumulatedAccMembership_Simplified_Excel.rpt");

    params.put(REPORT_VIEW_TYPE, "EXCEL");
    params.put("V_TEMP", "TEMP");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "PQC" + File.separator + "AccumulatedAccMembership_Simplified_Excel" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] accumAccMembership_Simplified...");
  }

  private void viewProcedure(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params) {
	this.checkArgument(params);

    SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS", Locale.getDefault(Locale.Category.FORMAT));
    Calendar startTime = Calendar.getInstance();
    Calendar endTime = null;

    String reportFile = (String) params.get(REPORT_FILE_NAME);
    String reportName = reportFilePath + reportFile;

    ReportController.ViewType viewType = ReportController.ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));
    String prodName;
    int maxLength = 0;
    String msg = "Completed";

    try {
      ReportAppSession ra = new ReportAppSession();
      ra.createService(REPORT_CLIENT_DOCUMENT);

      ra.setReportAppServer(ReportClientDocument.inprocConnectionString);
      ra.initialize();
      ReportClientDocument clientDoc = new ReportClientDocument();
      clientDoc.setReportAppServer(ra.getReportAppServer());
      clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);

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
      LOGGER.error(CommonUtils.printStackTraceToString(ex));
      maxLength = CommonUtils.printStackTraceToString(ex).length() <= 4000 ? CommonUtils.printStackTraceToString(ex).length() : 4000;

      msg = CommonUtils.printStackTraceToString(ex).substring(0, maxLength);
      throw new ApplicationException(ex);
    } finally{
      // Insert Log
      endTime = Calendar.getInstance();
      params.put("msg", msg);
      params.put("startTime", fmt.format(startTime.getTime()));
      params.put("endTime", fmt.format(endTime.getTime()));
      params.put("userId", 349);

      reportBatchService.insertLog(params);
    }
  }

  @RequestMapping(value = "/HP_OwnPurchase.do")
  //@Scheduled(cron = "0 40 4 * * *") // 매일 5시에 실행 // sample :
  // http://fmaker7.tistory.com/163
  public void hPOwnPurchase() throws IOException {
    LOGGER.info("[START] HP_OwnPurchase...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/HP_OwnPurchase.rpt");// visualcut
                                                                  // rpt file
                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance_Control" + File.separator + "HP_OwnPurchase" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] HP_OwnPurchase...");
  }

  @RequestMapping(value = "/DailyCollectionRaw.do")
  //@Scheduled(cron = "0 45 5 * * WED") // every Wednesday
  public void DailyCollectionRaw() throws IOException {
    LOGGER.info("[START] DailyCollectionRaw...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/DailyCollectionRaw.rpt");// visualcut
                                                                  // rpt file
                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance_Control" + File.separator + "DailyCollectionRaw_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] DailyCollectionRaw...");
  }

  @RequestMapping(value = "/RCM_Daily_Simplified_3.do")
  //@Scheduled(cron = "0 10 5 * * *")
  public void rcmDailySimplified_3() throws IOException {
	  LOGGER.info("[START] RCM_Daily_Simplified...");

    Map<String, Object> params = new HashMap<>();
    int startYear = 2006;
    int endYear = 2016;


      params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_Simplified_1.rpt");// visualcut
                                                                // rpt
                                                                // file
                                                                // name.
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_TEMP", "TEMP");// parameter
      params.put("V_STARTYEAR", startYear);// parameter
      params.put("V_ENDYEAR", endYear);// parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "Simplified_RCM" + File.separator + "RCM_Daily_Simplified" + startYear + "-" + endYear + "_" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);

    LOGGER.info("[END] RCM_Daily_Simplified...");
  }

  @RequestMapping(value = "/RCM_Daily_Simplified_4.do")
  //@Scheduled(cron = "0 10 5 * * *")
  public void rcmDailySimplified_4() throws IOException {
	  LOGGER.info("[START] RCM_Daily_Simplified...");

    Map<String, Object> params = new HashMap<>();
    int startYear = 2017;
    int endYear = 2018;


      params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_Simplified_1.rpt");// visualcut
                                                                // rpt
                                                                // file
                                                                // name.
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_TEMP", "TEMP");// parameter
      params.put("V_STARTYEAR", startYear);// parameter
      params.put("V_ENDYEAR", endYear);// parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "Simplified_RCM" + File.separator + "RCM_Daily_Simplified" + startYear + "-" + endYear + "_" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);

    LOGGER.info("[END] RCM_Daily_Simplified...");
  }


  @RequestMapping(value = "/RCM_Daily_Simplified_5.do")
  //@Scheduled(cron = "0 10 5 * * *")
  public void rcmDailySimplified_5() throws IOException {
	  LOGGER.info("[START] RCM_Daily_Simplified...");

    Map<String, Object> params = new HashMap<>();
    int minYear = 2019;

    for (int year = LocalDate.now().getYear(); year >= minYear; year--) {

      params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_Simplified_1.rpt");// visualcut
                                                                // rpt
                                                                // file
                                                                // name.
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_TEMP", "TEMP");// parameter
      params.put("V_STARTYEAR", year);// parameter
      params.put("V_ENDYEAR", year);// parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "Simplified_RCM" + File.separator + "RCM_Daily_Simplified" + year + "_" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);

    }

    LOGGER.info("[END] RCM_Daily_Simplified...");
  }


  @RequestMapping(value = "/MemberRawDate_Excel.do")
  //@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
  public void memberRawDateExcel() throws IOException {
    LOGGER.info("[START] MemberRawDate_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MemberRawDate_Excel.rpt");// visualcut
                                                                       // rpt
                                                                       // file
                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("MemTypeID", "1"); // parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Member" + File.separator + "MemberRawDate_Excel" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] MemberRawDate_Excel...");
  }

  @RequestMapping(value = "/CodyRawDate_Excel.do")
  //@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
  public void codyRawDateExcel() throws IOException {
    LOGGER.info("[START] CodyRawDate_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CodyRawDate_Excel.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/MemberRawDate_Excel_S.rpt");// visualcut
                                                                         // rpt
                                                                         // file
                                                                         // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/CodyRawDate_Excel_S.rpt");// visualcut
                                                                       // rpt
                                                                       // file
                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Member" + File.separator + "CodyRawDate_Excel_S" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] CodyRawDate_Excel_S...");
  }

  /* KV- SP_CR_TRAINEE_APP_RAW */
  @RequestMapping(value = "/CodyTraineeAppRaw_Excel.do")
  //@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
  public void codyTraineeAppRaw_Excel() throws IOException {
    LOGGER.info("[START] CodyTraineeAppRaw_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CodyTraineeAppRaw_Excel.rpt");// visualcut
                                                                           // rpt
                                                                           // file
                                                                           // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Member" + File.separator + "CodyTraineeAppRaw_Excel" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CodyTraineeAppRaw_Excel...");
  }

  // Requested by Homecare Department
  @RequestMapping(value = "/HTRawDate_Excel_S.do")
  //@Scheduled(cron = "0 0 8 * * MON,WED,THU,FRI")
  public void htRawDateExcelS() throws IOException {
    LOGGER.info("[START] HTRawDate_Excel_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/HTRawDate_Excel_S.rpt");// visualcut
                                                                       // rpt
                                                                       // file
                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Homecare" + File.separator + "HTRawDate_Excel_S" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] HTRawDate_Excel_S...");
  }

  @RequestMapping(value = "/CSRaw.do")
  //@Scheduled(cron = "0 40 8 * * MON,WED,FRI")
  public void csRaw() throws IOException {
    LOGGER.info("[START] csRaw...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CSRaw.rpt");// visualcut rpt
                                                                // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CSRaw" + File.separator + "CSRaw_" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] csRaw...");
  }

  @RequestMapping(value = "/CSRawPastMonth.do")
  //@Scheduled(cron = "0 40 8 * * MON,WED,FRI")
  public void CSRawPastMonth() throws IOException {
    LOGGER.info("[START] csRawPastMonth...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CSRawPastMonth.rpt");// visualcut rpt
                                                                // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CSRaw" + File.separator + "CSRawPastMonth_" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] csRawPastMonth...");
  }

  @RequestMapping(value = "/BSRawCurrent.do")
  //@Scheduled(cron = "0 20 8 * * MON,WED,FRI")
  public void bsRawCurrent() throws IOException {
    LOGGER.info("[START] BSRawCurrent...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent.rpt");// visualcut rpt
                                                                // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HSRaw" + File.separator + "HSRawCurrent" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] BSRawCurrent...");
  }

  @RequestMapping(value = "/BSRawCurrent_S1.do")
  //@Scheduled(cron = "0 20 8 * * *")
  public void bsRawCurrentS1() throws IOException {
    LOGGER.info("[START] BSRawCurrent_S1...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent_S1.rpt");// visualcut
                                                                   // rpt file
                                                                   // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HSRaw" + File.separator + "HSRawCurrent_S1" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] BSRawCurrent_S1...");
  }

  @RequestMapping(value = "/BSRawPrevious_S1.do")
  //@Scheduled(cron = "0 30 8 * * MON,WED,FRI")
  public void bsRawPreviousS1() throws IOException {
    LOGGER.info("[START] BSRawPrevious_S1...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawPrevious_S1.rpt");// visualcut
                                                                    // rpt file
                                                                    // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HSRaw" + File.separator + "HSRawPrevious_S1" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] BSRawPrevious_S1...");
  }

  @RequestMapping(value = "/BSRawCurrent_S.do")
  //@Scheduled(cron = "0 30 8 * * MON,WED,FRI")
  public void bsRawCurrentS() throws IOException {
    LOGGER.info("[START] BSRawCurrent_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent_S.rpt");// visualcut
                                                                  // rpt file
                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HSRaw" + File.separator + "HSRawCurrent_S" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] BSRawCurrent_S...");
  }

  @RequestMapping(value = "/CorpSMSList.do")
  //@Scheduled(cron = "0 0 5 * * MON")//Weekly (Mon) 5:00am
  public void corpSMSList() throws IOException {
    LOGGER.info("[START] CorpSMSList...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CorpSMSList.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CorpSMS" + File.separator + "CorpSMSList" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] CorpSMSList...");
  }

  @RequestMapping(value = "/PreMonth_ASResult.do")
  //@Scheduled(cron = " 0 0 6 15-24 * ?")//Monthly (Day from 15-24) 6:00am
  public void preMonthAsResult() throws IOException {
    LOGGER.info("[START] PreMonth_ASResult...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_ASResult.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HR" + File.separator + "PreMonth_ASResult" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] PreMonth_ASResult...");
  }

  @RequestMapping(value = "/PreMonth_Installation.do")
  //@Scheduled(cron = " 0 0 6 15-24 * ?")//Monthly (Day from 15-24) 6:00am
  public void preMonthInstallation() throws IOException {
    LOGGER.info("[START] PreMonth_Installation...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_Installation.rpt");// visualcut
                                                                         // rpt
                                                                         // file
                                                                         // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HR" + File.separator + "PreMonth_Installation" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] PreMonth_Installation...");
  }

  @RequestMapping(value = "/PreMonth_ProductReturn.do")
  //@Scheduled(cron = " 0 0 6 15-24 * ?")//Monthly (Day from 15-24) 6:00am
  public void preMonthProductReturn() throws IOException {
    LOGGER.info("[START] PreMonth_ProductReturn...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_ProductReturn.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HR" + File.separator + "PreMonth_ProductReturn" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] PreMonth_ProductReturn...");
  }

  @RequestMapping(value = "/staffPurchaseRaw.do")
  //@Scheduled(cron = " 0 0 6 10-24 * ?")//Monthly (Day from 10-24) 6:00am
  public void staffPurchaseRaw() throws IOException {
    LOGGER.info("[START] staffPurchaseRaw...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/StaffPurchaseRaw.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HR" + File.separator + "StaffPurchase_Raw" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] staffPurchaseRaw...");
  }

  @RequestMapping(value = "/staffPurchaseSVMRaw.do")
  //@Scheduled(cron = " 0 0 6 10-24 * ?")//Monthly (Day from 15-24) 6:00am
  public void staffPurchaseSVMRaw() throws IOException {
    LOGGER.info("[START] staffPurchaseSVMRaw...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/StaffPurchaseSVMRaw.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HR" + File.separator + "StaffPurchase_SVM_Raw" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] staffPurchaseSVMRaw...");
  }

  @RequestMapping(value = "/PreMonth_HS_Filter.do")
  //@Scheduled(cron = " 0 0 6 10 * ?")//Monthly (Day 10) 6:00am
  public void preMonthHsFilter() throws IOException {
    LOGGER.info("[START] PreMonth_HS_Filter...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PreMonth_HS_Filter.rpt");// visualcut
                                                                      // rpt
                                                                      // file
                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HR" + File.separator + "PreMonth_HS_Filter" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] PreMonth_HS_Filter...");
  }

  @RequestMapping(value = "/VC_CTCommission_PDF_V2.do")
  //@Scheduled(cron = " 0 5 8 25 * ?")//Monthly (Day 25) 8:05am
  public void vcCtCommissionPdfV2() throws IOException {
    LOGGER.info("[START] VC_CTCommission_PDF_V2...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/VC_CTCommission_PDF_V2.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "VC_CTCommission_PDF_V2" + CommonUtils.getNowDate() + ".pdf");

    this.view(null, null, params);
    LOGGER.info("[END] VC_CTCommission_PDF_V2...");
  }

/*  REMOVED BY CHEW KAH KIT - 20211102 - RAW DATA NOT LONGER IN USE
  @RequestMapping(value = "/RptReferralsRawData.do")
  //@Scheduled(cron = "0 35 4 * * *") // Daily (4:35am)
  public void rptReferralsRawData() throws IOException {
    LOGGER.info("[START] RptReferralsRawData...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RptReferralsRawData.rpt");// visualcut
                                                                       // rpt
                                                                       // file
                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RptReferrals" + File.separator + "RptReferralsRawData" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] RptReferralsRawData...");
  }*/

  @RequestMapping(value = "/RptRorAorBor_16th.do")
  //@Scheduled(cron = " 0 30 3 17 * ?") // Monthly (Day 17) 3:30am
  public void rptRorAorBor16th() throws IOException {
    LOGGER.info("[START] RptRorAorBor_16th...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RptRorAorBor_16th.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/RptRorAorBor_3th.rpt");// visualcut
                                                                    // rpt file
                                                                    // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/EInvoiceStatus.rpt");// visualcut
                                                                  // rpt file
                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "EInvoice" + File.separator + "EInvoiceStatus" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] EInvoiceStatus...");
  }

  @RequestMapping(value = "/CashFlowReport.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am) /*monthly - end of month
  // eg 31 @ 28 ...
  public void CashFlowReport() {
    LOGGER.info("[START] CashFlowReport...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CashFlowReport.rpt");// visualcut
                                                                  // rpt file
                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "CashFlow" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CashFlowReport...");
  }

  @RequestMapping(value = "/RentalStatusReport.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am) /*monthly - end of month
  // eg 31 @ 28 ...
  public void RentalStatusReport() {
    LOGGER.info("[START] RentalStatusReport...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalStatus.rpt");// visualcut rpt
                                                                // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "RentalStatus" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalStatusReport...");
  }

  @RequestMapping(value = "/ServiceMembershipReport.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am) /*monthly - end of month
  // eg 31 @ 28 ...
  public void ServiceMembershipReport() {
    LOGGER.info("[START] ServiceMembershipReport...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ServiceMembership.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "ServiceMembership" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ServiceMembershipReport...");
  }

  @RequestMapping(value = "/TDBalanceReport.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am) /*monthly - end of month
  // eg 31 @ 28 ...
  public void TDBalanceReport() {
    LOGGER.info("[START] TDBalanceReport...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/TDBalanceReport.rpt");// visualcut
                                                                   // rpt file
                                                                   // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "TDBalance" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] TDBalanceReport...");
  }

  @RequestMapping(value = "/RentalInstallationReport.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am) /*monthly - end of month
  // eg 31 @ 28 ...
  public void RentalInstallationReport() {
    LOGGER.info("[START] RentalInstallationReport...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalInstallDate.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "RentalStatus_InstallationDate_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalInstallationReport...");
  }

  @RequestMapping(value = "/StockRecordMonthly.do")
  //@Scheduled(cron = "0 0 5 1 * *")// Monthly - 1st of the month
  public void StockRecordMonthly() {
    LOGGER.info("[START] StockRecordMonthly...");
    Map<String, Object> params = new HashMap<>();

    // Get Last Month
    LocalDate lastMonth = LocalDate.now().minusMonths(1);
    String month = lastMonth.getMonth().toString();
    String year = String.valueOf(lastMonth.getYear());
    String rptDate = month + "_" + year;

    params.put(REPORT_FILE_NAME, "/visualcut/Stock_Record_Monthly.rpt");// visualcut
                                                                        // rpt
                                                                        // file
                                                                        // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "DSC" + File.separator + "STK_Movement_" + rptDate + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] StockRecordMonthly...");
  }

  @RequestMapping(value = "/FilterRecordMonthly.do")
  //@Scheduled(cron = "0 0 5 1 * *")// Monthly - 1st of the month
  public void FilterRecordMonthly() {
    LOGGER.info("[START] FilterRecordMonthly...");

    // Get Last Month
    LocalDate lastMonth = LocalDate.now().minusMonths(1);
    String month = lastMonth.getMonth().toString();
    String year = String.valueOf(lastMonth.getYear());
    String rptDate = month + "_" + year;

    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/Filter_Record_Monthly.rpt");// visualcut
                                                                         // rpt
                                                                         // file
                                                                         // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "DSC" + File.separator + "FLT_Movement_" + rptDate + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] FilterRecordMonthly...");
  }

  @RequestMapping(value = "/SparePartRecordMonthly.do")
  //@Scheduled(cron = "0 0 5 1 * *")// Monthly - 1st of the month
  public void SparePartRecordMonthly() {
    LOGGER.info("[START] SparePartRecordMonthly...");

    // Get Last Month
    LocalDate lastMonth = LocalDate.now().minusMonths(1);
    String month = lastMonth.getMonth().toString();
    String year = String.valueOf(lastMonth.getYear());
    String rptDate = month + "_" + year;

    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/SparePart_Record_Monthly.rpt");// visualcut
                                                                            // rpt
                                                                            // file
                                                                            // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "DSC" + File.separator + "PRT_Movement_" + rptDate + ".xls");
    this.viewProcedure(null, null, params);
    LOGGER.info("[END] SparePartRecordMonthly...");
  }

  //Not longer using this report
  /*@RequestMapping(value = "/AdminProductivityCody2.do")
  public void adminProductivityCody() throws IOException {
    LOGGER.info("[START] AdminProductivityCody2...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/AdminProductivityCody2.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "AdminProductivityCody" + File.separator + "AdminProductivityCody" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] AdminProductivityCody2...");
  }*/

  @RequestMapping(value = "/AdminProductivityPreviousMonthCody2.do")
  //@Scheduled(cron = " 0 10 9 1 * ?")//Monthly (Day 1) 5:07am
  public void adminProductivityPreviousMonthCody() throws IOException {
    LOGGER.info("[START] AdminProductivityPreviousMonthCody2...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/AdminProductivityPrevoiusMonthCody3.rpt");// visualcut
                                                                                       // rpt
                                                                                       // file
                                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "AdminProductivityPreviousMonthCody" + File.separator
        + "AdminProductivityPreviousMonthCody" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] AdminProductivityPreviousMonthCody2...");
  }

  @RequestMapping(value = "/NeoCallLogReport.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
  public void NeoCallLogReport() {
    LOGGER.info("[START] NeoCallLog...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/Neo_CallLog.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Sales Planning" + File.separator + "Neo_CallLog_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] NeoCallLog...");
  }

  @RequestMapping(value = "/MobileUsage.do")
  //@Scheduled(cron = "0 0 9 * * *")//Daily (09:00am)
  public void MobileUsageReport() {
    LOGGER.info("[START] MobileUsage...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MobileUsage_Excel.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Mobile Usage" + File.separator + "MobileUsage_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] MobileUsage...");
  }

  @RequestMapping(value = "/MobileUsageTesting.do")
  //@Scheduled(cron = "0 0 9 * * *")//Daily (09:00am)
  public void MobileUsageTestingReport() {
    LOGGER.info("[START] MobileUsageTesting...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MobileUsage_Testing_Excel.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Mobile Usage" + File.separator + "MobileUsage_Testing_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] MobileUsageTesting...");
  }

  /** Added for new RawData report - Mobile Usage Analyst by Hui Ding, 23-04-2020 **/
  @RequestMapping(value = "/MobileUsageAnalysis.do")
  //@Scheduled(cron = "0 0 9 * * *")//Daily (09:00am)
  public void MobileUsageAnalysisReport() {
    LOGGER.info("[START] MobileUsageAnalysis...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MobileUsageAnalysis_Excel.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Mobile Usage Analysis" + File.separator + "MobileUsageAnalysis_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] MobileUsageAnalysis...");
  }
  /** End for new RawData report - Mobile Usage Analyst by Hui Ding, 23-04-2020 **/

  @RequestMapping(value = "/dailyRentCollRtTrd.do")
  //@Scheduled(cron = "0 10 6 * * *")//Daily (06:10am)
  public void dailyRentCollRtTrd() throws IOException {
    LOGGER.info("[START] dailyRentCollRtTrd...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/DailyRCCollectionAnalysis_2.rpt");// visualcut
                                                                               // rpt
                                                                               // file
                                                                               // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Daily Rental Collection" + File.separator
        + "DailyRentalCollectionRateTrend" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] dailyRentCollRtTrd...");
  }

  @RequestMapping(value = "/dailyRentCollRtTrdInd.do")
  //@Scheduled(cron = "0 20 6 * * *")//Daily (06:20am)
  public void dailyRentCollRtTrdInd() throws IOException {
    LOGGER.info("[START] dailyRentCollRtTrdInd...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/DailyRCCollectionAnalysisInd.rpt");// visualcut
                                                                               // rpt
                                                                               // file
                                                                               // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Daily Rental Collection" + File.separator
        + "DailyRentalCollectionRateTrendInd" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] dailyRentCollRtTrdInd...");
  }

  @RequestMapping(value = "/dailyRentCollRtTrdCom.do")
  //@Scheduled(cron = "0 30 6 * * *")//Daily (06:30am)
  public void dailyRentCollRtTrdCom() throws IOException {
    LOGGER.info("[START] dailyRentCollRtTrdCom...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/DailyRCCollectionAnalysisCom.rpt");// visualcut
                                                                               // rpt
                                                                               // file
                                                                               // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Daily Rental Collection" + File.separator
        + "DailyRentalCollectionRateTrendCom" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] dailyRentCollRtTrdCom...");
  }

  /*KV*/
  @RequestMapping(value = "/SQLHs_and_Filter_RawDataWeekly_Excel.do")
  //@Scheduled(cron = " 0 30 0 * * MON,WED,FRI") // Weekly Mon, Wed, Fri 12:30am
  public void SQLHs_and_Filter_RawDataWeekly_Excel() throws IOException {
    LOGGER.info("[START] SQLHs_and_Filter_RawDataWeekly_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/SQLHs_and_Filter_RawData_Excel.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_IND", "0");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Monthly HS and Filter Raw Data" + File.separator + "MonthlyHSandFilter_RawDataWeekly" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] SQLHs_and_Filter_RawDataWeekly_Excel...");
  }

  /*KV*/
  @RequestMapping(value = "/SQLHs_and_Filter_RawDataMonthly_Excel.do")
  //@Scheduled(cron = " 0 0 1 1 * *") // Monthly 1st 1:00am
  public void SQLHs_and_Filter_RawDataMontly_Excel() throws IOException {
    LOGGER.info("[START] SQLHs_and_Filter_RawDataMonthly_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/SQLHs_and_Filter_RawData_Excel.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_IND", "-1");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Monthly HS and Filter Raw Data" + File.separator + "MonthlyHSandFilter_RawDataMonthly" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] SQLHs_and_Filter_RawDataMonthly_Excel...");
  }

  /* ONGHC - Generate HS Filter Changed Period Variance Data */
  @RequestMapping(value = "/FltChgPrdDiff.do")
  //@Scheduled(cron = " 0 0 2 1 * *") // Monthly 1st 2:00am
  public void FltChgPrdDiff() throws IOException {
    LOGGER.info("[START] FltChgPrdDiff...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/FltChgPrdDiff.rpt");
    params.put(REPORT_VIEW_TYPE, "EXCEL");
    params.put("V_TEMP", "TEMP");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Monthly HS and Filter Raw Data" + File.separator + "MonthlyFilterPeriodVariance" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] FltChgPrdDiff...");
  }

  /*KV-Negative Stock Balance of the Month*/
  @RequestMapping(value = "/Negative_StockB_OnMonth_Excel.do")
  //@Scheduled(cron = " 0 30 1 * * 1") // Every Monday (weekly) 01:30am
  public void Negative_StockB_OnMonth_Excel() throws IOException {
    LOGGER.info("[START] Negative_StockB_OnMonth_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/Negative_StockBalance_On_Month.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Monthly Negative Stock Balance Data" + File.separator + "Monthly_Negative_StockB" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Negative_StockB_OnMonth_Excel...");
  }

  /*ONGHC*/
  @RequestMapping(value = "/Gen_AS_Raw_CurrentMth.do")
  //@Scheduled(cron = " 0 0 8 * * *") // EVERYDAY 8AM
  public void Gen_AS_Raw_CurrentMth() throws IOException {
    LOGGER.info("[START] Gen_AS_Raw_CurrentMth_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ASRawData.rpt");// visualcut
                                                             // rpt file
                                                             // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_IND", "0"); // CURRENT MONTH
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "AS Raw Data (Daily)" + File.separator + "AS_RAW_DATA_DAILY_AS_AT_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Gen_AS_Raw_CurrentMth_Excel...");
  }

  /*ONGHC*/
  @RequestMapping(value = "/Gen_AS_Raw_PassMth.do")
  //@Scheduled(cron = " 0 30 8 * * 1") // EVERY MONDAY 8:30
  public void Gen_AS_Raw_PassMth() throws IOException {
    LOGGER.info("[START] Gen_AS_Raw_PassMth_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ASRawData.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_IND", "-2"); // PASS 2 MONTH
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "AS Raw Data (Pass Month)" + File.separator + "AS_RAW_DATA_PASSMTH_AS_AT_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Gen_AS_Raw_PassMth_Excel...");
  }

  @RequestMapping(value = "/CSP_Raw_Data_Excel.do")
  //@Scheduled(cron = "0 30 4 * * *")//Daily (3:30am)
  public void CSP_Raw_Data_Excel() {
    LOGGER.info("[START] CSP_Raw_Data_Excel...");

    Map<String, Object> params = new HashMap<>();
    int minYear = 2020;

    for (int year = LocalDate.now().getYear(); year >= minYear; year--) {
      params.put("V_YEAR", year);
      CSP_Raw_Data_Excel_Manual(params);
    }

    LOGGER.info("[END] CSP_Raw_Data_Excel...");
  }

  @RequestMapping(value = "/CSP_Raw_Data_Excel_Manual.do")
  public void CSP_Raw_Data_Excel_Manual(@RequestParam Map<String, Object> params) {
    params.put(REPORT_FILE_NAME, "/visualcut/CSPRawData.rpt");// visualcut
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_YEAR", params.get("V_YEAR").toString());// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "CSP" + File.separator + "CSP_Raw_Data_"
        + params.get("V_YEAR").toString() + "_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CSP_Raw_Data_Excel...");
  }

  @RequestMapping(value = "/HDC_Raw_Data_Excel.do")
  //@Scheduled(cron = "0 30 4 * * *")//Daily (3:30am)
  public void HDC_Raw_Data_Excel() {
    LOGGER.info("[START] HDC_Raw_Data_Excel...");

    Map<String, Object> params = new HashMap<>();
    int minYear = 2020;

    for (int year = LocalDate.now().getYear(); year >= minYear; year--) {
      params.put("V_YEAR", year);
      HDC_Raw_Data_Excel_Manual(params);
    }

    LOGGER.info("[END] HDC_Raw_Data_Excel...");
  }

  @RequestMapping(value = "/HDC_Raw_Data_Excel_Manual.do")
  public void HDC_Raw_Data_Excel_Manual(@RequestParam Map<String, Object> params) {
    params.put(REPORT_FILE_NAME, "/visualcut/HDCRawData.rpt");// visualcut
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_YEAR", params.get("V_YEAR").toString());// parameter
    params.put("V_TYPE", "HC");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "HDC" + File.separator + "HDC_Raw_Data_"
        + params.get("V_YEAR").toString() + "_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] HDC_Raw_Data_Excel_Manual...");
  }

  @RequestMapping(value = "/SST_Agreement_Raw_Data_Excel.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void SST_Agreement_Raw_Data_Excel() {
    LOGGER.info("[START] SST_Agreement_Raw_Data_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/SSTAgreementRawData.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Legal" + File.separator + "SST_Agreement_Raw_Data" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] SST_Agreement_Raw_Data_Excel...");
  }

  //No longer using this report
  /*@RequestMapping(value = "/AdminProductivitySO.do")
  public void AdminProductivitySO() throws IOException {
    LOGGER.info("[START] AdminProductivitySO...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/AdminProductivitySO.rpt");// visualcut
                                                                          // rpt
                                                                          // file
                                                                          // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "AdminProductivitySO" + File.separator + "AdminProductivitySO" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] AdminProductivitySO...");
  }*/

  @RequestMapping(value = "/AdminProductivityPreviousMonthSO.do")
  //@Scheduled(cron = " 0 40 9 1 * ?")//Monthly (Day 1) 5:07am
  public void AdminProductivityPreviousMonthSO() throws IOException {
    LOGGER.info("[START] AdminProductivityPreviousMonthSO...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/AdminProductivityPreviousMonthSO.rpt");// visualcut
                                                                                       // rpt
                                                                                       // file
                                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME, "AdminProductivityPreviousMonthSO" + File.separator
        + "AdminProductivityPreviousMonthSO" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] AdminProductivityPreviousMonthSO...");
  }

  @RequestMapping(value = "/SHI_Raw_Data_Excel.do")
  //@Scheduled(cron = "0 30 4 * * *")//Daily (4:00am)
  public void SHI_Raw_Data_Excel() {
    LOGGER.info("[START] SHI_Raw_Data_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/SHIRawData.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "SHI" + File.separator + "SHI_Raw_Data" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] SHI_Raw_Data_Excel...");
  }

  @RequestMapping(value = "/govAgreementRaw.do")
  //@Scheduled(cron = "0 0 5 * * *")//Daily (6:00am)
  public void govAgreementRaw() {
    LOGGER.info("[START] govAgreementRaw...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/sales/GovContratAgrRaw.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("v_WhereSQL","");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Legal" + File.separator + "AgreementRaw_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] govAgreementRaw...");
  }

  @RequestMapping(value = "/CustomerHealthScoreRaw_Excel.do")
  //@Scheduled(cron = " 0 0 4 26 * ?")//Monthly (Day 26) 4:00am
  public void CustomerHealthScoreRaw_Excel() {
    LOGGER.info("[START] CustomerHealthScoreRaw_Excel...");

    Map<String, Object> params = new HashMap<>();
//    int genYear = 1;
    int currentYear = LocalDate.now().getYear();

    for (int minYear = 2006; minYear <= currentYear; minYear++ ) {

      int maxYear = minYear;

      params.put("V_STARTYEAR", minYear);
      params.put("V_ENDYEAR", maxYear);

      CustomerHealthScoreRaw_Excel_Manual(params);

    }

    LOGGER.info("[END] CustomerHealthScoreRaw_Excel...");
  }



  @RequestMapping(value = "/CustomerHealthScoreRaw_Excel_Manual.do")
  public void CustomerHealthScoreRaw_Excel_Manual(@RequestParam Map<String, Object> params) {
    LOGGER.info("[START] CustomerHealthScoreRaw_Excel_Manual...");

    String startYear = params.get("V_STARTYEAR").toString();
    String endYear   = params.get("V_ENDYEAR").toString();

      params.put(REPORT_FILE_NAME, "/visualcut/CustHealthScoreRawData.rpt");
      params.put(REPORT_VIEW_TYPE, "EXCEL");
      params.put("V_TEMP", "TEMP");
      params.put("V_STARTYEAR", startYear);
      params.put("V_ENDYEAR", endYear);
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "CHS Raw Data (CPD)" + File.separator + "CustHealthScoreRawData_" + startYear + "-" + endYear + "_" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);

    LOGGER.info("[END] CustomerHealthScoreRaw_Excel_Manual...");
  }

  //Added by keyi 20211007
  @RequestMapping(value = "/CompanyCustomerHealthScoreRaw_Excel.do")
  //@Scheduled(cron = " 0 30 4 26 * ?")//Monthly (Day 26) 4:30am
  public void CompanyCustomerHealthScoreRaw_Excel() {
    LOGGER.info("[START] CompanyCustomerHealthScoreRaw_Excel...");

    Map<String, Object> params = new HashMap<>();
    int genYear = 4;
    int currentYear = LocalDate.now().getYear();

    for (int minYear = 2006; minYear <= currentYear; minYear+=(genYear+1) ) {

      int maxYear = minYear+genYear;

      params.put("V_STARTYEAR", minYear);
      params.put("V_ENDYEAR", maxYear);

      CompanyCustomerHealthScoreRaw_Excel_Manual(params);
    }

    LOGGER.info("[END] CompanyCustomerHealthScoreRaw_Excel...");
  }

  @RequestMapping(value = "/CompanyCustomerHealthScoreRaw_Excel_Manual.do")
  public void CompanyCustomerHealthScoreRaw_Excel_Manual(@RequestParam Map<String, Object> params) {
    LOGGER.info("[START] CompanyCustomerHealthScoreRaw_Excel_Manual...");

    String startYear = params.get("V_STARTYEAR").toString();
    String endYear   = params.get("V_ENDYEAR").toString();

      params.put(REPORT_FILE_NAME, "/visualcut/CompanyCustHealthScoreRawData.rpt");
      params.put(REPORT_VIEW_TYPE, "EXCEL");
      params.put("V_TEMP", "TEMP");
      params.put("V_STARTYEAR", startYear);
      params.put("V_ENDYEAR", endYear);
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "CHS Raw Data (CPD)" + File.separator + "CompCustHealthScoreRawData_" + startYear + "-" + endYear + "_" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);

    LOGGER.info("[END] CompanyCustomerHealthScoreRaw_Excel_Manual...");
  }

  @RequestMapping(value = "/RentalPaymentSettingRaw_Excel.do")
//@Scheduled(cron = "0 30 5 * * *")//Daily (5:30am)
  public void RentalPaymentSettingRaw_Excel() {
    LOGGER.info("[START] RentalPaymentSettingRaw_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalPaymentSettingRaw.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Pay Setting (ADD)" + File.separator + "Rent_Pay_Set_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalPaymentSettingRaw_Excel...");
  }

  @RequestMapping(value = "/dailyDeductionRaw.do")
  //@Scheduled(cron = "0 20 5 * * *")//Daily (5:20am)
  public void dailyDeductionRaw() {
    LOGGER.info("[START] dailyDeductionRaw...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/Daily_Deduction_Raw.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Daily Rental Collection" + File.separator + "Daily_Deduction_Raw" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] dailyDeductionRaw...");
  }

  @RequestMapping(value = "/DailyPotentialCn.do")
//@Scheduled(cron = "0 20 5 * * *")//Daily (5:20am)
  public void dailyPotentialCn() {
	LOGGER.info("[START] dailyPotentialCn...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/DailyPotentialCNList.rpt");// visualcut
                                                                        // rpt
                                                                        // file
                                                                        // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
            "Daily Rental Collection" + File.separator + "DailyPotentialCNList_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] dailyPotentialCn...");
  }


  @RequestMapping(value = "/ColorGrid_Daily.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void colorGridDaily() {
    LOGGER.info("[START] ColorGrid_Daily...");

    Map<String, Object> params = new HashMap<>();
    int minYear = 2018;

    for (int year = LocalDate.now().getYear(); year >= minYear; year--) {

      params.put("V_YEAR", year);
      colorGridDailyManual(params);
    }

    LOGGER.info("[END] ColorGrid_Daily...");
  }

  @RequestMapping(value = "/ColorGrid_Daily_Manual.do")
  public void colorGridDailyManual(@RequestParam Map<String, Object> params) {
      params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2021_Jan_Dec_S.rpt");
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_TEMP", "TEMP");// parameter
      params.put("V_YEAR", params.get("V_YEAR").toString());// parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "ColorGrid" + File.separator + "ColorGrid_Daily_"+ params.get("V_YEAR").toString() +"_Jan_Dec_S" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);
  }

  @RequestMapping(value = "/HC_ColorGrid_Daily.do")
  //@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
  public void colorGridHcDaily() {
    LOGGER.info("[START] HC_ColorGrid_Daily...");

    Map<String, Object> params = new HashMap<>();
    int minYear = 2020;

    for (int year = LocalDate.now().getYear(); year >= minYear; year--) {

      params.put("V_YEAR", year);
      colorGridHcDailyManual(params);
    }

    LOGGER.info("[END] HC_ColorGrid_Daily...");
  }

  @RequestMapping(value = "/HC_ColorGrid_Daily_Manual.do")
  public void colorGridHcDailyManual(@RequestParam Map<String, Object> params) {
      params.put(REPORT_FILE_NAME, "/visualcut/HC_ColorGrid_Daily_2021_Jan_Dec_S.rpt");
      params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
      params.put("V_TEMP", "TEMP");// parameter
      params.put("V_YEAR", params.get("V_YEAR").toString());// parameter
      params.put(AppConstants.REPORT_DOWN_FILE_NAME,
          "ColorGrid" + File.separator + "HC_ColorGrid_Daily_"+ params.get("V_YEAR").toString() +"_Jan_Dec_S" + CommonUtils.getNowDate() + ".xls");

      this.viewProcedure(null, null, params);
  }

/*  @RequestMapping(value = "/Hand_Collection_vs_Autopay_Excel.do")
  //@Scheduled(cron = " 0 0 6 1 * ?")//Monthly (Day 1) 6:00am
  public void handCollectionVsAutopay() {
    LOGGER.info("[START] Hand_Collection_vs_Autopay_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCMClosing_HandCollvsAutopay.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM" + File.separator + "RCM_Closing_HandCollvsAutopay" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Hand_Collection_vs_Autopay_Excel...");
  }*/

  @RequestMapping(value = "/Daily_BadDebtRaw.do")
  //@Scheduled(cron = "0 0 6 * * *")
  public void dailyBadDebtRaw() {
    LOGGER.info("[START] Daily_BadDebtRaw...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/DailyBadDebtRaw.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM" + File.separator + "Daily_BadDebtRaw" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Daily_BadDebtRaw...");
  }


  /*@RequestMapping(value = "/CowayDailySalesStatusHP_Adv.do")
  public void CowayDailySalesStatusHP_Adv() {
    LOGGER.info("[START] CowayDailySalesStatusHP_Adv...");
    Map<String, Object> params = new HashMap<>();
        String[] address ={"it-dept@coway.com.my",
            "nicky.lam@coway.com.my",
            "eddie.toh@coway.com.my",
            "joanne.chin@coway.com.my",
            "ivan.liew@coway.com.my",
            "lyeim@coway.com.my",
            "thomas.chin@coway.com.my",
            "rachel.wong@coway.com.my",
            "shawn.chow@coway.com.my",
            "austin@coway.com.my",
            "hod@coway.com.my"
            "<jypark30@coway.co.kr>",
            "<enough06@coway.co.kr>",
            "<rose3128@coway.co.kr>",
            "<jenux@coway.co.kr>",
            "<smhong@coway.co.kr>",
            "<yulyul@coway.co.kr>",
            "<ikchoul85@coway.co.kr>",
            "<kangsh@coway.co.kr>",
            "<hsjjang99@coway.co.kr>",
            "<jun1853@coway.co.kr>"
          };
    String email = "";
    email += "Dear All,\r\n\r\n";
    email += "Hereby is the Daily Accumulated Key-In Sales Analysis Report (HP) for your reference.\r\n\r\n";
    email +=  "Sincere Regards,\r\n";
    email +=  "IT Department";
    params.put(REPORT_FILE_NAME, "/visualcut/CowayDailySalesStatusHP_Adv.rpt");// visualcut
    params.put(EMAIL_SUBJECT, "Daily Accumulated Key-In Sales Analysis Report (HP)");
    params.put(EMAIL_TO, address);
    params.put(EMAIL_TEXT, email);
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    //params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
    params.put("v_Param", " ");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CowayDailySalesStatusHP_Adv" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CowayDailySalesStatusHP_Adv...");
  }


  @RequestMapping(value = "/CowayDailySalesStatusCody.do")
  public void CowayDailySalesStatusCody() {
    LOGGER.info("[START] CowayDailySalesStatusCody...");
    Map<String, Object> params = new HashMap<>();
    String[] address ={"it-dept@coway.com.my",
        "nicky.lam@coway.com.my",
        "eddie.toh@coway.com.my",
        "joanne.chin@coway.com.my",
        "ivan.liew@coway.com.my",
        "lyeim@coway.com.my",
        "thomas.chin@coway.com.my",
        "rachel.wong@coway.com.my",
        "shawn.chow@coway.com.my",
        "austin@coway.com.my",
        "hod@coway.com.my"
        "<jypark30@coway.co.kr>",
        "<enough06@coway.co.kr>",
        "<rose3128@coway.co.kr>",
        "<jenux@coway.co.kr>",
        "<smhong@coway.co.kr>",
        "<yulyul@coway.co.kr>",
        "<ikchoul85@coway.co.kr>",
        "<kangsh@coway.co.kr>",
        "<hsjjang99@coway.co.kr>",
        "<jun1853@coway.co.kr>"
        };
    String email = "";
    email += "Dear All,\r\n\r\n";
    email += "Hereby is the Daily Accumulated Key-In Sales Analysis Report (Cody) for your reference.\r\n\r\n";
    email +=  "Sincere Regards,\r\n";
    email +=  "IT Department";
    params.put(REPORT_FILE_NAME, "/visualcut/CowayDailySalesStatusCody.rpt");// visualcut
    params.put(EMAIL_SUBJECT, "Daily Accumulated Key-In Sales Analysis Report (Cody)");
    params.put(EMAIL_TO, address);
    params.put(EMAIL_TEXT, email);
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    //params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
    params.put("v_Param", " ");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CowayDailySalesStatusCody" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CowayDailySalesStatusCody...");
  }*/

  @RequestMapping(value = "/AutoDebitDuductionSummary.do")
   //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
  public void AutoDebitDuductionSummary() {
    LOGGER.info("[START] AutoDebitDuductionSummary...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/AutoDebitDeductionSummaryReport_PDF.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "AD Summary Report" + File.separator + "AutoDebitDeductionSummaryReport_" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] AutoDebitDuductionSummary...");
  }

  @RequestMapping(value = "/CreditCardClaimListDetails.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am)
 public void CreditCardClaimListDetails() {
   LOGGER.info("[START] CreditCardClaimListDetails...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/M1_M2_OrderDetails.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "AD Summary Report" + File.separator + "CreditCardClaimListDetails_" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] CreditCardClaimListDetails...");
 }

  @RequestMapping(value = "/TokenIdMaintenanceRaw.do")
  //@Scheduled(cron = "0 0 2 * * *")//Daily (2:00am)
 public void TokenIdMaintenanceRaw() {
   LOGGER.info("[START] TokenIdMaintenanceRaw...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/TokenIdMaintenanceRawdata_Excel.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "AD Summary Report" + File.separator + "TokenIdMaintenanceRawdata_" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] TokenIdMaintenanceRaw...");
  }
  @RequestMapping(value = "/FilterStockLogHSRuturnUsedFilterData.do")
  //@Scheduled(cron = "0 0 5 ? * MON")//5:00 a.m. every monday of the month
 public void FilterStockLogHSRuturnUsedFilterData() {
   LOGGER.info("[START] FilterStockLogHSRuturnUsedFilterData...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/FilterStockLogHSRuturnUsedFilterData.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "Monthly HS and Filter Raw Data" + File.separator + "FilterStockLogHSRuturnUsedFilterData" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] FilterStockLogHSRuturnUsedFilterData...");
 }

  @RequestMapping(value = "/FilterStockLogRawDataReq.do")
  //@Scheduled(cron = "0 0 5 ? * MON")//5:00 a.m. every monday of the month
 public void FilterStockLogRawDataReq() {
   LOGGER.info("[START] FilterStockLogRawDataReq...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/FilterStockLogRawDataReq.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "Monthly HS and Filter Raw Data" + File.separator + "FilterStockLogRawDataReq" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] FilterStockLogRawDataReq...");
 }

  @RequestMapping(value = "/FilterStockNewMemRawDataReq.do")
  //@Scheduled(cron = "0 0 5 1 * *")//1st of the Month 5:00a.m.
 public void FilterStockNewMemRawDataReq() {
   LOGGER.info("[START] FilterStockNewMemRawDataReq...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/FilterStockNewMemRawDataReq.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "Monthly HS and Filter Raw Data" + File.separator + "FilterStockNewMemRawDataReq" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] FilterStockNewMemRawDataReq...");
 }


  @RequestMapping(value = "/HSCompletedFilterRawData.do")
//@Scheduled(cron = "0 0 5 1 * *")//1st of the Month 5:00a.m.
 public void HSCompletedFilterRawData() {
   LOGGER.info("[START] HSCompletedFilterRawData...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/HSCompletedFilterRawData.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "Monthly HS and Filter Raw Data" + File.separator + "HSCompletedFilterRawData" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] HSCompletedFilterRawData...");
 }

  @RequestMapping(value = "/HSFilterForecastRawData.do")
  //@Scheduled(cron = "0 0 5 5 * *")//5th of the Month 5:00a.m.
 public void HSFilterForecastRawData() {
   LOGGER.info("[START] HSFilterForecastRawData...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/HSFilterForecastRawData.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "Monthly HS and Filter Raw Data" + File.separator + "HSFilterForecastRawData" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] HSFilterForecastRawData...");
 }

  @RequestMapping(value = "/RCM_Monthly.do")
  //@Scheduled(cron = "0 0 7 1 * ?")//Monthly (Day 1) (7:00am)
  public void rcmMonthly() {
    LOGGER.info("[START] RCM_Monthly...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Monthly.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Collection" + File.separator + "RCM_Monthly_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Monthly...");
  }

  @RequestMapping(value = "/Monthly_Rental_Collection.do")
  //@Scheduled(cron = "0 0 8 1 * ?")//Monthly (Day 1) (8:00am)
  public void MonthlyRentalCollection() {
    LOGGER.info("[START] Monthly_Rental_Collection...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MonthlyRentalCollection.rpt");// visualcut
                                                                           // rpt
                                                                           // file name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_TYPE", "SALES_GROUP");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Collection" + File.separator + "Monthly_Ren_Coll_" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Monthly_Rental_Collection...");
  }

  @RequestMapping(value = "/Monthly_Rental_Collection_HA.do")
  //@Scheduled(cron = "0 5 8 1 * ?")//Monthly (Day 1) (8:05am)
  public void MonthlyRentalCollectionHA() {
    LOGGER.info("[START] Monthly_Rental_Collection...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MonthlyRentalCollection_HA.rpt");// visualcut
                                                                           // rpt
                                                                           // file name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_TYPE", "SALES_GROUP_HA");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Collection" + File.separator + "Monthly_Ren_Coll_HA_" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Monthly_Rental_Collection HA...");
  }

  @RequestMapping(value = "/Monthly_Rental_Collection_HC.do")
  //@Scheduled(cron = "0 10 8 1 * ?")//Monthly (Day 1) (8:10am)
  public void MonthlyRentalCollectionHC() {
    LOGGER.info("[START] Monthly_Rental_Collection...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MonthlyRentalCollection_HC.rpt");// visualcut
                                                                           // rpt
                                                                           // file name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");
    params.put("V_TYPE", "SALES_GROUP_HC");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Collection" + File.separator + "Monthly_Ren_Coll_HC_" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Monthly_Rental_Collection HC...");
  }

  @RequestMapping(value = "/Monthly_Rental_Collection_SRV.do")
  //@Scheduled(cron = "0 15 8 1 * ?")//Monthly (Day 1) (8:15am)
  public void MonthlyRentalCollectionSRV() {
    LOGGER.info("[START] Monthly_Rental_Collection...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MonthlyRentalCollection_SRV.rpt");// visualcut
                                                                           // rpt
                                                                           // file name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Collection" + File.separator + "Monthly_Ren_Coll_SRV_" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Monthly_Rental_Collection SRV...");
  }

// Accumulated Operating Lease Details Other Raw Report - Added by TPY 20/07/2020 requested by Finance Department
  @RequestMapping(value = "/RentalOptLeaseDetailsOthRaw_Excel.do")
  //@Scheduled(cron = " 0 0 9 1 * ?")//Monthly (Day 1) 9:00am
  public void RentalOptLeaseDetailsOthRaw() {
    LOGGER.info("[START] RentalOptLeaseDetailsOthRaw_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalOptLeaseDetailsOthRaw_Excel.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Details Others Raw" + File.separator + "RentalOptLeaseDetailsOthRaw_" + CommonUtils.getNowDate() + ".xls");

        this.viewProcedure(null, null, params);
        LOGGER.info("[END] RentalOptLeaseDetailsOthRaw_Excel...");
  }

// Accumulated Finance Lease Details Other Raw Report - Added by TPY 20/07/2020 requested by Finance Department
  @RequestMapping(value = "/RentalFinLeaseDetailsOthRaw_Excel.do")
  //@Scheduled(cron = " 0 0 9 1 * ?")//Monthly (Day 1) 9:00am
  public void RentalFinLeaseDetailsOthRaw() {
    LOGGER.info("[START] RentalFinLeaseDetailsOthRaw_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RentalFinLeaseDetailsOthRaw_Excel.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Details Others Raw" + File.separator + "RentalFinLeaseDetailsOthRaw_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalFinLeaseDetailsOthRaw_Excel...");
  }

// GENERATION TIME : 09 00 START
  @RequestMapping(value = "/ProductReturn3MBlockList.do")
  //@Scheduled(cron = "0 0 9 * * *")//Daily (09:00am)
  public void ProductReturn3MBlockList() {
    LOGGER.info("[START] ProductReturn3MBlockList...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ProductReturn3MBlockList_Excel.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Compliance" + File.separator + "ProductReturn3MBlockList_Excel_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] ProductReturn3MBlockList...");
  }
// GENERATION TIME :　09 00 END

// GENERATION TIME : 23 45 START
  //Coway Mall SFTP file
 @RequestMapping(value = "/agentData_raw.do")
 //@Scheduled(cron = " 0 45 23 * * ?")//Daily 11:45pm
 public void agentData_raw() throws IOException {
   LOGGER.info("[START] agentData_raw...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/E_MALL_AGENT_INFO.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME, "e-mall" + File.separator + "agent_data" + ".xls");

   this.view(null, null, params);
   LOGGER.info("[END] agentData_raw...");
 }

 @RequestMapping(value = "/magicAddress_raw.do")
 //@Scheduled(cron = " 0 45 23 * * ?")//Daily 11:45pm
 public void magicAddress_raw() throws IOException {
   LOGGER.info("[START] magicAddress_raw...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/E_MALL_MAGIC_ADDRESS.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,  "e-mall" + File.separator + "magic_address.xls");

   this.view(null, null, params);
   LOGGER.info("[END] magicAddress_raw...");
 }
//GENERATION TIME : 23 45 END

 @RequestMapping(value = "/agingMonthRentalCollection.do")
 //@Scheduled(cron = " 0 0 12 * * ?")//Daily 12:00pm
 public void agingMonthRentalCollection() throws IOException {
   LOGGER.info("[START] agingMonthRentalCollection...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/AgingMonthRentalCollection.rpt");// visualcut
                                                                                 // rpt
                                                                                 // file
                                                                                 // name.
   params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Daily Rental Collection" + File.separator
	        + "AG4-6 monitoring report_" + CommonUtils.getNowDate() + ".pdf");

   this.view(null, null, params);
   LOGGER.info("[END] agingMonthRentalCollection...");
 }

 @RequestMapping(value = "/rentalStusReport.do")
 //@Scheduled(cron = " 0 0 9 * * ?")//Daily 9:00am
 public void rentalStusReport() throws IOException {
   LOGGER.info("[START] rentalStusReport...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/RentalStusReport.rpt");
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Daily Rental Collection" + File.separator
          + "Rental Status Report_" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] rentalStusReport...");
 }
//GENERATION TIME : 12 00 END

 @RequestMapping(value = "/accuDeductRawToken.do")
 //@Scheduled(cron = " 0 0 9 * * ?")//Daily 9:00am
 public void accuDeductRawToken() throws IOException {
   LOGGER.info("[START] accuDeductRawToken...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/AccumulativeDeductionResultRaw_TokenID.rpt");
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Daily Rental Collection" + File.separator
          + "Accumulative Deduction Result Raw (Token ID)_" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] accuDeductRawToken...");
 }

 @RequestMapping(value = "/accuDeductRawOrder.do")
 //@Scheduled(cron = " 0 0 9 * * ?")//Daily 9:00am
 public void accuDeductRawOrder() throws IOException {
   LOGGER.info("[START] accuDeductRawToken...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/AccumulativeDeductionResultRaw_OrderNo.rpt");
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME, "Daily Rental Collection" + File.separator
          + "Accumulative Deduction Result Raw (Order No)_" + CommonUtils.getNowDate() + ".xls");

   this.viewProcedure(null, null, params);
   LOGGER.info("[END] accuDeductRawToken...");
 }

 // Celeste: Account Health Index Raw Data (No need to set CRON ; manual job)
 @RequestMapping(value = "/accHealthIndexRawData.do")
 public void AccountHealthIndexRawData() throws IOException{
   LOGGER.info("[START] Account_Health_Index_Raw_Data...");
   Map<String, Object> params = new HashMap<>();
   params.put(REPORT_FILE_NAME, "/visualcut/AccHealthIndexRawData_Excel.rpt");// visualcut
   params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
   params.put("V_TEMP", "TEMP");// parameter
   params.put(AppConstants.REPORT_DOWN_FILE_NAME,
       "Rental Collection" + File.separator + "Account_Health_Index_Raw_Data_" + CommonUtils.getNowDate() + ".xls");

   this.view(null, null, params);
   LOGGER.info("[END] Account_Health_Index_Raw_Data...");
 }

//Celeste: Account Health Index Report (No need to set CRON ; manual job)
@RequestMapping(value = "/accHealthIndexReport.do")
public void AccountHealthIndexReport() throws IOException{
 LOGGER.info("[START] Account_Health_Index_Report...");
 Map<String, Object> params = new HashMap<>();
 params.put(REPORT_FILE_NAME, "/visualcut/AccHealthIndexReport_Excel.rpt");// visualcut
 params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
 params.put("V_TEMP", "TEMP");// parameter
 params.put(AppConstants.REPORT_DOWN_FILE_NAME,
     "Rental Collection" + File.separator + "Account_Health_Index_Report_" + CommonUtils.getNowDate() + ".xls");

 this.view(null, null, params);
 LOGGER.info("[END] Account_Health_Index_Report...");
}

//Celeste: Weekly Rental Accumulated Account Report (Every Friday Morning 9:00 AM)
@RequestMapping(value = "/weeklyRentalAccumulatedAccReportPDF.do")
//@Scheduled(cron = " 0 0 9 * * FRI") //Every Friday Morning 9:00 AM
public void WeeklyRentalAccumulatedAccReportPDF() throws IOException{
LOGGER.info("[START] WeeklyRentalAccumulatedAccReportPDF...");
Map<String, Object> params = new HashMap<>();
params.put(REPORT_FILE_NAME, "/visualcut/WeeklyRentalAccumulatedAccReportPDF.rpt");// visualcut
params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
params.put(AppConstants.REPORT_DOWN_FILE_NAME,
   "Finance_PNC" + File.separator + "WKLY_REN_ACMLT_ACC_" + CommonUtils.getNowDate() + ".pdf");

this.view(null, null, params);
LOGGER.info("[END] WeeklyRentalAccumulatedAccReportPDF...");
}

@RequestMapping(value = "/CTDutyAllowanceMonthly.do")
//@Scheduled(cron = " 0 0 2 13 * ?")//Monthly (Day 8) 2:00am
public void CTDutyAllowanceMonthly() {
  LOGGER.info("[START] CTDutyAllowanceMonthly...");
  Map<String, Object> params = new HashMap<>();

  // Get Last Month
  //.minusMonths(1)
  LocalDate lastMonth = LocalDate.now();
  String month = lastMonth.getMonth().toString();
  String year = String.valueOf(lastMonth.getYear());
  String rptDate = month + "_" + year;

  params.put(REPORT_FILE_NAME, "/visualcut/CT_Duty_Allowance_Excel.rpt");// visualcut
                                                                      // rpt
                                                                      // file
                                                                      // name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("v_WhereSQL", null);// parameter
  params.put("v_OrderBySQL", null);// parameter
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, "CT" + File.separator + "Duty_Allowance_" + rptDate + ".xls");

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] CTDutyAllowanceMonthly...");
}

@RequestMapping(value = "/DataMartReportScheduler.do")
//@Scheduled(cron = " 0 0 1 1 * ?")//Monthly (Day 1) 1:00am
public void dataMartReportScheduler() {
	dataMartReport(null);
}

@RequestMapping(value = "/rentalAgreementRaw.do")
//@Scheduled(cron = "0 0 5 * * *")//Daily (6:00am)
public void rentalAgreementRaw() {
  LOGGER.info("[START] rentalAgreementRaw...");
  Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/sales/RentalAgrRaw.rpt");// visualcut
                                                                                // rpt
                                                                                // file
                                                                                // name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("v_WhereSQL","");
  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
      "Legal" + File.separator + "RentalAgreementRaw_" + CommonUtils.getNowDate() + ".xls");

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] rentalAgreementRaw...");
}

@RequestMapping(value = "/AD_RCM_Daily_HA_2017_2018.do")
//@Scheduled(cron = "0 0 8 * * *")//Daily (8:00am)
public void adRcmDaily2017t2018() {

    LOGGER.info("[START] AD_RCM_Daily_HA_2017_2018...");
    Map<String, Object> params = new HashMap<>();

    int startYear = 2017;
    int endYear = 2018;

    params.put(REPORT_FILE_NAME, "/visualcut/AD_RCM_Daily_HA.rpt");// visualcut
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_STARTYEAR", startYear);// parameter
    params.put("V_ENDYEAR", endYear);// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Simplified_RCM" + File.separator + "AD_RCM_Daily_HA_2017_2018_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] AD_RCM_Daily_HA_2017_2018...");
}

@RequestMapping(value = "/AD_RCM_Daily_HA_Current_Year.do")
//@Scheduled(cron = "0 0 8 * * *")//Daily (8:00am)
public void adRcmDailyCurrentYear() {

  int startYear = 2019;
  int currentYear = LocalDate.now().getYear();

  for(int year= startYear;year <= currentYear; year++){
    LOGGER.info("[START] AD_RCM_Daily_HA_Current_Year...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/AD_RCM_Daily_HA.rpt");// visualcut
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_STARTYEAR", year);// parameter
    params.put("V_ENDYEAR", "");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Simplified_RCM" + File.separator + "AD_RCM_Daily_HA_" + year + "_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] AD_RCM_Daily_HA_Current_Year...");
  }
}

@RequestMapping(value = "/AD_RCM_Daily_HC_2020_2023.do")
//@Scheduled(cron = "0 0 8 * * *")//Daily (8:00am)
public void adRcmDailyHc2020t2023() {

  LOGGER.info("[START] AD_RCM_Daily_HC_2020_2023...");
  Map<String, Object> params = new HashMap<>();

  int startYear = 2020;
  int endYear = 2023;

  params.put(REPORT_FILE_NAME, "/visualcut/AD_RCM_Daily_HC.rpt");// visualcut
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter
  params.put("V_STARTYEAR", startYear);// parameter
  params.put("V_ENDYEAR", endYear);// parameter
  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
      "Simplified_RCM" + File.separator + "AD_RCM_Daily_HC_2020_2023_" + CommonUtils.getNowDate() + ".xls");

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] AD_RCM_Daily_HC_2020_2023...");
}


@RequestMapping(value = "/etrSummaryList.do")
//@Scheduled(cron = " 0 0 6 1 * FRI") //Every Friday Morning 6:00 AM
public void etrSummaryList() {
LOGGER.info("[START] etrSummaryList...");
Map<String, Object> params = new HashMap<>();
params.put(REPORT_FILE_NAME, "/visualcut/ETRReportSummary.rpt");
// visualcut
// rpt
// file
// name.
params.put("V_TEMP", "");// parameter
params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
params.put(AppConstants.REPORT_DOWN_FILE_NAME,
  "Daily Rental Collection" + File.separator + "ETR Summary List_" + CommonUtils.getNowDate() + ".xls");


this.viewProcedure(null, null, params);
LOGGER.info("[END] etrSummaryList...");
}

/*@RequestMapping(value="/attendanceRaw.do")
//@Scheduled(cron = "0 0 0 * * *")
public void attendanceRaw() throws ParseException, IOException {
	Map<String, Object> params = new HashMap();
	params.put("memCode", "ALL");
	String date = new SimpleDateFormat("yyyyMM").format(new Date());
	params.put("calMonthYear", date);
	List<String> cols = Arrays.asList("date", "time", "day", "location", "orgCode", "grpCode", "deptCode", "hpCode", "hpType", "QR - A0001", "Public Holiday - A0002", "State Holiday - A0003", "RFA - A0004", "Waived - A0005", "late");
	XSSFWorkbook wb1 = this.genExcel(new Gson().fromJson(attendanceService.getAttendanceRaw(params), new TypeToken<List<Map<String, Object>>>() {}.getType()), cols);
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.MONTH, -1);
	Date date2 = cal.getTime();
	params.put("calMonthYear", new SimpleDateFormat("yyyyMM").format(date2));



	XSSFWorkbook wb2 = this.genExcel(new Gson().fromJson(attendanceService.getAttendanceRaw(params), new TypeToken<List<Map<String, Object>>>() {}.getType()), cols);
	File raw = new File(uploadDirWeb + "/RawData/Privacy/Attendance" + File.separator + "AttendanceRaw_" + date + "_" + CommonUtils.getNowDate() + ".xlsx");
	raw.getParentFile().mkdirs();
	raw.createNewFile();
	wb1.write(new FileOutputStream(raw, false));
	File raw2 = new File(uploadDirWeb + "/RawData/Privacy/Attendance" + File.separator + "AttendanceRaw_" + new SimpleDateFormat("yyyyMM").format(date2) + "_" + CommonUtils.getNowDate() + ".xlsx");
	raw2.getParentFile().mkdirs();
	raw2.createNewFile();
	wb2.write(new FileOutputStream(raw2, false));


	Calendar cal2 = Calendar.getInstance();
	cal2.add(Calendar.MONTH, -2);
	Date date3 = cal2.getTime();
	params.put("calMonthYear", new SimpleDateFormat("yyyyMM").format(date3));
	XSSFWorkbook wb3 = this.genExcel(new Gson().fromJson(attendanceService.getAttendanceRaw(params), new TypeToken<List<Map<String, Object>>>() {}.getType()), cols);
	File raw3 = new File(uploadDirWeb + "/RawData/Privacy/Attendance" + File.separator + "AttendanceRaw_" + new SimpleDateFormat("yyyyMM").format(date3) + "_" + CommonUtils.getNowDate() + ".xlsx");
	raw3.getParentFile().mkdirs();
	raw3.createNewFile();
	wb3.write(new FileOutputStream(raw3, false));
}
*/


private XSSFWorkbook genExcel(List<Map<String, Object>> datas, List<String> cols) {
	XSSFWorkbook wb = new XSSFWorkbook();
	XSSFSheet sheet = wb.createSheet("Sheet1");
	int rowIndex = 1;
	Row mainRow = sheet.createRow(0);
	int mainColIndex = 0;
	for (String col : cols) {
		Cell mainCol = mainRow.createCell(mainColIndex);
		String title = col;
		mainCol.setCellValue(title);
		mainColIndex += 1;
	}
	for (Map<String, Object> data : datas) {
		Row row = sheet.createRow(rowIndex);
		int colIndex = 0;
		for (String col : cols) {
			Cell rowCell = row.createCell(colIndex);
			rowCell.setCellValue(data.get(col) == null ? "" : data.get(col).toString());
			colIndex += 1;
		}
		rowIndex += 1;
	}
	return wb;
}

@RequestMapping(value = "/DataMartReport.do")
public void dataMartReport(HttpServletRequest request) {
  LOGGER.info("[START] DataMartReport...");

  String nameParam =  "";
  if(request != null){
	  if(request.getParameter("name") != null && !request.getParameter("name").isEmpty()){
		  nameParam =  request.getParameter("name").toString().toUpperCase();
	  }
  }
  Map<String, Object> params = new HashMap<>();

  if(nameParam != null && nameParam != ""){
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	  	      "DataMart" + File.separator + nameParam +  File.separator + "PUBLIC_" + nameParam + CommonUtils.getNowDate() + ".csv"); //directory/filename

	  switch(nameParam){
	  	case "CLAIM":
    	  		params.put(REPORT_FILE_NAME, "/sales/DataMartClaimData.rpt");
    	  		this.viewProcedure(null, null, params);
			break;
	  	case "CUSTOMER":
    	  		params.put(REPORT_FILE_NAME, "/sales/DataMartCustData.rpt");
    	  		this.viewProcedure(null, null, params);
			break;
	  	case "PRODUCT":
    	  		params.put(REPORT_FILE_NAME, "/sales/DataMartProductData.rpt");
    	  		this.viewProcedure(null, null, params);
			break;
	  	case "MEMBER":
    	  		params.put(REPORT_FILE_NAME, "/sales/DataMartMemberData.rpt");
    	  		this.viewProcedure(null, null, params);
			break;
	  	case "ORDER":
    	  		params.put(REPORT_FILE_NAME, "/sales/DataMartOrderData.rpt");
    	  		this.viewProcedure(null, null, params);
			break;
	  	case "ACCUMACC":
    	  		params.put(REPORT_FILE_NAME, "/sales/DataMartAccumAccData.rpt");
    	  		this.viewProcedure(null, null, params);
    	  	break;
	  	case "NETSALES":
    	  		params.put(REPORT_FILE_NAME, "/sales/DataMartNetSalesData.rpt");
    	  		this.viewProcedure(null, null, params);
	  		break;
	  }
  }
  else{
/*	  //PART 1
	  params = new HashMap<>();
	  params.put(REPORT_FILE_NAME, "/sales/DataMartClaimData.rpt");// sales rpt file name
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	      "DataMart" + File.separator + "CLAIM" +  File.separator + "PUBLIC_CLAIM" + CommonUtils.getNowDate() + ".csv"); //directory/filename
	  this.viewProcedure(null, null, params);

	  //PART 2
	  params = new HashMap<>();
	  params.put(REPORT_FILE_NAME, "/sales/DataMartCustData.rpt");// sales rpt file name
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	      "DataMart" + File.separator + "CUSTOMER" +  File.separator + "PUBLIC_CUSTOMER" + CommonUtils.getNowDate() + ".csv"); //directory/filename
	  this.viewProcedure(null, null, params);*/

	  //PART 3
	  params = new HashMap<>();
	  params.put(REPORT_FILE_NAME, "/sales/DataMartProductData.rpt");// sales rpt file name
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	      "DataMart" + File.separator + "PRODUCT" +  File.separator + "PUBLIC_PRODUCT" + CommonUtils.getNowDate() + ".csv"); //directory/filename
	  this.viewProcedure(null, null, params);

	  //PART 4
	  params = new HashMap<>();
	  params.put(REPORT_FILE_NAME, "/sales/DataMartMemberData.rpt");// sales rpt file name
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	      "DataMart" + File.separator + "MEMBER" +  File.separator + "PUBLIC_MEMBER" + CommonUtils.getNowDate() + ".csv"); //directory/filename
	  this.viewProcedure(null, null, params);

/*	  //PART 5
	  params = new HashMap<>();
	  params.put(REPORT_FILE_NAME, "/sales/DataMartOrderData.rpt");// sales rpt file name
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	      "DataMart" + File.separator + "ORDER" +  File.separator + "PUBLIC_ORDER" + CommonUtils.getNowDate() + ".csv"); //directory/filename
	  this.viewProcedure(null, null, params);

	  //PART 6
	  params = new HashMap<>();
	  params.put(REPORT_FILE_NAME, "/sales/DataMartNetSalesData.rpt");// sales rpt file name
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	      "DataMart" + File.separator + "NET_SALES" +  File.separator + "PUBLIC_NET_SALES" + CommonUtils.getNowDate() + ".csv"); //directory/filename
	  this.viewProcedure(null, null, params);

	  //PART 7
	  params = new HashMap<>();
	  params.put(REPORT_FILE_NAME, "/sales/DataMartAccumAccData.rpt");// sales rpt file name
	  params.put(REPORT_VIEW_TYPE, "GENERAL_CSV"); // viewType
	  params.put("isGeneral", "true"); // to be use for general type path define
	  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
	      "DataMart" + File.separator + "ACCUMULATED_ACCOUNT" +  File.separator + "PUBLIC_ACCUMULATED_ACCOUNT" + CommonUtils.getNowDate() + ".csv"); //directory/filename
	  this.viewProcedure(null, null, params);*/
  }
  LOGGER.info("[END] DataMartReport...");
}

@RequestMapping(value = "/InboundGenPdf.do")
//@Scheduled(cron = "0 05 0 * * *")//Daily (12:05am)
public void InboundGenPdf1() throws Exception {
LOGGER.info("[START] InboundGenPdf...");
ObjectMapper mapper = new ObjectMapper();
Map<String, Object> params = new HashMap<String, Object>();
List<Map<String, Object>> emailListToSend = chatbotInboundApiService.getGenPdfList(params);

if(emailListToSend.size() > 0){
	for(int i =0;i<emailListToSend.size();i++)
	{
		Map<String, Object> info = emailListToSend.get(i);
		Map<String, Object> pdfMap = new HashMap<>();
        pdfMap.put(REPORT_FILE_NAME, info.get("rptName").toString());// visualcut// rpt// file name.
        pdfMap.put(REPORT_VIEW_TYPE, "PDF"); // viewType

        if(!CommonUtils.nvl(info.get("rptParams")).equals("")){
			try {
				Map<String, Object> additionalParam = mapper.readValue(info.get("rptParams").toString(),Map.class);
				pdfMap.putAll(additionalParam);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }

        pdfMap.put(AppConstants.REPORT_DOWN_FILE_NAME,
                "/Chatbot Inbound" + File.separator + info.get("fileName").toString());//pdf
        this.viewProcedure(null, null, pdfMap);

		info.putAll(pdfMap);
		chatbotInboundApiService.update_chatbot(info);
	}
}
LOGGER.info("[END] InboundGenPdf...");
}

@RequestMapping(value = "/superCrazyOrderRaw.do")
//@Scheduled(cron = "0 0 3 2 * *")//Monthly 2nd of the month (3:00am)
public void superCrazyOrderRaw() {
  LOGGER.info("[START] superCrazyOrderRaw...");
  // Get Last Month
  LocalDate lastMonth = LocalDate.now().minusMonths(1);
  String month = lastMonth.getMonth().toString();
  String year = String.valueOf(lastMonth.getYear());
  String rptDate = month + "_" + year;

  Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/sales/superCrazyOrderRawData_Excel.rpt");

  params.put(REPORT_VIEW_TYPE, "EXCEL");
  params.put("V_TEMP", "TEMP");
  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
      "superCrazyRawData" + File.separator + "Super Crazy Discount Entitlement Raw_" + rptDate + ".xls");

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] superCrazyOrderRaw...");
}

/** Added for new MD report - Sales Analysis Key In Report by Hui Ding, 05/01/2024 **/
@RequestMapping(value = "/salesAnalysisReport.do")
//@Scheduled(cron = "0 30 6 * * *")//Daily (06:30am)
public void SalesAnalystReport() {

List<String> fileName = new ArrayList<String>();
String fileNm = "";

  LOGGER.info("[START] SalesAnalysisKeyInDST...");
  Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisKeyInDST.rpt");// visualcut rpt
                                                             // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter

  fileNm = "MDReport/SalesAnalysisKeyInDST" + File.separator + "Key-in by DST (HP)_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisKeyInDST...");

  params = new HashMap<>();

  LOGGER.info("[START] SalesAnalysisKeyInCL...");
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisKeyInCL.rpt");// visualcut rpt
                                                             // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter

  fileNm = "MDReport/SalesAnalysisKeyInCL" + File.separator + "Key-in by CL (CD)_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisKeyInCL...");

  params = new HashMap<>();

  LOGGER.info("[START] SalesAnalysisKeyInCatDST...");
 // Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisKeyInCatDST.rpt");// visualcut rpt
                                                             // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter
  fileNm = "MDReport/SalesAnalysisKeyInCatDST" + File.separator + "Key-in by DST (HP) with product categories_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisKeyInCatDST...");

  params = new HashMap<>();

  LOGGER.info("[START] SalesAnalysisKeyInCatCL...");
 // Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisKeyInCatCL.rpt");// visualcut rpt
                                                             // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter

  fileNm = "MDReport/SalesAnalysisKeyInCatCL" + File.separator + "Key-in by CL (CD) with product categories_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisKeyInCatCL...");

  params = new HashMap<>();

  LOGGER.info("[START] SalesAnalysisNetDST...");
  //Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisNetDST.rpt");// visualcut rpt
                                                             // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter

  fileNm = "MDReport/SalesAnalysisNetDST" + File.separator + "Net Sales by DST (HP)_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisNetDST...");


  params = new HashMap<>();

  LOGGER.info("[START] SalesAnalysisNetCL...");
  //Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisNetCL.rpt");// visualcut rpt
                                                             // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter
  fileNm = "MDReport/SalesAnalysisNetCL" + File.separator + "Net Sales by CL (CD)_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisNetCL...");



  params = new HashMap<>();

  LOGGER.info("[START] SalesAnalysisNetCatDST...");
 // Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisNetCatDST.rpt");// visualcut rpt
                                                           // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter

  fileNm = "MDReport/SalesAnalysisNetCatDST" + File.separator + "Net Sales by DST (HP) with product categories_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisNetCatDST...");


  params = new HashMap<>();

  LOGGER.info("[START] SalesAnalysisNetCatCL...");
 // Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/SalesAnalysisNetCatCL.rpt");// visualcut rpt
                                                           // file name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TEMP", "TEMP");// parameter

  fileNm = "MDReport/SalesAnalysisNetCatCL" + File.separator + "Net Sales by CL (CD) with product categories_" + CommonUtils.getNowDate() + ".xls";
  fileName.add(fileNm);
  params.put(AppConstants.REPORT_DOWN_FILE_NAME, fileNm);

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] SalesAnalysisNetCatCL...");


  // file location
  String fileLocPath = uploadDirWeb + "/RawData/Public/";
  String fNameList = "";

  if (fileName != null && fileName.size() > 0){
	  LOGGER.info("fileName:-------------" + fileName.size());
	  for (int i = 0; i < fileName.size(); i++) {
		  if (i == fileName.size()-1) {
			  fNameList += fileLocPath + fileName.get(i);
		  } else {
			  fNameList += fileLocPath + fileName.get(i) + "///";
		  }
	  }
  }
  // insert batch email table
  int mailIDNextVal = voucherMapper.getBatchEmailNextVal();

  Map<String,Object> emailDet = new HashMap<String, Object>();
  		emailDet.put("mailId", mailIDNextVal);
      emailDet.put("emailType",AppConstants.EMAIL_TYPE_NORMAL);
      emailDet.put("attachment", fNameList);
      emailDet.put("categoryId", 2);
      emailDet.put("emailParams", "Dear, <br /><br />Good day<br /><br />Kindly refer to the attached files as the daily Sales Analysis Report for "
    		  									+ CommonUtils.getNowDate() + "<br /><br />Thank you. <br /><br />Regards,<br />Coway (Malaysia) Sdn Bhd");
       emailDet.put("email", "luis.jeong@coway.com.my;dennis.ko@coway.com.my;jack@coway.com.my;itsd@coway.com.my;planning@coway.com.my");
      //emailDet.put("email", "huiding.teoh@coway.com.my");
        emailDet.put("emailSentStus", 1);
        emailDet.put("name", "");
        emailDet.put("userId", 349);
        emailDet.put("emailSubject", "DAILY SALES ANALYSIS REPORT");

    	voucherMapper.insertBatchEmailSender(emailDet);

}

/** End for new MD report - Sales Analysis Key In Report by Hui Ding, 05/01/2024 **/

@RequestMapping(value = "/HpCommissionMonthlyData.do")
//@Scheduled(cron = "0 0 6 16 * ?")//6:00 a.m. 16th of the month
public void HpCommissionMonthlyData() {
  LOGGER.info("[START] HpCommissionMonthlyData...");
  int taskIDConf = this.calculateTaskId();
  Map<String, Object> params = new HashMap<>();
  params.put(REPORT_FILE_NAME, "/visualcut/HpCommisionRawdata_Excel.rpt");// visualcut
                                                                   // rpt file
                                                                   // name.
  params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
  params.put("V_TASKID", taskIDConf);
  params.put("V_TEMP", "TEMP");// parameter
  params.put(AppConstants.REPORT_DOWN_FILE_NAME,
      "Finance" + File.separator + "HpCommissionMonthlyData_" + CommonUtils.getNowDate() + ".xls");

  this.viewProcedure(null, null, params);
  LOGGER.info("[END] HpCommissionMonthlyDataReport...");
}

@RequestMapping(value = "/CodyCommissionMonthlyData.do")
//@Scheduled(cron = "0 0 6 16 * ?")//6:00 a.m. 16th of the month
public void CodyCommissionMonthlyData() {
LOGGER.info("[START] CodyCommissionMonthlyData...");
int taskIDConf = this.calculateTaskId();
Map<String, Object> params = new HashMap<>();
params.put(REPORT_FILE_NAME, "/visualcut/CodyCommisionRawdata_Excel.rpt");// visualcut
                                                                           // rpt
                                                                           // file
																			   //name.
params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
params.put("V_TASKID", taskIDConf);
params.put("V_TEMP", "TEMP");// parameter
params.put(AppConstants.REPORT_DOWN_FILE_NAME,
		"Finance" + File.separator + "CodyCommisionRawdata_" + CommonUtils.getNowDate() + ".xls");

this.viewProcedure(null, null, params);
LOGGER.info("[END] CodyCommissionMonthlyData...");
}

//[Ticket No: MY-1484] Add by Fannie - 24022025, for enhancement mobile Auto Debit Authorization (e-Notification) PDF
@RequestMapping(value = "/batchAutoDebitAuthorization.do")
//@Scheduled(cron = " 0 0 2 * * *") // EVERYDAY 2AM
public void batchAutoDebitAuthorization(){
	LOGGER.info("[START] batchAutoDebitAuthorization...");
	Map<String, Object> params = new HashMap<>();
	List<EgovMap> emailListToSend = autoDebitMapper.getPendingEmailSendInfo();
    boolean isAutoDebitAuthorization = false;

	if(emailListToSend.size() > 0){
		for(int i =0;i<emailListToSend.size();i++)
		{
			params.put(REPORT_FILE_NAME,  "/payment/AutoDebitAuthorization.rpt");
			params.put(REPORT_VIEW_TYPE, "PDF");
			params.put("V_WHERESQL", " AND EMAIL_IND = 'N' AND p0333m.PAD_ID ='" +emailListToSend.get(i).get("padId").toString()+"'");
		    String downFileName = "/" +emailListToSend.get(i).get("padId").toString() +"_" +"AutoDebitAuthorisationForm_"+ CommonUtils.getNowDate() + ".pdf";
	        params.put(AppConstants.REPORT_DOWN_FILE_NAME,  downFileName);
	        params.put("isAutoDebitAuthorization", "true");
	        this.viewProcedure(null, null, params);
		}
	}
	LOGGER.info("[END] batchAutoDebitAuthorization...");
}

// New report for e-Invoice Self Bill - HP
@RequestMapping(value = "/eInvoiceSelfBillHP.do")
//@Scheduled(cron = "0 0 6 16 * ?")//6:00 a.m. 16th of the month
public void eInvoiceSelfBillHP() {
    LOGGER.info("[START] eInvoiceSelfBillHP...");
    int taskIDConf = this.calculateTaskId();
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/eInvoiceSelfBillHP.rpt");// visualcut
                                                                             // rpt
                                                                             // file
    																			   //name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TASKID", taskIDConf);
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
    		"e-Invoice Self Bill" + File.separator + "SelfBillHP_" + CommonUtils.getNowDate() + ".xls");
    params.put("isEInvoice", "1");
    this.viewProcedure(null, null, params);
    LOGGER.info("[END] eInvoiceSelfBillHP...");
}

// New report for e-Invoice Self Bill - CD
@RequestMapping(value = "/eInvoiceSelfBillCD.do")
//@Scheduled(cron = "0 0 6 16 * ?")//6:00 a.m. 16th of the month
public void eInvoiceSelfBillCD() {
	LOGGER.info("[START] eInvoiceSelfBillCD...");
	int taskIDConf = this.calculateTaskId();
	Map<String, Object> params = new HashMap<>();
	params.put(REPORT_FILE_NAME, "/visualcut/eInvoiceSelfBillCD.rpt");// visualcut
	// rpt
	// file
	//name.
	params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
	params.put("V_TASKID", taskIDConf);
	params.put("V_TEMP", "TEMP");// parameter
	params.put(AppConstants.REPORT_DOWN_FILE_NAME,
			"e-Invoice Self Bill" + File.separator + "SelfBillCD_" + CommonUtils.getNowDate() + ".xls");
	params.put("isEInvoice", "1");
	this.viewProcedure(null, null, params);
	LOGGER.info("[END] eInvoiceSelfBillCD...");
}

// New report for e-Invoice Self Bill - HT
@RequestMapping(value = "/eInvoiceSelfBillHT.do")
//@Scheduled(cron = "0 0 6 16 * ?")//6:00 a.m. 16th of the month
public void eInvoiceSelfBillHT() {
	LOGGER.info("[START] eInvoiceSelfBillHT...");
	int taskIDConf = this.calculateTaskId();
	Map<String, Object> params = new HashMap<>();
	params.put(REPORT_FILE_NAME, "/visualcut/eInvoiceSelfBillHT.rpt");// visualcut
	// rpt
	// file
	//name.
	params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
	params.put("V_TASKID", taskIDConf);
	params.put("V_TEMP", "TEMP");// parameter
	params.put(AppConstants.REPORT_DOWN_FILE_NAME,
			"e-Invoice Self Bill" + File.separator + "SelfBillHT_" + CommonUtils.getNowDate() + ".xls");
	params.put("isEInvoice", "1");
	this.viewProcedure(null, null, params);
	LOGGER.info("[END] eInvoiceSelfBillHT...");
}

// New report for e-Invoice Self Bill - Vendors
@RequestMapping(value = "/eInvoiceSelfBillVendor.do")
//@Scheduled(cron = "0 0 6 16 * ?")//6:00 a.m. 16th of the month
public void eInvoiceSelfBillVendor() {
	LOGGER.info("[START] eInvoiceSelfBillVendor...");
	int taskIDConf = this.calculateTaskId();
	Map<String, Object> params = new HashMap<>();
	params.put(REPORT_FILE_NAME, "/visualcut/eInvoiceSelfBillVendor.rpt");// visualcut
	// rpt
	// file
	//name.
	params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
	params.put("V_TASKID", taskIDConf);
	params.put("V_TEMP", "TEMP");// parameter
	params.put(AppConstants.REPORT_DOWN_FILE_NAME,
			"e-Invoice Self Bill" + File.separator + "SelfBillVendor_" + CommonUtils.getNowDate() + ".xls");
	params.put("isEInvoice", "1");
	this.viewProcedure(null, null, params);
	LOGGER.info("[END] eInvoiceSelfBillVendor...");
}

public static int calculateTaskId() {
  // Get current date
  Calendar calendar = Calendar.getInstance();
  calendar.add(Calendar.MONTH, -1); // Move to previous month

  // Format the previous month's date to MM/yyyy format
  SimpleDateFormat dateFormat = new SimpleDateFormat("MM/yyyy");
  String cmmDtString = dateFormat.format(calendar.getTime());

  // Parse the commission date string
  Date cmmDt;
  try {
      cmmDt = dateFormat.parse(cmmDtString);
  } catch (Exception e) {
      e.printStackTrace();
      return -1; // Return -1 or another error code if parsing fails
  }

  // Create a Calendar instance and set it to the commission date
  calendar.setTime(cmmDt);

  // Extract month and year from the commission date
  int monthConf = calendar.get(Calendar.MONTH) + 1; // Calendar.MONTH is zero-based
  int yearConf = calendar.get(Calendar.YEAR);

  // Calculate the taskId
  int taskId = monthConf + (yearConf * 12) - 24157;

  return taskId;
}

  private void view(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params)
      throws IOException {
    checkArgument(params);

    SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS", Locale.getDefault(Locale.Category.FORMAT));
    Calendar startTime = Calendar.getInstance();
    Calendar endTime = null;

    String reportFile = (String) params.get(REPORT_FILE_NAME);
    ReportController.ViewType viewType = ReportController.ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));
    String reportName = reportFilePath + reportFile;
    String prodName = "view";
    int maxLength = 0;
    String msg = "Completed";

    try {

      //String reportName = reportFilePath + reportFile;
      ReportClientDocument clientDoc = new ReportClientDocument();

      // Report can be opened from the relative location specified in the
      // CRConfig.xml, or the report location
      // tag can be removed to open the reports as Java resources or using an
      // absolute path
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
        CRJavaHelper.replaceConnection(clientDoc, userName, password, connectString, driverName, jndiName);
        // logon to database
        CRJavaHelper.logonDataSource(clientDoc, userName, password);
      }

      Object reportSource = clientDoc.getReportSource();

      params.put("repProdName", prodName);

      ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
      Fields fields = clientDoc.getDataDefinition().getParameterFields();
      ReportUtils.setReportParameter(params, paramController, fields);
      {
        this.viewHandle(request, response, viewType, clientDoc, ReportUtils.getCrystalReportViewer(reportSource),
            params);
      }
    } catch (Exception ex) {
      LOGGER.error(CommonUtils.printStackTraceToString(ex));
      maxLength = CommonUtils.printStackTraceToString(ex).length() <= 4000 ? CommonUtils.printStackTraceToString(ex).length() : 4000;

      msg = CommonUtils.printStackTraceToString(ex).substring(0, maxLength);
      throw new ApplicationException(ex);
    } finally{
      // Insert Log
      endTime = Calendar.getInstance();
      params.put("msg", msg);
      params.put("startTime", fmt.format(startTime.getTime()));
      params.put("endTime", fmt.format(endTime.getTime()));
      params.put("userId", 349);

      reportBatchService.insertLog(params);
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

  private void viewHandle(HttpServletRequest request, HttpServletResponse response, ReportController.ViewType viewType,
      ReportClientDocument clientDoc, CrystalReportViewer crystalReportViewer, Map<String, Object> params)
      throws ReportSDKExceptionBase, IOException {

    String downFileName = (String) params.get(REPORT_DOWN_FILE_NAME);

    //[Ticket No: MY-1484] Add by Fannie - 24022025, for enhancement mobile Auto Debit Authorization (e-Notification) PDF
    boolean isAutoDebitAuthorization = false;

    if(CommonUtils.isNotEmpty(params.get("isAutoDebitAuthorization"))){
    	isAutoDebitAuthorization = true;
    }

    String isEInvoice = params.get("isEInvoice") != null ? params.get("isEInvoice").toString() : "" ;

    switch (viewType) {
      case CSV:
        ReportUtils.viewCSV(response, clientDoc, downFileName);
        break;
      case PDF:
    	  //[Ticket No: MY-1484] Add by Fannie - 24022025, for enhancement mobile Auto Debit Authorization (e-Notification) PDF
    	  if(isAutoDebitAuthorization == true){
    		  ReportUtils.viewAutoDebitAuthorizationPDF(response, clientDoc, downFileName, params);
    	  }else{
    		  ReportUtils.viewPDF(response, clientDoc, downFileName);
    	  }
        break;
      case EXCEL:

    	  if(!isEInvoice.equals("")){
    		  ReportUtils.viewDataEXCELEInvoice(response, clientDoc, downFileName, params);
    	  }
    	  else{
    		  ReportUtils.viewDataEXCEL(response, clientDoc, downFileName, params);
    	  }
        break;
      case EXCEL_FULL:
        ReportUtils.viewEXCEL(response, clientDoc, downFileName);
        break;
      case MAIL_CSV:
      case MAIL_PDF:
    	  ReportUtils.sendMailMultiple(clientDoc, viewType, params);
          break;
      case MAIL_EXCEL:
        ReportUtils.sendMail(clientDoc, viewType, params);
        break;
      case GENERAL_EXCEL:
    	  ReportUtils.viewGeneralDataEXCEL(response, clientDoc, downFileName, params);
    	  break;
      case GENERAL_CSV:
          ReportUtils.viewGeneralCSV(response, clientDoc, downFileName,params);
          break;
      default:
        throw new ApplicationException(AppConstants.FAIL, "wrong viewType....");
    }
  }


}
