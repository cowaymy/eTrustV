package com.coway.trust.biz.sales.order.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.impl.MembershipRSMapper;
import com.coway.trust.biz.sales.order.OrderConversionService;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderConversionService")
public class OrderConversionServiceImpl extends EgovAbstractServiceImpl implements  OrderConversionService{

	private static final Logger logger = LoggerFactory.getLogger(OrderConversionServiceImpl.class);
	
	@Resource(name = "orderConversionMapper")
	private OrderConversionMapper orderConversionMapper;
	
	@Resource(name = "membershipRSMapper")
	private MembershipRSMapper membershipRSMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderConversionList(Map<String, Object> params) {
		return orderConversionMapper.orderConversionList(params);
	}
	
	public EgovMap orderConversionView(Map<String, Object> params) {
		return orderConversionMapper.orderConversionView(params);
	}
	
	public List<EgovMap> orderConversionViewItmList(Map<String, Object> params) {
		return orderConversionMapper.orderConversionViewItmList(params);
	}
	
	public List<EgovMap> orderCnvrValidItmList(Map<String, Object> params) {
		return orderConversionMapper.orderCnvrValidItmList(params);
	}
	
	public List<EgovMap> orderCnvrInvalidItmList(Map<String, Object> params) {
		return orderConversionMapper.orderCnvrInvalidItmList(params);
	}
	
	public void delCnvrItmSAL0073D(Map<String, Object> params) {
		orderConversionMapper.delCnvrItmSAL0073D(params);
	}
	
	public void updCnvrConfirm(Map<String, Object> params) {
		orderConversionMapper.updCnvrConfirm(params);
	}
	
	public void updCnvrDeactive(Map<String, Object> params) {
		orderConversionMapper.updCnvrDeactive(params);
	}
	
	public EgovMap orderCnvrInfo(Map<String, Object> params) {
		return orderConversionMapper.orderCnvrInfo(params);
	}
	
	@Override
	public List<EgovMap> chkNewCnvrList(Map<String, Object> params) {
		
		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");
		
		EgovMap result = new EgovMap();
		
		String msg = null;

		Map<String, Object> map = new HashMap();
		
		List checkList = new ArrayList();
		
		for (Object obj : list) 
		{			
			((Map<String, Object>) obj).put("userId", params.get("userId"));
			
			logger.debug(" OrderNo : {}", ((Map<String, Object>) obj).get("0"));
			params.put("ordNo", ((Map<String, Object>) obj).get("0"));
			
			if(!StringUtils.isEmpty(params.get("ordNo"))){
				((Map<String, Object>) obj).put("ordNo",  String.format("%07d", Integer.parseInt(((Map<String, Object>) obj).get("0").toString())));
				
				EgovMap info = orderConversionMapper.orderCnvrInfo(params);
				
				((Map<String, Object>) obj).put("orderNo", info.get("ordNo"));
				((Map<String, Object>) obj).put("ordStusCode", info.get("ordStusCode"));
				((Map<String, Object>) obj).put("appTypeCode", info.get("appTypeCode"));
				((Map<String, Object>) obj).put("rentalStus", info.get("rentalStus"));
				logger.debug("info ================>>  " + info.get("ordNo"));
				logger.debug("info ================>>  " + info.get("ordStusCode"));
				logger.debug("info ================>>  " + info.get("appTypeCode"));
				logger.debug("info ================>>  " + info.get("rentalStus"));
				checkList.add(obj);
				continue;
			}
		}
		return checkList;
	}
	
	public void saveNewConvertList(Map<String, Object> params) {
		
		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");
		
		logger.debug("gridData ============>> " + list);
		
		params.put("docNoId", 100);
		String convertNo = membershipRSMapper.getDocNo(params);
		
		int crtSeqSAL0072D = orderConversionMapper.crtSeqSAL0072D();
		params.put("rsCnvrId", crtSeqSAL0072D);
		params.put("stusFrom", formData.get("pRsCnvrStusFrom"));
		params.put("stusTo", formData.get("pRsCnvrStusTo"));
		params.put("rsStusId", 1);
		params.put("rsCnvrStusId", 44);
		params.put("rsCnvrRem", formData.get("newCnvrRem"));
		params.put("rsCnvrCnfmUserId", 0);
		params.put("rsCnvrCnfmDt", SalesConstants.DEFAULT_DATE);
		params.put("rsCnvrUserId", 0);
		params.put("rsCnvrDt", SalesConstants.DEFAULT_DATE);
		params.put("rsCnvrNo", convertNo);
		params.put("rsCnvrAttachUrl", "");
		params.put("rsCnvrReactFeesApply", formData.get("rsCnvrReactFeesApply"));
		params.put("rsCnvrTypeId", 1319);
		
		orderConversionMapper.insertCnvrSAL0072D(params);
		
		for (Object obj : list) 
		{
			params.put("ordNo",  ((Map<String, Object>) obj).get("ordNo"));
			params.put("rsItmStusId", 1);
			params.put("rsSysSoId", 0);
			params.put("appTypeId", 0);
			params.put("rsSysRentalStus", "");
			params.put("rsItmValidStus", 0);
			params.put("rsItmValidRem", "");
			params.put("rsItmCnvrStusId", 44);
			params.put("rsItmUserId", 0);
			params.put("rsItmCnvrDt", SalesConstants.DEFAULT_DATE);
			params.put("rsItmCntrctId", 0);
			params.put("rsItmCntrctNo", null);
			orderConversionMapper.insertCnvrSAL0073D(params);
		}
		params.put("batchId", crtSeqSAL0072D);
		orderConversionMapper.insertCnvrList(params);
	}
}
