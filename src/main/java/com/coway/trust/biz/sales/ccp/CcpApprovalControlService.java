package com.coway.trust.biz.sales.ccp;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpApprovalControlService {

	List<EgovMap> selectProductControlList(Map<String, Object> params)throws Exception;

	void saveProductionControl(Map<String, ArrayList<Object>> params, int userId);

  List<EgovMap> selectChsControlList(Map<String, Object> params) throws Exception;

  void saveChsControl(Map<String, ArrayList<Object>> params, int userId);

  List<EgovMap> selectScoreRangeControlList(Map<String, Object> params) throws Exception;

  void saveScoreRangeControl(Map<String, ArrayList<Object>> params, int userId);

  EgovMap getScoreRangeControl(Map<String, Object> params);

  void submitScoreRange(Map<String, Object> params);

  List<EgovMap> selectUnitEntitleControlList(Map<String, Object> params);

  void saveUnitEntitle(Map<String, ArrayList<Object>> params, int userId);

  List<EgovMap> selectProdEntitleControlList(Map<String, Object> params);

  void saveProdEntitle(Map<String, ArrayList<Object>> params, int userId);
}
