package com.coway.trust.biz.eAccounting.pettyCash.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashApplication;
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("pettyCashApplication")
public class PettyCashApplicationImpl implements PettyCashApplication {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
	private PettyCashService pettyCashService;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
  public Boolean insertCustodianBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
    // TODO Auto-generated method stub
    LOGGER.debug("params =====================================>>  " + params);
    boolean result = false;
    // VANNIE ADD CHECKING DUPLICATE CUSTODIAN ID 11/12/2019
    
    String memAccId = (String) params.get("memAccId");
    
    String custdnId = pettyCashService.checkCustodian(memAccId);
    LOGGER.debug("custdnId =====>> " + custdnId);
    
    if (custdnId == null) {
      // serivce 에서 파일정보를 가지고, DB 처리.
      LOGGER.debug("list.size : {}", list.size());
      if (list.size() > 0) {
        int fileGroupKey = fileService.insertFiles(list, type, Integer.parseInt(String.valueOf(params.get("userId"))));
        params.put("fileGroupKey", fileGroupKey);
      }
      
      pettyCashService.insertCustodian(params);
      result = true;
      
    } else {
      result = false;
    }
    return result;
    
  }

	@Override
	public void updateCustodianBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
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
					fileMapper.insertFileDetail(list.get(i));

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

		pettyCashService.updateCustodian(params);
	}

	@Override
	public void deleteCustodianBiz(FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		// custodianInfo get
		// atchFileGrpId get
		// file data delete
		EgovMap custodianInfo = pettyCashService.selectCustodianInfo(params);
		String atchFileGrpId = String.valueOf(custodianInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if (atchFileGrpId != "null") {
			// TODO file delete
			fileService.removeFilesByFileGroupId(type, Integer.parseInt(atchFileGrpId));
		}

		pettyCashService.deleteCustodian(params);
	}

	@Override
	public void insertPettyCashReqstBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		LOGGER.debug("list.size : {}", list.size());

		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			int fileGroupKey = fileService.insertFiles(list, type, Integer.parseInt(params.get("userId").toString()));
			params.put("fileGroupKey", fileGroupKey);
		}

		String clmNo = pettyCashService.selectNextRqstClmNo();
		params.put("clmNo", clmNo);

		pettyCashService.insertPettyCashReqst(params);
	}

	@Override
	public void updatePettyCashReqstBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
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
					fileMapper.insertFileDetail(list.get(i));

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

		pettyCashService.updatePettyCashReqst(params);
	}

	@Override
	public void insertPettyCashAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}

	@Override
	public void updatePettyCashAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
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
					fileMapper.insertFileDetail(list.get(i));

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
	public void deletePettyCashAttachBiz(FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		//if(CommonUtils.isEmpty(params.get("clmNo"))) {
			// Not Temp. Save
			// 저장된 파일만 삭제
			//fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
		//} else {
			// Temp. Save
			// 저장된 파일 삭제 및 테이블 데이터 삭제
			fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
			pettyCashService.deletePettyCashExpItem(params);
			pettyCashService.updatePettyCashExpTotAmt(params);
		//}
	}

}
