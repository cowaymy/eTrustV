package com.coway.trust.biz.common;

import java.util.List;
import java.util.stream.Collectors;

import com.coway.trust.util.EgovFormBasedFileVo;

public class FileVO {
	private int atchFileId;
	private String atchFileName;
	private String fileSubPath;
	private String physiclFileName;
	private String fileExtsn;
	private long fileSize;
	private String filePassword;

	public static List<FileVO> createList(List<EgovFormBasedFileVo> list) {
		List<FileVO> fileVOList = list.stream().map(r -> FileVO.create(r)).collect(Collectors.toList());
		return fileVOList;
	}

	public static FileVO create(EgovFormBasedFileVo egovFormBasedFileVo) {
		FileVO vo = new FileVO();

		vo.setAtchFileName(egovFormBasedFileVo.getFileName());
		vo.setFileSubPath(egovFormBasedFileVo.getServerSubPath());
		vo.setPhysiclFileName(egovFormBasedFileVo.getPhysicalName());
		vo.setFileExtsn(egovFormBasedFileVo.getExtension());
		vo.setFileSize(egovFormBasedFileVo.getSize());
		vo.setFilePassword("");

		return vo;
	}

	public static List<FileVO> createList2(List<EgovFormBasedFileVo> list) {
		List<FileVO> fileVOList = list.stream().map(r -> FileVO.create2(r)).collect(Collectors.toList());
		return fileVOList;
	}

	public static FileVO create2(EgovFormBasedFileVo egovFormBasedFileVo) {
		FileVO vo = new FileVO();
		String physicalName="";
		physicalName = egovFormBasedFileVo.getPhysicalName() + "." + egovFormBasedFileVo.getExtension().toLowerCase();

		vo.setAtchFileName(egovFormBasedFileVo.getFileName());
		vo.setFileSubPath(egovFormBasedFileVo.getServerSubPath());
		vo.setPhysiclFileName(physicalName);
		vo.setFileExtsn(egovFormBasedFileVo.getExtension());
		vo.setFileSize(egovFormBasedFileVo.getSize());
		vo.setFilePassword("");

		return vo;
	}

	public int getAtchFileId() {
		return atchFileId;
	}

	public void setAtchFileId(int atchFileId) {
		this.atchFileId = atchFileId;
	}

	public String getAtchFileName() {
		return atchFileName;
	}

	public void setAtchFileName(String atchFileName) {
		this.atchFileName = atchFileName;
	}

	public String getFileSubPath() {
		return fileSubPath;
	}

	public void setFileSubPath(String fileSubPath) {
		this.fileSubPath = fileSubPath;
	}

	public String getPhysiclFileName() {
		return physiclFileName;
	}

	public void setPhysiclFileName(String physiclFileName) {
		this.physiclFileName = physiclFileName;
	}

	public String getFileExtsn() {
		return fileExtsn;
	}

	public void setFileExtsn(String fileExtsn) {
		this.fileExtsn = fileExtsn;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getFilePassword() {
		return filePassword;
	}

	public void setFilePassword(String filePassword) {
		this.filePassword = filePassword;
	}
}
