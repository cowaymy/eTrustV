package com.coway.trust.biz.sales.msales.impl;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.msales.OrderAddressApiService;
import com.coway.trust.biz.sales.msales.OrderApiService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("OrderApiService")
public class OrderApiServiceImpl extends EgovAbstractServiceImpl implements OrderApiService{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "OrderApiMapper")
	private OrderApiMapper orderApiMapper;
	
	@Override
	public List<EgovMap> orderProductList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderApiMapper.orderProductList(params);
	}
	
	@Override
	public List<EgovMap> orderPromotionList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		
		params.put("salesType", CommonUtils.changePromoAppTypeId(Integer.parseInt((String) params.get("salesType"))));
		
		return orderApiMapper.orderPromotionList(params);
	}
	
	@Override
	public EgovMap orderCostCalc(Map<String, Object> params) {

		BigDecimal orderPrice = BigDecimal.ZERO, orderRentalFees = BigDecimal.ZERO;
		BigDecimal orderPricePromo = BigDecimal.ZERO, orderRentalFeesPromo = BigDecimal.ZERO;
		
		EgovMap priceInfo = orderApiMapper.selectOrderCostCalc(params);
		EgovMap result  = new EgovMap();
		
		if(priceInfo != null) {
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_REN == Integer.parseInt(String.valueOf((BigDecimal)priceInfo.get("promoAppTypeId")))) { //Rental
				orderPrice           = (BigDecimal)priceInfo.get("prcRpf");
				orderRentalFees      = (BigDecimal)priceInfo.get("amt");
				orderPricePromo      = (BigDecimal)priceInfo.get("promoPrcRpf");
				orderRentalFeesPromo = (BigDecimal)priceInfo.get("promoAmt");
			}
			else {
				orderPrice           = (BigDecimal)priceInfo.get("amt");
				orderRentalFees      = BigDecimal.ZERO;
				orderPricePromo      = (BigDecimal)priceInfo.get("promoAmt");
				orderRentalFeesPromo = BigDecimal.ZERO;
			}
			
			result.put("normalPriceRpfAmt", orderPrice);
			result.put("normalRentalFeeAmt", orderRentalFees);
			result.put("finalPriceRpfAmt", orderPricePromo);
			result.put("finalRentalFeeAmt", orderRentalFeesPromo);
		}
	
		return result;
	}
	
	@Override
	public List<EgovMap> preOrderList(Map<String, Object> params) {
		return orderApiMapper.selectPreOrderList(params);
	}
}
