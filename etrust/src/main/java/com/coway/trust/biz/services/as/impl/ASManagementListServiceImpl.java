package com.coway.trust.biz.services.as.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.DATE;

@Service("ASManagementListService")
public class ASManagementListServiceImpl extends EgovAbstractServiceImpl implements ASManagementListService{
	@Resource(name = "ASManagementListMapper")
	private ASManagementListMapper ASManagementListMapper;
	
	@Override
	public List<EgovMap> selectASManagementList(Map<String, Object> params) {
		return ASManagementListMapper.selectASManagementList(params);
	}
	
	@Override
	public List<EgovMap> getASHistoryList(Map<String, Object> params) {
		return ASManagementListMapper.getASHistoryList(params);
	}
	
	@Override 
	public List<EgovMap> getBSHistoryList(Map<String, Object> params) {
		return ASManagementListMapper.getBSHistoryList(params);
	}
	
	@Override
	public EgovMap selectOrderBasicInfo(Map<String, Object> params) {
		return ASManagementListMapper.selectOrderBasicInfo(params);
	}
	
	@Override
	public boolean insertASNo(Map<String, Object> params,SessionVO sessionVO) {
		Map<String, Object> asEntryData = getSaveASEntry(params,sessionVO);
		//String remark
		return false;
	}
	
	private Map<String, Object> getSaveASEntry(Map<String, Object> params,SessionVO sessionVO){
		Map<String, Object> asEntry = new HashMap<String, Object>(); 
		asEntry.put("ASID", 0);
		asEntry.put("ASNo", "");
		asEntry.put("ASSOID", Integer.parseInt(params.get("hiddenOrderID").toString()));
		asEntry.put("ASMemID", Integer.parseInt(params.get("assignCT").toString()));
		asEntry.put("ASMemGroup", Integer.parseInt(params.get("CTGroup").toString()));
		asEntry.put("ASMemGroup", Integer.parseInt(params.get("CTGroup").toString()));
		
		if(CommonUtils.isNotEmpty(params.get("requestDate").toString())){
			asEntry.put("ASRequestDate", params.get("requestDate"));
		}else{
			asEntry.put("ASRequestDate", "01/01/1900");
		}
		
		if(CommonUtils.isNotEmpty(params.get("appDate").toString())){
			asEntry.put("ASAppoinmentDate", params.get("appDate"));
		}else{
			asEntry.put("ASAppoinmentDate", "01/01/1900");
		}
		asEntry.put("ASBranchID", Integer.parseInt(params.get("branchDSC").toString()));
		asEntry.put("ASMalfunctionID", Integer.parseInt(params.get("errorCode").toString()));
		asEntry.put("ASMalfunctionReasonID", Integer.parseInt(params.get("errorDesc").toString()));
		asEntry.put("ASRemarkRequestor", params.get("requestor").toString().trim());
		asEntry.put("ASRemarkRequestorContact", params.get("requestorCont").toString().trim());
		asEntry.put("ASCalllogID",  0);
		asEntry.put("ASStatusID",  1);
		asEntry.put("ASSMS",  false);
		asEntry.put("ASCreateBy",  sessionVO.getUserId());
		asEntry.put("ASCreateAt", new DATE());
		asEntry.put("ASUpdateBy",  sessionVO.getUserId());
		asEntry.put("ASUpdateAt", new DATE());
		asEntry.put("ASEntryIsSynch", false);
		asEntry.put("ASEntryIsEdit", false);
		asEntry.put("ASTypeID", 674);
		asEntry.put("ASRequestorTypeID", Integer.parseInt(params.get("requestor").toString()));
		asEntry.put("ASIsBSWithin30Days",params.get("checkBS") != null ? true:false);
		asEntry.put("ASAllowComm",params.get("checkComm") != null ? true:false);
		asEntry.put("ASRemarkAdditionalContact",params.get("additionalCont").toString().trim());
		asEntry.put("ASRemarkRequestorContactSMS",params.get("checkSms1") != null ? true:false);
		asEntry.put("ASRemarkAdditionalContactSMS",params.get("checkSms2") != null ? true:false);
		
		return asEntry;
	}
}
