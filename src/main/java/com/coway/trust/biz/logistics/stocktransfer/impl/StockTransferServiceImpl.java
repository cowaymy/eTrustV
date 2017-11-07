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
		//fMap.put("reqno", fMap.get("headtitle") + seq);
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
		stocktran.updateRequestTransfer(((String) fMap.get("headtitle") + seq));

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

	@Override
	public void StocktransferReqDelivery(Map<String, Object> params) {

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
	}

	@Override
	public List<EgovMap> StockTransferDeliveryIssue(Map<String, Object> params) {
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
		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");

		if ("RC".equals(formMap.get("gtype"))) {

			stocktran.StockTransferCancelIssue(formMap);
		} else {

			stocktran.StockTransferiSsue(formMap);
		}

		List<EgovMap> list = null;

		return list;
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
}
