package com.coway.trust.web.logistics.survey;

import java.util.ArrayList;
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
@RequestMapping(value = "/logistics/survey")
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

      surveyService.saveSurvey(params,sessionVO);

      String msg = "Thank you for completing our survey! <br/>"
          + "You will be login to eTRUST in 3 sec or press 'OK' to login";

      ReturnMessage message = new ReturnMessage();
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(msg);

      return ResponseEntity.ok(message);
  }

}
