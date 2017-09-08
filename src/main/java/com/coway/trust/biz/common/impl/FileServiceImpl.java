package com.coway.trust.biz.common.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;

@Service("fileService")
public class FileServiceImpl implements FileService {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileServiceImpl.class);

	@Autowired
	private FileMapper fileMapper;

	@Override
	public int insertFiles(List<FileVO> fileVOList, String fileChannel, int userId) {
		int fileGroupKey = fileMapper.selectFileGroupKey();
		fileVOList.forEach(r -> this.insertFile(fileGroupKey, r, fileChannel, userId));
		return fileGroupKey;
	}

	private int insertFile(int fileGroupId, FileVO fileVO, String fileChannel, int userId) {
		FileGroupVO fileGroupVO = new FileGroupVO();

		fileMapper.insertFileDetail(fileVO);

		fileGroupVO.setAtchFileGrpId(fileGroupId);
		fileGroupVO.setAtchFileId(fileVO.getAtchFileId());
		fileGroupVO.setChenalType(fileChannel);
		fileGroupVO.setCrtUserId(userId);
		fileGroupVO.setUpdUserId(userId);

		fileMapper.insertFileGroup(fileGroupVO);

		return fileGroupId;
	}
}
