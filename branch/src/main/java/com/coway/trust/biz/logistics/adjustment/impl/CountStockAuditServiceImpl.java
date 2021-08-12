package com.coway.trust.biz.logistics.adjustment.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.logistics.adjustment.CountStockAuditService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.logistics.LogisticsConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CountStockAuditServiceImpl.java
 * @Description : Count-Stock Audit Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 07.   KR-OHK        First creation
 * </pre>
 */
@Service("countStockAuditService")
public class CountStockAuditServiceImpl implements CountStockAuditService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CountStockAuditServiceImpl.class);

	@Resource(name = "countStockAuditMapper")
	private CountStockAuditMapper countStockAuditMapper;

	@Resource(name = "stockAuditMapper")
	private StockAuditMapper stockAuditMapper;

   @Autowired
   private AdaptorService adaptorService;

	@Override
	public int selectCountStockAuditListCnt(Map<String, Object> params) {
		return countStockAuditMapper.selectCountStockAuditListCnt(params);
	}

	@Override
	public List<EgovMap> selectCountStockAuditList(Map<String, Object> params) {
		return countStockAuditMapper.selectCountStockAuditList(params);
	}

	@Override
	public List<EgovMap> selectCountStockAuditListExcel(Map<String, Object> params) {
		return countStockAuditMapper.selectCountStockAuditListExcel(params);
	}

	@Override
	public EgovMap selectStockAuditDocInfo(Map<String, Object> params) {
		return countStockAuditMapper.selectStockAuditDocInfo(params);
	}

	@Override
	public List<EgovMap> selectStockAuditItemList(Map<String, Object> params) {
		return countStockAuditMapper.selectStockAuditItemList(params);
	}

	@Override
	public List<EgovMap> selectOtherReasonCodeList(Map<String, Object> params) {
		return countStockAuditMapper.selectOtherReasonCodeList(params);
	}

	@Override
	public EgovMap selectStockAuditLocDtTime(Map<String, Object> params) {
		return countStockAuditMapper.selectStockAuditLocDtTime(params);
	}

	@Override
	public List<EgovMap> getAttachmentFileInfo(Map<String, Object> params) {
		return countStockAuditMapper.selectAttachmentFileInfo(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveCountStockAuditNew(Map<String, Object> params) {
		int procCnt = 0;
		String newStocAuditNo = "";
		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
		List<Object> itemGrid= (List<Object>)gridData.get(AppConstants.AUIGRID_ALL);

		params.put("stockAuditNo", params.get("hidStockAuditNo"));
		params.put("whLocId", params.get("hidWhLocId"));

		String hidLocStusCodeId = (String) params.get("hidLocStusCodeId");
		String appvType = (String) params.get("appvType");

		LOGGER.debug("############# saveCountStockAuditNew hidLocStusCodeId  : " + hidLocStusCodeId);
		LOGGER.debug("############# saveCountStockAuditNew appvType  : " + appvType);

		if("save".equals(appvType)) {
			params.put("locStusCodeId", LogisticsConstants.LOC_SAVE);			// Loc Status : Save
		} else if("reqAprv".equals(appvType)) {
			params.put("locStusCodeId", LogisticsConstants.LOC_REQ_APRV);	// Loc Status : Request approval
		}

		if(CommonUtils.isEmpty(params.get("stockAuditNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit No is required.");
		}
		if(CommonUtils.isEmpty(params.get("whLocId"))) {
			throw new ApplicationException(AppConstants.FAIL, "Location Id is required.");
		}

		// Check status
		EgovMap locStusMap = countStockAuditMapper.selectStockAuditLocStatus(params);
		String locStusCodeId = locStusMap.get("locStusCodeId").toString();

		if(!LogisticsConstants.LOC_UNREG.equals(locStusCodeId) &&
			!LogisticsConstants.LOC_SAVE.equals(locStusCodeId) &&
			!LogisticsConstants.LOC_REJT1.equals(locStusCodeId) &&
		 	!LogisticsConstants.LOC_REJT2.equals(locStusCodeId) &&
			!LogisticsConstants.LOC_REJT3.equals(locStusCodeId)) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + locStusMap.get("locStusCodeName") +  " ]");
		}

		// Check progress
		if(LogisticsConstants.LOC_REJT1.equals(locStusCodeId) || LogisticsConstants.LOC_REJT2.equals(locStusCodeId) || LogisticsConstants.LOC_REJT3.equals(locStusCodeId)) {
			procCnt = countStockAuditMapper.selectStockAuditProcCnt(params);
			LOGGER.debug("############# saveCountStockAuditNew Check progress procCnt  : " + procCnt);
			if(procCnt > 0 ) {
    			throw new ApplicationException(AppConstants.FAIL, "There is an item in progress for Stock Audit.");
    		}

			newStocAuditNo = countStockAuditMapper.checkRejetCountStockAudit(params);
			LOGGER.debug("############# saveCountStockAuditNew Check progress newStocAuditNo  : " + newStocAuditNo);
			if(!newStocAuditNo.equals(params.get("stockAuditNo")) ) {
    			throw new ApplicationException(AppConstants.FAIL, "A newer Audit exists for the same item.<br />So, This Audit cannot proceed.<br />[ New Stock Audit No : " + newStocAuditNo +  " ]");
    		}
	    }

		// 1st Reject, 2nd Reject, 3rd Reject -> (History Insert, 1st Approval Info clear)
		if(LogisticsConstants.LOC_REJT1.equals(hidLocStusCodeId) || LogisticsConstants.LOC_REJT2.equals(hidLocStusCodeId) || LogisticsConstants.LOC_REJT3.equals(hidLocStusCodeId)) {
			// History Insert
			procCnt = countStockAuditMapper.insertStockAuditLocHistory(params);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.1");
			}
			procCnt = countStockAuditMapper.insertStockAuditItemHistory(params);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.2");
			}

			// 1st Approval Info clear
			procCnt = countStockAuditMapper.clear1stApprovalDoc(params);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.3");
			}
			procCnt = countStockAuditMapper.clear1stApprovalLoc(params);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.4");
			}
			procCnt = countStockAuditMapper.clear1stApprovalItem(params);
			if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.5");
			}
		}

		// doc status update
		if(LogisticsConstants.LOC_REJT3.equals(hidLocStusCodeId)) {
    		params.put("docStusCodeId", LogisticsConstants.DOC_START_AUDIT);		// Doc Status : Start Audit
    		procCnt = stockAuditMapper.updateDocStusCode(params);
    		if(procCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.6");
			}
		}

		procCnt = countStockAuditMapper.saveAppvInfo(params);
		if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.7");
		}

		if (itemGrid.size() > 0) {

			for (Object obj : itemGrid)
    		{
    			((Map<String, Object>) obj).put("stockAuditNo", params.get("stockAuditNo"));
    			((Map<String, Object>) obj).put("whLocId", params.get("whLocId"));
    			((Map<String, Object>) obj).put("userId", params.get("userId"));

    			// Item Qty update
				procCnt = countStockAuditMapper.updateCountStockAuditItem((Map<String, Object>) obj);
				if(procCnt == 0) {
					throw new ApplicationException(AppConstants.FAIL, "ERROR :Save Count Stock Audit.8");
				}
    		}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveAppvInfo(Map<String, Object> params) {
		int procCnt = 0;
		String appvType = (String)params.get("appvType");
		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
		List<Object> itemGrid= (List<Object>)gridData.get(AppConstants.AUIGRID_ALL);

		if(CommonUtils.isEmpty(params.get("stockAuditNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Stock Audit No is required.");
		}
		if(CommonUtils.isEmpty(params.get("whLocId"))) {
			throw new ApplicationException(AppConstants.FAIL, "Location Id is required.");
		}

		if(("aprv1".equals(appvType) || "rejt1".equals(appvType)) && CommonUtils.isEmpty(params.get("appv1Opinion"))) {
			throw new ApplicationException(AppConstants.FAIL, "1st Opinion is required.");
		}

		if(params.get("appv1Opinion").toString().getBytes().length > 500) {
			throw new ApplicationException(AppConstants.FAIL, "Please input the 1st Opinion below or less than 500 bytes.");
		}

		if("aprv1".equals(appvType)) {
			params.put("locStusCodeId", LogisticsConstants.LOC_APRV1);	// Loc Status : 1st Approve
		} else if("rejt1".equals(appvType)) {
			params.put("locStusCodeId", LogisticsConstants.LOC_REJT1);		// Loc Status : 1st Reject
		}

		// Check status
		EgovMap locStusMap = countStockAuditMapper.selectStockAuditLocStatus(params);
		String locStusCodeId = locStusMap.get("locStusCodeId").toString();

		if( ("aprv1".equals(appvType) && !LogisticsConstants.LOC_REQ_APRV.equals(locStusCodeId)) ||
		    ("rejt1".equals(appvType) && !LogisticsConstants.LOC_REQ_APRV.equals(locStusCodeId)) ) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the status.<br />[ Current Doc Status : " + locStusMap.get("locStusCodeName") +  " ]");
		}

		procCnt = countStockAuditMapper.saveAppvInfo(params);
		if(procCnt == 0) {
			throw new ApplicationException(AppConstants.FAIL, "ERROR :Approve Count Stock Audit.1");
		}

		if("aprv1Save".equals(appvType) || "aprv1".equals(appvType) ) {
			if (itemGrid.size() > 0) {

				for (Object obj : itemGrid)
	    		{
	    			((Map<String, Object>) obj).put("stockAuditNo", params.get("stockAuditNo"));
	    			((Map<String, Object>) obj).put("whLocId", params.get("whLocId"));
	    			((Map<String, Object>) obj).put("userId", params.get("userId"));

	    			// Item Qty update
					procCnt = countStockAuditMapper.updateCountStockAuditApprItem((Map<String, Object>) obj);
					if(procCnt == 0) {
						throw new ApplicationException(AppConstants.FAIL, "ERROR :Approve Count Stock Audit.2");
					}
	    		}
			}
		}

		// Send SMS
		if("rejt1".equals(appvType)) {
			params.put("smsMessage", "1st Approval is rejected. Please register Count-StockAudit.");
			stockAuditSendSms(params);
		}
	}

	@Override
	public void stockAuditSendSms(Map<String, Object> params) {

		List<EgovMap> mobileNoList = countStockAuditMapper.selectMobileNo(params);

		SmsVO sms = new SmsVO((Integer) params.get("userId"), 975);

		for(int i=0; i < mobileNoList.size() ; i++) {
			sms.setMessage((String) params.get("smsMessage"));
			sms.setMobiles((String)mobileNoList.get(i).get("userMobileNo")); // 말레이시아 번호이어야 함.

			LOGGER.debug("stockAuditSendSms : {}", (String)mobileNoList.get(i).get("userMobileNo"));
			LOGGER.debug("stockAuditSendSms : {}",  params.get("smsMessage"));

			SmsResult smsResult = adaptorService.sendSMS(sms);
			LOGGER.debug("getErrorCount : {}", smsResult.getErrorCount());
			LOGGER.debug("getFailCount : {}", smsResult.getFailCount());
			LOGGER.debug("getSuccessCount : {}", smsResult.getSuccessCount());
			LOGGER.debug("getFailReason : {}", smsResult.getFailReason());
			LOGGER.debug("getReqCount : {}", smsResult.getReqCount());
		}
	}
}
