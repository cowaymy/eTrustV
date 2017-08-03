/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("orderRegisterService")
public class OrderRegisterServiceImpl extends EgovAbstractServiceImpl implements OrderRegisterService{

	private static Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public EgovMap selectSrvCntcInfo(Map<String, Object> params) {
		
		EgovMap custAddInfo = orderRegisterMapper.selectSrvCntcInfo(params);
		
		return custAddInfo;
	}
	
}
