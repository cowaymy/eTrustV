/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.text.DecimalFormat;
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
import com.coway.trust.web.sales.SalesConstants;

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
	
	@Override
	public EgovMap selectStockPrice(Map<String, Object> params) {
		
		EgovMap priceInfo = orderRegisterMapper.selectStockPrice(params);
		
		BigDecimal orderPrice, orderPV, orderRentalFees;
		
		if(SalesConstants.APP_TYPE_CODE_ID_RENTAL.equals((String)params.get("appTypeId"))) {
//			orderPrice      = "₩" + ((BigDecimal)priceInfo.get("rentalDeposit")).toString();
//			orderPV         = "₩" + ((BigDecimal)priceInfo.get("pv")).toString();
//			orderRentalFees = "₩" + ((BigDecimal)priceInfo.get("monthlyRental")).toString();
			orderPrice      = (BigDecimal)priceInfo.get("rentalDeposit");
			orderPV         = (BigDecimal)priceInfo.get("pv");
			orderRentalFees = (BigDecimal)priceInfo.get("monthlyRental");
		}
		else {
//			orderPrice      = "₩" + ((BigDecimal)priceInfo.get("normalPrice")).toString();
//			orderPV         = "₩" + ((BigDecimal)priceInfo.get("pv")).toString();
			orderPrice      = (BigDecimal)priceInfo.get("normalPrice");
			orderPV         = (BigDecimal)priceInfo.get("pv");
			orderRentalFees = BigDecimal.ZERO;
		}
		
		priceInfo.put("orderPrice", new DecimalFormat("0.00").format(orderPrice));
		priceInfo.put("orderPV", new DecimalFormat("0.00").format(orderPV));
		priceInfo.put("orderRentalFees", new DecimalFormat("0.00").format(orderRentalFees));
		
		return priceInfo;
	}
	
	@Override
	public List<EgovMap> selectDocSubmissionList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderRegisterMapper.selectDocSubmissionList(params);
	}
	
	@Override
	public List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderRegisterMapper.selectPromotionByAppTypeStock(params);
	}
	
	@Override
	public EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> params) {

		EgovMap priceInfo = orderRegisterMapper.selectProductPromotionPriceByPromoStockID(params);
		
		BigDecimal orderPrice, orderPV, orderRentalFees;
		
		orderPrice      = (BigDecimal)priceInfo.get("promoItmPrc");
		orderPV         = (BigDecimal)priceInfo.get("promoItmPv");
		orderRentalFees = ((BigDecimal)priceInfo.get("promoItmRental")).compareTo(BigDecimal.ZERO) > 0 ? (BigDecimal)priceInfo.get("promoItmRental") : BigDecimal.ZERO;
		
		priceInfo.put("orderPrice", new DecimalFormat("0.00").format(orderPrice));
		priceInfo.put("orderPV", new DecimalFormat("0.00").format(orderPV));
		priceInfo.put("orderRentalFees", new DecimalFormat("0.00").format(orderRentalFees));
		
		return priceInfo;
	}
	
	@Override
	public EgovMap selectTrialNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderRegisterMapper.selectTrialNo(params);
	}
	
}
