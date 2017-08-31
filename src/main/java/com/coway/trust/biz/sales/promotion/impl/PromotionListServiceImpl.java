/**
 * 
 */
package com.coway.trust.biz.sales.promotion.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.sales.promotion.PromotionListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("promotionListService")
public class PromotionListServiceImpl extends EgovAbstractServiceImpl implements PromotionListService {

//	private static Logger logger = LoggerFactory.getLogger(OrderListServiceImpl.class);
	
	@Resource(name = "promotionListMapper")
	private PromotionListMapper promotionListMapper;
	
//	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selectPromotionList(Map<String, Object> params) {
		return promotionListMapper.selectPromotionList(params);
	}
}
