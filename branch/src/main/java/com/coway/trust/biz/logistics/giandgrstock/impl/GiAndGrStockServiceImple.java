/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.giandgrstock.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.giandgrstock.GiAndGrStockService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("GiAndGrStockService")
public class GiAndGrStockServiceImple implements GiAndGrStockService
{

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "GiAndGrStockMapper")
	private GiAndGrStockMapper giAndGrStockMapper;

	@Override
	public List<EgovMap> selectLocation(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return giAndGrStockMapper.selectLocation(params);
	}

	@Override
	public List<EgovMap> stockBalanceSearchList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return giAndGrStockMapper.stockBalanceSearchList(params);
	}

	@Override
	public List<EgovMap> selectStockBalanceDetailsList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return giAndGrStockMapper.selectStockBalanceDetailsList(params);
	}


	@Override
	public List<EgovMap> stockBalanceMovementType(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return giAndGrStockMapper.stockBalanceMovementType(params);
	}

}