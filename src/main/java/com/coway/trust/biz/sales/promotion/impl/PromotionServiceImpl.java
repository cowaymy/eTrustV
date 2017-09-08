/**
 * 
 */
package com.coway.trust.biz.sales.promotion.impl;

import java.math.BigDecimal;
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
import com.coway.trust.biz.sales.promotion.PromotionService;
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;
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
@Service("promotionService")
public class PromotionServiceImpl extends EgovAbstractServiceImpl implements PromotionService {

	private static Logger logger = LoggerFactory.getLogger(PromotionServiceImpl.class);
	
	@Resource(name = "promotionMapper")
	private PromotionMapper promotionMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selectPromotionList(Map<String, Object> params) {
		return promotionMapper.selectPromotionList(params);
	}
	
	@Override
	public EgovMap selectPromotionDetail(Map<String, Object> params) {
		return promotionMapper.selectPromotionDetail(params);
	}
	
	@Override
	public List<EgovMap> selectPromotionPrdList(Map<String, Object> params) {
		return promotionMapper.selectPromotionPrdList(params);
	}
	
	@Override
	public List<EgovMap> selectPromotionFreeGiftList(Map<String, Object> params) {
		return promotionMapper.selectPromotionFreeGiftList(params);
	}
	
	@Override
	public void updatePromoStatus(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.updatePromoStatus");

		GridDataSet<SalesPromoMVO> salesPromoMDataSetList  = promotionVO.getSalesPromoMGridDataSetList();
		
		List<SalesPromoMVO> updateList = salesPromoMDataSetList.getUpdate();

		for(SalesPromoMVO vo : updateList) {
			vo.setPromoUpdUserId(sessionVO.getUserId());
			promotionMapper.updatePromoStatus(vo);
		}

	}
	
	@Override
	public void registerPromotion(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.registerPromotion");
		
		SalesPromoMVO salesPromoMVO = promotionVO.getSalesPromoMVO();
		
		GridDataSet<SalesPromoDVO>        salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList = promotionVO.getFreeGiftGridDataSetList();
		
		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getAdd();
		List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getAdd();
		
		this.preprocSalesPromotionMaster(salesPromoMVO, sessionVO);

		promotionMapper.insertSalesPromoM(salesPromoMVO);

		this.preprocSalesPromotionDetail(addSalesPromoDVOList, salesPromoMVO.getPromoId(),  sessionVO);
		
		for(SalesPromoDVO salesPromoDVO : addSalesPromoDVOList) {
			promotionMapper.insertSalesPromoD(salesPromoDVO);
		}
		
		this.preprocSalesPromoFreeGift(addSalesPromoFreeGiftVOList, salesPromoMVO.getPromoId(), sessionVO);

		for(SalesPromoFreeGiftVO salesPromoFreeGiftVO : addSalesPromoFreeGiftVOList) {
			promotionMapper.insertSalesPromoFreeGift(salesPromoFreeGiftVO);
		}
	}
	
	@Override
	public void updatePromotion(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.registerPromotion");
		
		SalesPromoMVO salesPromoMVO = promotionVO.getSalesPromoMVO();
		
		GridDataSet<SalesPromoDVO>        salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList = promotionVO.getFreeGiftGridDataSetList();
		
		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getAdd();
		List<SalesPromoDVO> udtSalesPromoDVOList = salesPromoDDataSetList.getUpdate();
		List<SalesPromoDVO> delSalesPromoDVOList = salesPromoDDataSetList.getRemove();
		List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getAdd();
		List<SalesPromoFreeGiftVO> delSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getRemove();
		
		this.preprocSalesPromotionMaster(salesPromoMVO, sessionVO);

		promotionMapper.updateSalesPromoM(salesPromoMVO);;

		this.preprocSalesPromotionDetail(addSalesPromoDVOList, salesPromoMVO.getPromoId(),  sessionVO);
		this.preprocSalesPromotionDetail(udtSalesPromoDVOList, salesPromoMVO.getPromoId(),  sessionVO);
		
		for(SalesPromoDVO addVO : addSalesPromoDVOList) {
			promotionMapper.insertSalesPromoD(addVO);
		}
		
		for(SalesPromoDVO udtVO : udtSalesPromoDVOList) {
			promotionMapper.updateSalesPromoD(udtVO);
		}
		
		for(SalesPromoDVO delVO : delSalesPromoDVOList) {
			promotionMapper.deleteSalesPromoD(delVO);
		}
		
		this.preprocSalesPromoFreeGift(addSalesPromoFreeGiftVOList, salesPromoMVO.getPromoId(), sessionVO);
		
		for(SalesPromoFreeGiftVO addVO : addSalesPromoFreeGiftVOList) {
			promotionMapper.insertSalesPromoFreeGift(addVO);
		}

		for(SalesPromoFreeGiftVO delVO : delSalesPromoFreeGiftVOList) {
			promotionMapper.deleteSalesPromoFreeGift(delVO);
		}
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
	
	private void preprocSalesPromotionDetail(List<SalesPromoDVO> salesPromoDVOList, int promoId, SessionVO sessionVO) {
		
		if(salesPromoDVOList != null) {
			for(SalesPromoDVO addVo : salesPromoDVOList) {
				addVo.setPromoId(promoId);
				addVo.setPromoItmCurId(0);
				addVo.setPromoItmStusId(1);
				addVo.setPromoItmUpdUserId(sessionVO.getUserId());
			}
		}
	}
	
	private void preprocSalesPromoFreeGift(List<SalesPromoFreeGiftVO> salesPromoFreeGiftVOList, int promoId, SessionVO sessionVO) {
		
		if(salesPromoFreeGiftVOList != null) {
			for(SalesPromoFreeGiftVO addVo : salesPromoFreeGiftVOList) {
				addVo.setPromoFreeGiftPromoId(promoId);;
				addVo.setPromoFreeGiftCrtUserId(sessionVO.getUserId());
			}
		}
	}
	
	@Override
	public List<EgovMap> selectMembershipPkg(Map<String, Object> params) {
		return promotionMapper.selectMembershipPkg(params);
	}
	
	@Override
	public List<SalesPromoDVO> selectPriceInfo(PromotionVO promotionVO) {
		
		GridDataSet<SalesPromoDVO> salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		
		List<SalesPromoDVO> salesPromoDVOList = salesPromoDDataSetList.getAll();
		
		int appTypeId = promotionVO.getSalesPromoMVO().getPromoAppTypeId();
		
		appTypeId = this.getAppTypeId(appTypeId);
		
		Map<String, Object> params = null;
		
		for(SalesPromoDVO dvo: salesPromoDVOList) {
			
			params = new HashMap<String, Object>();
			
			params.put("stkId", dvo.getPromoItmStkId());
			params.put("appTypeId", appTypeId);
			
			EgovMap priceMap = promotionMapper.selectPriceInfo(params);
			
			if(priceMap != null) {
    			dvo.setAmt((BigDecimal)priceMap.get("amt"));
    			dvo.setPrcRpf((BigDecimal)priceMap.get("prcRpf"));
    			dvo.setPrcPv((BigDecimal)priceMap.get("prcPv"));
			}
		}
		
		return salesPromoDVOList;
	}
	
	private int getAppTypeId(int appTypeId) {
		int promoAppTypId = 0;
		
		if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_REN) {
			promoAppTypId = SalesConstants.APP_TYPE_CODE_ID_RENTAL;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT || appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_INS) {
			promoAppTypId = SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS) {
			promoAppTypId = SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OSVM) {
			promoAppTypId = 1036;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_RSVM) {
			promoAppTypId = 1330;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL) {
			promoAppTypId = 1035;
		}
		
		return promoAppTypId;
	}
}
