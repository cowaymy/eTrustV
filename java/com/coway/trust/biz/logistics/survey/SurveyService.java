package com.coway.trust.biz.logistics.survey;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**************************************
 * Author   Date                Remark
 * Kit           2019/04/16      Create for Survey Form
 ***************************************/

public interface SurveyService {
  int verifyStatus(Map<String, Object> params,SessionVO sessionVO);

  int isSurveyRequired(Map<String, Object> params,SessionVO sessionVO);

  List<EgovMap> getSurveyTitle(Map<String, Object> params);

  List<EgovMap> getSurveyQues(Map<String, Object> params);

  List<EgovMap> getSurveyAns(Map<String, Object> params);

  void saveSurvey(Map<String, ArrayList<Object>> params, SessionVO sessionVO,Map<String, Object> message);


}
