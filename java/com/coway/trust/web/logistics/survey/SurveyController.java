package com.coway.trust.web.logistics.survey;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.survey.SurveyService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**************************************
 * Author Date Remark Kit 2019/04/16 Create for Survey Form
 *
 ***************************************/
@Controller
@RequestMapping(value = "/logistics/survey/")
public class SurveyController {

  @Resource(name = "SurveyService")
  private SurveyService surveyService;

  private static final Logger logger = LoggerFactory.getLogger(SurveyController.class);

  @RequestMapping(value = "/surveyForm.do")
  public String surveyForm(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> title = surveyService.getSurveyTitle(params);

    title.forEach(obj -> {
      Map<String, Object> map = (Map<String, Object>) obj;
      params.put("surveyQuesGrp", map.get("surveySubGrp").toString());
      List<EgovMap> ques = surveyService.getSurveyQues(params);
      map.put("ques",ques);
      model.put("title", title);
      model.put("inWeb", params.get("inWeb").toString());
      model.put("surveyTypeId", params.get("surveyTypeId").toString());
    });

    return "logistics/survey/surveyFormPop";
  }

  @RequestMapping(value = "/getSurveyAns.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromotionByAppTypeStock(@RequestParam Map<String, Object> params) {
    List<EgovMap> surveyAns = surveyService.getSurveyAns(params);
    return ResponseEntity.ok(surveyAns);
  }

  @RequestMapping(value = "/surveySave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> surveySave(@RequestBody Map<String, ArrayList<Object>> params, Model model, SessionVO sessionVO)
          throws Exception {

      Map<String,Object> code = new HashMap<>();
      surveyService.saveSurvey(params,sessionVO,code);

      String msg = "";
      String stus = "";
      if(code.get("code").toString() != "FAIL"){
        msg = "Thank you for completing our survey! <br/>"
                  + "You will be login to eTRUST in 3 sec or press 'OK' to login";
        stus = AppConstants.SUCCESS;
      }else{
        msg = "Error while saving survey. Please contact IT department.";
        stus = AppConstants.FAIL;
      }

      ReturnMessage message = new ReturnMessage();
      message.setCode(stus);
      message.setMessage(msg);

      return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/verifyStatus.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> verifyStatus(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO)
          throws Exception {
          int verifyStus = surveyService.verifyStatus(params,sessionVO);
          String msg = null;

          if(verifyStus == 1){
            msg = "You done this survey before.<br/> To prevent duplicate survey result, please refresh and login again.";
          }

          ReturnMessage message = new ReturnMessage();
          message.setCode(String.valueOf(verifyStus));
          message.setMessage(msg);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/isSurveyRequired.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> isSurveyRequired(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO)
          throws Exception {

        params.put("inWeb","1");
        params.put("roleType",sessionVO.getRoleId());

        int surveyTypeId = surveyService.isSurveyRequired(params,sessionVO);

        if(surveyTypeId != 0){
          params.put("surveyTypeId",surveyTypeId);
        }

        int verifySurveyStus  = surveyService.verifyStatus(params, sessionVO);

      params.put("surveyTypeId", surveyTypeId);
      params.put("verifySurveyStus", verifySurveyStus);

          ReturnMessage message = new ReturnMessage();
          message.setData(params);

    return ResponseEntity.ok(message);
  }


}
