package com.coway.trust.cmmn.model;

import java.util.Collections;
import java.util.Date;
import java.util.List;

public class LoginVO {

	private int userId;
	private String userName; // AS-IS 에서 userName을 실제적인 로그인 ID로 사용함.
	private String userFullname;
	private String userEmail;
	private int userStatusId;
	private int userTypeId;
	private int userDeptId;
	private int roleId;
	private Date userUpdateAt;
	private Date userPasswdLastUpdateAt;
	private String userMobileNo;
	private String userExtNo;
	private int userIsPartTime;
	private int userIsExternal;
	private String statusName;
	private String code;
	private int userBranchId;
	private String branchName;
	private String branchAddr;
	private String branchTel1;
	private String branchTel2;
	private String deptName;
	private String diffDay;
	private String userSecQuesId;
	private String securityQuestion;
	private String userSecQuesAns;
	private String userPassWord;
	private String userNric;
	private String userWorkNo;
	private String mgrYn;

	public String getUserNric() {
		return userNric;
	}

	public void setUserNric(String userNric) {
		this.userNric = userNric;
	}

	public String getUserWorkNo() {
		return userWorkNo;
	}

	public void setUserWorkNo(String userWorkNo) {
		this.userWorkNo = userWorkNo;
	}

	private List<LoginSubAuthVO> loginSubAuthVOList;

	public String getDiffDay() {
		return diffDay;
	}

	public void setDiffDay(String diffDay) {
		this.diffDay = diffDay;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserFullname() {
		return userFullname;
	}

	public void setUserFullname(String userFullname) {
		this.userFullname = userFullname;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public int getUserStatusId() {
		return userStatusId;
	}

	public void setUserStatusId(int userStatusId) {
		this.userStatusId = userStatusId;
	}

	public int getUserTypeId() {
		return userTypeId;
	}

	public void setUserTypeId(int userTypeId) {
		this.userTypeId = userTypeId;
	}

	public int getUserDeptId() {
		return userDeptId;
	}

	public void setUserDeptId(int userDeptId) {
		this.userDeptId = userDeptId;
	}

	public int getRoleId() {
		return roleId;
	}

	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}

	public Date getUserUpdateAt() {
		return userUpdateAt;
	}

	public void setUserUpdateAt(Date userUpdateAt) {
		this.userUpdateAt = userUpdateAt;
	}

	public Date getUserPasswdLastUpdateAt() {
		return userPasswdLastUpdateAt;
	}

	public void setUserPasswdLastUpdateAt(Date userPasswdLastUpdateAt) {
		this.userPasswdLastUpdateAt = userPasswdLastUpdateAt;
	}

	public String getUserMobileNo() {
		return userMobileNo;
	}

	public void setUserMobileNo(String userMobileNo) {
		this.userMobileNo = userMobileNo;
	}

	public String getUserExtNo() {
		return userExtNo;
	}

	public void setUserExtNo(String userExtNo) {
		this.userExtNo = userExtNo;
	}

	public int getUserIsPartTime() {
		return userIsPartTime;
	}

	public void setUserIsPartTime(int userIsPartTime) {
		this.userIsPartTime = userIsPartTime;
	}

	public int getUserIsExternal() {
		return userIsExternal;
	}

	public void setUserIsExternal(int userIsExternal) {
		this.userIsExternal = userIsExternal;
	}

	public String getStatusName() {
		return statusName;
	}

	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public int getUserBranchId() {
		return userBranchId;
	}

	public void setUserBranchId(int userBranchId) {
		this.userBranchId = userBranchId;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getBranchAddr() {
		return branchAddr;
	}

	public void setBranchAddr(String branchAddr) {
		this.branchAddr = branchAddr;
	}

	public String getBranchTel1() {
		return branchTel1;
	}

	public void setBranchTel1(String branchTel1) {
		this.branchTel1 = branchTel1;
	}

	public String getBranchTel2() {
		return branchTel2;
	}

	public void setBranchTel2(String branchTel2) {
		this.branchTel2 = branchTel2;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getUserSecQuesId() {
		return userSecQuesId;
	}

	public void setUserSecQuesId(String userSecQuesId) {
		this.userSecQuesId = userSecQuesId;
	}

	public String getSecurityQuestion() {
		return securityQuestion;
	}

	public void setSecurityQuestion(String securityQuestion) {
		this.securityQuestion = securityQuestion;
	}

	public String getUserSecQuesAns() {
		return userSecQuesAns;
	}

	public void setUserSecQuesAns(String userSecQuesAns) {
		this.userSecQuesAns = userSecQuesAns;
	}

	public String getUserPassWord() {
		return userPassWord;
	}

	public void setUserPassWord(String userPassWord) {
		this.userPassWord = userPassWord;
	}

	public List<LoginSubAuthVO> getLoginSubAuthVOList() {
		if (loginSubAuthVOList == null) {
			loginSubAuthVOList = Collections.emptyList();
		}
		return loginSubAuthVOList;
	}

	public void setLoginSubAuthVOList(List<LoginSubAuthVO> loginSubAuthVOList) {
		this.loginSubAuthVOList = loginSubAuthVOList;
	}

	public String getMgrYn() {
		return mgrYn;
	}

	public void setMgrYn(String mgrYn) {
		this.mgrYn = mgrYn;
	}
}
