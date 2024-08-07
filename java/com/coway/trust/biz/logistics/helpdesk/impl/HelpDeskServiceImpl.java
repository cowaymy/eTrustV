/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.helpdesk.impl;

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
import com.coway.trust.biz.logistics.helpdesk.HelpDeskService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HelpDeskService")
public class HelpDeskServiceImpl extends EgovAbstractServiceImpl implements HelpDeskService {

	@Autowired
	private AdaptorService adaptorService;
	
	private static final Logger Logger = LoggerFactory.getLogger(HelpDeskServiceImpl.class);

	@Resource(name = "HelpDeskMapper")
	private HelpDeskMapper HelpDeskMapper;

	@Override
	public List<EgovMap> selectReasonList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.selectReasonList(params);
	}

	@Override
	public List<EgovMap> selectDataChangeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.selectDataChangeList(params);
	}

	@Override
	public List<EgovMap> detailDataChangeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.detailDataChangeList(params);
	}

	@Override
	public List<EgovMap> CompulsoryList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.CompulsoryList(params);
	}

	@Override
	public List<EgovMap> ChangeItemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.ChangeItemList(params);
	}

	@Override
	public List<EgovMap> RespondList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.RespondList(params);
	}

	@Override
	public Map<String, Object> insertDataChangeList(Map<String, Object> RespondMap, int loginId,String today) {
		
		int respnsIdCreateSeq = HelpDeskMapper.respnsIdCreateSeq();
		int trRcordIdCreateSeq = HelpDeskMapper.trRcordIdCreateSeq();
		int insReason = 0;
		if (RespondMap.get("insReason") != null) {
			insReason = Integer.parseInt((String) RespondMap.get("insReason"));
		}

		int insApprovalStatus = Integer.parseInt((String) RespondMap.get("insApprovalStatus"));
		String defaultDate = "19000101";
		int DCFReqStatusID = insApprovalStatus == 6 ? 10 : insApprovalStatus == 36 ? 34 : 0;
		int DCFReqProStatusID = insApprovalStatus != 61 ? insApprovalStatus : 0;
		String todate = insApprovalStatus != 61 ? CommonUtils.getNowDate() : defaultDate;

		// Logger.debug("DCFReqStatusID ???? : {}", DCFReqStatusID);
		// Logger.debug("DCFReqProStatusID ???? : {}", DCFReqProStatusID);
		// Logger.debug("insReason ???? : {}", insReason);

		int dcfReqStusId = 0;
		int dcfReqProStusId = 0;
		String dcfReqNo = "";

		List<EgovMap> DcfRequestMList = HelpDeskMapper.selectDcfRequestM(RespondMap);
		for (int i = 0; i < DcfRequestMList.size(); i++) {
			Logger.debug("DcfRequestMList : {}", DcfRequestMList.get(i));
			dcfReqStusId = Integer.parseInt(String.valueOf(DcfRequestMList.get(i).get("dcfReqStusId")));
			dcfReqProStusId = Integer.parseInt(String.valueOf(DcfRequestMList.get(i).get("dcfReqProStusId")));
			dcfReqNo = String.valueOf(DcfRequestMList.get(i).get("dcfReqNo"));
		}

		Logger.debug("dcfReqStusId : {}", dcfReqStusId);
		Logger.debug("dcfReqProStusId : {}", dcfReqProStusId);
		Logger.debug("dcfReqNo : {}", dcfReqNo);

		if (dcfReqStusId == 10 || dcfReqStusId == 34) {
			Logger.debug("Approval result has settled.");

		} else {
			Map<String, Object> updateDcfRequestMap = new HashMap<String, Object>();
			updateDcfRequestMap.put("crtuser_id", loginId);
			updateDcfRequestMap.put("upuser_id", loginId);
			updateDcfRequestMap.put("dcfReqAppvRem", RespondMap.get("insApprovalRemark"));
			updateDcfRequestMap.put("insApprovalStatus", insApprovalStatus);
			if (DCFReqStatusID > 0) {
				updateDcfRequestMap.put("DCFReqStatusID", DCFReqStatusID);
			}
			if (DCFReqProStatusID > 0) {
				updateDcfRequestMap.put("DCFReqProStatusID", DCFReqProStatusID);
			}
			if (insReason > 0) {
				updateDcfRequestMap.put("insReason", insReason);
			}
			updateDcfRequestMap.put("reqId", RespondMap.get("reqId"));
			Logger.debug("updateDcfRequestMap : {}", updateDcfRequestMap);
			HelpDeskMapper.updateDcfRequestM(updateDcfRequestMap);

			Map<String, Object> insertResLogMap = new HashMap<String, Object>();
			insertResLogMap.put("respnsIdCreateSeq", respnsIdCreateSeq);
			insertResLogMap.put("DCFReqEntryID", RespondMap.get("reqId"));
			insertResLogMap.put("DCFResponseStatusID", 1);
			insertResLogMap.put("DCFResponseMsg", RespondMap.get("insApprovalRemark"));
			insertResLogMap.put("crtuser_id", loginId);
			insertResLogMap.put("upuser_id", loginId);
			insertResLogMap.put("DCFSettleDate", todate);

			HelpDeskMapper.insertDcfResponseLog(insertResLogMap);

			if (dcfReqProStusId == 36 && dcfReqStusId == 34) {
				String CompulsoryField = "";
				String Holder = "";
				String LostType = "";
				List<EgovMap> list = HelpDeskMapper.selectDcfCompulsoryFieldList(RespondMap);
				for (int i = 0; i < list.size(); i++) {
					int num = Integer.parseInt(String.valueOf(list.get(i).get("dcfComFildTypeId")));
					if (num == 7) {
						CompulsoryField = String.valueOf(list.get(i).get("dcfReqComFildRefNo"));
					} else if (num == 3) {
						Holder = String.valueOf(list.get(i).get("dcfReqComFildRefNo"));
					} else if (num == 8) {
						LostType = String.valueOf(list.get(i).get("dcfReqComFildRefNo"));
					}
				}

				Logger.debug("Holder : {}", Holder);
				Logger.debug("LostType : {}", LostType);
				Logger.debug("CompulsoryField : {}", CompulsoryField);

				List<EgovMap> TrBookIdList = HelpDeskMapper.getTrBookId(CompulsoryField);
				int TrBookId = Integer.parseInt(String.valueOf(TrBookIdList.get(0).get("trBookId")));

				// Logger.debug("TrBookId : {}", TrBookId);
				// for (int i = 0; i < TrBookIdList.size(); i++) {
				// Logger.debug("TrBookIdList : {}", TrBookIdList.get(i));
				// }

				if (LostType == "Whole") {
					// LOST WHOLE
					List<EgovMap> TrBookList = HelpDeskMapper.getTrBookList(TrBookId);
					Map<String, Object> TrBookListMap = new HashMap<String, Object>();

					for (int i = 0; i < TrBookList.size(); i++) {
						Logger.debug("TrBookList ?????? : {}", TrBookList.get(i));
						TrBookListMap.put("upuser_id", loginId);
						TrBookListMap.put("TRStatusID", 67);
						TrBookListMap.put("TrBookId", TrBookId);
						HelpDeskMapper.updateTRBookM(TrBookListMap);

					}

					Map<String, Object> TrRecordMap = new HashMap<String, Object>();
					TrRecordMap.put("trRcordIdCreateSeq", trRcordIdCreateSeq);
					TrRecordMap.put("TrBookId", TrBookId);
					TrRecordMap.put("TRTypeID", 756);
					TrRecordMap.put("TRLocationCode", Holder);
					TrRecordMap.put("TRRecordStatusID", 1);
					TrRecordMap.put("crtuser_id", loginId);
					TrRecordMap.put("TRRecordQuantity", -1);
					TrRecordMap.put("dcfReqNo", dcfReqNo);
					HelpDeskMapper.insertTrRecordCard(TrRecordMap);

				} else {
					// LOST PIECES
					List<EgovMap> TrBookItemList = HelpDeskMapper.getTrBookItem(TrBookId);
					// for (int i = 0; i < TrBookItemList.size(); i++) {
					// Logger.debug("TrBookItemList ><><>< : {}", TrBookItemList.get(i));
					// }
					int trBookItmId = Integer.parseInt(String.valueOf(TrBookItemList.get(0).get("trBookItmId")));
					Map<String, Object> TrBookItemMap = new HashMap<String, Object>();
					Logger.debug("trBookItmId ?????? : {}", trBookItmId);
					for (int i = 0; i < TrBookItemList.size(); i++) {
						TrBookItemMap.put("upuser_id", loginId);
						TrBookItemMap.put("TRStatusID", 67);
						TrBookItemMap.put("trBookItmId", trBookItmId);
						HelpDeskMapper.updateTRBookD(TrBookItemMap);
					}
				}
				
			}
						
			Logger.debug("insApprovalStatus *****209***** : {}", insApprovalStatus);		

		}
		
		List<EgovMap> getEmailaddr = HelpDeskMapper.selectEmailaddr(loginId);
		
		String userEmail="";
		
		for (int i = 0; i < getEmailaddr.size(); i++) {
			Logger.debug("getEmailaddr : {}", getEmailaddr.get(i));
			userEmail = (String) getEmailaddr.get(i).get("userEmail");
		}
		
		Map<String, Object> emailMap = new HashMap<String, Object>();
		emailMap.put("userEmail", userEmail);
		emailMap.put("dcfReqNo", dcfReqNo);
		emailMap.put("loginId", loginId);
		emailMap.put("insApprovalStatus", insApprovalStatus);
		
		Logger.debug("emailMap : {}", emailMap);
		
		return emailMap;

	}
	
	@Override
	public void sendEmailList(Map<String, Object> params,String today) {
		
		String userEmail =(String) params.get("userEmail");
		String dcfReqNo =(String) params.get("dcfReqNo");
		int loginId = Integer.parseInt(String.valueOf(params.get("loginId")));
		int insApprovalStatus = Integer.parseInt(String.valueOf(params.get("insApprovalStatus")));
		
		Logger.debug("1 : {}", userEmail);
		Logger.debug("2 : {}", dcfReqNo);
		Logger.debug("3 : {}", loginId);
		Logger.debug("4 : {}", insApprovalStatus);
		
		//이메일
		if(61 == insApprovalStatus){
			Logger.debug("<b>Approval result successfully saved. {}");
		}else{
	
			// E-mail 전송하기
			EmailVO email = new EmailVO();
			List<String> toList = new ArrayList<String>();
			String localEmail="t1707038@partner.coway.co.kr";				
//			toList.add(localEmail);
			toList.add(userEmail);  

			String Subject ="TR Book Lost Request Ticket  "+dcfReqNo+"-";
			email.setTo(toList);
			email.setHtml(true);
				
			if (insApprovalStatus == 36){
				Subject += "Approved & Closed";
				email.setText( 
						"Please to inform you that your TR Book Lost request (" + dcfReqNo + ") " +
				                "has been approved & cloed by your DCF approver - [" +loginId+ "] on " +today+".<br />" +
				                "The TR book/receipt number has been marked as status : LOST.<br />" +
				                "For more information, please review your tickte request in our web system.<br />" +
				                "This email is reply from Coway Web System. Please do not reply this email.<br /><br />" +
				                "Thank you.");			
					
			}else{
				Subject += "Rejected";
				email.setText(
						"Please to inform you that your TR Book Lost request (" + dcfReqNo + ") " +
		                "has been rejected by your DCF approver - [" + loginId + "] on " +today+ ".<br />" +
		                "For more information, please review your tickte request in our web system.<br />" +
		                "This email is reply from Coway Web System. Please do not reply this email.<br /><br />" +
		                "Thank you.");			
				
			}
			email.setSubject(Subject);
			adaptorService.sendEmail(email, false);

			
		}	
		
		
	}

}
