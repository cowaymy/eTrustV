package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	public List<EgovMap> getZRLocationList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectZRLocationList(params);
	}
}
