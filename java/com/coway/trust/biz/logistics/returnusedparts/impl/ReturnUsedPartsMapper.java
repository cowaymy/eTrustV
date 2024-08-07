package com.coway.trust.biz.logistics.returnusedparts.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("returnUsedPartsMapper")
public interface ReturnUsedPartsMapper {

	List<EgovMap> returnPartsList(Map<String, Object> params);
	
	void upReturnParts(Map<String, Object> params);
	
	void returnPartsCanCle(Map<String, Object> params);

	//테스트 인서트 딜리트
	
	void returnPartsInsert(String params);
	
	void returnPartsdelete(String params);
	
	int validMatCodeSearch(String matcode);
	
	int returnPartsdupchek(Map<String, Object> insMap);
	
	List<EgovMap> selectBranchCodeList(Map<String, Object> params);
	
	List<EgovMap> getDeptCodeList(Map<String, Object> params);
	
	List<EgovMap> getCodyCodeList(Map<String, Object> params);

	List<EgovMap> selectSelectedBranchCodeList(Map<String, Object> params);

	void upToPendReturnParts(Map<String, Object> params);

	List<EgovMap> selectScanSerialList(Map<String, Object> params);

	List<EgovMap> checkScanSerial(Map<String, Object> params);

	String getScanNoSequence(Map<String, Object> params);

	void upTempScanSerial(Map<String, Object> params);

	void deleteTempScanSerial(Map<String, Object> params);

	void saveScanSerial(Map<String, Object> params);

	void upToFailedReturnParts(Map<String, Object> params);

}
