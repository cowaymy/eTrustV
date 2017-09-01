/**
 * 
 */
package com.coway.trust.biz.sales.promotion.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.promotion.PromotionListService;
import com.coway.trust.biz.sales.promotion.PromotionRegisterService;
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("promotionRegisterService")
public class PromotionRegisterServiceImpl extends EgovAbstractServiceImpl implements PromotionRegisterService {

	private static Logger logger = LoggerFactory.getLogger(PromotionRegisterServiceImpl.class);
	
	@Resource(name = "promotionRegisterMapper")
	private PromotionRegisterMapper promotionRegisterMapper;
	
//	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public void registerPromotion(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionRegisterServiceImpl.registerPromotion");
		
		SalesPromoMVO salesPromoMVO = promotionVO.getSalesPromoMVO();
		
		GridDataSet<SalesPromoDVO>        salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList = promotionVO.getFreeGiftGridDataSetList();
		
		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getAdd();
		List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getAdd();
		
		this.preprocSalesPromotionMaster(salesPromoMVO, sessionVO);
/*
		this.preprocSalesPromotionDetail(addSalesPromoDVOList, salesPromoMVO.getPromoId(),  sessionVO);
		
		this.preprocSalesPromoFreeGift(addSalesPromoFreeGiftVOList, salesPromoMVO.getPromoId(), sessionVO);
*/
		promotionRegisterMapper.insertSalesPromoM(salesPromoMVO);
/*
		for(SalesPromoDVO salesPromoDVO : addSalesPromoDVOList) {
			promotionRegisterMapper.insertSalesPromoD(salesPromoDVO);
		}
		
		for(SalesPromoFreeGiftVO salesPromoFreeGiftVO : addSalesPromoFreeGiftVOList) {
			promotionRegisterMapper.insertSalesPromoFreeGift(salesPromoFreeGiftVO);
		}
*/
	}
	
	private void preprocSalesPromotionMaster(SalesPromoMVO salesPromoMVO, SessionVO sessionVO) {
		
		String promoDtFrom = (String)salesPromoMVO.getPromoDtFrom();
		String promoDtEnd  = (String)salesPromoMVO.getPromoDtEnd();
		
		salesPromoMVO.setPromoMtchId(0);
		salesPromoMVO.setPromoDtFrom(CommonUtils.changeFormat(promoDtFrom, SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoDtEnd(CommonUtils.changeFormat(promoDtEnd,  SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoStusId(1);
		salesPromoMVO.setPromoUpdUserId(sessionVO.getUserId());
		salesPromoMVO.setPromoIsTrialCnvr(0);
	}
	
	private void preprocSalesPromotionDetail(List<SalesPromoDVO> addSalesPromoDVOList, int promoId, SessionVO sessionVO) {
		
		if(addSalesPromoDVOList != null) {
			for(SalesPromoDVO addVo : addSalesPromoDVOList) {
				addVo.setPromoId(promoId);
				addVo.setPromoItmUpdUserId(sessionVO.getUserId());
			}
		}
	}
	
	private void preprocSalesPromoFreeGift(List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList, int promoId, SessionVO sessionVO) {
		
		if(addSalesPromoFreeGiftVOList != null) {
			for(SalesPromoFreeGiftVO addVo : addSalesPromoFreeGiftVOList) {
				addVo.setPromoFreeGiftPromoId(promoId);;
				addVo.setPromoFreeGiftCrtUserId(sessionVO.getUserId());
			}
		}
	}
	
	@Override
	public List<EgovMap> selectMembershipPkg(Map<String, Object> params) {
		return promotionRegisterMapper.selectMembershipPkg(params);
	}
	
	@Override
	public List<SalesPromoDVO> selectPriceInfo(PromotionVO promotionVO) {
		
		GridDataSet<SalesPromoDVO> salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		
		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getAdd();
		
		int appTypeId = promotionVO.getSalesPromoMVO().getPromoAppTypeId();
		
		Map<String, Object> params = null;
		
		for(SalesPromoDVO dvo: addSalesPromoDVOList) {
			
			params = new HashMap<String, Object>();
			
			params.put("sktId", dvo.getPromoItmStkId());
			params.put("appTypeId", appTypeId);
			
			EgovMap priceMap = promotionRegisterMapper.selectPriceInfo(params);
			
			dvo.setAmt((BigDecimal)priceMap.get("amt"));
			dvo.setPrcRpf((BigDecimal)priceMap.get("prcRpf"));
			dvo.setPrcPv((BigDecimal)priceMap.get("prcPv"));
		}
		
		return addSalesPromoDVOList;
	}
}
