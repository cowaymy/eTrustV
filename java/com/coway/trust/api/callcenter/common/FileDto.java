package com.coway.trust.api.callcenter.common;

import java.util.List;
import java.util.stream.Collectors;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.util.EgovFormBasedFileVo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "FileDto", description = "FileDto")
public class FileDto {

	@ApiModelProperty(value = "파일 그룹 아이디")
	private int atchFileGrpId;
	@ApiModelProperty(value = "첨부파일 리스트")
	private List<FileDetailVO> files;

	public static FileDto create(List<EgovFormBasedFileVo> egovFormBasedFileVoList, int atchFileGrpId) {
		FileDto dto = new FileDto();
		dto.setFiles(FileDetailVO.createList(egovFormBasedFileVoList));
		dto.setAtchFileGrpId(atchFileGrpId);
		return dto;
	}

	public static FileDto create2(List<EgovFormBasedFileVo> egovFormBasedFileVoList, int atchFileGrpId) {
		FileDto dto = new FileDto();
		dto.setFiles(FileDetailVO.createList2(egovFormBasedFileVoList));
		dto.setAtchFileGrpId(atchFileGrpId);
		return dto;
	}

	public static FileDto createByFileVO(List<FileVO> fileVOList, int atchFileGrpId) {
		FileDto dto = new FileDto();
		List<FileDetailVO> fileDetailVOList = fileVOList.stream().map(r -> FileDetailVO.create(r)).collect(Collectors.toList());
		dto.setFiles(fileDetailVOList);
		dto.setAtchFileGrpId(atchFileGrpId);
		return dto;
	}

	static class FileDetailVO {
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

		public static List<FileDetailVO> createList(List<EgovFormBasedFileVo> list) {
			List<FileDetailVO> fileDetailVOList = list.stream().map(r -> FileDetailVO.create(r)).collect(Collectors.toList());
			return fileDetailVOList;
		}

		public static List<FileDetailVO> createList2(List<EgovFormBasedFileVo> list) {
			List<FileDetailVO> fileDetailVOList = list.stream().map(r -> FileDetailVO.create2(r)).collect(Collectors.toList());
			return fileDetailVOList;
		}

		public static FileDetailVO create(EgovFormBasedFileVo egovFormBasedFileVo) {
			FileDetailVO vo = new FileDetailVO();

			vo.setAtchFileName(egovFormBasedFileVo.getFileName());
			vo.setFileSubPath(egovFormBasedFileVo.getServerSubPath());
			vo.setPhysiclFileName(egovFormBasedFileVo.getPhysicalName());
			vo.setFileExtsn(egovFormBasedFileVo.getExtension());
			vo.setFileSize(egovFormBasedFileVo.getSize());

			return vo;
		}

		public static FileDetailVO create2(EgovFormBasedFileVo egovFormBasedFileVo) {
			FileDetailVO vo = new FileDetailVO();

			String physicalName="";
			physicalName = egovFormBasedFileVo.getPhysicalName() + "." + egovFormBasedFileVo.getExtension().toLowerCase();

			vo.setAtchFileName(egovFormBasedFileVo.getFileName());
			vo.setFileSubPath(egovFormBasedFileVo.getServerSubPath());
			vo.setPhysiclFileName(physicalName);
			vo.setFileExtsn(egovFormBasedFileVo.getExtension());
			vo.setFileSize(egovFormBasedFileVo.getSize());

			return vo;
		}

		public static FileDetailVO create(FileVO fileVO) {
			FileDetailVO vo = new FileDetailVO();

			vo.setAtchFileName(fileVO.getAtchFileName());
			vo.setFileSubPath(fileVO.getFileSubPath());
			vo.setPhysiclFileName(fileVO.getPhysiclFileName());
			vo.setFileExtsn(fileVO.getFileExtsn());
			vo.setFileSize(fileVO.getFileSize());

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

	public List<FileDetailVO> getFiles() {
		return files;
	}

	public void setFiles(List<FileDetailVO> files) {
		this.files = files;
	}
}
