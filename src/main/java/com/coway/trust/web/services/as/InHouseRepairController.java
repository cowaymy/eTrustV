package com.coway.trust.web.services.as;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.as.InHouseRepairService;
import com.coway.trust.biz.services.servicePlanning.CTSubGroupListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/inhouse")

public class InHouseRepairController {
  private static final Logger logger = LoggerFactory.getLogger(InHouseRepairController.class);

  @Resource(name = "InHouseRepairService")
  private InHouseRepairService inHouseRepairService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/inhouseList.do")
  public String main(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/inhouseList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/inhouseList.do===============================");
    return "services/as/inhouseRepairList";
  }

  @RequestMapping(value = "/inhouseDPop.do")
  public String inhouseDPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    logger.debug("===========================/inhouseDPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("== USER_ID " + sessionVO.getMemId());
    logger.debug("== USER_NAME " + sessionVO.getUserName());
    logger.debug("== BRANCH_NAME " + sessionVO.getBranchName());
    logger.debug("== BRANCH_ID " + sessionVO.getUserBranchId());
    logger.debug("===========================/inhouseDPop.do===============================");

    model.put("mode", (String) params.get("mode"));
    model.put("ORD_ID", (String) params.get("ORD_ID"));
    model.put("ORD_NO", (String) params.get("ORD_NO"));
    model.put("AS_NO", (String) params.get("AS_NO"));
    model.put("AS_ID", (String) params.get("AS_ID"));
    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());
    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());

    return "services/as/inRHouseNewRepairPop";
  }

  @RequestMapping(value = "/inHouseAsResultEditBasicPop.do")
  public String inHouseAsResultEditBasicPop(@RequestParam Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {

    logger.debug("===========================/inHouseAsResultEditBasicPop.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/inHouseAsResultEditBasicPop.do===============================");

    model.put("mode", (String) params.get("mode"));
    model.put("ORD_ID", (String) params.get("ORD_ID"));
    model.put("ORD_NO", (String) params.get("ORD_NO"));
    model.put("AS_NO", (String) params.get("AS_NO"));
    model.put("AS_ID", (String) params.get("AS_ID"));
    model.put("AS_RESULT_NO", (String) params.get("AS_RESULT_NO"));
    model.put("AS_RESULT_ID", (String) params.get("AS_RESULT_ID"));
    model.put("USER_ID", sessionVO.getMemId());
    model.put("USER_NAME", sessionVO.getUserName());

    model.put("BRANCH_NAME", sessionVO.getBranchName());
    model.put("BRANCH_ID", sessionVO.getUserBranchId());

    // 호출될 화면
    return "services/as/inHouseAsResultEditBasicPop";
  }

  @RequestMapping(value = "/selInhouseList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selInhouseList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("===========================/selInhouseList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selInhouseList.do===============================");

    String[] repStateList = request.getParameterValues("repState");
    params.put("repStateList", repStateList);

    List<EgovMap> mList = inHouseRepairService.selInhouseList(params);

    return ResponseEntity.ok(mList);
  }

  @RequestMapping(value = "/selInhouseDetailList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selInhouseDetailList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("===========================/selInhouseDetailList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selInhouseDetailList.do===============================");

    List<EgovMap> dList = null;
    dList = inHouseRepairService.selInhouseDetailList(params);

    return ResponseEntity.ok(dList);
  }

  @RequestMapping(value = "/getASRulstSVC0004DInfo.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getASRulstSVC0004DInfo(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getASRulstSVC0004DInfo.do===============================");

    List<EgovMap> dList = null;
    dList = inHouseRepairService.getASRulstSVC0004DInfo(params);

    return ResponseEntity.ok(dList);
  }

  @RequestMapping(value = "/save.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> save(@RequestParam Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/save.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/save.do===============================");

    params.put("updator", sessionVO.getUserId());
    int rtnValue = 1;

    List<EgovMap> asresultmst = (List<EgovMap>) params.get("asResultM");
    List<EgovMap> add = (List<EgovMap>) params.get("add");
    List<EgovMap> remove = (List<EgovMap>) params.get("remove");
    List<EgovMap> update = (List<EgovMap>) params.get("update");
    List<EgovMap> inhouse = (List<EgovMap>) params.get("inhouse");

    logger.debug("== asresultmst = " + asresultmst.toString());
    logger.debug("== asresultmst = " + inhouse.toString());

    logger.debug("== ADD = " + add.toString());
    logger.debug("== REMOVE = " + remove.toString());
    logger.debug("== UPDATE = " + update.toString());

    // inHouseRepairService.asResult_insert(params);

    ReturnMessage message = new ReturnMessage();
    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/update.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> update(@RequestParam Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/update.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/update.do===============================");

    params.put("USER_ID", sessionVO.getUserId());

    int rtnValue = 1;
    // inHouseRepairService.addASRemark(params);

    ReturnMessage message = new ReturnMessage();
    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/mListUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> mListUpdate(@RequestBody Map<String, Object> params, Model model,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("===========================/mListUpdate.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/mListUpdate.do===============================");

    params.put("USER_ID", sessionVO.getUserId());

    // LinkedHashMap updateList = (LinkedHashMap) params.get("update");

    int rtnValue = 1;
    // inHouseRepairService.asResultBasic_update(params);

    ReturnMessage message = new ReturnMessage();

    if (rtnValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getCallLog", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCallLog(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    logger.debug("===========================/getCallLog.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getCallLog.do===============================");

    List<EgovMap> list = inHouseRepairService.getCallLog(params);

    return ResponseEntity.ok(list);
  }

}
