
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.List;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.hsfilter.HsFilterForecastService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HsFilterForecastService")
public class HsFilterForecastServiceImpl extends EgovAbstractServiceImpl implements HsFilterForecastService
{
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "HsFilterForecastMapper")
	private HsFilterForecastMapper hsFilterForecastMapper;


	@Override
	public List<EgovMap> selectHSFilterForecastList(Map<String, Object> params) {


		logger.debug(params.toString());


		//forecastMonth=02/2021, searchCDC=2010, searchBranchCb=
		if(params.get("forecastMonth") !="" || params.get("forecastMonth") !=null ){

			String date[] = (String[])(params.get("forecastMonth")).toString().split("/");


			params.put("yyyy", date[1]);
			params.put("mm", date[0]);
		}
		return hsFilterForecastMapper.selectHSFilterForecastyList(params);
	}



}
