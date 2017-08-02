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
	public List<EgovMap> selectStockTransferList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		/*List<Object> updList = (List<Object>) params.get("upd");
		List<Object> delList = (List<Object>) params.get("rem");*/
		
		String seq = (String)stocktran.selectStockTransferSeq();
		
		System.out.println(" :::::: " + seq);
		
		Map<String, Object> fMap = (Map<String, Object>) params.get("form");
		fMap.put("reqno" , seq);
		fMap.put("userId", params.get("userId"));
		
		
		stocktran.insStockTransferHead(fMap);
		
		if (insList.size() > 0){
			for (int i = 0 ; i < insList.size() ; i++){
	    		Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
	    		insMap.put("reqno" , seq);
	    		insMap.put("userId", params.get("userId"));
	    		stocktran.insStockTransfer(insMap);
			}
		}
		/*if (updList.size() > 0){
			for (int i = 0 ; i < updList.size() ; i++){
	    		Map<String, Object> updMap = (Map<String, Object>) updList.get(i);
	    		stocktran.updStockTransfer(updMap);
			}
		}
		if (delList.size() > 0){
			for (int i = 0 ; i < delList.size() ; i++){
	    		Map<String, Object> remMap = (Map<String, Object>) delList.get(i);
	    		stocktran.remStockTransfer(remMap);
			}	
		}*/
	}

}