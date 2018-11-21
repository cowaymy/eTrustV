package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.order.PreOrderApplication;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.util.CommonUtils;

@Service("PreOrderApplication")
public class PreOrderApplicationImpl implements PreOrderApplication {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
	private PreOrderService preOrderService;

	@Override
	public void insertPreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}

	@Override
	public void updatePreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub

		LOGGER.debug("params =====================================>>  " + params);

		LOGGER.debug("list.size : {}", list.size());

		// 243,258
		String update = (String) params.get("update");
		String[] updateList = null;
		if(!StringUtils.isEmpty(update)) {
			updateList = params.get("update").toString().split(",");
			LOGGER.debug("updateList.length : {}", updateList.length);
		}
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			for(int i = 0; i < list.size(); i++) {
				if(updateList != null && i < updateList.length) {
					String atchFileId = updateList[i];
					LOGGER.debug("params.get('atchFileGrpId') =====================================>>  " + params.get("atchFileGrpId"));
					LOGGER.debug("atchFileId =====================================>>  " + atchFileId);
					LOGGER.debug("list.get(i) =====================================>>  " + list.get(i));
					LOGGER.debug("params.get('userId') =====================================>>  " + params.get("userId"));
					fileService.changeFile(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
				} else {
					FileGroupVO fileGroupVO = new FileGroupVO();

					LOGGER.debug("list.get(i) =====================================>>  " + list.get(i));
					//fileMapper.insertFileDetail(list.get(i));

					fileGroupVO.setAtchFileGrpId(Integer.parseInt(params.get("atchFileGrpId").toString()));
					fileGroupVO.setAtchFileId(list.get(i).getAtchFileId());
					fileGroupVO.setChenalType(type.getCode());
					fileGroupVO.setCrtUserId(Integer.parseInt(String.valueOf(params.get("userId"))));
					fileGroupVO.setUpdUserId(Integer.parseInt(String.valueOf(params.get("userId"))));

					LOGGER.debug("fileGroupVO =====================================>>  " + fileGroupVO);
					fileMapper.insertFileGroup(fileGroupVO);
				}
			}
		}

		String remove = (String) params.get("remove");
		String[] removeList = null;
		if(!StringUtils.isEmpty(remove)) {
			removeList = params.get("remove").toString().split(",");
			LOGGER.debug("removeList.size : {}", removeList.length);
		}
		if(removeList != null && removeList.length > 0) {
			for(int i = 0; i < removeList.length; i++) {
				String atchFileId = removeList[i];
				LOGGER.debug("atchFileId =====================================>>  " + atchFileId);
				fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
			}
		}
	}

	@Override
	public void deletePreOrderAttachBiz(FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		if(CommonUtils.isEmpty(params.get("clmNo"))) {
			// Not Temp. Save
			// 저장된 파일만 삭제
			fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
		} else {
			// Temp. Save
			// 저장된 파일 삭제 및 테이블 데이터 삭제
			/*// 2018-07-20 - LaiKW - Added check on atchFileGrpId for claims without attachments - Start
			if(params.get("atchFileGrpId") != null) {
				fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
			}
			// 2018-07-20 - LaiKW - Added check on atchFileGrpId for claims without attachments - End
			preOrderService.deletePreOrderExpItem(params);
			LOGGER.debug("expGrp =====================================>>  " + params.get("expGrp"));
			if("1".equals(params.get("expGrp"))) {
				preOrderService.deletePreOrderExpMileage(params);
			}
			preOrderService.updatePreOrderExpTotAmt(params);*/
		}
	}



}
