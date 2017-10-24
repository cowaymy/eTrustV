package com.coway.trust.biz.eAccounting.pettyCash.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("pettyCashService")
public class PettyCashServiceImpl implements PettyCashService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;
	
	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	@Autowired
	private FileApplication fileApplication;
	
	@Autowired
	private WebInvoiceMapper webInvoiceMapper;
	
	@Resource(name = "pettyCashMapper")
	private PettyCashMapper pettyCashMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectCustodianList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectCustodianList(params);
	}

	@Override
	public String selectUserNric(String memAccId) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectUserNric(memAccId);
	}

	@Override
	public Map<String, Object> insertCustodian(MultipartHttpServletRequest request, Map<String, Object> params)
			throws Exception {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		params.put("attachmentList", list);
		
		pettyCashMapper.insertCustodian(params);
		
		return params;
	}

	@Override
	public EgovMap selectCustodianInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectCustodianInfo(params);
	}

	

	@Override
	public Map<String, Object> updateCustodian(MultipartHttpServletRequest request, Map<String, Object> params)
			throws Exception {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			// file update 미구현
			//fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		params.put("attachmentList", list);
		
		pettyCashMapper.updateCustodian(params);
		
		return params;
	}

	@Override
	public void deleteCustodian(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		// custodianInfo get
		// atchFileGrpId get
		// file data delete
		EgovMap custodianInfo = pettyCashMapper.selectCustodianInfo(params);
		String atchFileGrpId = String.valueOf(custodianInfo.get("atchFileGrpId"));
		LOGGER.debug("atchFileGrpId =====================================>>  " + atchFileGrpId);
		// atchFileGrpId db column type number -> null인 경우 nullPointExecption (String.valueOf 처리)
		// file add 하지 않은 경우 "null" -> StringUtils.isEmpty false return
		if (atchFileGrpId != "null") {
			// TODO file delete
		}
		
		
		pettyCashMapper.deleteCustodian(params);
	}

	@Override
	public List<EgovMap> selectRequestList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectRequestList(params);
	}

	@Override
	public Map<String, Object> insertPettyCashReqst(MultipartHttpServletRequest request, Map<String, Object> params)
			throws Exception {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		params.put("attachmentList", list);
		
		String clmNo = pettyCashMapper.selectNextClmNo();
		params.put("clmNo", clmNo);
		
		pettyCashMapper.insertPettyCashReqst(params);
		
		return params;
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
LOGGER.debug("params =====================================>>  " + params);
		
		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		
		params.put("appvLineCnt", apprGridList.size());
		
		LOGGER.debug("insertApproveManagement =====================================>>  " + params);
		webInvoiceMapper.insertApproveManagement(params);
		
		if (apprGridList.size() > 0) {
			Map hm = null;
			
			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
				// TODO appvLineDetailTable Insert
				webInvoiceMapper.insertApproveLineDetail(hm);
			}
		}
		
		int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
		params.put("appvItmSeq", appvItmSeq);
		LOGGER.debug("insertApproveItems =====================================>>  " + params);
		// TODO appvLineItemsTable Insert
		pettyCashMapper.insertApproveItems(params);
		
		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		pettyCashMapper.updateAppvPrcssNo(params);
	}

	@Override
	public EgovMap selectRequestInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectRequestInfo(params);
	}
	
	

}
