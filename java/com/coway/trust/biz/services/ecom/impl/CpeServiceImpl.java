package com.coway.trust.biz.services.ecom.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.services.ecom.CpeService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("cpeService")
public class CpeServiceImpl extends EgovAbstractServiceImpl implements CpeService {

	private static final Logger logger = LoggerFactory.getLogger(CpeServiceImpl.class);

	@Resource(name = "cpeMapper")
	private CpeMapper cpeMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Override
	public List<EgovMap> getCpeStat(Map<String, Object> params) {
		return cpeMapper.getCpeStat(params);
	}

	@Override
	public List<EgovMap> getMainDeptList() {
		return cpeMapper.selectMainDept();
	}

	@Override
	public List<EgovMap> getSubDeptList(Map<String, Object> params) {
		return cpeMapper.selectSubDept(params);
	}

	@Override
	public EgovMap getOrderId(Map<String, Object> params) throws Exception {
		return cpeMapper.getOrderId(params);
	}

	@Override
	public boolean checkCpeRequestStatusActiveExist(Map<String, Object> params) {
		int result = cpeMapper.checkExistingCpeRequestStatusActive(params);

		if(result > 0){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception {
		return cpeMapper.selectSearchOrderNo(params);
	}

	@Override
	public List<EgovMap> selectRequestType() throws Exception {
		return cpeMapper.selectRequestType();
	}

	@Override
	public List<EgovMap> getSubRequestTypeList(Map<String, Object> params) {
		return cpeMapper.getSubRequestTypeList(params);
	}
	@Override
	public List<EgovMap> getIssueTypeList(Map<String, Object> params) {
		return cpeMapper.selectIssueTypeList(params);
	}
	@Override
	public void insertCpe(Map<String, Object> params) {
		params.put("mainDept","MD20");
		params.put("subDept","SD299");

		int ordStatusId = Integer.parseInt((String) params.get("ordStusId"));
		int reqStageId = ordStatusId == 1 ? 24 : 25;
		params.put("reqStageId", reqStageId);

		logger.debug("insertCpeReqst (master table) ===================================>>  " + params);
		cpeMapper.insertCpeReqst(params);

		int activeStatusForNewReq = 1;
		params.put("status", activeStatusForNewReq);

		logger.debug("insertCpeReqst (detail table) =====================================>>  " + params);
		cpeMapper.insertCpeRqstDetail(params);
	}

	@Override
	public int selectNextCpeId() {
		return cpeMapper.selectNextCpeId();
	}

	@Override
	public String selectNextCpeAppvPrcssNo() {
		return cpeMapper.selectNextCpeAppvPrcssNo();
	}

	@Override
	public void insertCpeRqstApproveMgmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.debug("params =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");

		params.put("appvLineCnt", apprGridList.size());

		logger.debug("insertCpeApproveManagement =====================================>>  " + params);
		cpeMapper.insertCpeApproveManagement(params);

		if (apprGridList.size() > 0) {
			Map hm = null;
			List<String> appvLineUserId = new ArrayList<>();

			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				logger.debug("insertCpeApproveLineDetail =====================================>>  " + hm);
				cpeMapper.insertCpeApproveLineDetail(hm);
			}

		}

		logger.debug("updateAppvPrcssNo =====================================>>  " + params);
		cpeMapper.updateCpeRqstAppvPrcssNo(params);

	}

	@Override
	public void updateCpe(Map<String, Object> params) {
		cpeMapper.insertCpeRqstDetail(params); //insert new status record for CPE
		cpeMapper.updateCpeStatusMain(params);  //update main table with latest status for CPE

		if (params.get("approvalRequired").equals("1") &&
				(params.get("status").equals("5") || params.get("status").equals("6"))) {
			this.sendNotificationEmail(params); //send email to notify about request approval (status = 5) or rejection (status = 6)
		}
	}

	@Override
	public List<EgovMap> selectCpeRequestList(Map<String, Object> params) {
		String adminFlag = CommonUtils.nvl(params.get("adminFlag"));
		params.put("adminFlag", adminFlag.toString());
		//EgovMap userBranch = cpeMapper.selectUserBranch(params);
		EgovMap userMemberLevel = cpeMapper.selectUserMemberLevel(params);

//		params.put("userBranchCode", userBranch.get("code").toString());

		if(userMemberLevel != null){
			params.put("memLvl", userMemberLevel.get("memLvl").toString());
			params.put("deptCode", userMemberLevel.get("deptCode").toString());
			params.put("grpCode", userMemberLevel.get("grpCode").toString());
			params.put("orgCode", userMemberLevel.get("orgCode").toString());
		}

		return cpeMapper.selectCpeRequestList(params);
	}

	@Override
	public EgovMap selectRequestInfo(Map<String, Object> params) {
		return cpeMapper.selectRequestInfo(params);
	}

	@Override
	public List<EgovMap> selectCpeDetailList(Map<String, Object> params) {
		return cpeMapper.selectCpeDetailList(params);
	}

	@Override
	public String getApproverList(Map<String, Object> params) {

		List<EgovMap> approverList = cpeMapper.getApproverList(params);
		StringBuilder sbApprovers = new StringBuilder();

		if (!approverList.isEmpty()) {
			for(int i = 0; i < approverList.size(); i++) {
				EgovMap appvLine = approverList.get(i);
				String appvLineUserName = (String) appvLine.get("appvLineUserName");

				sbApprovers.append(" - ");
				sbApprovers.append(appvLineUserName);
				sbApprovers.append("<br>");
			}
		} else {
			sbApprovers.append("N/A");
		}

		return sbApprovers.toString();
	}

	@Override
	public void sendNotificationEmail(Map<String, Object> params) {

		String requestorEmail = (String) params.get("requestorEmail");
		String cpeReqId = (String) params.get("cpeReqId");
		String userFullname = (String) params.get("userFullname");
		//String cpeType = (String) params.get("cpeType");
		String salesOrdNo = (String) params.get("salesOrdNo");
		int cpeApprovalStatus = Integer.parseInt(String.valueOf(params.get("status")));

		EmailVO email = new EmailVO();
		List<String> toList = new ArrayList<String>();
		toList.add(requestorEmail);

		String Subject = "CPE Request  (" + cpeReqId + ") - " + salesOrdNo + " - ";
		email.setTo(toList);
		email.setHtml(true);

		if (cpeApprovalStatus == 5) {
			Subject += "Approved";
			email.setText("CPE request (" + cpeReqId + ") for order " + salesOrdNo +
					" has been approved by " + userFullname + ".");
		} else {
			Subject += "Rejected";
			email.setText("CPE request (" + cpeReqId + ") for order " + salesOrdNo +
					" has been rejected by " + userFullname + ".");
		}

		email.setSubject(Subject);
		adaptorService.sendEmail(email, false);
	}

	@Override
	public EgovMap getOrderDscCode(String orderDscCode) {
		return cpeMapper.getOrderDscCode(orderDscCode);
	}

	  @Override
	  public List<EgovMap> selectCpeHistoryDetailPop(Map<String, Object> params) {
	    return cpeMapper.selectCpeHistoryDetailPop(params);
	  }


}
