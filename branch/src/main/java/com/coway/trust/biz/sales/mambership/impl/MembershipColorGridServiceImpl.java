package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipColorGridService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("membershipColorGridService")
public class MembershipColorGridServiceImpl extends EgovAbstractServiceImpl implements MembershipColorGridService {

	@Resource(name = "membershipColorGridMapper")
	private MembershipColorGridMapper membershipColorGridMapper;

	@Override
	public List<EgovMap> membershipColorGridList(Map<String, Object> params) {
		return membershipColorGridMapper.membershipColorGridList(params);
	}

}
