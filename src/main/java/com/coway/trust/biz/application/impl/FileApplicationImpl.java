package com.coway.trust.biz.application.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.notice.NoticeService;
import com.coway.trust.biz.services.as.CompensationService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * 서비스에서 서비스를 호출 하게되는 경우는 업무 + Application 클래스를 작성하여 서비스 각각의 서비스를 Injection 하여 사용함을 원칙으로 한다.
 * 
 * - [참고] Application에서 서비스 호출을 try{}catch{} 로 묶더라도 롤백 됨. Service 함수에서 try{}catch{} 처리를 해야 롤백 안됨.
 * 
 * @author lim
 *
 */
@Service("fileApplication")
public class FileApplicationImpl implements FileApplication {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);
	private static final String USER_ID = "userId";

	@Autowired
	private FileService fileService;

	@Autowired
	private NoticeService noticeService;
	
	@Autowired
	private CompensationService compensationService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Override
	public int businessAttach(FileType type, List<FileVO> list, Map<String, Object> params) {

		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get(USER_ID));
		params.put("fileGroupKey", fileGroupKey);

		// fileGroupKey 를 가지고 업무 처리..
		// 업무 crud 처리.
		// customerService.insertCustomerInfo(params);
		//noticeService.insertNotice(params);
		return fileGroupKey;
	}

	@Override
	public int commonAttachByUserId(FileType type, List<FileVO> list, Map<String, Object> params) {
		LOGGER.debug("user id(int) : {}", params.get(USER_ID));
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get(USER_ID));
		params.put("fileGroupKey", fileGroupKey);
		return fileGroupKey;
	}

	@Override
	public int commonAttachByUserName(FileType type, List<FileVO> list, Map<String, Object> params) {
		LOGGER.debug("user id(String) : {}", params.get(USER_ID));
		int userId = fileService.getUserIdByUserName((String) params.get(USER_ID));
		if (userId == 0) {
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "userId(String)" }));
		}
		params.put(USER_ID, userId);
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get(USER_ID));
		params.put("fileGroupKey", fileGroupKey);
		return fileGroupKey;
	}

	@Override
	public void noticeAttach(FileType type, List<FileVO> list, Map<String, Object> params) {
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get(USER_ID));
		params.put("atchFileGrpId", fileGroupKey);
		noticeService.insertNotice(params);
	}

	@Override
	public void updateNoticeAttach(List<FileVO> fileVOS, Map<String, Object> params) {

		String updateFileIds = (String) params.get("updateFileIds");
		String deleteFileIds = (String) params.get("deleteFileIds");
		String fileGroupId = (String) params.get("fileGroupId");
		int userId = (int) params.get(USER_ID);
		String[] updateFileId = null;
		String[] deleteFileId = null;

		int newFileGroupId = 0;

		if (StringUtils.isNotEmpty(updateFileIds)) {
			updateFileId = CommonUtils.getDelimiterValues(updateFileIds);
		}

		if (StringUtils.isNotEmpty(deleteFileIds)) {
			deleteFileId = CommonUtils.getDelimiterValues(deleteFileIds);
		}

		int fileCnt = 0;

		if (deleteFileId != null) {
			for (String fileId : deleteFileId) {
				if (StringUtils.isNotEmpty(fileId)) {
					fileService.removeFileByFileId(FileType.WEB, Integer.parseInt(fileId));
				}
			}
		}

		if (StringUtils.isNotEmpty(fileGroupId)) {
			for (FileVO fileVO : fileVOS) {
				if (updateFileId != null && fileCnt <= updateFileId.length - 1) {
					if (StringUtils.isNotEmpty(updateFileId[fileCnt])) {
						fileService.changeFile(Integer.parseInt(fileGroupId), Integer.parseInt(updateFileId[fileCnt]),
								fileVO, FileType.WEB, userId);
					}
				} else {
					fileService.insertFile(Integer.parseInt(fileGroupId), fileVO, FileType.WEB, userId);
				}

				fileCnt++;
			}
		} else {
			if (fileVOS.size() > 0) {
				newFileGroupId = fileService.insertFiles(fileVOS, FileType.WEB, userId);
				params.put("atchFileGrpId", newFileGroupId);
			}
		}

		noticeService.updateNotice(params);
	}
	
	
	
	@Override
	public void updateBusinessAttach(List<FileVO> fileVOS, Map<String, Object> params) {

		String updateFileIds = (String) params.get("updateFileIds");
		String deleteFileIds = (String) params.get("deleteFileIds");
		String fileGroupId = (String) params.get("fileGroupId");
		int userId = (int) params.get(USER_ID);
		String[] updateFileId = null;
		String[] deleteFileId = null;

		int newFileGroupId = 0;

		if (StringUtils.isNotEmpty(updateFileIds)) {
			updateFileId = CommonUtils.getDelimiterValues(updateFileIds);
		}

		if (StringUtils.isNotEmpty(deleteFileIds)) {
			deleteFileId = CommonUtils.getDelimiterValues(deleteFileIds);
		}

		int fileCnt = 0;

		if (deleteFileId != null) {
			for (String fileId : deleteFileId) {
				if (StringUtils.isNotEmpty(fileId)) {
					fileService.removeFileByFileId(FileType.WEB, Integer.parseInt(fileId));
				}
			}
		}

		if (StringUtils.isNotEmpty(fileGroupId)) {
			for (FileVO fileVO : fileVOS) {
				if (updateFileId != null && fileCnt <= updateFileId.length - 1) {
					if (StringUtils.isNotEmpty(updateFileId[fileCnt])) {
						fileService.changeFile(Integer.parseInt(fileGroupId), Integer.parseInt(updateFileId[fileCnt]),
								fileVO, FileType.WEB, userId);
					}
				} else {
					fileService.insertFile(Integer.parseInt(fileGroupId), fileVO, FileType.WEB, userId);
				}

				fileCnt++;
			}
		} else {
			if (fileVOS.size() > 0) {
				newFileGroupId = fileService.insertFiles(fileVOS, FileType.WEB, userId);
				params.put("atchFileGrpId", newFileGroupId);
			}
		}

		compensationService.updateCompensation(params);
	}
}
