package com.coway.trust.biz.eAccounting.staffClaim.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
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
import com.coway.trust.biz.eAccounting.staffClaim.StaffClaimApplication;
import com.coway.trust.biz.eAccounting.staffClaim.StaffClaimService;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import aj.org.objectweb.asm.Type;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("staffClaimApplication")
public class StaffClaimApplicationImpl implements StaffClaimApplication {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
	private StaffClaimMapper staffClaimMapper;

	@Autowired
	private StaffClaimService staffClaimService;

	@Override
	public void insertStaffClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}

	@Override
	public void updateStaffClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		try {
    		LOGGER.debug("params =====================================>>  " + params);

    		LOGGER.debug("list.size : {}", list.size());

    		// 243,258
    		JSONArray updateList = null;
    		String update = params.get("update").toString();

    		if(!StringUtils.isEmpty(update)) {
				updateList = new JSONArray(update);
    		}

    		if (list.size() > 0) {
    			for(int i = 0; i < list.size(); i++) {
    				if(updateList != null && i < updateList.length()) {
    					//Update previous existing data
    					String atchFileGrpId = updateList.getJSONObject(i).getString("atchFileGrpId").toString();
    					String atchFileId = updateList.getJSONObject(i).getString("atchFileId").toString();
    					LOGGER.debug("atchFileId =====================================>>  " + atchFileGrpId);
    					LOGGER.debug("list.get(i) =====================================>>  " + list.get(i));
    					LOGGER.debug("params.get('userId') =====================================>>  " + params.get("userId"));
    					fileService.changeFile(Integer.parseInt(atchFileGrpId), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
    				}
    				else{
    					//For Normal Expenses only if no update list found,
    					//Car mileage will always have update list as it solely use update only and new attachment will call upload instead
    					String atchFileGrpId = params.get("atchFileGrpId").toString();
    					FileGroupVO fileGroupVO = new FileGroupVO();
    					int atchFileId = staffClaimMapper.selectNewAtchFileId();
    					list.get(i).setAtchFileId(atchFileId);
    					staffClaimMapper.insertFileDetail(list.get(i));
    					LOGGER.debug("list.get(i) =====================================>>  " + list.get(i));

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

    		String remove = params.get("remove").toString();
    		JSONArray removeList = null;

    		if(!StringUtils.isEmpty(remove)) {
    			removeList = new JSONArray(remove);
    		}

    		if(removeList != null && removeList.length() > 0) {
    			for(int i = 0; i < removeList.length(); i++) {
    				String atchFileId = removeList.getJSONObject(i).getString("atchFileId").toString();;
    				LOGGER.debug("atchFileId =====================================>>  " + atchFileId);
    				fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
    			}
    		}

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void deleteStaffClaimAttachBiz(FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		if(CommonUtils.isEmpty(params.get("clmNo"))) {
			// Not Temp. Save
			// 저장된 파일만 삭제
			fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
		} else {
			int staffClaimDetailCount = staffClaimMapper.selectAttachmentStaffClaimExpItemCount(params);
			//Logic change explain: Now if detect there are more than 1 detail record in FCM0020D, attachment will not be removed automatically by deletion of 1 record,
			//instead user will have to manual delete, only if there is 1 detail record left, then attachment will be removed
			if(staffClaimDetailCount <= 1){
    			// Temp. Save
    			// 저장된 파일 삭제 및 테이블 데이터 삭제
    			// 2018-07-20 - LaiKW - Added check on atchFileGrpId for claims without attachments - Start
    			if(params.get("atchFileGrpId") != null) {
    				fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
    			}
			}
			// 2018-07-20 - LaiKW - Added check on atchFileGrpId for claims without attachments - End
			staffClaimService.deleteStaffClaimExpItem(params);
			LOGGER.debug("expGrp =====================================>>  " + params.get("expGrp"));
			if("1".equals(params.get("expGrp"))) {
				staffClaimService.deleteStaffClaimExpMileage(params);
			}

			staffClaimService.updateStaffClaimExpTotAmt(params);
		}
	}
}
