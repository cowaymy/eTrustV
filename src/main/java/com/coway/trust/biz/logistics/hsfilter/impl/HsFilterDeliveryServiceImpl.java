
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.hsfilter.HsFilterDeliveryService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HsFilterDeliveryService")
public class HsFilterDeliveryServiceImpl extends EgovAbstractServiceImpl implements HsFilterDeliveryService
{
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "HsFilterDeliveryMapper")
	private HsFilterDeliveryMapper hsFilterDeliveryMapper;


	@Override
	public List<EgovMap> selectHSFilterDeliveryBranchList(Map<String, Object> params) {


		return hsFilterDeliveryMapper.selectHSFilterDeliveryBranchList(params);
	}


	@Override
	public List<EgovMap> selectHSFilterDeliveryList(Map<String, Object> params) {


		logger.debug(params.toString());


		//forecastMonth=02/2021, searchCDC=2010, searchBranchCb=
		if(params.get("forecastMonth") !="" || params.get("forecastMonth") !=null ){

			String date[] = (String[])(params.get("forecastMonth")).toString().split("/");


			params.put("yyyy", date[1]);
			params.put("mm", date[0]);
		}
		return hsFilterDeliveryMapper.selectHSFilterDeliveryList(params);
	}


	@Override
	public List<EgovMap> selectHSFilterDeliveryPickingList(Map<String, Object> params) {


		//forecastMonth=02/2021, searchCDC=2010, searchBranchCb=
		if(params.get("forecastMonth") !="" || params.get("forecastMonth") !=null ){
			String date[] = (String[])(params.get("forecastMonth")).toString().split("/");
			params.put("yyyy", date[1]);
			params.put("mm", date[0]);
		}


		return hsFilterDeliveryMapper.selectHSFilterDeliveryPickingList(params);

	}



}
