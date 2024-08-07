package com.coway.trust.biz.notice;

import java.io.Serializable;
import java.util.Date;

public class NoticeVO implements Serializable {

	private static final long serialVersionUID = 4773175663882833924L;
	
	/**Notice List*/
    private int ntceNo;
    private String ntceStartDt;
    private String ntceEndDt;
    private int rgstUserId;
    private String rgstUserNm;
    private String emgncyFlag;
    private int readCnt;
    private String password;
    private String ntceSubject;
    private String ntceCntnt;
    private int atchFileGrpId;
    private int crtUserId;
    private Date crtDt;
    private int updUserId;
    private Date updDt;
    
	public int getNtceNo() {
		return ntceNo;
	}
	public void setNtceNo(int ntceNo) {
		this.ntceNo = ntceNo;
	}
	public String getNtceStartDt() {
		return ntceStartDt;
	}
	public void setNtceStartDt(String ntceStartDt) {
		this.ntceStartDt = ntceStartDt;
	}
	public String getNtceEndDt() {
		return ntceEndDt;
	}
	public void setNtceEndDt(String ntceEndDt) {
		this.ntceEndDt = ntceEndDt;
	}
	public int getRgstUserId() {
		return rgstUserId;
	}
	public void setRgstUserId(int rgstUserId) {
		this.rgstUserId = rgstUserId;
	}
	public String getRgstUserNm() {
		return rgstUserNm;
	}
	public void setRgstUserNm(String rgstUserNm) {
		this.rgstUserNm = rgstUserNm;
	}
	public String getEmgncyFlag() {
		return emgncyFlag;
	}
	public void setEmgncyFlag(String emgncyFlag) {
		this.emgncyFlag = emgncyFlag;
	}
	public int getReadCnt() {
		return readCnt;
	}
	public void setReadCnt(int readCnt) {
		this.readCnt = readCnt;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getNtceSubject() {
		return ntceSubject;
	}
	public void setNtceSubject(String ntceSubject) {
		this.ntceSubject = ntceSubject;
	}
	public String getNtceCntnt() {
		return ntceCntnt;
	}
	public void setNtceCntnt(String ntceCntnt) {
		this.ntceCntnt = ntceCntnt;
	}
	public int getAtchFileGrpId() {
		return atchFileGrpId;
	}
	public void setAtchFileGrpId(int atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}
	public int getCrtUserId() {
		return crtUserId;
	}
	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}
	public Date getCrtDt() {
		return crtDt;
	}
	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}
	public int getUpdUserId() {
		return updUserId;
	}
	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}
	public Date getUpdDt() {
		return updDt;
	}
	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}
	 
}
