package com.coway.trust.biz.common.impl;

import java.util.List;

import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("fileMapper")
public interface FileMapper {

	int selectFileGroupKey();

	void insertFileGroup(FileGroupVO fileGroupVO);

	void insertFileDetail(FileVO fileVO);

	FileVO selectFileByFileId(int fileId);

	List<FileVO> selectFilesByGroupId(int groupId);

	void deleteFileGroupByGroupId(int fileGroupId);

	void deleteFileByGroupId(int fileGroupId);

	void deleteFileGroupByFileId(int fileId);

	void deleteFileByFileId(int fileId);

	int selectFileGroupCountByFileId(int fileId);

	void updateFileDetail(FileVO fileVO);
}
