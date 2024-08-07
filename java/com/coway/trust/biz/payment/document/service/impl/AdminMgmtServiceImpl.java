package com.coway.trust.biz.payment.document.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.document.service.AdminMgmtService;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("adminMgmtService")
public class AdminMgmtServiceImpl extends EgovAbstractServiceImpl implements AdminMgmtService {

	@Resource(name = "adminMgmtMapper")
	private AdminMgmtMapper adminMgmtMapper;
	
	private static final Logger logger = LoggerFactory.getLogger(AdminMgmtServiceImpl.class);

	@Override
	public List<EgovMap> selectWaitingItemList(Map<String, Object> params) {
		return adminMgmtMapper.selectWaitingItemList(params);
	}

	@Override
	public List<EgovMap> selectReviewItemList(Map<String, Object> params) {
		return adminMgmtMapper.selectReviewItemList(params);
	}

	@Override
	public List<EgovMap> selectDocItemPayDetailList(Map<String, Object> params) {
		return adminMgmtMapper.selectDocItemPayDetailList(params);
	}
	
	@Override
	public List<EgovMap> selectDocItemPayReviewDetailList(Map<String, Object> params) {
		return adminMgmtMapper.selectDocItemPayReviewDetailList(params);
	}
	
	@Override
	public List<EgovMap> selectLoadItemLog(Map<String, Object> params) {
		return adminMgmtMapper.selectLoadItemLog(params);
	}
	
	@Override
	public EgovMap selectPaymentDocMs(Map<String, Object> params) {
		return adminMgmtMapper.selectPaymentDocMs(params);
	}
	
	@Override
	@Transactional
	public String saveConfirmSendWating(List<Object> checkList, SessionVO sessionVO, List<Object> formList) {
		
		String docNo = adminMgmtMapper.selectDocNo("38");
		
		if (checkList.size() > 0) {
			
			for (int i = 0; i < checkList.size(); i++) {
				
				Map<String, Object> checkMap = (Map<String, Object>) checkList.get(i);
				Map<String, Object> payDocDetailMap = null;
				payDocDetailMap = (Map<String, Object>) checkMap.get("item");
				int batchId = adminMgmtMapper.getPAY0170MSEQ();
				
				if(i == 0){
					
					Map<String, Object> payDocMasterMap = new HashMap<String, Object>();
					payDocMasterMap.put("batchId", batchId);
					payDocMasterMap.put("batchNo", docNo);
					payDocMasterMap.put("batchStatusId", 1);
					payDocMasterMap.put("batchResultStatusId", 0);
					payDocMasterMap.put("batchPaymodeId", payDocDetailMap.get("payModeId"));
					payDocMasterMap.put("batchPayIsOnline", payDocDetailMap.get("isOnline"));
					payDocMasterMap.put("batchTotalItem", checkList.size());
					payDocMasterMap.put("batchTotalComplete", 0);
					payDocMasterMap.put("batchTotalIncomplete", 0);
					payDocMasterMap.put("batchTotalPending", 0);
					payDocMasterMap.put("batchTotalNew", checkList.size());
					payDocMasterMap.put("batchTotalReview", 0);
					payDocMasterMap.put("batchTotalResend", 0);
					payDocMasterMap.put("creator", sessionVO.getUserId());
					payDocMasterMap.put("updator", sessionVO.getUserId());
					//MASTER INSERT
					adminMgmtMapper.insertPayDocMaster(payDocMasterMap);
				}
				
				payDocDetailMap.put("batchId", batchId);
				payDocDetailMap.put("itemStatusId", 33);
				payDocDetailMap.put("creator", sessionVO.getUserId());
				payDocDetailMap.put("updator", sessionVO.getUserId());
				
				//DETAIL INSERT
				adminMgmtMapper.insertPayDocDetail(payDocDetailMap);
				
				int itemId = adminMgmtMapper.getPAY0097DSEQ();
				Map<String, Object> logMap = new HashMap<String, Object>();
				Map<String, Object> formMap = (Map<String, Object>)formList.get(0);
				logMap.put("itemId", itemId);
				logMap.put("remark", String.valueOf(formMap.get("remark")).trim());
				logMap.put("creator", sessionVO.getUserId());
				logMap.put("itemStatusId", 33);
				//PAYMENTDOC LOG INSERT
				adminMgmtMapper.insertPayDocLogs(logMap);
				
				List<EgovMap> docPayItemList = adminMgmtMapper.selectDocPaymentItem(payDocDetailMap);
				
				if(docPayItemList.size() > 0){

					for (int j = 0; j < docPayItemList.size(); j++) {
						
						Map<String, Object> viewMap = (Map<String, Object>) docPayItemList.get(j);
						String payItmId = viewMap.get("payItmId") != null ? String.valueOf(viewMap.get("payItmId")) : "0";
						Map<String, Object> pdrMap = new HashMap<String, Object>();

						if(Integer.parseInt(payItmId) > 0){
							pdrMap.put("payItmId", payItmId);
							pdrMap.put("creator", sessionVO.getUserId());
							pdrMap.put("updator", sessionVO.getUserId());
							pdrMap.put("itemId", itemId);
							//PAYMENTDOCRELATEDS INSERT
							adminMgmtMapper.insertPayDocRelateds(pdrMap);
							
							EgovMap paymentDs = adminMgmtMapper.selectPaymentDs(payItmId);
							
							if(paymentDs != null){
								//PAYMENTITEM ISLOCK UPDATE
								adminMgmtMapper.updPayItemIsLock(payItmId);
							}
						}
					}
				}
			}
		}
		
		return docNo;
	}

}
