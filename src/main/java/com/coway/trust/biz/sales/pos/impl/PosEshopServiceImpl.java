package com.coway.trust.biz.sales.pos.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.pos.PosEshopService;
import com.coway.trust.biz.sales.pos.PosStockService;
import com.coway.trust.biz.sales.pos.vo.PosDetailVO;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.biz.sales.pos.vo.PosLoyaltyRewardVO;
import com.coway.trust.biz.sales.pos.vo.PosMasterVO;
import com.coway.trust.biz.sales.pos.vo.PosMemberVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.math.BigDecimal;
import com.uwyn.jhighlight.fastutil.Hash;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posEshopService")
public class PosEshopServiceImpl extends EgovAbstractServiceImpl implements PosEshopService {

  private static final Logger LOGGER = LoggerFactory.getLogger(PosEshopServiceImpl.class);

  @Resource(name = "posEshopMapper")
  private PosEshopMapper posMapper;

  @Autowired
  private MessageSourceAccessor messageAccessor;


  @Override
  public EgovMap selectItemPrice(Map<String, Object> params) throws Exception {

	return   posMapper.selectItemPrice(params);
  }


  @Override
  public Map<String, Object> insertPosEshopItemList(Map<String, Object> params) throws Exception {

  		int seq = 0;

  		seq=posMapper.getSeqSAL0321D();

  		Map<String, Object>  heardMap  = null;

  		LOGGER.debug(" params insertPosEshopItemList===>"+params.toString());

  		heardMap= new HashMap<String, Object>();

  		heardMap.put("id", seq);
  		heardMap.put("posType", params.get("posType_addItem"));
  		heardMap.put("sellingType", params.get("sellingType_addItem"));
  		heardMap.put("itemId", params.get("purcItems_addItem"));
  		heardMap.put("itemCtgryId", params.get("category_addItem"));
  		heardMap.put("itemType", params.get("itemType_addItem"));
  		heardMap.put("itemQty", params.get("qtyPerCarton_addItem"));
  		heardMap.put("itemWeight", params.get("unitWeight_addItem"));
  		heardMap.put("itemPrice", params.get("sellingPrice_addItem"));
  		heardMap.put("itemSize", params.get("size_addItem"));
  		heardMap.put("itemAttachGrpId", params.get("attachGrpId_addItem"));
  		heardMap.put("totalPrice", params.get("pricePerCarton_addItem"));
  		heardMap.put("totalWeight", params.get("weightPerCarton_addItem"));
  		heardMap.put("crtId", params.get("userId"));

  	   LOGGER.debug(" addList insertPosEshopItemList===>"+heardMap.toString());

  	   posMapper.insertEshopItemList(heardMap);

  	   //Return Message
	   Map<String, Object> rtnMap = new HashMap<String, Object>();
	   rtnMap.put("scnNo", "ok");
	   return rtnMap;

  }

	@Override
	public List<EgovMap> selectItemList(Map<String, Object> params) {
		return posMapper.selectItemList(params);
	}

	@Override
	public Map<String, Object> removeEshopItemList(Map<String, Object> params) throws Exception {

	   posMapper.removeEshopItemList(params);

	   Map<String, Object> rtnMap = new HashMap<String, Object>();
	   rtnMap.put("isOk", "OK");

	   return rtnMap;
	}


	  @Override
	  public Map<String, Object> updatePosEshopItemList(Map<String, Object> params) throws Exception {

	  		Map<String, Object>  heardMap  = null;

	  		LOGGER.debug(" params updatePosEshopItemList===>"+params.toString());

	  		heardMap= new HashMap<String, Object>();

	  		heardMap.put("id", params.get("id_editItem"));
	  		heardMap.put("itemQty", params.get("qtyPerCarton_editItem"));
	  		heardMap.put("itemWeight", params.get("unitWeight_editItem"));
	  		heardMap.put("itemPrice", params.get("sellingPrice_editItem"));
	  		heardMap.put("itemSize", params.get("size_editItem"));
	  		heardMap.put("itemAttachGrpId", params.get("attachGrpId_editItem"));
	  		heardMap.put("totalPrice", params.get("pricePerCarton_editItem"));
	  		heardMap.put("totalWeight", params.get("weightPerCarton_editItem"));
	  		heardMap.put("updId", params.get("userId"));

	  	   posMapper.updateEshopItemList(heardMap);

	  	   //Return Message
		   Map<String, Object> rtnMap = new HashMap<String, Object>();
		   rtnMap.put("scnNo", "ok");
		   return rtnMap;

	  }












}
