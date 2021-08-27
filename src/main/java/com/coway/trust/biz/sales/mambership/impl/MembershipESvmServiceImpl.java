package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipESvmService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("membershipESvmService")
public class MembershipESvmServiceImpl extends EgovAbstractServiceImpl implements MembershipESvmService {

	@Resource(name = "membershipESvmMapper")
	private MembershipESvmMapper membershipESvmMapper;

	@Override
	public List<EgovMap> selectESvmListAjax(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmListAjax(params);
	}

	@Override
	public EgovMap selectESvmInfo(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmInfo(params);
	}

	@Override
	public EgovMap selectMemberByMemberID(Map<String, Object> params) {
		return membershipESvmMapper.selectMemberByMemberID(params);
	}

	@Override
	public List<EgovMap> getESvmAttachList(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmAttachList(params);
	}
}
