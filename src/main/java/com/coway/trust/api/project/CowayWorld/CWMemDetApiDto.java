package com.coway.trust.api.project.CowayWorld;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.project.common.CommonApiDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CWMemDetApiDto.java
 * @Description : TO-DO Class Description
 *
 * @HistoryselectAnotherContact
 *
 *                              <pre>
 * Date                Author         Description
 * -------------       -----------      -------------
 * 2021. 10. 27.    MY-HLTANG   First creation- API for coway world
 *                              </pre>
 */
@ApiModel(value = "CWMemDetApiDto", description = "CWMemDetApiDto")
public class CWMemDetApiDto{

	@SuppressWarnings("unchecked")
	public static CWMemDetApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CWMemDetApiDto.class);
	}

	 public static Map<String, Object> createConvertListMap(CWMemDetApiDto cWMemDetApiDto){
	    Map<String, Object> params = new HashMap<>();
	    params.put("staffCode", cWMemDetApiDto.getStaffCode());
	    params.put("staffName", cWMemDetApiDto.getStaffName());
	    params.put("nric", cWMemDetApiDto.getNric());
	    params.put("email", cWMemDetApiDto.getEmail());
	    params.put("mobileNum", cWMemDetApiDto.getMobileNum());
	    params.put("branch", cWMemDetApiDto.getBranch());
	    params.put("department", cWMemDetApiDto.getDepartment());
	    params.put("address", cWMemDetApiDto.getAddress());
	    return params;
	  }

	private String staffCode;
	private String staffName;
	private String nric;
	private String email;
	private String mobileNum;
	private String branch;
	private String department;
	private String address;

	public String getStaffCode() {
		return staffCode;
	}

	public void setStaffCode(String staffCode) {
		this.staffCode = staffCode;
	}

	public String getStaffName() {
		return staffName;
	}

	public void setStaffName(String staffName) {
		this.staffName = staffName;
	}

	public String getNric() {
		return nric;
	}

	public void setNric(String nric) {
		this.nric = nric;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMobileNum() {
		return mobileNum;
	}

	public void setMobileNum(String mobileNum) {
		this.mobileNum = mobileNum;
	}

	public String getBranch() {
		return branch;
	}

	public void setBranch(String branch) {
		this.branch = branch;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}


}
