package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MemberAccessService {
	List<EgovMap> selectPosition(Map<String, Object> params);

	EgovMap getOrgDtls(Map<String, Object> params);

	List<EgovMap> selectMemberAccessList(Map<String, Object> params);

	EgovMap selectMemberAccessListView(String memberID);

	int checkExistRequest(String memCode);

	public String getFinApprover() throws Exception;

	List<EgovMap> accessApprovalList(Map<String, Object> p);

	int checkExistMemCode(Map<String, Object> params);

	String selectNextRequestID();

	void insertApproveManagement(Map<String, Object> params);

	void updateApproval(Map<String, Object> p);

	int updateAccess(Map<String, Object> p);

	/*void insertApproveMaster(Map<String, Object> params);*/


}
