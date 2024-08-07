package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("memberApprovalMapper")
public interface MemberApprovalMapper {
	List<EgovMap> selectMemberApproval(Map<String, Object> params);

	EgovMap selectAttachDownload(Map<String, Object> params);

	void submitMemberApproval(Map<String, Object> params);
}
