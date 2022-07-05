package com.coway.trust.biz.incentive.goldPoints.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.incentive.goldPoints.GoldPointsService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("goldPointsService")
public class GoldPointsServiceImpl extends EgovAbstractServiceImpl implements GoldPointsService {

	private static final Logger logger = LoggerFactory.getLogger(GoldPointsServiceImpl.class);

	@Resource(name = "goldPointsMapper")
	private GoldPointsMapper goldPointsMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Override
	public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {

        int masterSeq = goldPointsMapper.selectNextBatchId();
        master.put("goldPtsBatchId", masterSeq);
        int mResult = goldPointsMapper.insertGoldPointsMst(master); // INSERT INTO ICR0001M

        int size = 1000;
        int page = detailList.size() / size;
        int start;
        int end;

        Map<String, Object> goldPointsList = new HashMap<>();
        goldPointsList.put("goldPtsBatchId", masterSeq);
        for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if(i == page){
                end = detailList.size();
            }

            goldPointsList.put("list",
                detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
            goldPointsMapper.insertGoldPointsDtl(goldPointsList); // INSERT INTO ICR0002D
        }

		return masterSeq;
	}

	@Override
	public int saveCsvRedemptionItems(Map<String, Object> master, List<Map<String, Object>> detailList) {

        int masterSeq = goldPointsMapper.selectNextRedemptionItemsBatchId();
        master.put("riBatchId", masterSeq);
        int mResult = goldPointsMapper.insertRedemptionItemsMst(master); // INSERT INTO ICR0004M

        int size = 1000;
        int page = detailList.size() / size;
        int start;
        int end;

        Map<String, Object> rdmItmList = new HashMap<>();
        rdmItmList.put("riBatchId", masterSeq);
        for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if(i == page){
                end = detailList.size();
            }

            rdmItmList.put("list",
                detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
            goldPointsMapper.insertRedemptionItemsDtl(rdmItmList); // INSERT INTO ICR0005D
        }

        //CALL PROCEDURE
        goldPointsMapper.callRedemptionItemsConfirm(master); // MERGE INTO ICR0006D

		return masterSeq;
	}

	@Override
	public List<EgovMap> selectPointsSummaryList(Map<String, Object> params) {
		return goldPointsMapper.selectPointsSummaryList(params);
	}

	@Override
	public EgovMap selectMemInfo(Map<String, Object> params) {
		return goldPointsMapper.selectMemInfo(params);
	}

	@Override
	public List<EgovMap> selectPointsExpiryList(Map<String, Object> params) {
		return goldPointsMapper.selectPointsExpiryList(params);
	}

	@Override
	public EgovMap selectRedemptionBasicInfo(Map<String, Object> params) {
		return goldPointsMapper.selectRedemptionBasicInfo(params);
	}

	@Override
	public EgovMap getOrgDtls(Map<String, Object> params) {
		return goldPointsMapper.getOrgDtls(params);
	}

	@Override
	public List<EgovMap> searchItemCategoryList(Map<String, Object> params) {
		return goldPointsMapper.searchItemCategoryList(params);
	}

	@Override
	public List<EgovMap> searchRedemptionItemList(Map<String, Object> params) {
		return goldPointsMapper.searchRedemptionItemList(params);
	}

	@Override
	public Map<String, Object> createNewRedemption(Map<String, Object> params) {

		int redemptionSeq = goldPointsMapper.selectNextRedemptionId();
		String redemptionNo = goldPointsMapper.getNextRedemptionNo();
		params.put("redemptionId", redemptionSeq);
		params.put("redemptionNo", redemptionNo);
		goldPointsMapper.insertNewRedemption(params);

		goldPointsMapper.processRedemption(params);		//CALL SP_GOLD_PTS_REDEEM

		return params;	//return output SP_GOLD_PTS_REDEEM
	}

	@Override
	public void sendNotification(Map<String, Object> params) {
		sendSMS(params);
		sendEmail(params);
	}

	private void sendEmail(Map<String, Object> params) {

		String emailAddr = (String) params.get("emailAddr");
		String rdmNo = (String) params.get("redemptionNo");

		if (emailAddr != null && !emailAddr.equals("")
				&& rdmNo != null && !rdmNo.equals("")) {

			EgovMap redemptionDtl = new EgovMap();
			redemptionDtl = goldPointsMapper.selectRedemptionDetailsEmail(params);

			params.put("memCode", redemptionDtl.get("memCode"));
			params.put("memName", redemptionDtl.get("memName"));
			params.put("itmDisplayName", redemptionDtl.get("itmDisplayName"));
			params.put("qty", redemptionDtl.get("qty"));
			params.put("totalPts", redemptionDtl.get("totalPts"));
			params.put("collectBrnch", redemptionDtl.get("collectBrnch"));

		    EmailVO email = new EmailVO();
		    String emailTitle = goldPointsMapper.getEmailTitle(params);
		    String emailDetails = goldPointsMapper.getEmailDetails(params);

		    email.setTo(emailAddr);
		    email.setHtml(true);
		    email.setSubject(emailTitle);
		    email.setText(emailDetails);
		    email.setHasInlineImage(false);

		    boolean isResult = false;
		    isResult = adaptorService.sendEmail(email, false);

			logger.debug(" Email sent : " + isResult);
		}
	}

	private void sendSMS(Map<String, Object> params) {

		String mobileNumber = (String) params.get("mobileNo");
		String rdmNo = (String) params.get("redemptionNo");

		if (mobileNumber != null && !mobileNumber.equals("")
				&& rdmNo != null && !rdmNo.equals("")) {

			SmsVO sms = new SmsVO((int) params.get("userId"), 975);

			String smsContent = "COWAY:Your Gold Point Redemption No is " + rdmNo + ". Login to eTrust system to check redemption status";

			logger.debug(" Message Contents : " + smsContent);
			logger.debug(" Mobile Phone Number : " + mobileNumber);

			sms.setMessage(smsContent);
			sms.setMobiles(mobileNumber);

			//send SMS
			SmsResult smsResult = adaptorService.sendSMS(sms);

			logger.debug("getErrorCount : {}", smsResult.getErrorCount());
			logger.debug("getFailCount : {}", smsResult.getFailCount());
			logger.debug("getSuccessCount : {}", smsResult.getSuccessCount());
			logger.debug("getFailReason : {}", smsResult.getFailReason());
			logger.debug("getReqCount : {}", smsResult.getReqCount());
		}
	}

	@Override
	public List<EgovMap> selectTransactionHistoryList(Map<String, Object> params) {
		return goldPointsMapper.selectTransactionHistoryList(params);
	}

	@Override
	public List<EgovMap> selectRedemptionList(Map<String, Object> params) {
		return goldPointsMapper.selectRedemptionList(params);
	}

	@Override
	public Map<String, Object> cancelRedemption(Map<String, Object> params) {
		goldPointsMapper.cancelRedemption(params);		//CALL SP_GOLD_PTS_CANCEL_REDEMPTN
		return params;	//return output SP_GOLD_PTS_CANCEL_REDEMPTN
	}

	@Override
	public List<EgovMap> selectRedemptionDetails(Map<String, Object> params) {
		return goldPointsMapper.selectRedemptionDetails(params);
	}

	@Override
	public int updateRedemption(Map<String, Object> params) {
        int result = goldPointsMapper.updateRedemption(params);
		return result;
	}

	@Override
	public List<EgovMap> selectPointsUploadList(Map<String, Object> params) {
		return goldPointsMapper.selectPointsUploadList(params);
	}

	@Override
	public EgovMap selectPointsBatchInfo(Map<String, Object> params) {
		EgovMap pointsBatchInfo = goldPointsMapper.selectPointsBatchMaster(params);
	    List<EgovMap> pointsBatchDtl = goldPointsMapper.selectPointsBatchDetail(params);

	    pointsBatchInfo.put("pointsBatchDtl", pointsBatchDtl);
	    return pointsBatchInfo;
	}

	@Override
	public void callPointsUploadConfirm(Map<String, Object> params) {
        //CALL PROCEDURE
        goldPointsMapper.callPointsUploadConfirm(params); // MERGE INTO ICR0003D

	}

	@Override
	public int updPointsUploadReject(Map<String, Object> params) {
        int result = goldPointsMapper.updPointsUploadReject(params);

        return result;
	}

	@Override
	public Map<String, Object> adminCancelRedemption(Map<String, Object> params) {
		goldPointsMapper.adminCancelRedemption(params);		//CALL SP_GOLD_PTS_ADM_CANCEL_RDM
		return params;	//return output SP_GOLD_PTS_ADM_CANCEL_RDM
	}

	@Override
	public Map<String, Object> adminForfeitRedemption(Map<String, Object> params) {
		goldPointsMapper.adminForfeitRedemption(params);		//CALL SP_GOLD_PTS_ADM_FORFEIT_RDM
		return params;	//return output SP_GOLD_PTS_ADM_FORFEIT_RDM
	}

	@Override
	public List<EgovMap> selectRedemptionItemList(Map<String, Object> params) {
		return goldPointsMapper.selectRedemptionItemList(params);
	}

}
