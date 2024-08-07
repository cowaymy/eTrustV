package com.coway.trust.web.payment.otherpayment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentService;
import com.coway.trust.biz.payment.otherpayment.service.JompayRtnService;
import com.coway.trust.biz.payment.otherpayment.service.OtherPaymentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class JompayRtnController {

  @Resource(name = "jompayRtnService")
  private JompayRtnService jompayRtnService;

  private static final Logger LOGGER = LoggerFactory.getLogger(JompayRtnController.class);

  @RequestMapping(value = "/initJompayRtn.do")
  public String initUploadBankStatementList(@RequestParam Map<String, Object> params, ModelMap model) {
    return "payment/otherpayment/jompayRtn";
  }

  @RequestMapping(value = "/selectJompayRtnList.do")
  public ResponseEntity<List<EgovMap>> selectJompayRTNList(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> resultList = jompayRtnService.selectJompayRtnList(params);
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectJompayRtnDetailsList.do")
  public ResponseEntity<List<EgovMap>> selectJompayRtnDetailsList(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> resultList = jompayRtnService.selectJompayRtnDetailsList(params);
    return ResponseEntity.ok(resultList);
  }

}
