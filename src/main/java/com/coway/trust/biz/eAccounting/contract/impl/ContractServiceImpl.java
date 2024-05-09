package com.coway.trust.biz.eAccounting.contract.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.contract.impl.ContractMapper;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.contract.ContractService;
import com.coway.trust.biz.eAccounting.vendor.VendorMapper;
import com.coway.trust.biz.eAccounting.vendor.VendorService;
import com.coway.trust.biz.sales.mambership.impl.MembershipESvmMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("contractService")
public class ContractServiceImpl implements ContractService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "vendorMapper")
	private VendorMapper vendorMapper;

	@Resource(name = "contractMapper")
	private ContractMapper contractMapper;

	@Resource(name = "membershipESvmMapper")
    private MembershipESvmMapper membershipESvmMapper;

	@Autowired
    private FileService fileService;

	@Autowired
    private FileMapper fileMapper;

	@Override
	public List<EgovMap> selectContractTrackingList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return contractMapper.selectContractTrackingList(params);
	}

	@Override
	public String selectNextContractNo() {
		// TODO Auto-generated method stub
		return contractMapper.selectNextContractNo();
	}

	@Override
	public void insertVendorTrackingInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub

		String contractNumber = contractMapper.selectNextContractNo();
		params.put("contTrackNo", contractNumber);

		int contractId = contractMapper.selectNextContractId();
		params.put("contTrackId", contractId);

		LOGGER.debug("insertWebInvoiceInfo =====================>>  " + params);

		contractMapper.insertVendorMain(params);

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기

		contractMapper.insertVendorDetails(params);

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("contTrackId", params.get("contTrackId"));
				int contractSeq = contractMapper.selectNextContractSeq((int) params.get("contTrackId"));
				//hm.put("seq", params.get("seq"));
				hm.put("userId", params.get("userId"));
				LOGGER.debug("insertContractCycleDetails ============>>  " + params);
				contractMapper.insertContractCycleDetails(hm);
			}
		}

		LOGGER.info("추가 : {}", addList.toString());
		int numberOfCycle = addList.size();
		params.put("noOfCycle", numberOfCycle);
		contractMapper.updateRenewalCycle(params);
	}

	@Override
	public EgovMap selectContractTrackingViewDetails(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return contractMapper.selectContractTrackingViewDetails(params);
	}

	@Override
	public List<EgovMap> selectContractCycleDetails(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return contractMapper.selectContractCycleDetails(params);
	}

	@Override
	public void updateVendorTrackingInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub

//		String contractNumber = contractMapper.selectNextContractNo();
//		params.put("contTrackNo", contractNumber);

//		int contractId = contractMapper.selectNextContractId();
//		params.put("contTrackId", contractId);

		LOGGER.debug("insertWebInvoiceInfo =====================>>  " + params);

		contractMapper.insertVendorMain(params);

		contractMapper.insertVendorDetails(params);

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
		List<Object> addList = (List<Object>) gridData.get("add");
		List<Object> updateList = (List<Object>) gridData.get("update");
		List<Object> removeList = (List<Object>) gridData.get("remove");

		if (removeList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : removeList) {
				hm = (HashMap<String, Object>) map;
				hm.put("contTrackId", params.get("contTrackId"));
				hm.put("userId", params.get("userId"));
				hm.put("status", 8);
				LOGGER.debug("updateContractCycleDetails removeList============>>  " + params);
				contractMapper.removeContractCycleDetails(hm);
			}
		}

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				int contractSeq = contractMapper.selectNextContractSeq(Integer.parseInt(params.get("contTrackId").toString()));
				hm.put("contTrackId", params.get("contTrackId"));
				//hm.put("seq", params.get("seq"));
				hm.put("userId", params.get("userId"));
				LOGGER.debug("insertContractCycleDetails addList============>>  " + params);
				contractMapper.insertContractCycleDetails(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("contTrackId", params.get("contTrackId"));
				hm.put("userId", params.get("userId"));
				LOGGER.debug("updateContractCycleDetails updateList============>>  " + params);
				contractMapper.updateContractCycleDetails(hm);
			}
		}


		List<EgovMap> numberCycle = contractMapper.selectContractCycleDetails(params);
		int numberOfCycle = numberCycle.size();
		params.put("noOfCycle", numberOfCycle);
		contractMapper.updateRenewalCycle(params);

	}

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

		if(updateList == null && removeList != null && removeList.length > 0){
			for(String id : removeList){
				LOGGER.info(id);
				String atchFileId = id;
				fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
			}
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
					int fileGroupId = params.get("atchFileGrpId").toString().isEmpty() ? fileMapper.selectFileGroupKey() : (Integer.parseInt(params.get("atchFileGrpId").toString())) ;
					this.insertFile(fileGroupId, list.get(i), type,params, seqs.get(i));
					params.put("atchFileGrpId", fileGroupId);
					params.put("fileGroupKey", fileGroupId);
				}
			}
		}
	}


	@Override
	public void deleteVendorTrackingInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub

//		String contractNumber = contractMapper.selectNextContractNo();
//		params.put("contTrackNo", contractNumber);

//		int contractId = contractMapper.selectNextContractId();
//		params.put("contTrackId", contractId);

		LOGGER.debug("insertWebInvoiceInfo =====================>>  " + params);

		contractMapper.insertVendorMain(params);

	}

}
