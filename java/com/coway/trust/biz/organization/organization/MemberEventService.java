package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MemberEventService {

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrganizationEventVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> reqPersonComboList();

	List<EgovMap> reqStatusComboList();

	List<EgovMap> selectOrganizationEventList(Map<String, Object> params);

	EgovMap getMemberEventDetailPop(Map<String, Object> params);
	
	List<EgovMap> selectPromteDemoteList(Map<String, Object> params);
	
	boolean selectMemberPromoEntries(Map<String, Object> params);
	
	EgovMap getAvailableChild(Map<String, Object> params);

	
}
