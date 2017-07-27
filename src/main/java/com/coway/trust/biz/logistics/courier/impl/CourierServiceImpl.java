package com.coway.trust.biz.logistics.courier.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.courier.CourierService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("courierService")
public class CourierServiceImpl implements CourierService {

	private static final Logger logger = LoggerFactory.getLogger(CourierServiceImpl.class);

	@Resource(name = "courierMapper")
	private CourierMapper courierMapper;

	@Override
	public List<EgovMap> selectCourierList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return courierMapper.selectCourierList(params);
	}

	@Override
	public List<EgovMap> selectCourierDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return courierMapper.selectCourierDetail(params);
	}

}
