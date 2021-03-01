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

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("cpeService")
public class CpeServiceImpl implements CpeService {

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
	public void insertCpeReqst(Map<String, Object> params) {
		logger.debug("insertCpeReqst (master table) ===================================>>  " + params);
		cpeMapper.insertCpeReqst(params);
	}

	@Override
	public void insertCpeReqstDetail(Map<String, Object> params) {
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

			// TODO: Notification - Yong - start
/*            Map ntf = (HashMap<String, Object>) apprGridList.get(0);
            ntf.put("cpeReqId", params.get("cpeReqId"));

            EgovMap ntfDtls = new EgovMap();
            ntfDtls = (EgovMap) webInvoiceMapper.getClmDesc(params);
            ntf.put("codeName", ntfDtls.get("codeDesc"));

            ntfDtls = (EgovMap) webInvoiceMapper.getNtfUser(ntf);
            ntf.put("reqstUserId", ntfDtls.get("userName"));
            ntf.put("code", params.get("clmNo").toString().substring(0, 2));
            ntf.put("appvStus", "R");
            ntf.put("rejctResn", "Pending Approval.");

            logger.debug("ntf =====================================>>  " + ntf);

            cpeMapper.insertNotification(ntf);
*/         // TODO: Notification - Yong - end
		}

		logger.debug("updateAppvPrcssNo =====================================>>  " + params);
		cpeMapper.updateCpeRqstAppvPrcssNo(params);

	}

	@Override
	public List<EgovMap> selectCpeRequestList(Map<String, Object> params) {
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
	public void updateCpeStatusMain(Map<String, Object> params) {
		logger.debug("updateCpeStatusMain =====================================>>  " + params);
		cpeMapper.updateCpeStatusMain(params);
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

}
