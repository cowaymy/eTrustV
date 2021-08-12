package com.coway.trust.biz.payment.refund.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.refund.service.BatchRefundService;
import com.coway.trust.biz.payment.refund.service.RefundApplication;
import com.coway.trust.biz.payment.refund.service.RefundService;
import com.coway.trust.cmmn.model.SessionVO;

@Service("refundApplication")
public class RefundApplicationImpl implements RefundApplication {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RefundApplicationImpl.class);
	
	@Autowired
	private RefundService refundService;
	
	@Autowired
	private BatchRefundService batchRefundService;

	@Override
	public int refundValidChecking(List<Object> girdDataList, SessionVO sessionVO) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
		//String accNo = request.getParameter("accNo");
		String refModeId = null;
		for(int i = 0; i < girdDataList.size(); i++) {
			Map<String, Object> vo = (Map<String, Object>) girdDataList.get(i);
			
			HashMap<String, Object> hm = new HashMap<String, Object>();
			
			if(i == 0) {
				refModeId = String.valueOf(vo.get("refModeCode"));
			}
			
			hm.put("disabled", 0);
			hm.put("creator", sessionVO.getUserId());
			hm.put("updator", sessionVO.getUserId());
			hm.put("validStatusId", 1);
			hm.put("validRemark", "");
			hm.put("salesOrdId", 0);
			hm.put("worNo", String.valueOf(vo.get("worNo")));
			hm.put("amt", String.valueOf(vo.get("refAmt")));
			hm.put("payMode", "");
			hm.put("payTypeId", 0);
			hm.put("bankAccId", String.valueOf(vo.get("bankAccCode")));
			hm.put("issBankId", String.valueOf(vo.get("custBankId")));
			hm.put("chqNo", String.valueOf(vo.get("chqNo")));
			hm.put("refNo", String.valueOf(vo.get("refNo")));
			hm.put("ccHolderName", String.valueOf(vo.get("cardHolder")));
			hm.put("ccNo", String.valueOf(vo.get("cardNo")));
			//hm.put("refundRemark", String.valueOf(vo.get("remark")));
			hm.put("refundRemark", "");
			hm.put("refDateMonth", "");
			hm.put("refDateDay", "");
			hm.put("refDateYear", "");
			hm.put("payItemId", 0);
			
			detailList.add(hm);
		}
		LOGGER.debug("detailList =====================================>>  " + detailList);

		Map<String, Object> master = new HashMap<String, Object>();
		//String payMode = request.getParameter("payMode");
		//String remark = request.getParameter("remark");
		
		master.put("refundModeId", refModeId);
		master.put("batchStatusId", 1);
		master.put("confirmStatusId", 44);
		master.put("creator", sessionVO.getUserId());
		master.put("updator", sessionVO.getUserId());
		master.put("confirmDate", "1900/01/01");
		master.put("confirmBy", 0);
		master.put("convertDate", "1900/01/01");
		master.put("convertBy", 0);
		master.put("batchRefundType", 97);
		//master.put("batchRefundRemark", remark != null ? remark : "");
		master.put("batchRefundRemark", "");
		master.put("batchRefundCustType", 1368);
		
		LOGGER.debug("master =====================================>>  " + master);
		
		int result = batchRefundService.saveBatchRefundUpload(master, detailList);
		
		return result;
	}

	@Override
	public int refundConfirm(List<Object> batchIdList, SessionVO sessionVO) {
		// TODO Auto-generated method stub
		int result = 0;
		
		for(int i = 0; i < batchIdList.size(); i++) {
			Map<String, Object> master = new HashMap<String, Object>();
			String batchId = String.valueOf(batchIdList.get(i)); 
			
			master.put("batchId", batchId);
			master.put("refundModeId", 0);
			master.put("batchStatusId", 1);
			master.put("confirmStatusId", 77);
			master.put("creator", 0);
			master.put("created", "1900/01/01");
			master.put("updator", sessionVO.getUserId());
			master.put("confirmBy", sessionVO.getUserId());
			master.put("convertDate", "1900/01/01");
			master.put("convertBy", 0);
			
			master.put("userId", sessionVO.getUserId());
			
			result = batchRefundService.batchRefundConfirm(master, true);
		}
		
		return result;
	}

}
