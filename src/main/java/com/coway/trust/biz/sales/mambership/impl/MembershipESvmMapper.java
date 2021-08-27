package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("membershipESvmMapper")
public interface MembershipESvmMapper {

	List<EgovMap> selectESvmListAjax(Map<String, Object> params);

	EgovMap selectESvmInfo(Map<String, Object> params);

	EgovMap selectMemberByMemberID(Map<String, Object> params);

	List<EgovMap> selectESvmAttachList(Map<String, Object> params);

	int selectNextFileId();

	void insertFileDetail(Map<String, Object> flInfo);

}
