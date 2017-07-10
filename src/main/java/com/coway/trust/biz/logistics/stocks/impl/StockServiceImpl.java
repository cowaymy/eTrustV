/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stocks.impl;


import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.stocks.StockService;
import com.coway.trust.biz.logistics.stocks.impl.StockMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stockService")
public class StockServiceImpl extends EgovAbstractServiceImpl implements StockService {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "stockMapper")
	private StockMapper stockMapper;

	@Override
	public List<EgovMap> selectStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockList(params);
	}

	@Override
	public List<EgovMap> selectStockInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockInfo(params);
	}

	@Override
	public List<EgovMap> selectPriceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectPriceInfo(params);
		
	}

	@Override
	public List<EgovMap> selectFilterInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectFilterInfo(params);
	}

	@Override
	public List<EgovMap> selectServiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectServiceInfo(params);
	}

	@Override
	public List<EgovMap> selectStockImgList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockImgList(params);
	}
	
}