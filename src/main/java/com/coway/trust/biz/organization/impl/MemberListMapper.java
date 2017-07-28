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
}
