package com.coway.trust.api.mobile.common.userProfileApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : UserProfileApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 01.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "UserProfileApiDto", description = "UserProfileApiDto")
public class UserProfileApiDto {



	@SuppressWarnings("unchecked")
	public UserProfileApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, UserProfileApiDto.class);
	}



    public static Map<String, Object> createMap(UserProfileApiDto vo){
        Map<String, Object> params = new HashMap<>();
        params.put("memCode", vo.getMemCode());
        params.put("memName", vo.getMemName());
        params.put("memTypeName", vo.getMemTypeName());
        params.put("memStatus", vo.getMemStatus());
        params.put("brnchCode", vo.getBrnchCode());
        params.put("brnchName", vo.getBrnchName());
        params.put("grpCode", vo.getGrpCode());
        params.put("orgCode", vo.getOrgCode());
        params.put("deptCode", vo.getDeptCode());
        params.put("bankName", vo.getBankName());
        params.put("bankAccNo", vo.getBankAccNo());
        return params;
    }



	private String memCode;
	private String memName;
	private String memTypeName;
	private String memStatus;
	private String brnchCode;
	private String brnchName;
	private String grpCode;
	private String orgCode;
	private String deptCode;
	private String bankName;
	private String bankAccNo;



    public String getMemCode() {
        return memCode;
    }

    public void setMemCode(String memCode) {
        this.memCode = memCode;
    }

    public String getMemName() {
        return memName;
    }

    public void setMemName(String memName) {
        this.memName = memName;
    }

    public String getMemTypeName() {
        return memTypeName;
    }

    public void setMemTypeName(String memTypeName) {
        this.memTypeName = memTypeName;
    }

    public String getMemStatus() {
        return memStatus;
    }

    public void setMemStatus(String memStatus) {
        this.memStatus = memStatus;
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

    public String getGrpCode() {
        return grpCode;
    }

    public void setGrpCode(String grpCode) {
        this.grpCode = grpCode;
    }

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

    public String getDeptCode() {
        return deptCode;
    }

    public void setDeptCode(String deptCode) {
        this.deptCode = deptCode;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getBankAccNo() {
        return bankAccNo;
    }

    public void setBankAccNo(String bankAccNo) {
        this.bankAccNo = bankAccNo;
    }
}
