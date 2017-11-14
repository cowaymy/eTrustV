package com.coway.trust.biz.common.impl;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.exception.ApplicationException;

@Service("fileService")
public class FileServiceImpl implements FileService {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileServiceImpl.class);

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Value("${web.resource.upload.file}")
	private String uploadResourceDir;

	@Value("${com.file.mobile.upload.path}")
	private String mobileUploadDir;

	@Value("${com.file.callcenter.upload.path}")
	private String callcenterUploadDir;

	@Autowired
	private FileMapper fileMapper;

	@Override
	public int insertFiles(List<FileVO> fileVOList, FileType type, int userId) {
		int fileGroupKey = fileMapper.selectFileGroupKey();
		fileVOList.forEach(r -> this.insertFile(fileGroupKey, r, type, userId));
		return fileGroupKey;
	}

	@Override
	public int insertFile(int fileGroupId, FileVO fileVO, FileType type, int userId) {
		FileGroupVO fileGroupVO = new FileGroupVO();

		fileMapper.insertFileDetail(fileVO);

		fileGroupVO.setAtchFileGrpId(fileGroupId);
		fileGroupVO.setAtchFileId(fileVO.getAtchFileId());
		fileGroupVO.setChenalType(type.getCode());
		fileGroupVO.setCrtUserId(userId);
		fileGroupVO.setUpdUserId(userId);

		fileMapper.insertFileGroup(fileGroupVO);

		return fileGroupId;
	}

	@Override
	public FileVO getFile(int fileId) {
		return fileMapper.selectFileByFileId(fileId);
	}

	@Override
	public List<FileVO> getFiles(int fileGroupId) {
		return fileMapper.selectFilesByGroupId(fileGroupId);
	}

	@Override
	public void removeFilesByFileGroupId(FileType type, int fileGroupId) {
		String baseDir = getBaseDir(type);
		List<FileVO> fileVOList = this.getFiles(fileGroupId);

		fileVOList.forEach(fileVO -> {
			try {
				FileUtils.forceDelete(
						new File(baseDir + fileVO.getFileSubPath() + File.separator + fileVO.getPhysiclFileName()));
			} catch (IOException e) {
				LOGGER.error("deleteFile Fail : {}", e.getMessage());
				//throw new ApplicationException(e);
			}
		});

		fileMapper.deleteFileByGroupId(fileGroupId);
		fileMapper.deleteFileGroupByGroupId(fileGroupId);
	}

	private String getBaseDir(FileType type) {
		String baseDir;

		switch (type) {
		case WEB:
			baseDir = uploadDir;
			break;
		case MOBILE:
			baseDir = mobileUploadDir;
			break;
		case CALL_CENTER:
			baseDir = callcenterUploadDir;
			break;
		case WEB_DIRECT_RESOURCE:
			baseDir = uploadResourceDir;
			break;
		default:
			throw new ApplicationException(AppConstants.FAIL, "Invalid FileType ....");
		}

		return baseDir;
	}

	@Override
	public void removeFileByFileId(FileType type, int fileId) {
		String baseDir = getBaseDir(type);
		FileVO fileVO = this.getFile(fileId);

		try {
			FileUtils.forceDelete(
					new File(baseDir + File.separator+ fileVO.getFileSubPath() + File.separator + fileVO.getPhysiclFileName()));
		} catch (IOException e) {
			LOGGER.error("deleteFile Fail : {}", e.getMessage());
			//throw new ApplicationException(e);
		}

		fileMapper.deleteFileByFileId(fileId);
		fileMapper.deleteFileGroupByFileId(fileId);
	}

	@Override
	public void changeFile(int fileGroupId, int preFileId, FileVO fileVO, FileType type, int userId) {
		this.removeFileByFileId(type, preFileId);
		this.insertFile(fileGroupId, fileVO, type, userId);
	}
}
