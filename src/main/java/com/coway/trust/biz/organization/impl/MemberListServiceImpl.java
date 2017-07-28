package com.coway.trust.biz.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.MemberListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberListService")


public class MemberListServiceImpl extends EgovAbstractServiceImpl implements MemberListService{
	
	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;
	
	/**
	 * search Organization Gruop List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> nationality() {
		return memberListMapper.nationality();
	}

	public List<EgovMap> selectStatus() {
		return memberListMapper.selectStatus();
	}

	public List<EgovMap> selectUserBranch() {
		return memberListMapper.selectUserBranch();
	}
	
	public List<EgovMap> selectUser() {
		return memberListMapper.selectUser();
	}

	public List<EgovMap> selectMemberList(Map<String, Object> params) {
		return memberListMapper.selectMemberList(params);
	}

	@Override
	public EgovMap selectMemberListView(Map<String, Object> params) {
		return memberListMapper.selectMemberListView(params);
	}
	
	@Override
	public List<EgovMap> selectDocSubmission(Map<String, Object> params) {
		return memberListMapper.selectDocSubmission(params);
	}
	@Override
	public List<EgovMap> selectPromote(Map<String, Object> params) {
		return memberListMapper.selectPromote(params);
	}

	@Override
	public List<EgovMap> selectPaymentHistory(Map<String, Object> params) {
		return memberListMapper.selectPaymentHistory(params);
	}
	
	@Override
	public List<EgovMap> selectRenewalHistory(Map<String, Object> params) {
		return memberListMapper.selectRenewalHistory(params);
	}
	
	@Override
	public List<EgovMap> selectDocSubmission2(Map<String, Object> params) {
		return memberListMapper.selectDocSubmission2(params);
	}
	
	@Override
	public List<EgovMap> selectIssuedBank() {
		return memberListMapper.selectIssuedBank();
	}
	
	@Override
	public EgovMap selectApplicantConfirm(Map<String, Object> params) {
		return memberListMapper.selectApplicantConfirm(params);
	}
	
	@Override
	public EgovMap selectCodyPAExpired(Map<String, Object> params) {
		return memberListMapper.selectCodyPAExpired(params);
	}
	
}
