/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.helpdesk.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.helpdesk.HelpDeskService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HelpDeskService")
public class HelpDeskServiceImpl extends EgovAbstractServiceImpl implements HelpDeskService {

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
	public void insertDataChangeList(Map<String, Object> RespondMap, int loginId) {
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

		}

	}

}
