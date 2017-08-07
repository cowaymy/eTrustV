package com.coway.trust.biz.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("memberListMapper")
public interface MemberListMapper {

	
	List<EgovMap> nationality();
	
	List<EgovMap> selectStatus();
	
	List<EgovMap> selectUserBranch();
	
	List<EgovMap> selectUser();
	
	List<EgovMap> selectMemberList(Map<String, Object> params);
	
	EgovMap selectMemberListView(Map<String, Object> params);
	
	List<EgovMap> selectPromote(Map<String, Object> params);
	
	List<EgovMap> selectDocSubmission(Map<String, Object> params);
	
	List<EgovMap> selectPaymentHistory(Map<String, Object> params);
	
	List<EgovMap> selectRenewalHistory(Map<String, Object> params);
	
	List<EgovMap> selectDocSubmission2(Map<String, Object> params);
	
	List<EgovMap> selectIssuedBank();
	
	EgovMap selectApplicantConfirm(Map<String, Object> params);
	
	EgovMap selectCodyPAExpired(Map<String, Object> params);
	
	String saveMember(Map<String, Object> params) ;
	
	EgovMap selectDocNo(String code);
	
	void updateDocNo(Map<String, Object> params);
	
	void insertMember(Map<String, Object> params);
	
	EgovMap selectOranization(Map<String, Object> params);
	
	String selectMemberId();
	
	void insertOrganization(Map<String, Object> params);
	
	void insertAccBill(Map<String, Object> params);
	
	void insertAccOrderBill(Map<String, Object> params);
	
	EgovMap selectMiscList(Map<String, Object> params);
	
	String insertInvMISC(Map<String, Object> params);
	
	void insertInvMISCD(Map<String, Object> params);
	
	void updateBillRem(Map<String, Object> params);
	
	void insertUser(Map<String, Object> params);
	
	void insertRoleUser(Map<String, Object> params);
	
	
	
}
