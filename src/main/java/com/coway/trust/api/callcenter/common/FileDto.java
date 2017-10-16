package com.coway.trust.api.callcenter.common;

import java.util.List;
import java.util.stream.Collectors;

import com.coway.trust.util.EgovFormBasedFileVo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "FileDto", description = "FileDto")
public class FileDto {

	@ApiModelProperty(value = "파일 그룹 아이디")
	private int atchFileGrpId;
	@ApiModelProperty(value = "첨부파일 리스트")
	private List<FileVO> files;

	public static FileDto create(List<EgovFormBasedFileVo> egovFormBasedFileVoList, int atchFileGrpId) {
		FileDto dto = new FileDto();
		dto.setFiles(FileVO.createList(egovFormBasedFileVoList));
		dto.setAtchFileGrpId(atchFileGrpId);
		return dto;
	}

	static class FileVO {
		@ApiModelProperty(value = "원본 첨부파일 명")
		private String atchFileName;
		@ApiModelProperty(value = "첨부파일 sub path")
		private String fileSubPath;
		@ApiModelProperty(value = "저장된 첨부파일 명")
		private String physiclFileName;
		@ApiModelProperty(value = "원본 첨부파일 확장자")
		private String fileExtsn;
		@ApiModelProperty(value = "원본 첨부파일 사이즈")
		private long fileSize;

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

			return vo;
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

	}

	public int getAtchFileGrpId() {
		return atchFileGrpId;
	}

	public void setAtchFileGrpId(int atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}

	public List<FileVO> getFiles() {
		return files;
	}

	public void setFiles(List<FileVO> files) {
		this.files = files;
	}
}
