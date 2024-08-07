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

import com.coway.trust.biz.sales.promotion.ProductMgmtService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("productMgmtService")
public class ProductMgmtServiceImpl extends EgovAbstractServiceImpl implements ProductMgmtService {

	private static Logger logger = LoggerFactory.getLogger(ProductMgmtServiceImpl.class);

	@Resource(name = "productMgmtMapper")
	private ProductMgmtMapper productMgmtMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectProductMgmtList(Map<String, Object> params) {
		return productMgmtMapper.selectProductMgmtList(params);
	}

	@Override
	public List<EgovMap> selectPromotionListByStkId(Map<String, Object> params) {
	   return productMgmtMapper.selectPromotionListByStkId(params);
	}

	@Override
	public EgovMap selectProductDiscontinued(Map<String, Object> params) {
	   return productMgmtMapper.selectProductDiscontinued(params);
	}

	@Override
  public EgovMap selectAdminKeyinCount(Map<String, Object> params) {
     return productMgmtMapper.selectAdminKeyinCount(params);
  }

	@Override
  public EgovMap selecteKeyinCount(Map<String, Object> params) {
     return productMgmtMapper.selecteKeyinCount(params);
  }

	@Override
  public EgovMap selectQuotaCount(Map<String, Object> params) {
     return productMgmtMapper.selectQuotaCount(params);
  }

	@SuppressWarnings("unchecked")
  @Override
  public void updateProductCtrl(Map<String, Object> params) {

	  Map<String, Object> formD = (Map<String,Object>) params.get("form");
	  String userId = params.get("userId").toString();
	  String stkId = formD.get("modify_stkId").toString();

	  List<Object> gridD =  (List) params.get("grid");
	  formD.put("userId", userId);

    productMgmtMapper.updateProductCtrl(formD);

	  if (gridD.size() > 0) {
      for (int i = 0; i < gridD.size(); i++) {
        Map<String, Object> gridMap = (Map<String, Object>) gridD.get(i);

        gridMap.put("stkId",stkId);
        gridMap.put("userId", userId);

        productMgmtMapper.updatePromotionCtrl(gridMap);
      }
    }

	}


	@Override
	public List<EgovMap> selectPriceReqstList(Map<String, Object> params) {
		return productMgmtMapper.selectPriceReqstList(params);
	}

	@Override
	public EgovMap selectPriceReqstInfo(Map<String, Object> params) {
	   return productMgmtMapper.selectPriceReqstInfo(params);
	}

	@Override
	public List<EgovMap> selectPriceHistoryInfo2(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return productMgmtMapper.selectPriceHistoryInfo2(params);
	}

}
