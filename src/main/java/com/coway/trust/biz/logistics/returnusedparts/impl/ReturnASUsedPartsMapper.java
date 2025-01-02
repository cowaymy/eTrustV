	package com.coway.trust.biz.logistics.returnusedparts.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 18/12/2019    ONGHC      1.0.1       - Create AS Used Filter
 *********************************************************************************************/

@Mapper("returnASUsedPartsMapper")
public interface ReturnASUsedPartsMapper {

  List<EgovMap> returnPartsList(Map<String, Object> params);

  void upReturnParts(Map<String, Object> params);

  void returnPartsCanCle(Map<String, Object> params);

  void returnPartsInsert(String params);

  void returnPartsdelete(String params);

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

  EgovMap getCodyInfo(Map<String, Object> params);

  void upToPendReturnParts(Map<String, Object> params);

  void upToFailedReturnParts(Map<String, Object> params);

  List<EgovMap> selectScanSerialList(Map<String, Object> params);

	void saveScanSerial(Map<String, Object> params);

	void deleteTempScanSerial(Map<String, Object> params);

	String getScanNoSequence(Map<String, Object> params);

	List<EgovMap> checkScanSerial(Map<String, Object> params);

	void upTempScanSerial(Map<String, Object> params);
}
