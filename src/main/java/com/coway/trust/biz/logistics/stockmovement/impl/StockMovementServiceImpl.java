/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stockmovement.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.stockmovement.StockMovementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stockMovementService")
public class StockMovementServiceImpl extends EgovAbstractServiceImpl implements StockMovementService {

	@Resource(name = "stockMoveMapper")
	private StockMovementMapper stockMoveMapper;

	@Override
	public void insertStockMovementInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");

		String seq = stockMoveMapper.selectStockMovementSeq();

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		fMap.put("reqno", fMap.get("headtitle") + seq);
		fMap.put("userId", params.get("userId"));

		stockMoveMapper.insStockMovementHead(fMap);

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("reqno", fMap.get("headtitle") + seq);
				insMap.put("userId", params.get("userId"));
				stockMoveMapper.insStockMovement(insMap);
			}
		}
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
	public void stockMovementReqDelivery(Map<String, Object> params) {
		List<Object> updList = (List<Object>) params.get("check");

		String seq = stockMoveMapper.selectDeliveryStockMovementSeq();

		if (updList.size() > 0) {
			Map<String, Object> insMap = null;
			for (int i = 0; i < updList.size(); i++) {

				insMap = (Map<String, Object>) updList.get(i);
				insMap.put("delno", seq);
				insMap.put("userId", params.get("userId"));
				stockMoveMapper.insertDeliveryStockMovementDetail(insMap);
			}
			stockMoveMapper.insertDeliveryStockMovement(insMap);
		}

	}
}
