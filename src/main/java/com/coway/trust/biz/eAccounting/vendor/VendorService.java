package com.coway.trust.biz.eAccounting.vendor;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface VendorService {

	List<Object> budgetCheck(Map<String, Object> params);

	List<EgovMap> selectVendorGroup();

	List<EgovMap> selectBank();

	List<EgovMap> selectSAPCountry();

	List<EgovMap> selectVendorList(Map<String, Object> params);

	int checkExistNo(String reqNo);

	String selectMemberID(String selectMemberID);

	String selectNextReqNo();

	String selectNextAppvPrcssNo();

	void insertVendorInfo(Map<String, Object> params);

	void insertApproveManagement(Map<String, Object> params);

	String selectSameVender(Map<String, Object> params);

	int checkExistClmNo(String reqNo);

	EgovMap getFinApprover(Map<String, Object> params);
}
