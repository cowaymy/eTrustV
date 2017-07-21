package com.coway.trust.biz.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MemberListService {
	
	List<EgovMap> nationality();
	
	List<EgovMap> selectStatus();
	
	List<EgovMap> selectUserBranch();
	
	List<EgovMap> selectUser();
	
	List<EgovMap> selectMemberList(Map<String, Object> params);
}
