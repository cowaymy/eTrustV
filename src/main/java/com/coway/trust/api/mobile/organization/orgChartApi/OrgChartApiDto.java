package com.coway.trust.api.mobile.organization.orgChartApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

/**
 * @ClassName : OrgChartApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "OrgChartApiDto", description = "OrgChartApiDto")
public class OrgChartApiDto {



	@SuppressWarnings("unchecked")
	public static OrgChartApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, OrgChartApiDto.class);
	}



	public static Map<String, Object> createMap(OrgChartApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("memId", vo.getMemId());
		params.put("memUpId", vo.getMemUpId());
		params.put("memLvl", vo.getMemLvl());
		params.put("deptCode", vo.getDeptCode());
		params.put("memType", vo.getMemType());
		params.put("member", vo.getMember());
		params.put("paramMemId", vo.getParamMemId());
		params.put("paramMemType", vo.getParamMemType());
		params.put("paramMemLvl", vo.getParamMemLvl());
		params.put("cnt", vo.getCnt());
		return params;
	}



	private int memId;
	private int memUpId;
	private int memLvl;
	private String deptCode;
	private int memType;
	private String member;
	private int paramMemId;
	private int paramMemType;
	private int paramMemLvl;
	private int cnt;



	public int getMemId() {
		return memId;
	}

	public void setMemId(int memId) {
		this.memId = memId;
	}

	public int getMemUpId() {
		return memUpId;
	}

	public void setMemUpId(int memUpId) {
		this.memUpId = memUpId;
	}

	public int getMemLvl() {
		return memLvl;
	}

	public void setMemLvl(int memLvl) {
		this.memLvl = memLvl;
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

	public String getMember() {
		return member;
	}

	public void setMember(String member) {
		this.member = member;
	}

	public int getParamMemId() {
		return paramMemId;
	}

	public void setParamMemId(int paramMemId) {
		this.paramMemId = paramMemId;
	}

	public int getParamMemType() {
		return paramMemType;
	}

	public void setParamMemType(int paramMemType) {
		this.paramMemType = paramMemType;
	}

	public int getParamMemLvl() {
		return paramMemLvl;
	}

	public void setParamMemLvl(int paramMemLvl) {
		this.paramMemLvl = paramMemLvl;
	}

	public int getCnt() {
		return cnt;
	}

	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
}
