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
}
