package com.coway.trust.biz.ResearchDevelopment;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface UsedPartReTestResultService {

	  List<EgovMap> selectUsedPartReList(Map<String, Object> params);

	  List<EgovMap> getTestResultInfo(Map<String, Object> params);

	  EgovMap selectOrderBasicInfo(Map<String, Object> params);

	  EgovMap getAsEventInfo(Map<String, Object> params);

	  String getSearchDtRange();

	  List<EgovMap> asProd();

	  List<EgovMap> selectAsCrtStat();

	  List<EgovMap> selectTimePick();

	  int isReTestAlreadyResult(HashMap<String, Object> mp);

	  EgovMap usedPartReTestResult_insert(Map<String, Object> params);

	  EgovMap usedPartReTestResult_update(Map<String, Object> params);

}
