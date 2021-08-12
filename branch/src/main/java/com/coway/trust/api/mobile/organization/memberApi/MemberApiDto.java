package com.coway.trust.api.mobile.organization.memberApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

/**
 * @ClassName : MemberApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 09.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "MemberApiDto", description = "MemberApiDto")
public class MemberApiDto {



	@SuppressWarnings("unchecked")
	public static MemberApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, MemberApiDto.class);
	}



	public static Map<String, Object> createMap(MemberApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("name", vo.getName());
		params.put("memCode", vo.getMemCode());
		params.put("codeName", vo.getCodeName());
		params.put("memOrgDesc", vo.getDeptCode());
		params.put("brnchCode", vo.getBrnchCode());
		params.put("brnchName", vo.getBrnchName());
		params.put("deptCode", vo.getDeptCode());
		params.put("memType", vo.getMemType());
		params.put("memId", vo.getMemId());
		params.put("hpType", vo.getHpType());
		params.put("department", vo.getDepartment());
		params.put("dob", vo.getDob());
		params.put("gender", vo.getGender());
		params.put("countryName", vo.getCountryName());
		params.put("raceName", vo.getRaceName());
		params.put("telMobile", vo.getTelMobile());
		params.put("telOffice", vo.getTelOffice());
		params.put("telHuse", vo.getTelHuse());
		params.put("email", vo.getEmail());
		return params;
	}



	private String name;
	private String memCode;
	private String codeName;
	private String memOrgDesc;
	private String brnchCode;
	private String brnchName;
	private String deptCode;
	private int memType;
	private int memId;
	private String hpType;
	private String department;
	private String dob;
	private String gender;
	private String countryName;
	private String raceName;
	private String telMobile;
	private String telOffice;
	private String telHuse;
	private String email;
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMemCode() {
        return memCode;
    }

    public void setMemCode(String memCode) {
        this.memCode = memCode;
    }

    public String getCodeName() {
        return codeName;
    }

    public void setCodeName(String codeName) {
        this.codeName = codeName;
    }

    public String getMemOrgDesc() {
        return memOrgDesc;
    }

    public void setMemOrgDesc(String memOrgDesc) {
        this.memOrgDesc = memOrgDesc;
    }

    public String getBrnchCode() {
        return brnchCode;
    }

    public void setBrnchCode(String brnchCode) {
        this.brnchCode = brnchCode;
    }

    public String getBrnchName() {
        return brnchName;
    }

    public void setBrnchName(String brnchName) {
        this.brnchName = brnchName;
    }

    public String getDeptCode() {
        return deptCode;
    }

    public void setDeptCode(String deptCode) {
        this.deptCode = deptCode;
    }

    public int getMemType() {
        return memType;
    }

    public void setMemType(int memType) {
        this.memType = memType;
    }

    public int getMemId() {
        return memId;
    }

    public void setMemId(int memId) {
        this.memId = memId;
    }

    public String getHpType() {
        return hpType;
    }

    public void setHpType(String hpType) {
        this.hpType = hpType;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getRaceName() {
        return raceName;
    }

    public void setRaceName(String raceName) {
        this.raceName = raceName;
    }

    public String getTelMobile() {
        return telMobile;
    }

    public void setTelMobile(String telMobile) {
        this.telMobile = telMobile;
    }

    public String getTelOffice() {
        return telOffice;
    }

    public void setTelOffice(String telOffice) {
        this.telOffice = telOffice;
    }

    public String getTelHuse() {
        return telHuse;
    }

    public void setTelHuse(String telHuse) {
        this.telHuse = telHuse;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
