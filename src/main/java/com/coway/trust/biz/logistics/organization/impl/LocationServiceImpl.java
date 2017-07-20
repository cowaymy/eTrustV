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
	
	@Override
	public void insertLocationInfo(Map<String, Object> params) {
		
		System.out.println("inwarecd                 :"+params.get("inwarecd"));
		System.out.println("inwarenm          :"+params.get("inwarenm"));
		System.out.println("inaddr1                 :"+params.get("inaddr1"));
		System.out.println("inaddr1                 :"+params.get("inaddr2"));
		System.out.println("inaddr3                 :"+params.get("inaddr3"));
		System.out.println("incontact1                 :"+params.get("incontact1"));
		System.out.println("incontact2                 :"+params.get("incontact2"));
		
		String inlocid = locMapper.locCreateSeq();
		System.out.println("inlocid@@@                 :"+params.get("inlocid"));
		params.put("inlocid", inlocid);
		
		// TODO Auto-generated method stub
		locMapper.insertLocationInfo(params);
	}

	
	
}