/**************************************
 * Author   Date                Remark
 * Kit           2019/04/16      Create for Survey Form
 ***************************************/
package com.coway.trust.biz.logistics.survey.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.survey.SurveyService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.logistics.survey.SurveyController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SurveyService")
public class SurveyServiceImpl implements SurveyService
{

  private static final Logger logger = LoggerFactory.getLogger(SurveyServiceImpl.class);

  @Autowired
  private SurveyMapper surveyMapper;

  @Override
  public int verifyStatus(Map<String, Object> params,SessionVO sessionVO) {
    params.put("userId",sessionVO.getUserId());
    return surveyMapper.verifyStatus(params);
  }

  @Override
  public int isSurveyRequired(Map<String, Object> params,SessionVO sessionVO) {
    params.put("userTypeId",sessionVO.getUserTypeId());
    //params.put("userMemLvl",sessionVO.getMemberLevel());
    int surveyTypeId = 0;
    if (surveyMapper.isSurveyRequired(params) != null){
      surveyTypeId = Integer.parseInt(surveyMapper.isSurveyRequired(params).get("surveyTypeId").toString());
    }
    return surveyTypeId;
  }

  @Override
  public List<EgovMap> getSurveyTitle(Map<String, Object> params) {
      return surveyMapper.getSurveyTitle(params);
  }

  @Override
  public List<EgovMap> getSurveyQues(Map<String, Object> params) {
      return surveyMapper.getSurveyQues(params);
  }

  @Override
  public List<EgovMap> getSurveyAns(Map<String, Object> params) {
      return surveyMapper.getSurveyAns(params);
  }

  @Override
  public void saveSurvey(Map<String, ArrayList<Object>> params, SessionVO sessionVO, Map<String,Object> code) {

    try{
      List<Map<String, Object>> survey = new ArrayList<>();

      List<Object> etcMap = params.get("etc");
      Map<String, Object> rem = (Map<String, Object>)etcMap.get(0);
      Map<String, Object> surveyTypeIdMap = (Map<String, Object>)etcMap.get(1);

      int surveyTypeId = Integer.valueOf(surveyTypeIdMap.get("surveyTypeId").toString());
      int surveyId =surveyMapper.selectSurveyMSeq();

      Map<String, Object> surveyM = new HashMap<>();
      surveyM.put("surveyId", surveyId);
      surveyM.put("surveyTypeId", surveyTypeId);
      surveyM.put("userId", sessionVO.getUserId());
      surveyM.put("rem", String.valueOf(rem.get("rem")));

      surveyMapper.insertSurveyM(surveyM);

      if(surveyTypeId != 0){
        List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터

        // Remove last survey comment
        formList.remove(formList.size()-1);

        formList.forEach(obj -> {
          Map<String, Object> map = (Map<String, Object>) obj;

          map.put("surveyId", surveyId);
          map.put("quesId", map.get("id"));
          if(map.get("type").equals("radio")){
            map.put("quesIsScre", 1);
            map.put("scre", map.get("val"));
          }else if(map.get("type").equals("select")){
            map.put("quesIsCustAns", 1);
            map.put("quesAnsId", map.get("val"));
          }else if(map.get("type").equals("text") || map.get("type").equals("textarea")){
            map.put("quesIsRem", 1);
            map.put("rem", map.get("val"));
          }
          surveyMapper.insertSurveyD(map);

        });

        code.put("code", "SUCCESS");
      }

    }catch(Exception e){
      code.put("code", "FAIL");
      e.printStackTrace();
    }
  }

}