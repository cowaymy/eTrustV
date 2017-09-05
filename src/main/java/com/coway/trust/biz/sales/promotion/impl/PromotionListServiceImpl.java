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
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("promotionListService")
public class PromotionListServiceImpl extends EgovAbstractServiceImpl implements PromotionListService {

	private static Logger logger = LoggerFactory.getLogger(PromotionListServiceImpl.class);
	
	@Resource(name = "promotionListMapper")
	private PromotionListMapper promotionListMapper;
	
//	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selectPromotionList(Map<String, Object> params) {
		return promotionListMapper.selectPromotionList(params);
	}
	
	@Override
	public void updatePromoStatus(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionListServiceImpl.updatePromoStatus");

		GridDataSet<SalesPromoMVO> salesPromoMDataSetList  = promotionVO.getSalesPromoMGridDataSetList();
		
		List<SalesPromoMVO> updateList = salesPromoMDataSetList.getUpdate();

		for(SalesPromoMVO vo : updateList) {
			vo.setPromoUpdUserId(sessionVO.getUserId());
			promotionListMapper.updatePromoStatus(vo);
		}

	}
}
