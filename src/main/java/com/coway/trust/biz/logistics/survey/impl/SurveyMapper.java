/**************************************
 * Author	Date				Remark
 * Kit           2019/04/16      Create for Survey Form
 ***************************************/
package com.coway.trust.biz.logistics.survey.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SurveyMapper")
public interface SurveyMapper
{
  int verifyStatus(Map<String, Object> params);

  EgovMap isSurveyRequired(Map<String, Object> params);

  List<EgovMap> getSurveyTitle(Map<String, Object> params);

  List<EgovMap> getSurveyQues(Map<String, Object> params);

  List<EgovMap> getSurveyAns(Map<String, Object> params);

  int selectSurveyMSeq();

  int getSurveyTypeId();

  void insertSurveyM(Map<String, Object> params);

  void insertSurveyD(Map<String, Object> params);

}