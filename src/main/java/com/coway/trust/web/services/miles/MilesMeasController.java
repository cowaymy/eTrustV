package com.coway.trust.web.services.miles;

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

import com.coway.trust.biz.services.miles.MilesMeasService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.services.servicePlanning.MileageCalculationController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE             PIC           VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 15/08/2023    ONGHC      1.0.1          - INITIAL MilesMeasController
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/miles")
public class MilesMeasController {

  private static final Logger logger = LoggerFactory.getLogger(MileageCalculationController.class);

  @Resource(name = "milesMeasService")
  MilesMeasService milesMeasService;

  @RequestMapping(value = "/milesMeasList.do")
  public String viewTagMangement(@RequestParam Map<String, Object> params, ModelMap model) {
    return "services/miles/milesMeasList";
  }

  @RequestMapping(value = "/getMilesMeasMasterList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMilesMeasMasterList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
    String[] branchIdList = request.getParameterValues("branchId");
    params.put("branchIdList",branchIdList);

    List<EgovMap> rtnList = milesMeasService.getMilesMeasMasterList(params);

    return ResponseEntity.ok(rtnList);
  }

  @RequestMapping(value = "/getMilesMeasList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMilesMeasList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
    String[] branchIdList = request.getParameterValues("branchId");
    params.put("branchIdList",branchIdList);
    logger.debug("param : " + params.toString());

    List<EgovMap> rtnList = milesMeasService.getMilesMeasList(params);

    return ResponseEntity.ok(rtnList);
  }

  @RequestMapping(value = "/getMilesMeasDetailList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMilesMeasDetailList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
    List<EgovMap> rtnList = milesMeasService.getMilesMeasDetailList(params);

    return ResponseEntity.ok(rtnList);
  }

  @RequestMapping(value = "/goMilesMeasRaw.do")
  public String goMilesMeasRaw(@RequestParam Map<String, Object> params, ModelMap model) {
    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "services/miles/milesMeasRawPop";
  }

  @RequestMapping(value = "/getMilesMeasRaw")
  public ResponseEntity<List<EgovMap>> getMilesMeasRaw(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
    List<EgovMap> milesMeasRaw = milesMeasService.getMilesMeasRaw(params);
    return ResponseEntity.ok(milesMeasRaw);
  }
}
