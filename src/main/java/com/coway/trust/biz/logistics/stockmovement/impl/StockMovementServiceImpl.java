package com.coway.trust.biz.logistics.stockmovement.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.stockmovement.StockMovementService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stockMovementService")
public class StockMovementServiceImpl extends EgovAbstractServiceImpl implements StockMovementService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "stockMoveMapper")
	private StockMovementMapper stockMoveMapper;

	@Resource(name = "stocktranService")
	private StockTransferService stock;

	@Override
	public String insertStockMovementInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		/* 2017-11-30 김덕호 위원 채번 변경 요청 */
		String seq = stockMoveMapper.selectStockMovementSeq();

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		// String reqNo = fMap.get("headtitle") + seq;
		String reqNo = seq;

		fMap.put("reqno", reqNo);
		// fMap.put("reqno", fMap.get("headtitle") + seq);
		fMap.put("userId", params.get("userId"));

		stockMoveMapper.insStockMovementHead(fMap);

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				// insMap.put("reqno", fMap.get("headtitle") + seq);
				insMap.put("reqno", seq);
				insMap.put("userId", params.get("userId"));
				stockMoveMapper.insStockMovement(insMap);
			}
		}

		insertStockBooking(fMap);

		return reqNo;

	}

	@Override
	public List<EgovMap> selectStockMovementNoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<EgovMap> list = null;

		if ("stock".equals(params.get("groupCode"))) {
			list = stockMoveMapper.selectStockMovementNoList();
		} else {
			list = stockMoveMapper.selectDeliveryNoList();
		}
		return list;
	}

	@Override
	public List<EgovMap> selectStockMovementMainList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMoveMapper.selectStockMovementMainList(params);
	}

	@Override
	public List<EgovMap> selectStockMovementDeliveryList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMoveMapper.selectStockMovementDeliveryList(params);
	}

	@Override
	public List<EgovMap> selectTolocationItemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMoveMapper.selectStockMovementToItem(params);
	}

	@Override
	public int stockMovementItemDeliveryQty(Map<String, Object> params) {
		Map<String, Object> map = stockMoveMapper.selectStockMovementItemDeliveryQty(params);
		int iCnt = 0;
		try {
			iCnt = (int) map.get("qty");
		} catch (Exception ex) {
			iCnt = 0;
		}
		return iCnt;
	}

	@Override
	public Map<String, Object> selectStockMovementDataDetail(String param) {

		Map<String, Object> hdMap = stockMoveMapper.selectStockMovementHead(param);

		List<EgovMap> list = stockMoveMapper.selectStockMovementItem(param);

		Map<String, Object> pMap = new HashMap();
		pMap.put("toloc", hdMap.get("rcivcr"));

		List<EgovMap> toList = stockMoveMapper.selectStockMovementToItem(pMap);

		Map<String, Object> reMap = new HashMap();
		reMap.put("hValue", hdMap);
		reMap.put("iValue", list);
		reMap.put("itemto", toList);

		return reMap;
	}

	@Override
	public void deleteDeliveryStockMovement(Map<String, Object> params) {
		List<Object> delList = (List<Object>) params.get("del");

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		if (delList.size() > 0) {
			for (int i = 0; i < delList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) delList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				stockMoveMapper.deleteStockMovementItm(insMap);
				stockMoveMapper.deleteDeliveryStockMovementItm(insMap);
			}
		}

	}

	@Override
	public List<EgovMap> addStockMovementInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		List<Object> updList = (List<Object>) params.get("upd");
		/* List<Object> delList = (List<Object>) params.get("rem"); */

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				insMap.put("userId", params.get("userId"));
				stockMoveMapper.insStockMovement(insMap);
			}
		}
		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				insMap.put("userId", params.get("userId"));
				stockMoveMapper.insStockMovement(insMap);
			}
		}
		List<EgovMap> list = stockMoveMapper.selectStockMovementItem((String) fMap.get("reqno"));
		return list;
	}

	@Override
	public Map<String, Object> stockMovementReqDelivery(Map<String, Object> params) {
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		/* 2017-11-30 김덕호 위원 채번 변경 요청 */
		String deliSeq = stockMoveMapper.selectDeliveryStockMovementSeq();
		
		String scanno = "";

		if (checkList.size() > 0) {

			Map<String, Object> insMap = null;

			for (int i = 0; i < checkList.size(); i++) {

				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);

				insMap = (Map<String, Object>) tmpMap.get("item");

				logger.info(" item : {}", tmpMap.get("item"));
				logger.info(" reqstno : {}", insMap.get("reqstno"));

				insMap.put("delno", deliSeq);
				insMap.put("userId", params.get("userId"));
				stockMoveMapper.insertDeliveryStockMovementDetail(insMap);
				
				if (serialList.size() > 0) {
					int uCnt = 0;
					for (int j = 0; j < serialList.size(); j++) {

						Map<String, Object> insSerial = null;
						insSerial = (Map<String, Object>) serialList.get(j);
						insSerial.put("delno"  , deliSeq);
						insSerial.put("reqstno", insMap.get("reqstno"));
						insSerial.put("userId" , params.get("userId"));
						int icnt = stockMoveMapper.insertMovementSerial(insSerial);
						logger.info(" :::: " + icnt);
						if (icnt > 0 ){
							uCnt = uCnt +icnt;
							if (uCnt == (int)insMap.get("indelyqty")){
								break;
							}
						}
						scanno = (String)insSerial.get("scanno");
					}
					if (scanno != null) stockMoveMapper.updateMovementSerialScan(scanno);
				}
				
				insMap.put("scanno" , scanno);
				
			}

			stockMoveMapper.insertDeliveryStockMovement(insMap);
			stockMoveMapper.updateRequestMovement((String) formMap.get("reqstno"));
		}
		String[] delvcd = { deliSeq };

		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");

		stockMoveMapper.StockMovementIssue(formMap);

		return formMap;

	}

	@Override
	public List<EgovMap> selectStockMovementSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMoveMapper.selectStockMovementSerial(params);
	}

	@Override
	public Map<String, Object> stockMovementDeliveryIssue(Map<String, Object> params) {
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		int iCnt = 0;
		String tmpdelCd = "";
		String delyCd = "";
		if (checklist.size() > 0) {
			for (int i = 0; i < checklist.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checklist.get(i);

				Map<String, Object> imap = new HashMap();
				imap = (Map<String, Object>) map.get("item");

				String delCd = (String) imap.get("delyno");
				if (delCd != null && !(tmpdelCd.equals(delCd))) {
					tmpdelCd = delCd;
					if (iCnt == 0) {
						delyCd = delCd;
					} else {
						delyCd += "∈" + delCd;
					}
					iCnt++;
				}
			}
		}

		String[] delvcd = delyCd.split("∈");
		
		for (int i = 0 ; i < delvcd.length ; i ++){
			String receiptFlag = stockMoveMapper.getReceiptFlag(delvcd[i]);
			logger.debug( "279 Line ::::: " + receiptFlag);
			if (receiptFlag != null && "Y".equals(receiptFlag)){
				formMap.put("retMsg" , "fail");
				return formMap; 
			}
				
		}
		
		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");
		logger.debug("formMap : {}", formMap);
		if ("RC".equals(formMap.get("gtype"))) {
			stockMoveMapper.StockMovementCancelIssue(formMap); // movement receipt cancel
		} else {
			Map<String, Object> grade = (Map<String, Object>) params.get("grade");
			logger.info(" grade : {}", grade);
			if ("GR".equals(formMap.get("gtype")) & null != grade) {
				List<Object> gradelist = (List<Object>) grade.get(AppConstants.AUIGRID_UPDATE);
				logger.info(" gradelist : {}", gradelist);
				logger.info(" gradelist size : {}", gradelist.size());
				for (int i = 0; i < gradelist.size(); i++) {
					Map<String, Object> getmap = (Map<String, Object>) gradelist.get(i);
					logger.info(" getmap: {}", getmap);
					logger.info(" getmap delvryNo: {}", getmap.get("delvryNo"));
					Map<String, Object> setmap = new HashMap();
					setmap.put("delvryNo", getmap.get("delvryNo"));
					setmap.put("serialNo", getmap.get("serialNo"));
					setmap.put("grade", getmap.get("grade"));
					setmap.put("userId", params.get("userId"));
					stockMoveMapper.insertReturnGrade(setmap);
					logger.info(" setmap: {}", setmap);
				}
			}

			stockMoveMapper.StockMovementIssue(formMap);
		}
		formMap.put("retMsg" , "succ");
		//}

		return formMap;

	}

	@Override
	public List<EgovMap> selectStockMovementDeliverySerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMoveMapper.selectStockMovementDeliverySerial(params);
	}

	@Override
	public List<EgovMap> selectStockMovementMtrDocInfoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMoveMapper.selectStockMovementMtrDocInfoList(params);
	}

	@Override
	public void insertStockBooking(Map<String, Object> params) {
		// TODO Auto-generated method stub
		// return stocktran.selectStockTransferMtrDocInfoList(params);
		stockMoveMapper.insertStockBooking(params);
	}
	
	@Override
	public List<EgovMap> selectGetSerialDataCall(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMoveMapper.selectGetSerialDataCall(params);
	}
}
