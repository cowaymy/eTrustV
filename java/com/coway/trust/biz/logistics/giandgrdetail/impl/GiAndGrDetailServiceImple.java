/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.giandgrdetail.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.giandgrdetail.GiAndGrDetailService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("GiAndGrDetailService")
public class GiAndGrDetailServiceImple implements GiAndGrDetailService
{

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "GiAndGrDetailMapper")
	private GiAndGrDetailMapper giAndgrDetailMapper;

	@Override
	public List<EgovMap> selectLocation(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return giAndgrDetailMapper.selectLocation(params);
	}

	@Override
	public List<EgovMap> giAndGrDetailSearchList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return giAndgrDetailMapper.giAndGrDetailSearchList(params);
	}

//	@Override
//	public List<EgovMap> selectStockBalanceDetailsList(Map<String, Object> params)
//	{
//		// TODO Auto-generated method stub
//		return giAndgrDetailMapper.selectStockBalanceDetailsList(params);
//	}
//
//
//	@Override
//	public List<EgovMap> stockBalanceMovementType(Map<String, Object> params)
//	{
//		// TODO Auto-generated method stub
//		return giAndgrDetailMapper.stockBalanceMovementType(params);
//	}

}