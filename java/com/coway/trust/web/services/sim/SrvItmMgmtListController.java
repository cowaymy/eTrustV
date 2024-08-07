package com.coway.trust.web.services.sim;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.services.sim.SrvItmMgmtListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - CREATE SERVICE ITEM MENAGEMENT FUNCTION
 * 22/07/2019    ONGHC      1.0.2       - AMEND BAESD ON FEEDBACK
 * 29/08/2019    ONGHC      1.0.3       - Enhance to Support DSC Branch
 * 06/07/2021    KAHKIT     1.1.0       - MAJOR ENHANCEMENT
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/sim")
public class SrvItmMgmtListController {
  private static final Logger logger = LoggerFactory.getLogger(SrvItmMgmtListController.class);

  @Resource(name = "SrvItmMgmtListService")
  private SrvItmMgmtListService SrvItmMgmtListService;

  @RequestMapping(value = "/srvItmMgmt.do")
  public String initSrvItmMgmttList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/srvItmMgmt.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmMgmt.do===============================");

    String brTypId =  SrvItmMgmtListService.getBrTypId(sessionVO.getUserName());
    model.put("BR_TYP_ID", brTypId);

    return "services/sim/srvItmMgmtList";
  }

  @RequestMapping(value = "/srvItmRawPop.do")
  public String srvItmRawPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/srvItmRawPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmRawPop.do===============================");

    String brTypId =  SrvItmMgmtListService.getBrTypId(sessionVO.getUserName());
    model.put("BR_TYP_ID", brTypId);

    return "services/sim/srvItmRawPop";
  }

  @RequestMapping(value = "/srvItmEntryPop.do")
  public String srvItmMgntAddPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/srvItmEntryPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmEntryPop.do===============================");

    String brTypId =  SrvItmMgmtListService.getBrTypId(sessionVO.getUserName());

    model.put("BR_TYP_ID", brTypId);

    return "services/sim/srvItmEntryPop";
  }

  @RequestMapping(value = "/srvItmView.do")
  public String srvItmView(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/srvItmView.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmView.do===============================");

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    String br =  SrvItmMgmtListService.getBchDesc((String) params.get("brCde"));
    String itmCde =  SrvItmMgmtListService.getItmCde((String) params.get("itmCde"));
    String itmDesc =  SrvItmMgmtListService.getItmDesc((String) params.get("itmCde"));
    String brTyp =  SrvItmMgmtListService.getBrTypDesc((String) params.get("brCde"));

    model.put("toDay", toDay);
    model.put("BR_TYP_DESC", brTyp);
    model.put("BR", (String) params.get("brCde"));
    model.put("BR_DESC", br);
    model.put("ITM_CDE", (String) params.get("itmCde"));
    model.put("ITM_STK_CDE", itmCde);
    model.put("ITM_STK_DESC", itmDesc);

    return "services/sim/srvItmViewPop";
  }

  @RequestMapping(value = "/srvItmAddPop.do")
  public String addSrvItmMgnt(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/srvItmAddPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmAddPop.do===============================");

    String brTyp = "";
    if ((params.get("cboBchTyp").toString()).equals("")) {
      brTyp =  SrvItmMgmtListService.getBrTypDesc((String) params.get("cboBch"));
    } else {
      brTyp =  SrvItmMgmtListService.getBchTypDesc(params.get("cboBchTyp").toString());
    }

    String br =  SrvItmMgmtListService.getBchDesc(params.get("cboBch").toString());
    String itmCde =  SrvItmMgmtListService.getItmCde(params.get("cboItm").toString());
    String itmDesc =  SrvItmMgmtListService.getItmDesc(params.get("cboItm").toString());
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    List<EgovMap> srvItmList = SrvItmMgmtListService.searchSrvItmLst(params);
    String qty = srvItmList.size() > 0 ? srvItmList.get(0).get("qty").toString() : "0";

    model.put("BR_TYP", (String) params.get("cboBchTyp"));
    model.put("BR_TYP_DESC", brTyp);
    model.put("BR", (String) params.get("cboBch"));
    model.put("BR_DESC", br);
    model.put("ITM_CDE", (String) params.get("cboItm"));
    model.put("ITM_STK_CDE", itmCde);
    model.put("ITM_STK_DESC", itmDesc);
    model.put("QTY", qty);
	model.put("toDay", toDay);

    return "services/sim/srvItmAddPop";
  }

  @RequestMapping(value = "/getBchTyp.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBchTyp(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getBchTyp.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getBchTyp.do===============================");

    List<EgovMap> bchTyp = SrvItmMgmtListService.getBchTyp(params);
    logger.debug("BRANCH TYPE {}", bchTyp);
    return ResponseEntity.ok(bchTyp);
  }

  @RequestMapping(value = "/getBch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBch(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getBch.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getBch.do===============================");

    List<EgovMap> bch = SrvItmMgmtListService.getBch(params);
    logger.debug("BRANCH {}", bch);
    return ResponseEntity.ok(bch);
  }

  @RequestMapping(value = "/getItm.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getItm(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getItm.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getItm.do===============================");

    List<EgovMap> itm = SrvItmMgmtListService.getItm(params);
    logger.debug("ITEM {}", itm);
    return ResponseEntity.ok(itm);
  }

  @RequestMapping(value = "/searchSrvItmLst.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> searchSrvItmLst(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/searchSrvItmLst.do===============================");
    logger.debug("== params " + params.toString());

    String[] ctgryList = request.getParameterValues("cboCat");

    params.put("ctgryList", ctgryList);

    List<EgovMap> SrvItmList = SrvItmMgmtListService.searchSrvItmLst(params);

    logger.debug("== SrvItmList : {}", SrvItmList);
    logger.debug("===========================/searchSrvItmLst.do===============================");
    return ResponseEntity.ok(SrvItmList);
  }

  @RequestMapping(value = "/getSrvItmRcd.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSrvItmRcd(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getSrvItmRcd.do===============================");
    logger.debug("== params " + params.toString());

    List<EgovMap> SrvItmRcd = SrvItmMgmtListService.getSrvItmRcd(params);

    //logger.debug("== SrvItmRcd : {}", SrvItmRcd);
    logger.debug("===========================/getSrvItmRcd.do===============================");
    return ResponseEntity.ok(SrvItmRcd);
  }

  @RequestMapping(value = "/getMovTyp.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMovTyp(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getMovTyp.do===============================");
    logger.debug("== params " + params.toString());

    List<EgovMap> movTyp = SrvItmMgmtListService.getMovTyp(params);

    logger.debug("== movTyp : {}", movTyp);
    logger.debug("===========================/getMovTyp.do===============================");
    return ResponseEntity.ok(movTyp);
  }

  @RequestMapping(value = "/getMovDtl.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMovDtl(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getMovDtl.do===============================");
    logger.debug("== params " + params.toString());

    List<EgovMap> movDtl = SrvItmMgmtListService.getMovDtl(params);

    logger.debug("== movDtl : {}", movDtl);
    logger.debug("===========================/getMovDtl.do===============================");
    return ResponseEntity.ok(movDtl);
  }

  @RequestMapping(value = "/srvItmSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> srvItmSave(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    params.put("updator", sessionVO.getUserId());

    logger.debug("===========================/srvItmSave.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmSave.do===============================");

    ReturnMessage message = new ReturnMessage();

    EgovMap rtnValue = SrvItmMgmtListService.insertSrvItm(params);

    if (rtnValue != null) {
      message.setCode(AppConstants.SUCCESS);
      message.setData(rtnValue);
      message.setMessage("");
    } else {
      message.setCode(AppConstants.FAIL);
      message.setData(rtnValue);
      message.setMessage("");
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/srvItmStkRawPop.do")
  public String srvItmStkRawPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/srvItmRawPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmRawPop.do===============================");

    String brTypId =  SrvItmMgmtListService.getBrTypId(sessionVO.getUserName());
    model.put("BR_TYP_ID", brTypId);

    return "services/sim/srvItmStkRawPop";
  }

  @RequestMapping(value = "/srvItmForecastRawPop.do")
  public String srvForecastRawPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/srvItmRawPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/srvItmRawPop.do===============================");

    String brTypId =  SrvItmMgmtListService.getBrTypId(sessionVO.getUserName());
    model.put("BR_TYP_ID", brTypId);

    return "services/sim/srvItmForecastRawPop";
  }

  @RequestMapping(value = "/deleteSrvItmRcd.do")
  public ResponseEntity<ReturnMessage> deleteSrvItmRcd(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

    params.put("updator", sessionVO.getUserId());

    ReturnMessage message = new ReturnMessage();

    int rtnValue = SrvItmMgmtListService.deactivateLog91d(params);

    if (rtnValue != 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setData(rtnValue);
      message.setMessage("");
    } else {
      message.setCode(AppConstants.FAIL);
      message.setData(rtnValue);
      message.setMessage("");
    }
    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/editSrvItmRcd.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> editSrvItmRcd(@RequestBody Map<String, Object> params, SessionVO sessionVO) {

    params.put("updator", sessionVO.getUserId());

    logger.debug("===========================/editSrvItmRcd.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/editSrvItmRcd.do===============================");

    ReturnMessage message = new ReturnMessage();

    Map<String, Object> deactData = (Map<String, Object>) params.get("resultMst");
    deactData.put("updator", sessionVO.getUserId());
    int deactVal = SrvItmMgmtListService.deactivateLog91d(deactData);

    EgovMap rtnValue = null;

    if(deactVal != 0)
      rtnValue = SrvItmMgmtListService.insertSrvItm(params);

    if (rtnValue != null) {
      message.setCode(AppConstants.SUCCESS);
      message.setData(rtnValue);
      message.setMessage("");
    } else {
      message.setCode(AppConstants.FAIL);
      message.setData(rtnValue);
      message.setMessage("");
    }
    return ResponseEntity.ok(message);

  }

}
