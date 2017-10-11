package com.coway.trust.biz.common;

import java.util.List;

public interface FileService {

	/**
	 * 공통 첨부파일 저장.
	 * 
	 * @param fileVOList
	 * @param fileChannel
	 *            {@link com.coway.trust.AppConstants}
	 * @param userId
	 * @return
	 */
	int insertFiles(List<FileVO> fileVOList, String fileChannel, int userId);

}
