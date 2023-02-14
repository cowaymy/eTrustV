package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("memberEligibilityMapper")
public interface MemberEligibilityMapper {
	List<EgovMap> selectMemberEligibility(Map<String, Object> params);

	EgovMap getMemberInfo(Map<String, Object> params);

	EgovMap getMemberRejoinInfo(Map<String, Object> params);

	void submitMemberRejoin(Map<String, Object> params);

	List<EgovMap> getPICEmail(Map<String, Object> params);
}
