package com.coway.trust.biz.organization.organization;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.organization.organization.vo.MemberListVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
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

	String selectLastGroupCode(Map<String, Object> params);

	EgovMap selectMemberListView(Map<String, Object> params);
	EgovMap selectHPMemberListView(Map<String, Object> params);

	//<EgovMap> selectMemberTab(Map<String, Object> params);
	List<EgovMap> selectPromote(Map<String, Object> params);

	List<EgovMap> selectDocSubmission(Map<String, Object> params);

	List<EgovMap> selectPaymentHistory(Map<String, Object> params);

	List<EgovMap> selectRenewalHistory(Map<String, Object> params);

	List<EgovMap> selectDocSubmission2(Map<String, Object> params);

	List<EgovMap> selectIssuedBank();

	EgovMap selectApplicantConfirm(Map<String, Object> params);

	EgovMap selectCodyPAExpired(Map<String, Object> params);

	String saveMember(Map<String, Object> params, List<Object> docType, SessionVO sessionVO);

	List<EgovMap> selectCodyDocSubmission(Map<String, Object> params);

	List<EgovMap> selectHpDocSubmission(Map<String, Object> params);

	Map<String, Object> insertTerminateResign(Map<String, Object> params,SessionVO sessionVO);

	/* BY KV start Do Save Vacation Request*/
	Map<String, Object> insertRequestVacation(Map<String, Object> params, SessionVO sessionVO);
	/* BY KV end Do Save Vacation Request*/

	List<EgovMap> selectSuperiorTeam(Map<String, Object> params);

	List<EgovMap> selectDeptCode(Map<String, Object> params);

	List<EgovMap> selectCourse();

	Map<String, Object> traineeUpdate(Map<String, Object> params,SessionVO sessionVO);

	Map<String, Object> hpMemRegister(Map<String, Object> params,SessionVO sessionVO);


	List<EgovMap> getMemberListView(Map<String, Object> params);

	int memberListUpdate_user(Map<String, Object> params);

	int memberListUpdate_memorg(Map<String, Object> params);

	int memberListUpdate_memorg2(Map<String, Object> params);

	/*By KV - for service capacity update data purpose*/
	int memberListUpdate_memorg3(Map<String, Object> params);

	int memberListUpdate_member(Map<String, Object> params);

	int traineeUpdateInfo(Map<String, Object> params,SessionVO sessionVO);

	boolean updateMember(Map<String, Object> params, List<Object> docType,SessionVO sessionVO);

	void saveDocSubmission(MemberListVO memberListVO,Map<String, Object> params, SessionVO sessionVO) throws Exception;

	List<EgovMap> selectDeptCodeHp(Map<String, Object> params);

	List<EgovMap> selectHPApplicantList(Map<String, Object> params);

	List<EgovMap> getMainDeptList();

	List<EgovMap> getSubDeptList(Map<String, Object> params);

	List<EgovMap> getDeptCdListList(Map<String, Object> params);

	List<EgovMap> getSpouseInfoView(Map<String, Object> params);

	List<EgovMap> selectCoureCode(Map<String, Object> params);

	String selectTypeGroupCode(Map<String, Object> params);

	List<EgovMap> selectDepartmentCodeLit(Map<String, Object> params);

	List<EgovMap> selectBranchCodeLit(Map<String, Object> params);

	List<EgovMap> checkNRIC1(Map<String, Object> params);

	List<EgovMap> checkNRIC2(Map<String, Object> params);

	List<EgovMap> checkNRIC3(Map<String, Object> params);

	// modify jgkim
	EgovMap checkSponsor(Map<String, Object> params);

	List<EgovMap> selectBusinessType();

	List<EgovMap> getHpMemberView(Map<String, Object> params);

	EgovMap selectOneHPMember(Map<String, Object> params);

	int hpMemberUpdate(Map<String, Object> formMap);

	List<EgovMap> branch();

	void updateMemberBranch(Map<String, Object> params) throws Exception;
	void updateMemberBranch2(Map<String, Object> params) throws Exception;

	void updateDocSub(List<Object> updList, String memId, int userId , String memType);

	void memberCodyPaUpdate(Map<String, Object> formMap);

	void MemberValidateUpdate(Map<String,Object> formMap);

	boolean updateHpApprovalReject(Map<String, Object> params);

	List<EgovMap> selectMemberType(Map<String, Object> params);

	List<EgovMap> selectSponBrnchList(Map<String, Object> params);

	List<EgovMap> selectSponMemberSearch(Map<String, Object> params);

	void insertDocSub(List<Object> updList, String memCode, int userId, String memberType, String trainType);

	EgovMap memberListService(Map<String, Object> params);

	void updateDocSubWhenAppr(Map<String, Object> params, SessionVO sessionVO);

	EgovMap selectAreaInfo(Map<String, Object> params);

	List<EgovMap> selectAllBranchCode();

	EgovMap validateHpStatus(Map<String, Object> params);

    void updateHpCfm(Map<String, Object> params) throws Exception;

    EgovMap getHPCtc(Map<String, Object> params);

    EgovMap verifyAccess(Map<String, Object> params);

    EgovMap checkBankAcc(Map<String, Object> params);

    EgovMap getUserRole(Map<String, Object> params);

	EgovMap selectMemberValidDate(Map<String, Object> params);

    void updateCodyCfm(Map<String, Object> params) throws Exception;

	int UpdateMemberValidate(Map<String, Object> params);

	EgovMap getOrgDtls(Map<String, Object> params);

	EgovMap getCDInfo(Map<String, Object> params);

	List<EgovMap> selectHpMeetPoint();
}
