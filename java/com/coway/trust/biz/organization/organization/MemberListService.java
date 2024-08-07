package com.coway.trust.biz.organization.organization;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.vo.MemberListVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
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

	String saveMember(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) throws Exception;

	List<EgovMap> selectCodyDocSubmission(Map<String, Object> params);

	List<EgovMap> selectHpDocSubmission(Map<String, Object> params);

	Map<String, Object> insertTerminateResign(Map<String, Object> params,SessionVO sessionVO) throws Exception;

	/* BY KV start Do Save Vacation Request*/
	Map<String, Object> insertRequestVacation(Map<String, Object> params, SessionVO sessionVO);
	/* BY KV end Do Save Vacation Request*/

	List<EgovMap> selectSuperiorTeam(Map<String, Object> params);

	List<EgovMap> selectDeptCode(Map<String, Object> params);

	List<EgovMap> selectCourse();

	Map<String, Object> traineeUpdate(Map<String, Object> params,SessionVO sessionVO) throws Exception;

	Map<String, Object> hpMemRegister(Map<String, Object> params,SessionVO sessionVO) throws Exception;


	List<EgovMap> getMemberListView(Map<String, Object> params);

	int memberListUpdate_user(Map<String, Object> params);

	int memberListUpdate_memorg(Map<String, Object> params);

	int memberListUpdate_memorg2(Map<String, Object> params);

	/*By KV - for service capacity update data purpose*/
	int memberListUpdate_memorg3(Map<String, Object> params);

	int memberListUpdate_member(Map<String, Object> params);

	int updateMemberName(Map<String, Object> params);

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

	List<EgovMap> selectMemberInfo(Map<String, Object> params);

	List<EgovMap> selectMemberApprovalInfo(Map<String, Object> params);

	void updateMemberStatus(Map<String, Object> params);

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

    EgovMap getApplicantDetails(Map<String, Object> params);

    EgovMap checkBankAcc(Map<String, Object> params);

    EgovMap getUserRole(Map<String, Object> params);

	EgovMap selectMemberValidDate(Map<String, Object> params);

    void updateCodyCfm(Map<String, Object> params) throws Exception;

    void updateMobileUse(Map<String, Object> params) throws Exception;

	int UpdateMemberValidate(Map<String, Object> params);

	EgovMap getOrgDtls(Map<String, Object> params);

	EgovMap getCDInfo(Map<String, Object> params);

	List<EgovMap> selectHpMeetPoint();

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

	ReturnMessage checkMemCode(Map<String, Object> params);
	// LaiKW - Comment ends here

	List<EgovMap> selectTraining(Map<String, Object> params);

	int getNextMPID();
	List<EgovMap> searchMP(Map<String, Object> params);
	int addMeetingPoint(List<Object> addList, String userId);
	int updMeetingPoint(List<Object> updList, String userId);
	int updHPMeetingPoint(Map<String, Object> params) throws Exception;

	String getUpdUserID(Map<String, Object> params);
	int updateOrgUserPW(Map<String, Object> params);

	List<EgovMap> selectPromoDisHistory(Map<String, Object> params);

	EgovMap getCurrOrgDtls(Map<String, Object> params);

	EgovMap checkIncomeTax(Map<String, Object> params);

	EgovMap validateVaccineDeclarationStatus(Map<String, Object> params);

	EgovMap getVaccineDeclarationMemDetails(Map<String, Object> params);

	void updateVaccineDeclaration(Map<String, Object> params) throws Exception;

	List<EgovMap> selectTrApplByEmail(Map<String, Object> params);

	EgovMap selectSocialMedia(Map<String, Object> params);

	void updateSocialMedia(Map<String, Object> params) throws Exception;

	List<EgovMap> selectHTOrgCode(Map<String, Object> params);

	List<EgovMap> selectHTGroupCode(Map<String, Object> params);

	List<EgovMap> selectHTDeptCode(Map<String, Object> params);

	List<EgovMap> selectStatusList(Map<String, Object> params);

	List<EgovMap> selectPositionList(Map<String, Object> params);

	void insertMemberListAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);

	void updateMemberListAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);

	void deleteMemberListAttachBiz(FileType type, Map<String, Object> params);

	List<EgovMap> selectMemberWorkingHistory(Map<String, Object> params);

	List<EgovMap> selectHpRegistrationOption(Map<String, Object> params);

	BigDecimal getOwnPurcOutsInfo(Map<String, Object> params);

	int selectCntMemSameEmail(Map<String, Object> params);

	int insertMfaResetRequest(Map<String, Object> p);

	int insertMfaApprovalLine(Map<String, Object> p);

	List<EgovMap> mfaResetList(Map<String, Object> p);

	void updateMFAApproval(Map<String, Object> p);

	int selectCurrRequestId();

	int resetMfa(Map<String, Object> p);

	int insertResetMfaHistory(Map<String, Object> p);

	List<EgovMap> getMfaResetHist(Map<String, Object> params);

	List<EgovMap> checkEmail(Map<String, Object> params);

	Map<String, Object> suspendFromCU(Map<String, Object> params) throws Exception;


}
