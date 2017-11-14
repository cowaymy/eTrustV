package com.coway.trust.biz.common;

import java.util.List;

import com.coway.trust.biz.common.type.FileType;

public interface FileService {

	/**
	 * 공통 첨부파일 저장.
	 * 
	 * @param fileVOList
	 * @param type
	 *            {@link FileType}
	 * @param userId
	 * @return
	 */
	int insertFiles(List<FileVO> fileVOList, FileType type, int userId);

	int insertFile(int fileGroupId, FileVO fileVO, FileType type, int userId);

	FileVO getFile(int fileId);

	List<FileVO> getFiles(int fileGroupId);

	void removeFilesByFileGroupId(FileType type, int fileGroupId);

	void removeFileByFileId(FileType type, int fileId);

	void changeFile(int fileGroupId, int preFileId, FileVO fileVO, FileType type, int userId);
}
