package com.coway.trust.biz.sales.mambership;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MembershipESvmService {

	List<EgovMap> selectESvmListAjax(Map<String, Object> params);

	EgovMap selectESvmInfo(Map<String, Object> params);

	EgovMap selectMemberByMemberID(Map<String, Object> params);

	List<EgovMap> getESvmAttachList(Map<String, Object> params);

}
