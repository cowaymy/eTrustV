package com.coway.trust.cmmn.model;

// TODO : 사용자정보 구성 필요. 현재는 임시.
public class SessionVO {

	private String id;
	private String name;
	private String phoneNumber;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public static SessionVO create(LoginVO loginVO) {
		SessionVO sessionVO = new SessionVO();

		if (loginVO != null) {
			
			// TODO : loginVO, sessionVO 확정시 수정해야 함. 현재는 샘플.
			sessionVO.setId(loginVO.getId());
			sessionVO.setName(loginVO.getName());
			sessionVO.setPhoneNumber(loginVO.getPhoneNumber());
		}

		return sessionVO;
	}
}
