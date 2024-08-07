/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.organization.LocationService;

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
	public int insertLocationInfo(Map<String, Object> params) {

		int inlocid = locMapper.locCreateSeq();

		params.put("inlocid", inlocid);

		// TODO Auto-generated method stub
		locMapper.insertLocationInfo(params);

		return inlocid;

	}

	@Override
	public void deleteLocationInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		locMapper.deleteLocationInfo(params);
	}

	@Override
	public List<EgovMap> selectLocationCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return locMapper.selectLocationCodeList(params);
	}

	@Override
	public int selectLocationChk(String params) {
		// TODO Auto-generated method stub
		return locMapper.selectLocationChk(params);
	}

	@Override
	public List<EgovMap> selectLocStatusList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return locMapper.selectLocStatusList(params);
	}

	@Override
	public void updateBranchLoc(Map<String, Object> params){
		locMapper.updateBranchLoc(params);
	}

}
