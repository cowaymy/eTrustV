package com.coway.trust.biz.common;

import java.util.Date;
import java.util.List;

public class FileGroupVO {
	private int atchFileGrpId;
	private int atchFileId;
	private String chenalType;
	private int crtUserId;
	private Date crtDt;
	private int updUserId;
	private Date updDt;

	private List<FileVO> fileVOList;

	public int getAtchFileGrpId() {
		return atchFileGrpId;
	}

	public void setAtchFileGrpId(int atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}

	public int getAtchFileId() {
		return atchFileId;
	}

	public void setAtchFileId(int atchFileId) {
		this.atchFileId = atchFileId;
	}

	public String getChenalType() {
		return chenalType;
	}

	public void setChenalType(String chenalType) {
		this.chenalType = chenalType;
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

	public List<FileVO> getFileVOList() {
		return fileVOList;
	}

	public void setFileVOList(List<FileVO> fileVOList) {
		this.fileVOList = fileVOList;
	}
}
