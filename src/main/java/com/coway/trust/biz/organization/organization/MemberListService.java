package com.coway.trust.biz.organization.organization;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MemberListService {

	List<EgovMap> nationality();

	List<EgovMap> selectStatus();

	/*By KV start - Position*/
	List<EgovMap> selectPosition(Map<String, Object> params);
	/*By KV end  - Position*/

	/*By KV start - ReplacementCT*/
	List<EgovMap> selectReplaceCTList(Map<String, Object> params);
	/*By KV end  - ReplacementCT*/

	List<EgovMap> selectUserBranch();

	List<EgovMap> selectUser();

	List<EgovMap> selectMemberList(Map<String, Object> params);

	EgovMap selectMemberListView(Map<String, Object> params);

	//<EgovMap> selectMemberTab(Map<String, Object> params);
	List<EgovMap> selectPromote(Map<String, Object> params);

	List<EgovMap> selectDocSubmission(Map<String, Object> params);

	List<EgovMap> selectPaymentHistory(Map<String, Object> params);

	List<EgovMap> selectRenewalHistory(Map<String, Object> params);

	List<EgovMap> selectDocSubmission2(Map<String, Object> params);

	List<EgovMap> selectIssuedBank();

	EgovMap selectApplicantConfirm(Map<String, Object> params);

	EgovMap selectCodyPAExpired(Map<String, Object> params);

	String saveMember(Map<String, Object> params, List<Object> docType);

	List<EgovMap> selectCodyDocSubmission(Map<String, Object> params);

	List<EgovMap> selectHpDocSubmission(Map<String, Object> params);

	Map<String, Object> insertTerminateResign(Map<String, Object> params,SessionVO sessionVO);

	List<EgovMap> selectSuperiorTeam(Map<String, Object> params);

	List<EgovMap> selectDeptCode(Map<String, Object> params);

	List<EgovMap> selectCourse();


}
