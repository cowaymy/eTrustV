/**
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.PayPopService;
import com.coway.trust.biz.sales.order.impl.OrderDetailMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
@Service("payPopService")
public class PayPopServiceImpl extends EgovAbstractServiceImpl implements PayPopService {

	private static Logger logger = LoggerFactory.getLogger(PayPopServiceImpl.class);

	@Resource(name = "payPopMapper")
	private PayPopMapper payPopMapper;

	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;


	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Override
	public List<EgovMap> selectTransferHistoryList(Map<String, Object> params) {
		return payPopMapper.selectTransferHistoryList(params);
	}

	@Override
	public EgovMap selectHPCodyList(Map<String, Object> params) {
		EgovMap orderDetail = new EgovMap();
	    EgovMap codyInfo = orderDetailMapper.selectOrderServiceMemberViewByOrderID(params);
	    EgovMap salesmanInfo = orderDetailMapper.selectOrderSalesmanViewByOrderID(params);
		orderDetail.put("codyInfo", codyInfo);
		orderDetail.put("salesmanInfo", salesmanInfo);

		return orderDetail;
	}
}
