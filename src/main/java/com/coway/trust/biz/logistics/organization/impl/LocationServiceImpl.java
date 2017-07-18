/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.logistics.organization.impl.LocationMapper;
import com.coway.trust.biz.logistics.stocks.StockService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("locationService")
public class LocationServiceImpl extends EgovAbstractServiceImpl implements LocationService {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "locMapper")
	private LocationMapper locMapper;

	@Override
	public List<EgovMap> selectLocationList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return locMapper.selectLocationList(params);
	}

	@Override
	public List<EgovMap> selectLocationStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return locMapper.selectLocationStockList(params);
	}

	@Override
	public void updateLocationInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		locMapper.updateLocationInfo(params);
	}

	
	
}