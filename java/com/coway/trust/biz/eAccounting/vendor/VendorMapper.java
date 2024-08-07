package com.coway.trust.biz.eAccounting.vendor;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("vendorMapper")
public interface VendorMapper {

	String budgetCheck(Map<String, Object> params);

	List<EgovMap> selectCodeList( Map<String, Object> params) throws Exception;

	List<EgovMap> selectVendorGroup();

	List<EgovMap> selectBank();

	List<EgovMap> selectSAPCountry();

	List<EgovMap> selectVendorList(Map<String, Object> params);

	int checkExistNo(String regCompNo);

	String selectMemberCode(String memId);

	String selectNextReqNo();

	String selectNextAppvPrcssNo();

	String selectSameVender(Map<String, Object> params);

	void insertVendorInfo(Map<String, Object> params);

	void insertApproveManagement(Map<String, Object> params);

	void insertApproveLineDetail(Map<String, Object> params);

	void insMissAppr(Map<String, Object> params);

	void insertNotification(Map<String, Object> params);

	void insertApproveItems(Map<String, Object> params);

	void updateAppvPrcssNo(Map<String, Object> params);

	int checkExistClmNo(String clmNo);

	int checkExistPaymentType(Map<String, Object> params);

	int checkExistBankListNo(Map<String, Object> params);

	int checkExistBankAccNo(Map<String, Object> params);

	String selectExistBankAccNo(Map<String, Object> params);

	EgovMap getFinApprover(Map<String, Object> params);

	EgovMap getClmDesc(Map<String, Object> params);

	EgovMap getNtfUser(Map<String, Object> params);

	EgovMap selectVendorInfo(String reqNo);

	EgovMap selectVendorInfoMaster(String vendorAccId);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	String checkReqNo(Map<String, Object> params);

	void updateVendorInfo(Map<String, Object> params);

	void insertVendorInterface(Map<String, Object> params);

	void insertApprovedDraft(Map<String, Object> params);

	// Edit Rejected functions - 20210624 - Start
	EgovMap getAttachmenDetails(Map<String, Object> params);

	int getFileAtchGrpId();
	int getFileAtchId();

	void insertSYS0070M_ER(Map<String, Object> params);
	void insertSYS0071D_ER(Map<String, Object> params);

	void insertRejectM(Map<String, Object> params);
	// Edit Rejected functions - 20210624 - End

	EgovMap existingVendorValidation(Map<String, Object> params);
}
