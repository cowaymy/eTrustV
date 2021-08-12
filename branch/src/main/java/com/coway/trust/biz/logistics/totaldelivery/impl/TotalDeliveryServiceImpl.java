/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.totaldelivery.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.totaldelivery.TotalDeliveryService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("TotalDeliveryService")
public class TotalDeliveryServiceImpl extends EgovAbstractServiceImpl implements TotalDeliveryService
{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "TotalDeliveryMapper")
	private TotalDeliveryMapper delivery;

	@Override
	public List<EgovMap> selectTotalDeliveryList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return delivery.selectTotalDeliveryList(params);
	}
}