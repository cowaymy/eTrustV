package com.coway.trust.cmmn.model;

import java.io.Serializable;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class SessionVO implements Serializable {

	private int userId;
	private String userName; // AS-IS 에서 userName을 실제적인 로그인 ID로 사용함.
	private String userFullname;
	private String userEmail;
	private int userStatusId;
	private int userTypeId;
	private int userDeptId;
	private int roleId;
	private Integer memberLevel;
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
	private String deptName;
	private String userPassWord;
	private String mgrYn;

	private String menuCode; // 메뉴에 등록된 uri 에 대한 menuCode.... 등록되지 않은 uri 호출이 된 경우에도 이전 메뉴를 가지고 있음.
							 // (AuthenticInterceptor.java 에서 등록)

	private String memId;
	

	private List<LoginSubAuthVO> loginSubAuthVOList;

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

	public Integer getMemberLevel() {
		return memberLevel;
	}

	public void setMemberLevel(Integer memberLevel) {
		this.memberLevel = memberLevel;
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

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
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

	public String getUserPassWord() {
		return userPassWord;
	}

	public void setUserPassWord(String userPassWord) {
		this.userPassWord = userPassWord;
	}

	public String getMgrYn() {
		return mgrYn;
	}

	public void setMgrYn(String mgrYn) {
		this.mgrYn = mgrYn;
	}

	public static SessionVO create(LoginVO loginVO) {
		SessionVO sessionVO = new SessionVO();

		if (loginVO != null) {
			sessionVO.setUserId(loginVO.getUserId());
			sessionVO.setUserName(loginVO.getUserName());
			sessionVO.setUserFullname(loginVO.getUserFullname());
			sessionVO.setUserEmail(loginVO.getUserEmail());
			sessionVO.setUserStatusId(loginVO.getUserStatusId());
			sessionVO.setUserTypeId(loginVO.getUserTypeId());
			sessionVO.setRoleId(loginVO.getRoleId());
			sessionVO.setMemberLevel(loginVO.getMemberLevel());
			sessionVO.setUserDeptId(loginVO.getUserDeptId());
			sessionVO.setUserUpdateAt(loginVO.getUserUpdateAt());
			sessionVO.setUserPasswdLastUpdateAt(loginVO.getUserPasswdLastUpdateAt());
			sessionVO.setUserMobileNo(loginVO.getUserMobileNo());
			sessionVO.setUserExtNo(loginVO.getUserExtNo());
			sessionVO.setUserIsPartTime(loginVO.getUserIsPartTime());
			sessionVO.setUserIsExternal(loginVO.getUserIsExternal());
			sessionVO.setStatusName(loginVO.getStatusName());
			sessionVO.setCode(loginVO.getCode());
			sessionVO.setBranchName(loginVO.getBranchName());
			sessionVO.setUserBranchId(loginVO.getUserBranchId());
			sessionVO.setDeptName(loginVO.getDeptName());
			sessionVO.setUserPassWord(loginVO.getUserPassWord());
			sessionVO.setMgrYn(loginVO.getMgrYn());
			sessionVO.setMemId(loginVO.getMemId());
			sessionVO.setLoginSubAuthVOList(loginVO.getLoginSubAuthVOList());
		}

		return sessionVO;
	}

	public String getMenuCode() {
		return menuCode;
	}

	public void setMenuCode(String menuCode) {
		this.menuCode = menuCode;
	}
	

	public String getMemId() {
		return memId;
	}

	public void setMemId(String memId) {
		this.memId = memId;
	}
}
