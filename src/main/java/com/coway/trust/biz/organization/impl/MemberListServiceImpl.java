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
	
}
