package com.coway.trust.biz.eAccounting.creditCard.impl;

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
import com.coway.trust.biz.eAccounting.creditCard.CreditCardApplication;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardService;
import com.coway.trust.util.CommonUtils;

@Service("creditCardApplication")
public class CreditCardApplicationImpl implements CreditCardApplication {

private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
	private CreditCardService creditCardService;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public void insertCreditCardBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		// serivce 에서 파일정보를 가지고, DB 처리.
		LOGGER.debug("list.size : {}", list.size());
		if (list.size() > 0) {
			int fileGroupKey = fileService.insertFiles(list, type, Integer.parseInt(String.valueOf(params.get("userId"))));
			params.put("fileGroupKey", fileGroupKey);
		}

		creditCardService.insertCreditCard(params);

		String ifKey = creditCardService.selectNextIfKey();
		params.put("ifKey", ifKey);

		int seq = creditCardService.selectNextSeq(ifKey);
		params.put("seq", seq);

		String crditCardNo = (String) params.get("crditCardNo");
		String agentNo = "CC" + crditCardNo.substring(0, 4) + crditCardNo.substring(crditCardNo.length() - 4, crditCardNo.length());
		params.put("agentNo", agentNo);

		String crditCardUserId = (String) params.get("crditCardUserId");
		String agentNm = "Corporate_" + crditCardUserId;
		params.put("agentNm", agentNm);

		params.put("acctSt", "01");

		creditCardService.insertCrditCardInterface(params);
	}

	@Override
	public void updateCreditCardBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
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

		creditCardService.updateCreditCard(params);

		String ifKey = creditCardService.selectNextIfKey();
		params.put("ifKey", ifKey);

		int seq = creditCardService.selectNextSeq(ifKey);
		params.put("seq", seq);

		String crditCardNo = (String) params.get("crditCardNo");
		String agentNo = "CC" + crditCardNo.substring(0, 4) + crditCardNo.substring(crditCardNo.length() - 4, crditCardNo.length());
		params.put("agentNo", agentNo);

		String crditCardUserId = (String) params.get("crditCardUserId");
		String agentNm = "Corporate_" + crditCardUserId;
		params.put("agentNm", agentNm);

		params.put("acctSt", "02");

		creditCardService.insertCrditCardInterface(params);
	}

	@Override
	public void removeCreditCardBiz(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		creditCardService.removeCreditCard(params);

		String ifKey = creditCardService.selectNextIfKey();
		params.put("ifKey", ifKey);

		int seq = creditCardService.selectNextSeq(ifKey);
		params.put("seq", seq);

		String crditCardNo = (String) params.get("crditCardNo");
		String agentNo = "CC" + crditCardNo.substring(0, 4) + crditCardNo.substring(crditCardNo.length() - 4, crditCardNo.length());
		params.put("agentNo", agentNo);

		String crditCardUserId = String.valueOf(params.get("crditCardUserId"));
		String agentNm = "Corporate_" + crditCardUserId;
		params.put("agentNm", agentNm);

		params.put("acctSt", "03");

		creditCardService.insertCrditCardInterface(params);
	}

	@Override
	public void insertReimbursementAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}

	@Override
	public void updateReimbursementAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
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
	public void deleteReimbursementAttachBiz(FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		//if(CommonUtils.isEmpty(params.get("clmNo"))) {
			// Not Temp. Save
			// 저장된 파일만 삭제
//			fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
		//} else {
			// Temp. Save
			// 저장된 파일 삭제 및 테이블 데이터 삭제
			fileService.removeFilesByFileGroupId(type, (int) params.get("atchFileGrpId"));
			creditCardService.deleteReimbursement(params);
			creditCardService.updateReimbursementTotAmt(params);
		//}
	}





}
