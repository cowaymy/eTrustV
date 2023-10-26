package com.coway.trust.web.services.report;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.report.HSReportService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs/report")
public class HSReportController {
  private static final Logger logger = LoggerFactory.getLogger(HSReportController.class);

  @Resource(name = "HSReportService")
  private HSReportService HSReportService;

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @RequestMapping(value = "/hsCountForecastListingPop.do")
  public String hsCountForecastListingPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/bs/hsCountForecastListingPop";
  }

  @RequestMapping(value = "/hsReportGroupPop.do")
  public String hsReportGroupPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    // 호출될 화면
	  params.put("userId", sessionVO.getUserId());

	  if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
		  sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

	      EgovMap result =  salesCommonService.getUserInfo(params);

	      model.put("orgCode", result.get("orgCode"));
	      model.put("grpCode", result.get("grpCode"));
	      model.put("deptCode", result.get("deptCode"));
	      model.put("memCode", result.get("memCode"));
	    }
    return "services/bs/hsReportGroupPop";
  }

  @RequestMapping(value = "/hsReportSinglePop.do")
  public String hsReportSinglePop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "services/bs/hsReportSinglePop";
  }

  @RequestMapping(value = "/bSSummaryList.do")
  public String bSSummaryList(@RequestParam Map<String, Object> params, ModelMap model,  SessionVO sessionVO) {

	  params.put("userId", sessionVO.getUserId());
	  EgovMap userInfo = salesCommonService.getUserInfo(params);

	  if (userInfo != null) {
	      model.put("memCode", userInfo.get("memCode"));
	      model.put("memLvl", userInfo.get("memLvl"));
	      model.put("orgCode", userInfo.get("orgCode"));
	      model.put("grpCode", userInfo.get("grpCode"));
	      model.put("deptCode", userInfo.get("deptCode"));
	      logger.info("memType ##### " + userInfo.get("memType"));
	  }

	  // 호출될 화면
    return "services/bs/bSSummaryPop";
  }

  /**
   * Search rule book management list
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectHSReportSingle.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSReportSingle(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> HSReportSingle = HSReportService.selectHSReportSingle(params);
    logger.debug("HSReportSingle {}", HSReportSingle);
    return ResponseEntity.ok(HSReportSingle);
  }

  /**
   * Search rule book management list
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectHSReportGroup.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSReportGroup(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> HSReportGroup = HSReportService.selectHSReportGroup(params);
    logger.debug("HSReportGroup {}", HSReportGroup);
    return ResponseEntity.ok(HSReportGroup);
  }

  @RequestMapping(value = "/filterForecastListingPop.do")
  public String filterForecastPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    // 호출될 화면
	  params.put("memberLevel", sessionVO.getMemberLevel());
	  params.put("userName", sessionVO.getUserName());
	  params.put("userType", sessionVO.getUserTypeId());

	  List<EgovMap> branchList = hsManualService.selectBranchList(params);
	    model.addAttribute("branchList", branchList);

	    model.addAttribute("userName", sessionVO.getUserName());

	    model.addAttribute("memberLevel", sessionVO.getMemberLevel());
	    model.addAttribute("userType", sessionVO.getUserTypeId());
    return "services/bs/filterForecastListingPop";
  }

  /**
   * Search rule book management list
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectCMGroupList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCMGroupList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> selectCMGroupList = HSReportService.selectCMGroupList(params);
    logger.debug("HSReportGroup {}", selectCMGroupList);
    return ResponseEntity.ok(selectCMGroupList);
  }

  /**
   * Search rule book management list
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/selectCodyList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodyList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> selectCodyList = HSReportService.selectCodyList(params);
    logger.debug("selectCodyList {}", selectCodyList);
    return ResponseEntity.ok(selectCodyList);
  }

  /**
   * Search rule book management list
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/reportBranchCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectReportBranchCodeList(@RequestParam Map<String, Object> params,
      ModelMap model) {

    List<EgovMap> selectBranchList = HSReportService.selectReportBranchCodeList(params);
    logger.debug("selectBranchList {}", selectBranchList);
    return ResponseEntity.ok(selectBranchList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/deptCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectdeptCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> DeptCodeList = HSReportService.selectDeptCodeList(params);
    logger.debug("HSReportSingle {}", DeptCodeList);
    return ResponseEntity.ok(DeptCodeList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/dscCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDscCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> DscCode = HSReportService.selectDscCodeList(params);
    logger.debug("HSReportSingle {}", DscCode);
    return ResponseEntity.ok(DscCode);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/insStatusCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectInsStatusList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> InsStatusList = HSReportService.selectInsStatusList(params);
    logger.debug("HSReportSingle {}", InsStatusList);
    return ResponseEntity.ok(InsStatusList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/codyCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodyCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> CodyCodeList = HSReportService.selectCodyCodeList(params);
    logger.debug("HSReportSingle {}", CodyCodeList);
    return ResponseEntity.ok(CodyCodeList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/codyCode_1.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodyCodeList_1(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> CodyCodeList = HSReportService.selectCodyCodeList_1(params);
    logger.debug("HSReportSingle {}", CodyCodeList);
    return ResponseEntity.ok(CodyCodeList);
  }

  /**
   *
   * @param request
   * @param model
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/areaCode.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAreaCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> AreaCodeList = HSReportService.selectAreaCodeList(params);
    logger.debug("HSReportSingle {}", AreaCodeList);
    return ResponseEntity.ok(AreaCodeList);
  }

  @RequestMapping(value = "/safetyLevelList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> safetyLevelList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> safetyLevelList = HSReportService.safetyLevelList(params);
    logger.debug("safetyLevelList {}", safetyLevelList);
    return ResponseEntity.ok(safetyLevelList);
  }

  @RequestMapping(value = "/safetyLevelQtyList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> safetyLevelQtyList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> safetyLevelQtyList = HSReportService.safetyLevelQtyList(params);
    logger.debug("safetyLeveltyQtyList {}", safetyLevelQtyList);
    return ResponseEntity.ok(safetyLevelQtyList);
  }

  @RequestMapping(value = "/hsReportCustSignPop.do")
  public String hsReportCustSignPop(@RequestParam Map<String, Object> params, ModelMap model) {
    return "services/bs/hsReportCustSignPop";
  }

  @RequestMapping(value = "/selectHSReportCustSign.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHSReportCustSign(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> HSReportCustSign = HSReportService.selectHSReportCustSign(params);
    return ResponseEntity.ok(HSReportCustSign);
  }
  @RequestMapping(value = "/selectCodyList2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodyList2(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    params.put("memLevl", sessionVO.getMemberLevel());
	    params.put("userName", sessionVO.getUserName());
	    params.put("userType", sessionVO.getUserTypeId());
    List<EgovMap> selectCodyList2 = HSReportService.getCodyList2(params);
    logger.debug("selectCodyList2 {}", selectCodyList2);
    return ResponseEntity.ok(selectCodyList2);
  }
  @RequestMapping(value = "/selectRegion.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectRegion(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    params.put("memLevl", sessionVO.getMemberLevel());
	    params.put("userName", sessionVO.getUserName());
	    params.put("userType", sessionVO.getUserTypeId());
    List<EgovMap> selectRegion = HSReportService.selectRegion(params);
    logger.debug("selectCodyList2 {}", selectRegion);
    return ResponseEntity.ok(selectRegion);
  }
  @RequestMapping(value = "/getCdUpMem.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCdUpMem(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    params.put("memLevl", sessionVO.getMemberLevel());
	    params.put("userName", sessionVO.getUserName());
	    params.put("userType", sessionVO.getUserTypeId());
    List<EgovMap> getCdUpMem = HSReportService.getCdUpMem(params);
    logger.debug("selectCodyList2 {}", getCdUpMem);
    return ResponseEntity.ok(getCdUpMem);
  }

  @RequestMapping(value = "/selectCodyBranch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCodyBranch(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    params.put("memLevl", sessionVO.getMemberLevel());
	    params.put("userName", sessionVO.getUserName());
	    params.put("userType", sessionVO.getUserTypeId());
    List<EgovMap> selectCodyBranch = HSReportService.selectCodyBranch(params);
    logger.debug("selectCodyBranch {}", selectCodyBranch);
    return ResponseEntity.ok(selectCodyBranch);
  }

  @RequestMapping(value = "/hsFmcoEvoucherPop.do")
  public String hsFmcoEvoucher(@RequestParam Map<String, Object> params, ModelMap model,  SessionVO sessionVO) {

	  return "services/bs/hsFmcoEvoucherPop";
  }

  @RequestMapping(value = "/selectEVoucherList")
	public ResponseEntity<List<EgovMap>> selectEVoucherList() throws Exception{

	  logger.info("#############################################");
	  logger.info("#############selectEVoucherList");
	  logger.info("#############################################");

		List<EgovMap> branchMap = null;

		branchMap = HSReportService.selectEVoucherList();

		return ResponseEntity.ok(branchMap);

	}
}
