package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("memberListMapper")
public interface MemberListMapper {

	void insertFileDetail(Map<String, Object> flInfo);

	void insertFileGroup(FileGroupVO fileGroupVO);

	int selectNextFileId();

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

	int memberListUpdate_memorg2(Map<String, Object> params);

	/*By KV - for service capacity update data purpose*/
	int memberListUpdate_memorg3(Map<String, Object> params);

	int memberListUpdate_member(Map<String, Object> params);

	int updateMemberName(Map<String, Object> params);

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

	EgovMap getOwnPurcOutsInfo(Map<String, Object> params);

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

	List<EgovMap> selectMemberInfo(Map<String, Object> params);

	List<EgovMap> selectMemberApprovalInfo(Map<String, Object> params);

	void updateMemberStatus(Map<String, Object> params);

	// modify jgkim
	EgovMap checkSponsor(Map<String, Object> params);

	List<EgovMap> selectBusinessType();

	List<EgovMap> selectParentIdFrom(Map<String, Object> parentEntry);

	List<EgovMap> selectParentDCFrom(Map<String, Object> parentDCFEntry);

	List<EgovMap> selectHpMemberView(Map<String, Object> params);

	EgovMap selectOneHPMember(Map<String, Object> params);

	int updateHpMember(Map<String, Object> formMap);

	List<EgovMap> branch();

	void updateMemberBranch(Map<String, Object> params);
	void updateMemberBranch2(Map<String, Object> params);

	EgovMap selectOneDocSub(Map<String, Object> oneDocSub);

	void updateDocSub(Map<String, Object> oneDocSub);

	void insertDocSub(Map<String, Object> oneDocSub);

	void deleteDocSub(Map<String, Object> oneDocSub);

	EgovMap selectNricExist(Map<String, Object> params);

	void updateCodyPaDate(Map<String, Object> params);

	EgovMap selectRejoin(Map<String, Object> params);

	void updateMemberValidateDt(Map<String, Object> params);

	int updateHpApprovalReject(Map<String, Object> params);

	List<EgovMap> selectMemberType(Map<String, Object> params);

	List<EgovMap> selectSponBrnchList(Map<String, Object> params);

	List<EgovMap> selectSponMemberSearch(Map<String, Object> params);

	EgovMap getMemIdwithCode(Map<String, Object> getMap);

	EgovMap selectTrainType(Map<String, Object> oneDocSub);

	void updateDocSubWhenApproval(Map<String, Object> params);

	Map<String, Object> SP_DAY_USER_CRT(Map<String, Object> param);

	EgovMap selectAreaInfo(Map<String, Object> params);

	void SP_SVC_LOG_SYS0028M(Map<String, Object> logPram);

	List<EgovMap> selectAllBranchCode();

	EgovMap validateHpStatus(Map<String, Object> params);

	void updateHpCfm(Map<String, Object> params) throws Exception;

	EgovMap getHPCtc(Map<String, Object> params);

	EgovMap verifyAccess(Map<String, Object> params);

	EgovMap getApplicantDetails(Map<String, Object> params);

	EgovMap checkBankAcc(Map<String, Object> params);

	EgovMap getUserRole(Map<String, Object> params);

	//EgovMap getCDDtls(Map<String, Object> params);

	EgovMap selectMemberValidDate(Map<String, Object> params);

    void updateCodyCfm(Map<String, Object> params) throws Exception;

    void updateMobileUse(Map<String, Object> params) throws Exception;

    EgovMap getCDInfo(Map<String, Object> params);

    void updateCodyAplCde(Map<String, Object> params);

    EgovMap getCdAplId(Map<String, Object> params);

	int updateMemberValidate(Map<String, Object> params);

	void insertORG03D(Map<String, Object> params);

    EgovMap getOrgDtls(Map<String, Object> params);

    List<EgovMap> selectHpMeetPoint();

    EgovMap getAplcntId();

    void updateCdApl(Map<String, Object> params);

    void updateCdAplCody(Map<String, Object> params);

    void updateMeetpoint(Map<String, Object> params);

	List<EgovMap> selectMemberTypeHP(Map<String, Object> params);

	List<EgovMap> selectApprovalBranch(Map<String, Object> params);

	EgovMap checkAccLen(Map<String, Object> params);

	List<EgovMap> selectAccBank(Map<String, Object> params);

	//void updateAplctDtls(Map<String, Object> params);

	// LaiKW - Comment starts here
	int memberListUpdate_SYS47(Map<String, Object> params);
	int memberListUpdate_ORG05(Map<String, Object> params);
	int memberListUpdate_ORG01(Map<String, Object> params);
	int memberListUpdate_ORG03(Map<String, Object> params);
	int memberListUpdate_MSC09(Map<String, Object> params);
	int memberListUpdate_ORG15(Map<String, Object> params);
	int memberListUpdate_ORG02(Map<String, Object> params);

	EgovMap selectMemCourse(Map<String, Object> params);

	int checkMemCode(Map<String, Object> params);
	// LaiKW - Comment ends here

	List<EgovMap> selectTraining(Map<String, Object> params);

	int getNextMPID();
	List<EgovMap> searchMP(Map<String, Object> params);
	int addMeetingPoint(Map<String, Object> params);
    int updMeetingPoint(Map<String, Object> params);
    int updHPMeetingPoint(Map<String, Object> params) throws Exception;

    String getUpdUserID(Map<String, Object> params);
    int updateOrgUserPW(Map<String, Object> params);

    int getRookie(Map<String, Object> params);
    int getOrientation(Map<String, Object> params);
    void insertHPorientation(Map<String, Object> params);

    String  getUserID(String params);

    EgovMap getCurrOrgDtls(Map<String, Object> params);

	List<EgovMap> selectPromoDisHistory(Map<String, Object> params);

	EgovMap checkIncomeTax(Map<String, Object> params);

	EgovMap validateVaccineDeclarationStatus(Map<String, Object> params);

	EgovMap getVaccineDeclarationMemDetails(Map<String, Object> params);

	void updateVaccineDeclaration(Map<String, Object> params) throws Exception;

	List<EgovMap> selectTrApplByEmail(Map<String, Object> params);

	void updateMemberEmail(Map<String, Object> params);

	EgovMap selectSocialMedia(Map<String, Object> params);

	void updateSocialMedia(Map<String, Object> params) throws Exception;

	List<EgovMap> selectHTOrgCode(Map<String, Object> params);

	List<EgovMap> selectHTGroupCode(Map<String, Object> params);

	List<EgovMap> selectHTDeptCode(Map<String, Object> params);

	List<EgovMap> selectStatusList(Map<String, Object> params);

	List<EgovMap> selectPositionList(Map<String, Object> params);

	List<EgovMap> selectMemberWorkingHistory(Map<String, Object> params);

	List<EgovMap> selectHpRegistrationOption(Map<String, Object> params);

	int selectCntMemSameEmail(Map<String, Object> params);

	String selectHpRegOptionId(Map<String, Object> params);

	int selectRegisPrice(String regOptionId);

	int insertMfaResetRequest(Map<String, Object> p);

	int selectCurrRequestId();

	int insertMfaApprovalLine(Map<String, Object> p);

	List<EgovMap> mfaResetList(Map<String, Object> p);

	void updateMFAApproval(Map<String, Object> p);

	int resetMfa(Map<String, Object> p);

	int insertResetMfaHistory(Map<String, Object> p);

	List<EgovMap> getMfaResetHist(Map<String, Object> params);

	List<EgovMap> checkEmail(Map<String, Object> params);

    /**
     * Get State List (Magic Address)
     *
     * @param params
     * @exception Exception
     * @author
     */
    List<EgovMap> selectMagicAddressComboList(Map<String, Object> params) throws Exception;

}
