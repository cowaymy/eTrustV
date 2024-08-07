package com.coway.trust.biz.sales.mambership.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

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
import com.coway.trust.biz.sales.mambership.MembershipESvmApplication;

@Service("membershipESvmApplication")
public class MembershipESvmApplicationImpl implements MembershipESvmApplication {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
    private FileService fileService;

	@Autowired
    private FileMapper fileMapper;

    @Resource(name = "membershipESvmMapper")
    private MembershipESvmMapper membershipESvmMapper;

	@Override
	public void insertPreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileMapper.selectFileGroupKey();
		AtomicInteger i = new AtomicInteger(0); // get seq key.

		list.forEach(r -> {this.insertFile(fileGroupKey, r, type, params, seqs.get(i.getAndIncrement()));});
		params.put("fileGroupKey", fileGroupKey);
	}

	public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params,String seq) {
        LOGGER.debug("insertFile :: Start");

        int atchFlId = membershipESvmMapper.selectNextFileId();

        FileGroupVO fileGroupVO = new FileGroupVO();

        Map<String, Object> flInfo = new HashMap<String, Object>();
        flInfo.put("atchFileId", atchFlId);
        flInfo.put("atchFileName", flVO.getAtchFileName());
        flInfo.put("fileSubPath", flVO.getFileSubPath());
        flInfo.put("physiclFileName", flVO.getPhysiclFileName());
        flInfo.put("fileExtsn", flVO.getFileExtsn());
        flInfo.put("fileSize", flVO.getFileSize());
        flInfo.put("filePassword", flVO.getFilePassword());
        flInfo.put("fileUnqKey", params.get("claimUn"));
        flInfo.put("fileKeySeq", seq);

        membershipESvmMapper.insertFileDetail(flInfo);

        fileGroupVO.setAtchFileGrpId(fileGroupKey);
        fileGroupVO.setAtchFileId(atchFlId);
        fileGroupVO.setChenalType(flType.getCode());
        fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
        fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));

        fileMapper.insertFileGroup(fileGroupVO);

        LOGGER.debug("insertFile :: End");
    }

	@Override
	public void updatePreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params.toString());
		LOGGER.debug("list.size : {}", list.size());
		String update = (String) params.get("update");
		String remove = (String) params.get("remove");
		String[] updateList = null;
		String[] removeList = null;
		if(!StringUtils.isEmpty(update)) {
			updateList = params.get("update").toString().split(",");
			LOGGER.debug("updateList.length : {}", updateList.length);
		}
		if(!StringUtils.isEmpty(remove)) {
			removeList = params.get("remove").toString().split(",");
			LOGGER.debug("removeList.length : {}", removeList.length);
		}
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			for(int i = 0; i < list.size(); i++) {
				if(updateList != null && i < updateList.length && removeList != null && removeList.length > 0) {
					String atchFileId = updateList[i];
					String removeAtchFileId = removeList[i];
					if(atchFileId.equals(removeAtchFileId))
					{
						fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
					}
					else {
						int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
						this.insertFile(fileGroupId, list.get(i), type,params, seqs.get(i));
					}
				}
				else if(updateList != null && i < updateList.length) {
					String atchFileId = updateList[i];
					fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
				}
				else {
					int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
					this.insertFile(fileGroupId, list.get(i), type,params, seqs.get(i));
				}
			}
		}
		if(updateList == null && removeList != null && removeList.length > 0){
			for(String id : removeList){
				LOGGER.info(id);
				String atchFileId = id;
				fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
			}
		}
	}
}
