package com.coway.trust.web.common.visualcut;

import static com.coway.trust.AppConstants.*;

import java.io.File;
import java.io.IOException;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.ReportBatchService;
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
 * CAUTION : 135 Server only //////@Scheduled of ReportBatchController should be
 * uncommented. Then the report batch is executed. Note: If another instance is
 * uncommented, it will be executed multiple times.
 * http://10.201.32.135:8094/
 * Path: /apps/domains/SalesDmain/servers/eTRUST_report/WEB-INF/classes/com/coway/trust/web/common/visualcut
 * Folder: /apps/apache/htdocs/resources/WebShare/RawData/Public
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

  @Autowired
  private ReportBatchService reportBatchService;

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

  @RequestMapping(value = "/ColorGrid_Daily_2018_Jan_Dec_S.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (4:00am)
  public void colorGridDaily2018JanDecS() {
    LOGGER.info("[START] SQLColorGrid_NoRental-Out-Ins_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2018_Jan_Dec_S.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "ColorGrid" + File.separator + "ColorGrid_Daily_2018_Jan_Dec_S" + CommonUtils.getNowDate() + ".xls");

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

  @RequestMapping(value = "/RCM_Daily_Current_Year.do")
  //@Scheduled(cron = "0 30 5 * * *")//Daily (5:30am)
  public void rcmDailyCurrentYear() {
    LOGGER.info("[START] RCM_Daily_Current_Year...");

    String startYear = String.valueOf(LocalDate.now().getYear());

    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily.rpt");// visualcut
                                                                       // rpt
                                                                       // file
                                                                       // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_STARTYEAR", startYear);// parameter
    params.put("V_ENDYEAR", "");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM" + File.separator + "RCM_Daily_"  + startYear + "_"+ CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Daily_Current_Year...");
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

  @RequestMapping(value = "/RCM_Daily_HTMattress.do")
  //@Scheduled(cron = "0 0 5 * * *")//Daily (5:00am)
  public void rcmDailyHtMattress() {
    LOGGER.info("[START] RCM_Daily_HTMattress...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_HTMattress.rpt");// visualcut
                                                                      // rpt
                                                                      // file
                                                                      // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "RCM_HT" + File.separator + "RCM_Daily_HTMattress_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RCM_Daily_HTMattress...");
  }

  @RequestMapping(value = "/ColorGrid_Simplification_2014_2015.do")
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
  }

  @RequestMapping(value = "/ColorGrid_Simplification_2018.do")
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
  }

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
  //@Scheduled(cron = "0 24 8 * * MON,WED,FRI")//Weekly (Mon, Wed, Fri) 8:24am
  public void preBSConfig() {
    LOGGER.info("[START] PreBSConfig...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/PreBSConfig.rpt");// visualcut rpt
                                                               // file name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "BSRaw" + File.separator + "PreBSConfig" + CommonUtils.getNowDate() + ".xls");

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
  //@Scheduled(cron = "0 0 2 2 * *")//2nd day of the month (2am)
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
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "RentalAging12Month" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalAging12Month...");
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
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "RentalAgingReport" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] RentalAgingReport...");
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
          "BSReport" + File.separator + "BSReport" + CommonUtils.getNowDate() + "_" + param + ".xls");

      this.viewProcedure(null, null, params);
    }

    LOGGER.info("[END] BSReport...");
  }

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
          "BSReport" + File.separator + "BSReportCT" + CommonUtils.getNowDate() + "_" + param + ".xls");

      this.viewProcedure(null, null, params);
    }

    LOGGER.info("[END] BSReportCT...");
  }

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

      clientDoc.getDatabaseController().logon(reportUserName, reportPassword);

      prodName = clientDoc.getDatabaseController().getDatabase().getTables().size() > 0 ? clientDoc.getDatabaseController().getDatabase().getTables().get(0).getName() : null;

      params.put("repProdName", prodName);

      ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
      Fields fields = clientDoc.getDataDefinition().getParameterFields();
      ReportUtils.setReportParameter(params, paramController, fields);
      {
        this.viewHandle(request, response, viewType, clientDoc,
            ReportUtils.getCrystalReportViewer(clientDoc.getReportSource()), params);
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

  @RequestMapping(value = "/LCD_StockTransfer.do")
  //@Scheduled(cron = "0 50 4 * * *")
  public void lcdStockTransfer() throws IOException {
    LOGGER.info("[START] LCD_StockTransfer...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/LCD_StockTransfer.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "LCD" + File.separator + "LCD_StockTransfer" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] LCD_StockTransfer...");
  }

  /*
   * Split to rcmDailySimplified_1 and rcmDailySimplified_2
   * Not Required to run
   */
  @RequestMapping(value = "/RCM_Daily_Simplified.do")
  //@Scheduled(cron = "0 10 5 * * *")
  public void rcmDailySimplified() throws IOException {
    LOGGER.info("[START] RCM_Daily_Simplified...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_Simplified.rpt");// visualcut
                                                                        // rpt
                                                                        // file
                                                                        // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Simplified_RCM" + File.separator + "RCM_Daily_Simplified" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] RCM_Daily_Simplified...");
  }

  @RequestMapping(value = "/RCM_Daily_Simplified_1.do")
  //@Scheduled(cron = "0 10 5 * * *")
  public void rcmDailySimplified_1() throws IOException {
    LOGGER.info("[START] RCM_Daily_Simplified...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_Simplified_1.rpt");// visualcut
                                                                        // rpt
                                                                        // file
                                                                        // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Simplified_RCM" + File.separator + "RCM_Daily_Simplified" + CommonUtils.getNowDate() + "_1.xls");

    this.view(null, null, params);
    LOGGER.info("[END] RCM_Daily_Simplified...");
  }

  @RequestMapping(value = "/RCM_Daily_Simplified_2.do")
  //@Scheduled(cron = "0 40 5 * * *")
  public void rcmDailySimplified_2() throws IOException {
    LOGGER.info("[START] RCM_Daily_Simplified...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/RCM_Daily_Simplified_2.rpt");// visualcut
                                                                        // rpt
                                                                        // file
                                                                        // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Simplified_RCM" + File.separator + "RCM_Daily_Simplified" + CommonUtils.getNowDate() + "_2.xls");

    this.view(null, null, params);
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
  //@Scheduled(cron = "0 24 8 * * MON,WED,FRI")
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

  @RequestMapping(value = "/BSRawCurrent.do")
  //@Scheduled(cron = "0 24 8 * * MON,WED,FRI")
  public void bsRawCurrent() throws IOException {
    LOGGER.info("[START] BSRawCurrent...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent.rpt");// visualcut rpt
                                                                // file name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent_S1.rpt");// visualcut
                                                                   // rpt file
                                                                   // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "BSRaw" + File.separator + "BSRawCurrent_S1" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] BSRawCurrent_S1...");
  }

  @RequestMapping(value = "/BSRawPrevious_S1.do")
  //@Scheduled(cron = "0 24 8 * * MON,WED,FRI")
  public void bsRawPreviousS1() throws IOException {
    LOGGER.info("[START] BSRawPrevious_S1...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawPrevious_S1.rpt");// visualcut
                                                                    // rpt file
                                                                    // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "BSRaw" + File.separator + "BSRawPrevious_S1" + CommonUtils.getNowDate() + ".xls");

    this.view(null, null, params);
    LOGGER.info("[END] BSRawPrevious_S1...");
  }

  @RequestMapping(value = "/BSRawCurrent_S.do")
  //@Scheduled(cron = "0 24 8 * * MON,WED,FRI")
  public void bsRawCurrentS() throws IOException {
    LOGGER.info("[START] BSRawCurrent_S...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/BSRawCurrent_S.rpt");// visualcut
                                                                  // rpt file
                                                                  // name.
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
    params.put(REPORT_FILE_NAME, "/visualcut/CorpSMSList.rpt");// visualcut rpt
                                                               // file name.
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
  //@Scheduled(cron = " 0 0 6 2 * ?")//Monthly (Day 2) 6:00am
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
  //@Scheduled(cron = " 0 0 6 2 * ?")//Monthly (Day 2) 6:00am
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

  @RequestMapping(value = "/PreMonth_HS_Filter.do")
  //@Scheduled(cron = " 0 0 6 2 * ?")//Monthly (Day 2) 6:00am
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
  }

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

  @RequestMapping(value = "/OutrightPlusAging.do")
  //@Scheduled(cron = "0 0 6 * * *")//Daily (6:00am) /*monthly - end of month
  // eg 31 @ 28 ...
  public void OutrightPlusAging() {
    LOGGER.info("[START] OutrightPlusAging...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/OutrightPlusAging.rpt");// visualcut
                                                                     // rpt file
                                                                     // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Finance" + File.separator + "OutrightPlusAging" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] OutrightPlusAging...");
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
  //@Scheduled(cron = " 0 30 0 * * 5") // Weekly Friday 12:30am
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

    this.view(null, null, params);
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

  @RequestMapping(value = "/CSP_Raw_Data_Excel_2018.do")
  //@Scheduled(cron = "0 0 3 * * *")//Daily (3:00am)
  public void CSP_Raw_Data_Excel_2018() {
    LOGGER.info("[START] CSP_Raw_Data_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CSPRawData.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_YEAR", "2018");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CSP" + File.separator + "CSP_Raw_Data_2018_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CSP_Raw_Data_Excel...");
  }

  @RequestMapping(value = "/CSP_Raw_Data_Excel_2019.do")
  //@Scheduled(cron = "0 30 3 * * *")//Daily (3:30am)
  public void CSP_Raw_Data_Excel_2019() {
    LOGGER.info("[START] CSP_Raw_Data_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CSPRawData.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_YEAR", "2019");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CSP" + File.separator + "CSP_Raw_Data_2019_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CSP_Raw_Data_Excel...");
  }

  @RequestMapping(value = "/CSP_Raw_Data_Excel_2020.do")
  //@Scheduled(cron = "0 0 4 * * *")//Daily (3:30am)
  public void CSP_Raw_Data_Excel_2020() {
    LOGGER.info("[START] CSP_Raw_Data_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/CSPRawData.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put("V_YEAR", "2020");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CSP" + File.separator + "CSP_Raw_Data_2020_" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CSP_Raw_Data_Excel...");
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
    params.put(REPORT_FILE_NAME, "/visualcut/CustHealthScoreRawData.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CCP" + File.separator + "CustHealthScoreRawData" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CustomerHealthScoreRaw_Excel...");
  }

  @RequestMapping(value = "/ColorGrid_Daily_2019_Jan_Dec_S.do")
  //@Scheduled(cron = "0 20 5 * * *")//Daily (5:20am)
  public void colorGridDaily2019JanDecS() {
    LOGGER.info("[START] SQLColorGrid_NoRental-Out-Ins_Excel...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/ColorGrid_Daily_2019_Jan_Dec_S.rpt");// visualcut
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    params.put(REPORT_VIEW_TYPE, "EXCEL"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "ColorGrid" + File.separator + "ColorGrid_Daily_2019_Jan_Dec_S" + CommonUtils.getNowDate() + ".xls");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] SQLColorGrid_NoRental-Out-Ins_Excel...");
  }

  @RequestMapping(value = "/Hand_Collection_vs_Autopay_Excel.do")
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
  }


  @RequestMapping(value = "/CowayDailySalesStatusHP_Adv.do")
  public void CowayDailySalesStatusHP_Adv() {
    LOGGER.info("[START] CowayDailySalesStatusHP_Adv...");
    Map<String, Object> params = new HashMap<>();
    String[] address =
      {
        "kahkit.chew@coway.com.my",
        "nicky.lam@coway.com.my",
        "eddie.toh@coway.com.my",
        "joanne.chin@coway.com.my",
        "ivan.liew@coway.com.my",
        "lyeim@coway.com.my",
        "thomas.chin@coway.com.my",
        "khongboon.soo@coway.com.my",
        "rachel.wong@coway.com.my",
        "jack@coway.com.my",
        "<jypark30@coway.co.kr>",
        "<enough06@coway.co.kr>",
        "<rose3128@coway.co.kr>",
        "<jenux@coway.co.kr>",
        "<smhong@coway.co.kr>",
        "<yulyul@coway.co.kr>",
        "<ikchoul85@coway.co.kr>"
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
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
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
    String[] address ={"kahkit.chew@coway.com.my",
          "nicky.lam@coway.com.my",
          "eddie.toh@coway.com.my",
          "joanne.chin@coway.com.my",
          "ivan.liew@coway.com.my",
          "lyeim@coway.com.my",
          "thomas.chin@coway.com.my",
          "khongboon.soo@coway.com.my",
          "rachel.wong@coway.com.my",
          "jack@coway.com.my",
          "<jypark30@coway.co.kr>",
          "<enough06@coway.co.kr>",
          "<rose3128@coway.co.kr>",
          "<jenux@coway.co.kr>",
          "<smhong@coway.co.kr>",
          "<yulyul@coway.co.kr>",
          "<ikchoul85@coway.co.kr>"
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
    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
    params.put("v_Param", " ");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "CowayDailySalesStatusCody" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] CowayDailySalesStatusCody...");
  }

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

  @RequestMapping(value = "/RCM_Monthly.do")
  //@Scheduled(cron = "0 0 1 2 * ?")//Monthly (Day 2) (1:00am)
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
  //@Scheduled(cron = "0 0 1 2 * ?")//Monthly (Day 2) (1:00am)
  public void MonthlyRentalCollection() {
    LOGGER.info("[START] Monthly_Rental_Collection...");
    Map<String, Object> params = new HashMap<>();
    params.put(REPORT_FILE_NAME, "/visualcut/MonthlyRentalCollection.rpt");// visualcut
                                                                           // rpt
                                                                           // file name.
    params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put("V_TEMP", "TEMP");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "Rental Collection" + File.separator + "Monthly_Ren_Coll_" + CommonUtils.getNowDate() + ".pdf");

    this.viewProcedure(null, null, params);
    LOGGER.info("[END] Monthly_Rental_Collection...");
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
        CRJavaHelper.changeDataSource(clientDoc, userName, password, connectString, driverName, jndiName);
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
    	  ReportUtils.sendMailMultiple(clientDoc, viewType, params);
          break;
      case MAIL_EXCEL:
        ReportUtils.sendMail(clientDoc, viewType, params);
        break;
      default:
        throw new ApplicationException(AppConstants.FAIL, "wrong viewType....");
    }
  }
}
