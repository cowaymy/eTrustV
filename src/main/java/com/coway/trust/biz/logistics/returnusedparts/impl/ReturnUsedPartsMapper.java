package com.coway.trust.biz.logistics.returnusedparts.impl;

import java.util.List;
import java.util.Map;

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
	
}
