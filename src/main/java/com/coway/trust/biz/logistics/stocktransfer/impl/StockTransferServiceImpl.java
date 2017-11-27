/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stocktransfer.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stocktranService")
public class StockTransferServiceImpl extends EgovAbstractServiceImpl implements StockTransferService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "stockTranMapper")
	private StockTransferMapper stocktran;

	@Override
	public List<EgovMap> selectStockTransferMainList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferMainList(params);
	}

	@Override
	public List<EgovMap> selectStockTransferDeliveryList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferDeliveryList(params);
	}

	@Override
	public String insertStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");

		String seq = stocktran.selectStockTransferSeq();

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		String reqNo = fMap.get("headtitle") + seq;

		fMap.put("reqno", reqNo);
		// fMap.put("reqno", fMap.get("headtitle") + seq);
		fMap.put("userId", params.get("userId"));

		stocktran.insStockTransferHead(fMap);

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("reqno", fMap.get("headtitle") + seq);
				insMap.put("userId", params.get("userId"));
				stocktran.insStockTransfer(insMap);
			}
		}
		//
		insertStockBooking(fMap);

		return reqNo;

	}

	@Override
	public List<EgovMap> selectStockTransferNoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<EgovMap> list = null;
		if ("stock".equals(params.get("groupCode"))) {
			list = stocktran.selectStockTransferNoList();
		} else {
			list = stocktran.selectDeliveryNoList();
		}
		return list;
	}

	@Override
	public Map<String, Object> StocktransferDataDetail(String param) {

		Map<String, Object> hdMap = stocktran.selectStockTransferHead(param);

		List<EgovMap> list = stocktran.selectStockTransferItem(param);

		Map<String, Object> pMap = new HashMap();
		pMap.put("toloc", hdMap.get("rcivcr"));

		List<EgovMap> toList = stocktran.selectStockTransferToItem(pMap);

		Map<String, Object> reMap = new HashMap();
		reMap.put("hValue", hdMap);
		reMap.put("iValue", list);
		reMap.put("itemto", toList);

		return reMap;
	}

	@Override
	public int stockTransferItemDeliveryQty(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Map<String, Object> map = stocktran.stockTransferItemDeliveryQty(params);
		int iCnt = 0;
		try {
			iCnt = (int) map.get("qty");
		} catch (Exception ex) {
			iCnt = 0;
		}
		return iCnt;
	}

	@Override
	public List<EgovMap> selectTolocationItemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferToItem(params);
	}

	@Override
	public List<EgovMap> addStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		List<Object> updList = (List<Object>) params.get("upd");
		/* List<Object> delList = (List<Object>) params.get("rem"); */

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				insMap.put("userId", params.get("userId"));
				stocktran.insStockTransfer(insMap);
			}
		}
		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				insMap.put("userId", params.get("userId"));
				stocktran.insStockTransfer(insMap);
			}
		}
		List<EgovMap> list = stocktran.selectStockTransferItem((String) fMap.get("reqno"));
		return list;
	}

	@Override
	public void deliveryStockTransferInfo(Map<String, Object> params) {

		List<Object> updList = (List<Object>) params.get("upd");

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		fMap.put("reqno", fMap.get("reqno"));
		String seq = stocktran.selectDeliveryNobyReqsNo(fMap);
		if (seq == null || "0".equals(seq)) {
			seq = stocktran.selectDeliveryStockTransferSeq();
		}

		fMap.put("delno", seq);
		fMap.put("ttype", fMap.get("smtype"));
		fMap.put("userId", params.get("userId"));

		stocktran.deliveryStockTransferIns(fMap);

		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
				insMap.put("delno", seq);
				insMap.put("userId", params.get("userId"));

				stocktran.deliveryStockTransferDetailIns(insMap);
			}
		}
	}

	@Override
	public void deliveryStockTransferItmDel(Map<String, Object> params) {
		List<Object> delList = (List<Object>) params.get("del");

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		if (delList.size() > 0) {
			for (int i = 0; i < delList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) delList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				stocktran.StockTransferItmDel(insMap);
				stocktran.deliveryStockTransferItmDel(insMap);
			}
		}
	}

//	@Override
//	public String StocktransferReqDelivery(Map<String, Object> params) {
//
//		List<Object> updList = (List<Object>) params.get("check");
////		List<Object> serialList = (List<Object>) params.get("add");
//		Map<String, Object> formMap = (Map<String, Object>) params.get("formMap");
//
//		// for (int i = 0; i < updList.size(); i++) {
//		// logger.info(" updList.get(i) : {}", updList.get(i));
//		// }
//		// for (int i = 0; i < serialList.size(); i++) {
//		// logger.info(" serialList.get(i) : {}", serialList.get(i));
//		// }
//		//
//		// logger.info(" reqstno : {}", formMap.get("reqstno"));
//
//		String seq = stocktran.selectDeliveryStockTransferSeq();
//
//		if (updList.size() > 0) {
//			Map<String, Object> imap = new HashMap();
//			Map<String, Object> insMap = null;
//			for (int i = 0; i < updList.size(); i++) {
//
//				logger.info(" updList.get(i) : {}", updList.get(i).toString());
//				insMap = (Map<String, Object>) updList.get(i);
//
//				imap = (Map<String, Object>) insMap.get("item");
//
//				imap.put("delno", seq);
//				imap.put("userId", params.get("userId"));
//				stocktran.deliveryStockTransferDetailIns(imap);
//			}
//			stocktran.deliveryStockTransferIns(imap);
//		}
//
////		if (serialList.size() > 0) {
////
////			for (int j = 0; j < serialList.size(); j++) {
////
////				Map<String, Object> insSerial = null;
////
////				insSerial = (Map<String, Object>) serialList.get(j);
////
////				insSerial.put("delno", seq);
////				insSerial.put("reqstno", formMap.get("reqstno"));
////				insSerial.put("userId", params.get("userId"));
////				stocktran.insertTransferSerial(insSerial);
////			}
////		}
//		return seq;
//	}

	@Override
	public String StocktransferReqDelivery(Map<String, Object> params) {

		List<Object> updList = (List<Object>) params.get("check");

		String seq = stocktran.selectDeliveryStockTransferSeq();

		if (updList.size() > 0) {
			Map<String, Object> insMap = null;
			for (int i = 0; i < updList.size(); i++) {

				logger.info(" updList.get(i) : {}", updList.get(i).toString());
				insMap = (Map<String, Object>) updList.get(i);
				insMap.put("delno", seq);
				insMap.put("userId", params.get("userId"));
				stocktran.deliveryStockTransferDetailIns(insMap);
			}
			stocktran.deliveryStockTransferIns(insMap);
		}
		
		return seq;
		
	}

	@Override
	public String StockTransferDeliveryIssue(Map<String, Object> params) {
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> serialList = (List<Object>) params.get("add");
		String reVal = "";

		int iCnt = 0;
		String tmpdelCd = "";
		String delyCd = "";
		String delno="";
		
		
		if (checklist.size() > 0) {
			for (int i = 0; i < checklist.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checklist.get(i);
				
				logger.info(" map:::!!! ??: {}", map);
				
				Map<String, Object> imap = new HashMap();
				imap = (Map<String, Object>) map.get("item");

				String delCd = (String) imap.get("delyno");
				delno = (String) imap.get("delyno");
				if (delCd != null && !(tmpdelCd.equals(delCd))) {
					tmpdelCd = delCd;
					if (iCnt == 0) {
						delyCd = delCd;
					} else {
						delyCd += "∈" + delCd;
					}
					iCnt++;
				}
				String reqstNo = (String) imap.get("reqstno");
				stocktran.updateRequestTransfer(reqstNo);
			}
		}
		
	if (serialList.size() > 0) {

		for (int j = 0; j < serialList.size(); j++) {

			Map<String, Object> insSerial = null;

			insSerial = (Map<String, Object>) serialList.get(j);

			insSerial.put("delno", delno);
			insSerial.put("reqstno", formMap.get("reqstno"));
			insSerial.put("userId", params.get("userId"));
			
			logger.info(" insSerial ??: {}", insSerial);
			
			stocktran.insertTransferSerial(insSerial);
		}
	}
			

		String[] delvcd = delyCd.split("∈");
		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");

		if ("RC".equals(formMap.get("gtype"))) {
			stocktran.StockTransferCancelIssue(formMap);
			reVal = (String) formMap.get("rdata");
		} else {
			stocktran.StockTransferiSsue(formMap);
			reVal = (String) formMap.get("rdata");
		}
		String returnValue[] = reVal.split("∈");
		return returnValue[1];
	}

	@Override
	public List<EgovMap> selectStockTransferMtrDocInfoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferMtrDocInfoList(params);
	}

	@Override
	public void insertStockBooking(Map<String, Object> params) {
		// TODO Auto-generated method stub
		// return stocktran.selectStockTransferMtrDocInfoList(params);
		stocktran.insertStockBooking(params);
	}

	@Override
	public void StocktransferDeliveryDelete(Map<String, Object> params) {
		List<Object> updList = (List<Object>) params.get("check");
		String delno = "";
		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> dmap = (Map<String, Object>) ((Map<String, Object>) updList.get(i)).get("item");
				logger.debug("323 Line params ::: {}", dmap);

				if (!delno.equals(dmap.get("delyno"))) {
					delno = (String) dmap.get("delyno");
					stocktran.deliveryDelete54(dmap);
					stocktran.deliveryDelete55(dmap);
					stocktran.deliveryDelete61(dmap);
					logger.debug("329Line :::: " + delno);
				}
				stocktran.updateRequestTransfer(dmap);

			}
		}
	}
}
