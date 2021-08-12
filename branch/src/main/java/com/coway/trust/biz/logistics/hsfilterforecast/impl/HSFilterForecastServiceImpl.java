/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.hsfilterforecast.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.hsfilterforecast.HSFilterForecastService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HSFilterForecastService")
public class HSFilterForecastServiceImpl extends EgovAbstractServiceImpl implements HSFilterForecastService
{
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "HSFilterForecastMapper")
	private HSFilterForecastMapper hSFilterForecastMapper;

	@Override
	public List<EgovMap> selectHSFilterForecastList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return hSFilterForecastMapper.selectHSFilterForecastList(params);

	}

	@Override
	public List<EgovMap> selectForecastDetailsList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return hSFilterForecastMapper.selectForecastDetailsList(params);
	}
}
