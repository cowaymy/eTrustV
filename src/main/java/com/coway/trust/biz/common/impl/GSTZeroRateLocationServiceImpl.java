package com.coway.trust.biz.common.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.GSTZeroRateLocationService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("gstZeroRateLocationService")
public class GSTZeroRateLocationServiceImpl implements GSTZeroRateLocationService {

	@Autowired
	private GSTZeroRateLocationMapper gstZeroRateLocationMapper;

	@Override
	public List<EgovMap> getStateCodeList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectStateCodeList(params);
	}

	@Override
	public List<EgovMap> getSubAreaList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectSubAreaList(params);
	}

	@Override
	public List<EgovMap> getPostCodeList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectPostCodeList(params);
	}

	@Override
	public List<EgovMap> getZRLocationList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectZRLocationList(params);
	}

	@Override
	public void saveZRLocation(Map<String, ArrayList<Object>> params, int userId) {
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD);

		Map<String, Object> param;
		for (Object map : updateList) {
			param = (HashMap<String, Object>) map;
			setUserId(param, userId);
			gstZeroRateLocationMapper.updateZrLocStusId(param);
		}

		for (Object map : addList) {
			param = (HashMap<String, Object>) map;
			setUserId(param, userId);
			gstZeroRateLocationMapper.insertZrLocStusId(param);
		}

	}

	private void setUserId(Map<String, Object> map, int userId) {
		map.put("userId", userId);
	}
}
