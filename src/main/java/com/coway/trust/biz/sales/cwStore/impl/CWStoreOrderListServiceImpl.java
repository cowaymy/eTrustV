package com.coway.trust.biz.sales.cwStore.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.cwStore.CWStoreOrderListService;
import com.coway.trust.biz.sales.order.impl.OrderListMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("cwStoreOrderListService")
public class CWStoreOrderListServiceImpl extends EgovAbstractServiceImpl implements CWStoreOrderListService{

	@Resource(name = "cwStoreOrderListMapper")
	private CWStoreOrderListMapper cwStoreOrderListMapper;
	
	@Override
	public List<EgovMap> selectCWStoreOrderList(Map<String, Object> params) {
		return cwStoreOrderListMapper.selectCWStoreOrderList(params);
	}

}
