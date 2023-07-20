package com.coway.trust.web.homecare.services.report;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.services.as.HcASManagementListService;
import com.coway.trust.biz.services.report.ASReportService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 26/07/2019    ONGHC      1.0.1       - Add Recall Status
 * 17/09/2019    ONGHC      1.0.2       - Amend asLedgerPop
 * 03/10/2019    ONGHC      1.0.3       - Add AS Raw Report for 31Days
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/homecare/services/as/report")
public class HcASReportController {
  //private static final Logger logger = LoggerFactory.getLogger(HcASReportController.class);

  //@Resource(name = "hcASReportService")
  //private HcASReportService hcASReportService;


	@Resource(name = "ASReportService")
	private ASReportService ASReportService;


    @Resource(name = "hcASManagementListService")
    private HcASManagementListService hcASManagementListService;


    @RequestMapping(value = "/asReportPop.do")
    public String asReportPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
      //String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    //String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
      //EgovMap orderNum = ASReportService.selectOrderNum();
      //model.addAttribute("orderNum", orderNum);

      // HomeCare Branch : SYS0005M - 5743
      model.addAttribute("branchList", hcASManagementListService.selectHomeCareBranchWithNm());

      return "homecare/services/as/hcAsReportPop";
    }

    @RequestMapping(value = "/asLogBookListPop.do")
    public String asPerformanceReportPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

      List<EgovMap> asLogBookTyp = ASReportService.selectAsLogBookTyp();
      model.addAttribute("asLogBookTyp", asLogBookTyp);

      List<EgovMap> asLogBookGrp= ASReportService.selectAsLogBookGrp();
      model.addAttribute("asLogBookGrp", asLogBookGrp);

      // HomeCare Branch : SYS0005M - 5743
      model.addAttribute("branchList", hcASManagementListService.selectHomeCareBranchWithNm());
      //model.addAttribute("branchList", hcASManagementListService.getBrnchId(null));

      List<EgovMap> asSumStat = ASReportService.selectAsSumStat();
      model.addAttribute("asSumStat", asSumStat);

      return "homecare/services/as/hcAsLogBookListPop";
    }

    @RequestMapping(value = "/asRawDataPop.do")
    public String asRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
      model.addAttribute("ind", params.get("ind"));
      return "homecare/services/as/hcAsRawDataPop";
    }

    @RequestMapping(value = "/asSummaryListPop.do")
    public String asSummaryListPop(@RequestParam Map<String, Object> params, ModelMap model) {
      List<EgovMap> asSumTyp = ASReportService.selectAsSumTyp();
      model.addAttribute("asSumTyp", asSumTyp);

      List<EgovMap> asSumStat = ASReportService.selectAsSumStat();
      model.addAttribute("asSumStat", asSumStat);

      List<EgovMap> asSumGrp= ASReportService.selectAsLogBookGrp();
      model.addAttribute("asSumGrp", asSumGrp);
      return "homecare/services/as/hcAsSummaryListPop";
    }

    @RequestMapping(value = "/asYellowSheetPop.do")
    public String asYellowSheetPop(@RequestParam Map<String, Object> params, ModelMap model) {
      List<EgovMap> asYsTyp = ASReportService.selectAsYsTyp();
      model.addAttribute("asYsTyp", asYsTyp);

      List<EgovMap> asYsAge = ASReportService.selectAsYsAge();
      model.addAttribute("asYsAge", asYsAge);
      return "homecare/services/as/hcAsYellowSheetPop";
    }

    //  TO-BE 화면 내용 확인필요.
    @RequestMapping(value = "/asLedgerPop.do")
    public String asLedgerPop(@RequestParam Map<String, Object> params, ModelMap model) {
      //logger.debug("params {}", params);

      model.addAttribute("ASNo", params.get("ASNO"));
      // 호출될 화면
      return "homecare/services/as/hcAsLedgerPop";
    }

  @RequestMapping(value = "/selectHCProductList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHCProductCodeList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> HCproductList = ASReportService.selectHCProductList();
    return ResponseEntity.ok(HCproductList);
  }

  @RequestMapping(value = "/selectHCProductCategory.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHCProductCategory(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> HCproductCategoryList = ASReportService.selectHCProductCategory();
    return ResponseEntity.ok(HCproductCategoryList);
  }

  @RequestMapping(value = "/selectHCDefectTypeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHCDefectTypeList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> HCdefectTypeList = ASReportService.selectHCDefectTypeList();
    return ResponseEntity.ok(HCdefectTypeList);
  }

  @RequestMapping(value = "/selectHCDefectRmkList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHCDefectRmkList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> HCdefectRmkList = ASReportService.selectHCDefectRmkList();
    return ResponseEntity.ok(HCdefectRmkList);
  }

  @RequestMapping(value = "/selectHCDefectDescList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHCDefectDescList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> HCdefectDescList = ASReportService.selectHCDefectDescList();
    return ResponseEntity.ok(HCdefectDescList);
  }

  @RequestMapping(value = "/selectHCDefectDescSymptomList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHCDefectDescSymptomList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> HCdefectDescSymptomList = ASReportService.selectHCDefectDescSymptomList();
    return ResponseEntity.ok(HCdefectDescSymptomList);
  }

}
