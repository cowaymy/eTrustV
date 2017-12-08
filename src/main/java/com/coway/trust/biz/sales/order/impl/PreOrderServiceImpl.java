/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.PreOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
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
@Service("preOrderService")
public class PreOrderServiceImpl extends EgovAbstractServiceImpl implements PreOrderService {

//	private static Logger logger = LoggerFactory.getLogger(OrderListServiceImpl.class);
	
	@Resource(name = "preOrderMapper")
	private PreOrderMapper preOrderMapper;
	
//	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selectPreOrderList(Map<String, Object> params) {
		return preOrderMapper.selectPreOrderList(params);
	}

	@Override
	public EgovMap selectPreOrderInfo(Map<String, Object> params) {
		
		EgovMap rslt = preOrderMapper.selectPreOrderInfo(params);
		
		if(rslt.get("preTm") != null) {
			rslt.put("preTm", this.convert12Tm((String) rslt.get("preTm")));
		}
		
		return preOrderMapper.selectPreOrderInfo(params);
	}
	
	private String convert12Tm(String TM) {
		String HH = "", MI = "", cvtTM = "";
		
		if(CommonUtils.isNotEmpty(TM)) {
			HH = CommonUtils.left(TM, 2);
			MI = TM.substring(3, 5);
			
			if(Integer.parseInt(HH) > 12) {
				cvtTM = CommonUtils.getFillString((Integer.parseInt(HH) - 12), "0", 2) + ":" + String.valueOf(MI) + " PM";
			}
			else {
				cvtTM = HH + ":" + String.valueOf(MI) + " AM";
			}
		}
		return cvtTM;
	}

	@Override
	public int selectExistSofNo(Map<String, Object> params) {
		return preOrderMapper.selectExistSofNo(params);
	}
	
	@Override
	public void insertPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) {
		
		this.preprocPreOrder(preOrderVO, sessionVO);
		
		preOrderMapper.insertPreOrder(preOrderVO);
	}
	
	@Override
	public void updatePreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) {
		
		this.preprocPreOrder(preOrderVO, sessionVO);
		
		preOrderMapper.updatePreOrder(preOrderVO);
	}
	
	@Override
	public void updatePreOrderStatus(PreOrderListVO preOrderListVO, SessionVO sessionVO) {
		
		GridDataSet<PreOrderVO> preOrderList = preOrderListVO.getPreOrderVOList();
		
		ArrayList<PreOrderVO> updateList = preOrderList.getUpdate();
		
		for(PreOrderVO vo : updateList) {
			vo.setUpdUserId(sessionVO.getUserId());
			preOrderMapper.updatePreOrderStatus(vo);
		}
	}
	
	private void preprocPreOrder(PreOrderVO preOrderVO, SessionVO sessionVO) {
		
		preOrderVO.setChnnl(SalesConstants.PRE_ORDER_CHANNEL_WEB);
		preOrderVO.setStusId(SalesConstants.STATUS_ACTIVE);
		preOrderVO.setKeyinBrnchId(sessionVO.getUserBranchId());
		preOrderVO.setPreTm(this.convert24Tm(preOrderVO.getPreTm()));

		preOrderVO.setCrtUserId(sessionVO.getUserId());
		preOrderVO.setUpdUserId(sessionVO.getUserId());
	}
	
	private String convert24Tm(String TM) {
		String ampm = "", HH = "", MI = "", cvtTM = "";
		
		if(CommonUtils.isNotEmpty(TM)) {
			ampm = CommonUtils.right(TM, 2);
			HH = CommonUtils.left(TM, 2);
			MI = TM.substring(3, 5);
			
			if("PM".equals(ampm)) {
				cvtTM = String.valueOf(Integer.parseInt(HH) + 12) + ":" + MI + ":00";
			}
			else  {
				cvtTM = HH + ":" + MI + ":00";
			}
		}
		return cvtTM;
	}
}
