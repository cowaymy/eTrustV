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

	int checkExistNo(String regCompNo);

	int checkExistPaymentType(Map<String, Object> params);

	int checkExistBankListNo(Map<String, Object> params);

	int checkExistBankAccNo(Map<String, Object> params);

	String selectExistBankAccNo(Map<String, Object> params);

	String selectMemberCode(String memId);

	String selectNextReqNo();

	String selectNextAppvPrcssNo();

	void insertVendorInfo(Map<String, Object> params);

	void insertApproveManagement(Map<String, Object> params);

	String selectSameVender(Map<String, Object> params);

	int checkExistClmNo(String reqNo);

	EgovMap getFinApprover(Map<String, Object> params);

	EgovMap selectVendorInfo(String reqNo);

	EgovMap selectVendorInfoMaster(String vendorAccId);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	String checkReqNo(Map<String, Object> params);

	void updateVendorInfo(Map<String, Object> params);

	void editRejected(Map<String, Object> params);

	void editApproved(Map<String, Object> params);

	EgovMap existingVendorValidation(Map<String, Object> params);
}
