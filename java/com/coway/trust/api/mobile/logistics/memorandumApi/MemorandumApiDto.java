package com.coway.trust.api.mobile.logistics.memorandumApi;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

/**
 * @ClassName : MemorandumApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "MemorandumApiDto", description = "공통코드 Dto")
public class MemorandumApiDto {



	@SuppressWarnings("unchecked")
	public static MemorandumApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, MemorandumApiDto.class);
	}



    private int memoId;
    private int stusCodeId;
    private String memoTitle;
    private String memoCntnt;
    private int isStaffMemo;
    private int isCodyMemo;
    private int isHpMemo;
    private int isHtMemo;
    private String crtdeptid;
    private String crtDeptIdNm;
    private int crtUserId;
    private String crtDt;
    private int updUserId;
    private String updDt;
    private String crtUserIdNm;
    private String updUserIdNm;
    private String code;
    private String name;



	public int getMemoId() {
		return memoId;
	}

	public void setMemoId(int memoId) {
		this.memoId = memoId;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public String getMemoTitle() {
		return memoTitle;
	}

	public void setMemoTitle(String memoTitle) {
		this.memoTitle = memoTitle;
	}

	public String getMemoCntnt() {
		return memoCntnt;
	}

	public void setMemoCntnt(String memoCntnt) {
		this.memoCntnt = memoCntnt;
	}

	public int getIsStaffMemo() {
		return isStaffMemo;
	}

	public void setIsStaffMemo(int isStaffMemo) {
		this.isStaffMemo = isStaffMemo;
	}

	public int getIsCodyMemo() {
		return isCodyMemo;
	}

	public void setIsCodyMemo(int isCodyMemo) {
		this.isCodyMemo = isCodyMemo;
	}

	public int getIsHpMemo() {
		return isHpMemo;
	}

	public void setIsHpMemo(int isHpMemo) {
		this.isHpMemo = isHpMemo;
	}

	public int getIsHtMemo() {
		return isHtMemo;
	}

	public void setIsHtMemo(int isHtMemo) {
		this.isHtMemo = isHtMemo;
	}

	public String getCrtdeptid() {
		return crtdeptid;
	}

	public void setCrtdeptid(String crtdeptid) {
		this.crtdeptid = crtdeptid;
	}

	public String getCrtDeptIdNm() {
		return crtDeptIdNm;
	}

	public void setCrtDeptIdNm(String crtDeptIdNm) {
		this.crtDeptIdNm = crtDeptIdNm;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public String getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(String crtDt) {
		this.crtDt = crtDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

	public String getUpdDt() {
		return updDt;
	}

	public void setUpdDt(String updDt) {
		this.updDt = updDt;
	}

	public String getCrtUserIdNm() {
		return crtUserIdNm;
	}

	public void setCrtUserIdNm(String crtUserIdNm) {
		this.crtUserIdNm = crtUserIdNm;
	}

	public String getUpdUserIdNm() {
		return updUserIdNm;
	}

	public void setUpdUserIdNm(String updUserIdNm) {
		this.updUserIdNm = updUserIdNm;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
