/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stocks.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.stocks.StockService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stockService")
public class StockServiceImpl extends EgovAbstractServiceImpl implements StockService {

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "stockMapper")
	private StockMapper stockMapper;

	@Override
	public List<EgovMap> selectStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockList(params);
	}

	@Override
	public List<EgovMap> selectStockInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockInfo(params);
	}

	@Override
	public List<EgovMap> selectPriceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectPriceInfo(params);

	}

	@Override
	public List<EgovMap> selectFilterInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectFilterInfo(params);
	}

	@Override
	public List<EgovMap> selectServiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectServiceInfo(params);
	}

	@Override
	public List<EgovMap> selectStockImgList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockImgList(params);
	}

	@Override
	public void updateStockInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		stockMapper.updateStockInfo(params);

		String apptype_id = "";
		if (params.get("stock_type") != null && "61".equals(params.get("stock_type"))) {
			params.put("app_type_id", "66");
			stockMapper.updateSalePriceUOM(params);
			params.put("app_type_id", "67");
			stockMapper.updateSalePriceUOM(params);
		} else {
			params.put("app_type_id", "69");
			stockMapper.updateSalePriceUOM(params);
		}
	}
	
	@Override
	public void modifyServicePoint(Map<String, Object> params) {
		// TODO Auto-generated method stub
		stockMapper.modifyServicePoint(params);
	}

	@Override
	public void updatePriceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Map<String, Object> smap = new HashMap<>();
		Map<String, Object> smap2 = new HashMap<>();
		smap.put("upd_user", params.get("upd_user"));
		smap2.put("upd_user", params.get("upd_user"));

		if (params.get("priceTypeid") != null) {

			if ("61".equals(params.get("priceTypeid"))) {
				smap.put("stockid", params.get("stockId"));
				smap.put("amt", params.get("dNormalPrice"));
				smap.put("apptypeid", "67");
				smap.put("pricecharges", 0);
				smap.put("pricecosting", params.get("dCost"));
				smap.put("statuscodeid", 1);
				smap.put("pricepv", params.get("dPV"));
				smap.put("tradeinpv", params.get("dTradeInPV"));

				smap2.put("stockid", params.get("stockId"));
				smap2.put("amt", params.get("dMonthlyRental"));
				smap2.put("apptypeid", "66");
				smap2.put("pricecharges", 0);
				smap2.put("pricecosting", params.get("dCost"));
				smap2.put("statuscodeid", 1);
				smap2.put("pricepv", params.get("dPV"));
				smap2.put("tradeinpv", params.get("dTradeInPV"));
				smap2.put("pricerpf", params.get("dRentalDeposit"));
				
				stockMapper.insertSalePriceInfoHistory(smap);
				stockMapper.insertSalePriceInfoHistory(smap2);
						
				stockMapper.updateSalePriceInfo(smap);
				stockMapper.updateSalePriceInfo(smap2);

			} else {

				smap.put("stockid", params.get("stockId"));
				smap.put("amt", params.get("dNormalPrice"));
				smap.put("apptypeid", "67");
				smap.put("pricecharges", params.get("dPenaltyCharge"));
				smap.put("pricecosting", params.get("dCost"));
				smap.put("statuscodeid", 1);

				stockMapper.insertSalePriceInfoHistory(smap);
				
				stockMapper.updateSalePriceInfo(smap);


			}
		}
	}

	@Override
	public List<EgovMap> srvMembershipList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.srvMembershipList();
	}

	@SuppressWarnings("unchecked")
	@Override
	public int addServiceInfoGrid(int stockId, List<Object> addLIst, int loginId) {
		int cnt = 0;

		int pac_id = stockMapper.selectPacId();
		logger.debug("pac_id : {}", pac_id);
		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		param.put("pac_id", pac_id);
		for (Object obj : addLIst) {
			param.put("packagename", ((Map<String, Object>) obj).get("packagename"));
			param.put("chargeamt", (((Map<String, Object>) obj).get("chargeamt") == null) ? 0
					: ((Map<String, Object>) obj).get("chargeamt"));
			cnt = cnt + stockMapper.addServiceInfoGrid(param);
		}

		logger.debug("stockId : {}", param.get("stockId"));
		logger.debug("crtUserId : {}", param.get("crtUserId"));
		logger.debug("packagename : {}", param.get("packagename"));
		// TODO Auto-generated method stub
		return cnt;
	}

	@SuppressWarnings("unchecked")
	@Override
	public int removeServiceInfoGrid(int stockId, List<Object> removeLIst, int loginId) {
		// TODO Auto-generated method stub
		int cnt = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		for (Object obj : removeLIst) {
			param.put("packageid", ((Map<String, Object>) obj).get("packageid"));
			cnt = cnt + stockMapper.removeServiceInfoGrid(param);
		}
		return cnt;
	}

	@SuppressWarnings("unchecked")
	@Override
	public int removeFilterInfoGrid(int stockId, List<Object> removeLIst, int loginId, String revalue) {
		int cnt = 0;

		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		param.put("revalue", revalue);
		for (Object obj : removeLIst) {
			param.put("bom_part_id", ((Map<String, Object>) obj).get("stockid"));
			// String bom_part_id = (String) ((Map<String, Object>) obj).get("typeid");
			// param.put("bom_part_id", Integer.parseInt(bom_part_id));
			cnt = cnt + stockMapper.removeFilterInfoGrid(param);
		}
		return cnt;
	}

	@SuppressWarnings({ "unchecked", "null" })
	@Override
	public int addFilterInfoGrid(int stockId, List<Object> addLIst, int loginId, String revalue) {
		int cnt = 0;

		int bom_id = stockMapper.selectBomId();
		logger.debug("bom_id : {}", bom_id);
		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		param.put("revalue", revalue);
		param.put("bom_id", bom_id);
		if (null != addLIst) {
			for (Object obj : addLIst) {
				String bom_stk_id = (String) ((Map<String, Object>) obj).get("stockid");
				String bom_part_qty = (String) ((Map<String, Object>) obj).get("qty");
				param.put("bom_stk_id", Integer.parseInt(bom_stk_id));
				param.put("bom_part_qty", Integer.parseInt(bom_part_qty));

				if (revalue.equals("filter_info")) {
					String bom_part_id = (String) ((Map<String, Object>) obj).get("typeid");
					String bom_part_priod = (String) ((Map<String, Object>) obj).get("period");
					param.put("bom_part_id", Integer.parseInt(bom_part_id));
					param.put("bom_part_priod", Integer.parseInt(bom_part_priod));
				}

				cnt = cnt + stockMapper.addFilterInfoGrid(param);
			}
		}

		return cnt;
	}

	@Override
	public List<EgovMap> selectPriceHistoryInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectPriceHistoryInfo(params);
	}

	@Override
	public List<EgovMap> selectStockCommisionSetting(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockCommisionSetting(param);
	}

	@Override
	public void updateStockCommision(Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.debug("stckcd : {}", params.get("stckcd"));
		stockMapper.updateStockCommision(params);
	}

	@Override
	public String nonvalueStockIns(Map<String, Object> params) {
		// TODO Auto-generated method stub
		String reVal = stockMapper.nonvaluedItemCodeChk(params);
		if ("0".equals(reVal)){

    		int stkid = stockMapper.stockSTKIDsearch();
    		params.put("stkid", stkid);
    		stockMapper.nonvalueStockIns(params);
    		stockMapper.nonvalueItemPriceins(params);
		}
		return reVal;
	}

	@Override
	public EgovMap nonvaluedItemCodeChk(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;//stockMapper.nonvaluedItemCodeChk(params);
	}

}
