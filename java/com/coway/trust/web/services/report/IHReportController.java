package com.coway.trust.web.services.report;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.report.IHReportService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 23/08/2019    ONGHC      1.0.0       - CREATE FOR IN HOUSE REPAIR
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/inhouse/report")
public class IHReportController {
  private static final Logger logger = LoggerFactory.getLogger(IHReportController.class);

  @Resource(name = "IHReportService")
  private IHReportService IHReportService;

  @RequestMapping(value = "/asReportPop.do")
  public String asReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
    EgovMap orderNum = IHReportService.selectOrderNum();
    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    model.addAttribute("orderNum", orderNum);
    model.addAttribute("bfDay", bfDay);
    model.addAttribute("toDay", toDay);

    return "services/ihr/asReportPop";
  }

  @RequestMapping(value = "/selectMemberCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMemberCode(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
    List<EgovMap> memberCode = IHReportService.selectMemberCodeList(params);
    return ResponseEntity.ok(memberCode);
  }

  @RequestMapping(value = "/asRawDataPop.do")
  public String asRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "services/ihr/asRawDataPop";
  }

  @RequestMapping(value = "/asYellowSheetPop.do")
  public String asYellowSheetPop(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> asYsTyp = IHReportService.selectAsYsTyp();
    model.addAttribute("asYsTyp", asYsTyp);

    List<EgovMap> asYsAge = IHReportService.selectAsYsAge();
    model.addAttribute("asYsAge", asYsAge);
    return "services/ihr/asYellowSheetPop";
  }

  @RequestMapping(value = "/asLogBookListPop.do")
  public String asPerformanceReportPop(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> asLogBookTyp = IHReportService.selectAsLogBookTyp();
    model.addAttribute("asLogBookTyp", asLogBookTyp);

    List<EgovMap> asLogBookGrp= IHReportService.selectAsLogBookGrp();
    model.addAttribute("asLogBookGrp", asLogBookGrp);

    return "services/ihr/asLogBookListPop";
  }

  @RequestMapping(value = "/asSummaryListPop.do")
  public String asSummaryListPop(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> asSumTyp = IHReportService.selectAsSumTyp();
    model.addAttribute("asSumTyp", asSumTyp);

    List<EgovMap> asSumStat = IHReportService.selectAsSumStat();
    model.addAttribute("asSumStat", asSumStat);

    List<EgovMap> asSumGrp= IHReportService.selectAsLogBookGrp();
    model.addAttribute("asSumGrp", asSumGrp);
    return "services/ihr/asSummaryListPop";
  }

  @RequestMapping(value = "/asLedgerPop.do")
  public String asLedgerPop(@RequestParam Map<String, Object> params, ModelMap model) {
    model.addAttribute("ASRNo", params.get("ASRNO"));
    return "services/ihr/asLedgerPop";
  }

  @RequestMapping(value = "/getViewLedger.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getViewLedger(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> viewLedger = IHReportService.selectViewLedger(params);
    return ResponseEntity.ok(viewLedger);
  }

  @RequestMapping(value = "/selectMemCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMemCodeList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("params {}", params);
    List<EgovMap> memberCode = IHReportService.selectMemCodeList();
    logger.debug("memberCode {}", memberCode);
    return ResponseEntity.ok(memberCode);
  }
}
