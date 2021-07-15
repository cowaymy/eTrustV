package com.coway.trust.biz.sales.ownershipTransfer.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ownershipTransfer.OwnershipTransferApplication;

@Service("ownershipTransferApplication")
public class OwnershipTransferApplicationImpl implements OwnershipTransferApplication {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Override
	public void insertOwnershipTransferAttach(List<FileVO> list, FileType type, Map<String, Object> params) {
		LOGGER.debug("ownershipTransferApplication :: insertOwnershipTransferAttach");

		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}

	@Override
	public void updateOwnershipTransferAttach(List<FileVO> list, FileType type, Map<String, Object> params) {
		LOGGER.debug("ownershipTransferApplication :: updateOwnershipTransferAttach");

		String update = (String) params.get("update");
		String[] updateList = null;
		if (!StringUtils.isEmpty(update)) {
			updateList = params.get("update").toString().split(",");
			LOGGER.debug("updateList.length : {}", updateList.length);
		}

		if (list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				if (updateList != null && i < updateList.length) {
					String atchFileId = updateList[i];

					LOGGER.debug("updateAttach(i) :: atchFileGrpId :: " + params.get("atchFileGrpId"));
					LOGGER.debug("updateAttach(i) :: atchFileId :: " + atchFileId);
					LOGGER.debug("updateAttach(i) :: list.get(i) :: " + list.get(i));
					LOGGER.debug("updateAttach(i) :: userId :: " + params.get("userId"));

					fileService.changeFile(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))),
							Integer.parseInt(atchFileId), list.get(i), type,
							Integer.parseInt(String.valueOf(params.get("userId"))));
				} else {
					FileGroupVO fileGroupVO = new FileGroupVO();

					LOGGER.debug("updateAttach(e) :: list.get(i) :: " + list.get(i));
					fileMapper.insertFileDetail(list.get(i));

					fileGroupVO.setAtchFileGrpId(Integer.parseInt(params.get("atchFileGrpId").toString()));
					fileGroupVO.setAtchFileId(list.get(i).getAtchFileId());
					fileGroupVO.setChenalType(type.getCode());
					fileGroupVO.setCrtUserId(Integer.parseInt(String.valueOf(params.get("userId"))));
					fileGroupVO.setUpdUserId(Integer.parseInt(String.valueOf(params.get("userId"))));

					LOGGER.debug("updateAttach(e) :: fileGroupVO :: " + fileGroupVO);
					fileMapper.insertFileGroup(fileGroupVO);
				}
			}
		}
	}

}
