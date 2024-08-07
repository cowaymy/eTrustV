/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.stockbalance.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.stockbalance.StockBalanceService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("StockBalanceService")
public class StockBalanceServiceImple implements StockBalanceService
{

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "StockBalanceMapper")
	private StockBalanceMapper stockBalanceMapper;

	@Override
	public List<EgovMap> selectLocation(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return stockBalanceMapper.selectLocation(params);
	}

	@Override
	public List<EgovMap> stockBalanceSearchList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return stockBalanceMapper.stockBalanceSearchList(params);
	}

	@Override
	public List<EgovMap> selectStockBalanceDetailsList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return stockBalanceMapper.selectStockBalanceDetailsList(params);
	}


	@Override
	public List<EgovMap> stockBalanceMovementType(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return stockBalanceMapper.stockBalanceMovementType(params);
	}

}