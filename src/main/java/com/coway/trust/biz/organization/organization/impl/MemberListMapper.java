package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("memberListMapper")
public interface MemberListMapper {


	List<EgovMap> nationality();

	List<EgovMap> selectStatus();

	//By KV start - Position
	List<EgovMap> selectPosition(Map<String, Object> params);
	//By KV end - Position

	//By KV start -ReplacementCT
	List<EgovMap> selectReplaceCTList(Map<String, Object> params);
	//By KV end - ReplacementCT

	List<EgovMap> selectUserBranch();

	List<EgovMap> selectUser();

	List<EgovMap> selectMemberList(Map<String, Object> params);

	List<EgovMap> selectHPApplicantList(Map<String, Object> params);

	EgovMap selectMemberListView(Map<String, Object> params);
	
	EgovMap getHPMemberListView(Map<String, Object> params);

	List<EgovMap> selectPromote(Map<String, Object> params);

	List<EgovMap> selectDocSubmission(Map<String, Object> params);

	List<EgovMap> selectPaymentHistory(Map<String, Object> params);

	List<EgovMap> selectRenewalHistory(Map<String, Object> params);

	List<EgovMap> selectDocSubmission2(Map<String, Object> params);

	List<EgovMap> selectIssuedBank();

	EgovMap selectApplicantConfirm(Map<String, Object> params);

	EgovMap selectCodyPAExpired(Map<String, Object> params);

	String saveMember(Map<String, Object> params) ;

	EgovMap selectDocNo(String code);

	void updateDocNo(Map<String, Object> params);

	void insertMember(Map<String, Object> params);

	EgovMap selectOranization(Map<String, Object> params);

	String selectMemberId( Map<String, Object> params);

	String selectLastGroupCode(Map<String, Object> params);

	void insertOrganization(Map<String, Object> params);

	void insertAccBill(Map<String, Object> params);

	void insertAccOrderBill(Map<String, Object> params);

	EgovMap selectMiscList(Map<String, Object> params);

	void insertInvMISC(Map<String, Object> params);

	void insertInvMISCD(Map<String, Object> params);

	void updateBillRem(Map<String, Object> params);

	void insertUser(Map<String, Object> params);

	void insertRoleUser(Map<String, Object> params);

	void insertMemApp(Map<String, Object> params);

	void insertMemberAgr(Map<String, Object> params);

	void insertinvWH(Map<String, Object> params);

	List<EgovMap> selectCodyDocSubmission(Map<String, Object> params);

	List<EgovMap> selectHpDocSubmission(Map<String, Object> params);

	void insertDocSubmission(Map<String, Object> params);

	void insertSmsEntry(Map<String, Object> params);

	void insertSmsReply(Map<String, Object> params);

	EgovMap selectMember(Map<String, Object> params);

	EgovMap  selectOrganization(Map<String, Object> params);

	EgovMap  selectMemberOrgs(Map<String, Object> params);

	void updateOrganization(Map<String, Object> params);

	void insertPromoEntry(Map<String, Object> params);

	/*by KV start  insert request vacation */
	void insertVacationEntry(Map<String, Object> params);
	/*by KV end  insert request vacation */

	void updateMember(Map<String, Object> params);

	EgovMap selectUserName(Map<String, Object> params);

	void updateUser(Map<String, Object> params);

	List<EgovMap> selectSuperiorTeam(Map<String, Object> params);

	List<EgovMap> selectDeptCode(Map<String, Object> params);

	List<EgovMap> selectCourse();


	EgovMap getDocNo(Map<String, Object> params);



	int traineeUpdate(Map<String, Object> params);
	int hpMemRegister(Map<String, Object> params);
	
	EgovMap afterSelTrainee(Map<String, Object> params);

	List<EgovMap> getMemberListView(Map<String, Object> params);

	int memberListUpdate_user(Map<String, Object> params);

	int memberListUpdate_memorg(Map<String, Object> params);

	int memberListUpdate_member(Map<String, Object> params);
	
	int traineeUpdateInfo(Map<String, Object> params);
	
	int traineeInsertInfor(Map<String, Object> params);

	void saveDocSubmission(DocSubmissionVO docSubmissionVO);

	void updateDocSubmissionDel(DocSubmissionVO docSubmissionVO);

	List<EgovMap> selectDeptCodeHp(Map<String, Object> params);

	EgovMap selectHpOranization(Map<String, Object> params);
	
	void updateHpApproval(Map<String, Object> params);
	
	public List<EgovMap> selectMainDept();
	
	public List<EgovMap> selectSubDept(Map<String, Object> params);
	
	public List<EgovMap> getDeptCdListList(Map<String, Object> params);

	List<EgovMap> getSpouseInfoView(Map<String, Object> params);	
	
	List<EgovMap> selectCoureCode(Map<String, Object> params);
	
	String selectTypeGroupCode(Map<String, Object> params);
	
	EgovMap selectORG001DInfo(String MemberId);
	
	public List<EgovMap> selectDepartmentCodeLit(Map<String, Object> params);
	
	public List<EgovMap> selectBranchCodeLit(Map<String, Object> params);

	EgovMap selectLastCode(Map<String, Object> lastCode);

	
	String  getORG0001D_SEQ(Map<String, Object> params);
	

	List<EgovMap> checkNRIC1(Map<String, Object> params);

	List<EgovMap> checkNRIC2(Map<String, Object> params);

	List<EgovMap> checkNRIC3(Map<String, Object> params);

	// modify jgkim
	EgovMap checkSponsor(Map<String, Object> params);

	List<EgovMap> selectBusinessType();
	
}
