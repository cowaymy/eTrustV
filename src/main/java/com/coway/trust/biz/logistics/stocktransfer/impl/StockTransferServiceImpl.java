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
import javax.measure.unit.SystemOfUnits;

import org.apache.commons.collections.map.ListOrderedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.stocks.StockService;
import com.coway.trust.biz.logistics.stocks.impl.StockMapper;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stocktranService")
public class StockTransferServiceImpl extends EgovAbstractServiceImpl implements StockTransferService {
	
	@Resource(name = "stockTranMapper")
	private StockTransferMapper stocktran;

	@Override
	public List<EgovMap> selectStockTransferMainList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferMainList(params);
	}

	@Override
	public void insertStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		
		String seq = (String)stocktran.selectStockTransferSeq();
		
		Map<String, Object> fMap = (Map<String, Object>) params.get("form");
		
		fMap.put("reqno" , fMap.get("headtitle") + seq);
		fMap.put("userId", params.get("userId"));
		
		
		stocktran.insStockTransferHead(fMap);
		
		if (insList.size() > 0){
			for (int i = 0 ; i < insList.size() ; i++){
	    		Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
	    		insMap.put("reqno" , fMap.get("headtitle") + seq);
	    		insMap.put("userId", params.get("userId"));
	    		stocktran.insStockTransfer(insMap);
			}
		}		
	}

	@Override
	public List<EgovMap> selectStockTransferNoList() {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferNoList();
	}

	@Override
	public Map<String, Object> StocktransferDataDetail(String param) {
		
		Map<String, Object> hdMap = stocktran.selectStockTransferHead(param);
		
		List<EgovMap> list = stocktran.selectStockTransferItem(param);
		
		Map<String, Object> pMap = new HashMap();
		pMap.put("toloc", (String)hdMap.get("rcivcr"));
		
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
		try{
			iCnt = (int)map.get("qty");
		}catch(Exception ex){
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
	public void addStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		List<Object> updList = (List<Object>) params.get("upd");
		/*List<Object> delList = (List<Object>) params.get("rem");*/
		
		Map<String, Object> fMap = (Map<String, Object>) params.get("form");
		
		if (insList.size() > 0){
			for (int i = 0 ; i < insList.size() ; i++){
	    		Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
	    		insMap.put("reqno" , fMap.get("reqno"));
	    		insMap.put("userId", params.get("userId"));	    		
	    		stocktran.insStockTransfer(insMap);
			}
		}
		if (updList.size() > 0){
			for (int i = 0 ; i < updList.size() ; i++){
	    		Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
	    		insMap.put("reqno" , fMap.get("reqno"));
	    		insMap.put("userId", params.get("userId"));	    		
	    		stocktran.insStockTransfer(insMap);
			}
		}
	}
	
	
	@Override
	public void deliveryStockTransferInfo(Map<String, Object> params) {
		List<Object> updList = (List<Object>) params.get("upd");
		
		String seq = (String)stocktran.selectDeliveryStockTransferSeq();
		
		Map<String, Object> fMap = (Map<String, Object>) params.get("form");
		
		fMap.put("reqno" , fMap.get("reqno")   );
		fMap.put("delno" , seq                 );
		fMap.put("ttype" , fMap.get("smtype")  );
		fMap.put("userId", params.get("userId"));	
		
		stocktran.deliveryStockTransferIns(fMap);
		
		if (updList.size() > 0){
			for (int i = 0 ; i < updList.size() ; i++){
	    		Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
	    		insMap.put("delno" , seq                 );
	    		insMap.put("userId", params.get("userId"));
	    		
	    		stocktran.deliveryStockTransferDetailIns(insMap);
			}
		}		
	}

}