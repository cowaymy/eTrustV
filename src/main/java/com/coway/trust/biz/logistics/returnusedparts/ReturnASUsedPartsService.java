	package com.coway.trust.biz.logistics.returnusedparts;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 18/12/2019    ONGHC      1.0.1       - Create AS Used Filter
 *********************************************************************************************/

public interface ReturnASUsedPartsService {

  List<EgovMap> returnPartsList(Map<String, Object> params);

  void returnPartsUpdate(Map<String, Object> params, int loginId);

  void returnPartsCanCle(Map<String, Object> params);

  void returnPartsInsert(String param);

  void returnPartsdelete(String param);

  int validMatCodeSearch(String matcode);

  int returnPartsdupchek(Map<String, Object> insMap);

  List<EgovMap> selectBranchCodeList(Map<String, Object> params);

  List<EgovMap> getBchBrowse(Map<String, Object> params);

  List<EgovMap> getDeptCodeList(Map<String, Object> params);

  List<EgovMap> getCodyCodeList(Map<String, Object> params);

  List<EgovMap> getLoc(Map<String, Object> params);

  List<EgovMap> getDefGrp(Map<String, Object> params);

  List<EgovMap> getSltCde(Map<String, Object> params);

  List<EgovMap> getProdCat(Map<String, Object> params);

  List<EgovMap> getdefCde(Map<String, Object> params);

  List<EgovMap> getRptType();

  List<EgovMap> getRtnStat();

  Map<String, Object> returnPartsUpdatePend(Map<String, Object> params, int loginId);

  Map<String, Object> returnPartsUpdateFailed(Map<String, Object> params, int loginId);

List<EgovMap> selectScanSerialInPop(Map<String, Object> params);

void saveReturnUsedSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

void deleteSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

List<Object> saveReturnBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

EgovMap getCodyInfo(Map<String, Object> params);

}
