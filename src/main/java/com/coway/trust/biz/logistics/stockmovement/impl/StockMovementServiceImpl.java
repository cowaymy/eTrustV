/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stockmovement.impl;

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
}
