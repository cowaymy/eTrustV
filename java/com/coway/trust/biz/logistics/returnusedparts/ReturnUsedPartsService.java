package com.coway.trust.biz.logistics.returnusedparts;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ReturnUsedPartsService {

	List<EgovMap> returnPartsList(Map<String, Object> params);
		
	void returnPartsUpdate(Map<String, Object> params,int loginId);
	
	void returnPartsCanCle(Map<String, Object> params);
	
	//테스트 인서트 딜리트
	void returnPartsInsert(String param);
	
	void returnPartsdelete(String param);
	
	int validMatCodeSearch(String matcode);
	
	int returnPartsdupchek(Map<String, Object> insMap);
	
	List<EgovMap> selectBranchCodeList(Map<String, Object> params);
	
	List<EgovMap> getDeptCodeList(Map<String, Object> params);
	
	List<EgovMap> getCodyCodeList(Map<String, Object> params);

	List<EgovMap> selectSelectedBranchCodeList(Map<String, Object> params);

	Map<String, Object> returnPartsUpdatePend(Map<String, Object> params,int loginId);

	List<EgovMap> selectScanSerialInPop(Map<String, Object> params);

	public void deleteGridSerial(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	public void deleteSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public List<Object> saveReturnBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	void saveReturnUsedSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	Map<String, Object> returnPartsUpdateFailed(Map<String, Object> params,int loginId);

}
