package com.coway.trust.biz.eAccounting.staffClaim.impl;

import java.util.ArrayList;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.staffClaim.StaffClaimService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("staffClaimService")
public class StaffClaimServiceImpl implements StaffClaimService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "staffClaimMapper")
	private StaffClaimMapper staffClaimMapper;

	@Autowired
	private WebInvoiceMapper webInvoiceMapper;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
	private FileService fileService;

	@Override
	public List<EgovMap> selectStaffClaimList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectStaffClaimList(params);
	}

	@Override
	public List<EgovMap> selectTaxCodeStaffClaimFlag() {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectTaxCodeStaffClaimFlag();
	}

	@Override
	public void insertStaffClaimExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> gridDataList = (List<Object>) params.get("gridDataList");

		Map<String, Object> masterData = (Map<String, Object>) gridDataList.get(0);

		String clmNo = staffClaimMapper.selectNextClmNo();
		params.put("clmNo", clmNo);

		masterData.put("clmNo", clmNo);
		masterData.put("allTotAmt", params.get("allTotAmt"));
		masterData.put("userId", params.get("userId"));
		masterData.put("userName", params.get("userName"));

		LOGGER.debug("masterData =====================================>>  " + masterData);
		staffClaimMapper.insertStaffClaimExp(masterData);

		for(int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
			int clmSeq = staffClaimMapper.selectNextClmSeq(clmNo);
			item.put("clmNo", clmNo);
			item.put("clmSeq", clmSeq);
			item.put("userId", params.get("userId"));
			item.put("userName", params.get("userName"));
			LOGGER.debug("insertStaffClaimExpItem =====================================>>  " + item);
			staffClaimMapper.insertStaffClaimExpItem(item);
			// Expense Type Name == Car Mileage Expense
	        //$("#expTypeName").val() == "Car Mileage Expense"
	        // WebInvoice Test는 Test
			LOGGER.debug("expGrp =====================================>>  " + item.get("expGrp"));
			if("1".equals(item.get("expGrp"))) {
				LOGGER.debug("insertStaffClaimExpMileage =====================================>>  " + item);
				staffClaimMapper.insertStaffClaimExpMileage(item);
			}
		}
	}

	@Override
	public List<EgovMap> selectStaffClaimItems(String clmNo) {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectStaffClaimItems(clmNo);
	}

	@Override
	public EgovMap selectStaffClaimInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectStaffClaimInfo(params);
	}

	@Override
	public EgovMap selectStaffClaimInfoForAppv(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectStaffClaimInfoForAppv(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public void updateStaffClaimExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		// TODO editGridDataList GET
		List<Object> addList = (List<Object>) params.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) params.get("update"); // 수정 리스트 얻기
		List<Object> removeList = (List<Object>) params.get("remove"); // 수정 리스트 얻기

		//Update FCM0019M Detail
		staffClaimMapper.updateStaffClaimExp(params);

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("allTotAmt", params.get("allTotAmt"));
				int clmSeq = staffClaimMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertStaffClaimExpItem =====================================>>  " + hm);
				staffClaimMapper.insertStaffClaimExpItem(hm);
				// Expense Type Name == Car Mileage Expense
		        //$("#expTypeName").val() == "Car Mileage Expense"
		        // WebInvoice Test는 Test
				LOGGER.debug("expGrp =====================================>>  " + hm.get("expGrp"));
				if("1".equals(hm.get("expGrp"))) {
					LOGGER.debug("insertStaffClaimExpMileage =====================================>>  " + hm);
					staffClaimMapper.insertStaffClaimExpMileage(hm);
				}
				staffClaimMapper.updateStaffClaimExpTotAmt(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			hm = (Map<String, Object>) updateList.get(0);
			hm.put("clmNo", params.get("clmNo"));
			hm.put("allTotAmt", params.get("allTotAmt"));
			hm.put("userId", params.get("userId"));
			hm.put("userName", params.get("userName"));
			LOGGER.debug("updateStaffClaimExp =====================================>>  " + hm);
			staffClaimMapper.updateStaffClaimExp(hm);
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("updateStaffClaimExpItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				staffClaimMapper.updateStaffClaimExpItem(hm);
				// Expense Type Name == Car Mileage Expense
		        //$("#expTypeName").val() == "Car Mileage Expense"
		        // WebInvoice Test는 Test
				LOGGER.debug("expGrp =====================================>>  " + hm.get("expGrp"));
				if("1".equals(hm.get("expGrp"))) {
					LOGGER.debug("updateStaffClaimExpMileage =====================================>>  " + hm);
					staffClaimMapper.updateStaffClaimExpMileage(hm);
				}
			}
		}

		if(removeList.size() > 0) {
			Map hm = null;
			hm = (Map<String, Object>) removeList.get(0);
			hm.put("clmNo", params.get("clmNo"));
			hm.put("allTotAmt", params.get("allTotAmt"));
			hm.put("userId", params.get("userId"));
			hm.put("userName", params.get("userName"));
			LOGGER.debug("updateStaffClaimExp =====================================>>  " + hm);
			//staffClaimMapper.updateStaffClaimExp(hm);
			for (Object map : removeList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("removeStaffClaimExpItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				staffClaimMapper.deleteStaffClaimExpItem(hm);
				// Expense Type Name == Car Mileage Expense
		        //$("#expTypeName").val() == "Car Mileage Expense"
		        // WebInvoice Test는 Test
				LOGGER.debug("expGrp =====================================>>  " + hm.get("expGrp"));
				if("1".equals(hm.get("expGrp"))) {
					LOGGER.debug("removeStaffClaimExpMileage =====================================>>  " + hm);
					staffClaimMapper.deleteStaffClaimExpMileage(hm);

					fileService.removeFilesByFileGroupId(FileType.WEB_DIRECT_RESOURCE, (int) hm.get("atchFileGrpId"));
				}
				else{
					int staffClaimDetailCount = staffClaimMapper.selectAttachmentStaffClaimExpItemCount(hm);
					//For normal claim
					//Logic change explain: Now if detect there are more than 1 detail record in FCM0020D, attachment will not be removed automatically by deletion of 1 record,
					//instead user will have to manual delete, only if there is 1 detail record left, then attachment will be removed
					if(staffClaimDetailCount < 1){
		    			if(hm.get("atchFileGrpId") != null) {
		    				fileService.removeFilesByFileGroupId(FileType.WEB_DIRECT_RESOURCE, (int) hm.get("atchFileGrpId"));
		    			}
					}
				}
			}
		}

		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
		LOGGER.info("수정 : {}", removeList.toString());
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");

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

		if (newGridList.size() > 0) {
			Map hm = null;

			// biz처리
			for (Object map : newGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				//int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
				//hm.put("appvItmSeq", appvItmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveItems =====================================>>  " + hm);
				// TODO appvLineItemsTable Insert
				staffClaimMapper.insertApproveItems(hm);
			}
		}

		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		staffClaimMapper.updateAppvPrcssNo(params);
	}

	@Override
	public void deleteStaffClaimExpItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		staffClaimMapper.deleteStaffClaimExpItem(params);
	}

	@Override
	public void deleteStaffClaimExpMileage(Map<String, Object> params) {
		// TODO Auto-generated method stub
		staffClaimMapper.deleteStaffClaimExpMileage(params);
	}

	@Override
	public void updateStaffClaimExpTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		staffClaimMapper.updateStaffClaimExpTotAmt(params);
	}

	@Override
	public List<EgovMap> selectStaffClaimItemGrp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectStaffClaimItemGrp(params);
	}

	@Override
	public List<EgovMap> selectStaffClaimItemGrpForAppv(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffClaimMapper.selectStaffClaimItemGrpForAppv(params);
	}

	@Override
	public int checkOnceAMonth(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffClaimMapper.checkOnceAMonth(params);
	}

	@Override
	public ReturnMessage editRejectedClaimExp(Map<String, Object> params)
	{
		ReturnMessage message = new ReturnMessage();
		String newClmNo = staffClaimMapper.selectNextClmNo();
		params.put("newClmNo", newClmNo);

		//Clone master claim detail
		staffClaimMapper.reinsertRejectedClaimMasterForEdit(params);

		//Reinsert if mileage related
		staffClaimMapper.reinsertRejectedClaimMileageForEdit(params);

		duplicateRejectedClaimDetailWithAttachmentList(params);
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	public void duplicateRejectedClaimDetailWithAttachmentList(Map<String, Object> params){
		int currentAtchFileGrpId = 0;
		int newIncrementAtchFileGrpId = 0;
		List<EgovMap> rejectedClaimDetailList = staffClaimMapper.selectRejectedClaimDetail(params);
		for(int i=0; i < rejectedClaimDetailList.size(); i++) {
			EgovMap rejectedClaimDetail = rejectedClaimDetailList.get(i);
			rejectedClaimDetail.put("newClmNo", params.get("newClmNo"));
			rejectedClaimDetail.put("userId", params.get("userId"));

			if(rejectedClaimDetail.get("atchFileGrpId") != null && rejectedClaimDetail.get("atchFileGrpId") != ""){
    			String atchFileGroupIdString = rejectedClaimDetail.get("atchFileGrpId").toString();

    			if(atchFileGroupIdString != null && atchFileGroupIdString != ""){
    				int atchFileGrpId = Integer.parseInt(rejectedClaimDetail.get("atchFileGrpId").toString());

    				if(currentAtchFileGrpId == atchFileGrpId){
    					//Clone claim detail
    					rejectedClaimDetail.put("newAtchFileGrpId", newIncrementAtchFileGrpId);
    					staffClaimMapper.reinsertRejectedClaimDetailForEdit(rejectedClaimDetail);
    				}
    				else{
    					newIncrementAtchFileGrpId = fileMapper.selectFileGroupKey();
    					currentAtchFileGrpId = atchFileGrpId;

    					//Clone claim detail
    					rejectedClaimDetail.put("newAtchFileGrpId", newIncrementAtchFileGrpId);
    					staffClaimMapper.reinsertRejectedClaimDetailForEdit(rejectedClaimDetail);


    					//Clone attachment and attachment detail with new id
    					List<EgovMap> attachmentMasterList = staffClaimMapper.selectRejectedClaimAttachmentMaster(rejectedClaimDetail);
    					Map<String,Object> newAttachmentDetail = new HashMap<String,Object>();
    					newAttachmentDetail.put("newAtchFileGrpId", newIncrementAtchFileGrpId);
    					newAttachmentDetail.put("userId", params.get("userId"));

    					for(int j = 0; j < attachmentMasterList.size(); j++){
    						int newAtchFileId = staffClaimMapper.selectNewAtchFileId();
    						EgovMap attachmentMaster = attachmentMasterList.get(j);
    						newAttachmentDetail.put("atchFileId",Integer.parseInt(attachmentMaster.get("atchFileId").toString()));
    						newAttachmentDetail.put("newAtchFileId",newAtchFileId);

    						staffClaimMapper.reinsertRejectedClaimDetailAttachmentForEdit(newAttachmentDetail);
    						staffClaimMapper.reinsertRejectedClaimMasterAttachmentForEdit(newAttachmentDetail);
    					}
    				}
				}
			}
			else{
				staffClaimMapper.reinsertRejectedClaimDetailForEdit(rejectedClaimDetail);
			}
		}
	}

	@Override
    public List<EgovMap> selectExcelListNew(Map<String, Object> params) {
    	// TODO Auto-generated method stub
    	return staffClaimMapper.selectStaffClaimListForExcel(params);
    }
}
